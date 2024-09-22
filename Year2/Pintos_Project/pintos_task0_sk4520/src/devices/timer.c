#include "devices/timer.h"
#include <debug.h>
#include <inttypes.h>
#include <round.h>
#include <stdio.h>
#include "devices/pit.h"
#include "threads/interrupt.h"
#include "threads/synch.h"
#include "threads/thread.h"
  
/* See [8254] for hardware details of the 8254 timer chip. */

#if TIMER_FREQ < 19
#error 8254 timer requires TIMER_FREQ >= 19
#endif
#if TIMER_FREQ > 1000
#error TIMER_FREQ <= 1000 recommended
#endif

/* Number of timer ticks since OS booted. */
static int64_t ticks;

/* Number of loops per timer tick.
   Initialized by timer_calibrate(). */
static unsigned loops_per_tick;

static intr_handler_func timer_interrupt;
static bool too_many_loops (unsigned loops);
static void busy_wait (int64_t loops);
static void real_time_sleep (int64_t num, int32_t denom);
static void real_time_delay (int64_t num, int32_t denom);

/* sleeping_thred_list stores a list of struct sleeping_thread
   which represent all of the threads that are currently blocked
   because timer_sleep was invoked on them. For reference, 
   see the documentation of struct sleeping_thread below. */
static struct list sleeping_thread_list; 

/* sleeping_list_sema is a semaphore used to prevent race conditions
   when multiple threads try to access the sleeping_thread_list at
   the same time. It is initialised to 1 in timer_init, and then
   downed each time a thread is about to access the list and upped
   once it has finished manipulating the list. */
static struct semaphore sleeping_list_sema;

/* Attempts to wake up all of the threads which sleep time has 
   expired, it is invoked in the timer interrupt handler. */ 
static void try_to_wake_up_threads (void);

/* Compares two struct sleeping_thread by their sleep_end_time_in_ticks
   It is used by list_insert_ordered in timer_sleep while adding
   sleeping threads to the sleeping_thread_list */
static list_less_func has_less_sleep_time; 


/* Sets up the timer to interrupt TIMER_FREQ times per second,
   and registers the corresponding interrupt. Also thread
   sleeping functionality is initialised. */
void
timer_init (void) 
{
  pit_configure_channel (0, 2, TIMER_FREQ);
  intr_register_ext (0x20, timer_interrupt, "8254 Timer");
  list_init (&sleeping_thread_list);
  sema_init (&sleeping_list_sema, 1);
}

/* Calibrates loops_per_tick, used to implement brief delays. */
void
timer_calibrate (void) 
{
  unsigned high_bit, test_bit;

  ASSERT (intr_get_level () == INTR_ON);
  printf ("Calibrating timer...  ");

  /* Approximate loops_per_tick as the largest power-of-two
     still less than one timer tick. */
  loops_per_tick = 1u << 10;
  while (!too_many_loops (loops_per_tick << 1)) 
    {
      loops_per_tick <<= 1;
      ASSERT (loops_per_tick != 0);
    }

  /* Refine the next 8 bits of loops_per_tick. */
  high_bit = loops_per_tick;
  for (test_bit = high_bit >> 1; test_bit != high_bit >> 10; test_bit >>= 1)
    if (!too_many_loops (high_bit | test_bit))
      loops_per_tick |= test_bit;

  printf ("%'"PRIu64" loops/s.\n", (uint64_t) loops_per_tick * TIMER_FREQ);
}

/* Returns the number of timer ticks since the OS booted. */
int64_t
timer_ticks (void) 
{
  enum intr_level old_level = intr_disable ();
  int64_t t = ticks;
  intr_set_level (old_level);
  return t;
}

/* Returns the number of timer ticks elapsed since THEN, which
   should be a value once returned by timer_ticks(). */
int64_t
timer_elapsed (int64_t then) 
{
  return timer_ticks () - then;
}

/* Sleeps for approximately TICKS timer ticks.  Interrupts must
   be turned on. */
void
timer_sleep (int64_t ticks) 
{
	if (ticks < 0)
	{
		return;
	}
  int64_t start = timer_ticks ();
   
  ASSERT (intr_get_level () == INTR_ON);

  /* To prevent race conditions while accessing the list of 
     sleeping threads by multiple threads at the same time, we down 
     sleep_list_sema and then up it when finished accesing the list. */
  sema_down(&sleeping_list_sema);
  struct sleeping_thread sleeping_thread;

  struct semaphore sema;
  sema_init (&sema, 0);
  sleeping_thread.sema = &sema;

  sleeping_thread.sleep_end_time_in_ticks = start + ticks;
  list_insert_ordered (&sleeping_thread_list, 
                       &sleeping_thread.sleep_elem,
                       &has_less_sleep_time,
                       NULL);

  sema_up (&sleeping_list_sema);
  sema_down (&sema);
}

static void 
try_to_wake_up_threads (void) 
{
  if(sema_try_down (&sleeping_list_sema)) 
  {
    for (struct list_elem *e = list_begin (&sleeping_thread_list); 
         e != list_end (&sleeping_thread_list); 
         e = list_next (e)) 
    {
      struct sleeping_thread *sleeping_thread = 
        list_entry (e, struct sleeping_thread, sleep_elem);
      if (sleeping_thread->sleep_end_time_in_ticks <= timer_ticks ()) 
      {
        sema_up (sleeping_thread->sema);
        list_remove (&sleeping_thread->sleep_elem);
      } 
      else 
      {
        /* Since the list is sorted, we can stop once we find the first thread
           for which the sleeping time hasn't expired yet. */
        break;
      }
    }
    sema_up (&sleeping_list_sema);
  }
}

static bool has_less_sleep_time (const struct list_elem *a,
                                 const struct list_elem *b,
                                 void *aux UNUSED) 
{
  struct sleeping_thread *thread_a = 
      list_entry (a, struct sleeping_thread, sleep_elem);

  struct sleeping_thread *thread_b = 
      list_entry (b, struct sleeping_thread, sleep_elem);

  int64_t time_a = thread_a->sleep_end_time_in_ticks;
  int64_t time_b = thread_b->sleep_end_time_in_ticks;

  return time_a < time_b;
}
/* Sleeps for approximately MS milliseconds.  Interrupts must be
   turned on. */
void
timer_msleep (int64_t ms) 
{
  real_time_sleep (ms, 1000);
}

/* Sleeps for approximately US microseconds.  Interrupts must be
   turned on. */
void
timer_usleep (int64_t us) 
{
  real_time_sleep (us, 1000 * 1000);
}

/* Sleeps for approximately NS nanoseconds.  Interrupts must be
   turned on. */
void
timer_nsleep (int64_t ns) 
{
  real_time_sleep (ns, 1000 * 1000 * 1000);
}

/* Busy-waits for approximately MS milliseconds.  Interrupts need
   not be turned on.

   Busy waiting wastes CPU cycles, and busy waiting with
   interrupts off for the interval between timer ticks or longer
   will cause timer ticks to be lost.  Thus, use timer_msleep()
   instead if interrupts are enabled. */
void
timer_mdelay (int64_t ms) 
{
  real_time_delay (ms, 1000);
}

/* Sleeps for approximately US microseconds.  Interrupts need not
   be turned on.

   Busy waiting wastes CPU cycles, and busy waiting with
   interrupts off for the interval between timer ticks or longer
   will cause timer ticks to be lost.  Thus, use timer_usleep()
   instead if interrupts are enabled. */
void
timer_udelay (int64_t us) 
{
  real_time_delay (us, 1000 * 1000);
}

/* Sleeps execution for approximately NS nanoseconds.  Interrupts
   need not be turned on.

   Busy waiting wastes CPU cycles, and busy waiting with
   interrupts off for the interval between timer ticks or longer
   will cause timer ticks to be lost.  Thus, use timer_nsleep()
   instead if interrupts are enabled.*/
void
timer_ndelay (int64_t ns) 
{
  real_time_delay (ns, 1000 * 1000 * 1000);
}

/* Prints timer statistics. */
void
timer_print_stats (void) 
{
  printf ("Timer: %"PRId64" ticks\n", timer_ticks ());
}

/* Timer interrupt handler. */
static void
timer_interrupt (struct intr_frame *args UNUSED)
{
  ticks++;
  try_to_wake_up_threads ();
  thread_tick ();
}

/* Returns true if LOOPS iterations waits for more than one timer
   tick, otherwise false. */
static bool
too_many_loops (unsigned loops) 
{
  /* Wait for a timer tick. */
  int64_t start = ticks;
  while (ticks == start)
    barrier ();

  /* Run LOOPS loops. */
  start = ticks;
  busy_wait (loops);

  /* If the tick count changed, we iterated too long. */
  barrier ();
  return start != ticks;
}

/* Iterates through a simple loop LOOPS times, for implementing
   brief delays.

   Marked NO_INLINE because code alignment can significantly
   affect timings, so that if this function was inlined
   differently in different places the results would be difficult
   to predict. */
static void NO_INLINE
busy_wait (int64_t loops) 
{
  while (loops-- > 0)
    barrier ();
}

/* Sleep for approximately NUM/DENOM seconds. */
static void
real_time_sleep (int64_t num, int32_t denom) 
{
  /* Convert NUM/DENOM seconds into timer ticks, rounding down.
          
        (NUM / DENOM) s          
     ---------------------- = NUM * TIMER_FREQ / DENOM ticks. 
     1 s / TIMER_FREQ ticks
  */
  int64_t ticks = num * TIMER_FREQ / denom;

  ASSERT (intr_get_level () == INTR_ON);
  if (ticks > 0)
    {
      /* We're waiting for at least one full timer tick.  Use
         timer_sleep() because it will yield the CPU to other
         processes. */                
      timer_sleep (ticks); 
    }
  else 
    {
      /* Otherwise, use a busy-wait loop for more accurate
         sub-tick timing. */
      real_time_delay (num, denom); 
    }
}

/* Busy-wait for approximately NUM/DENOM seconds. */
static void
real_time_delay (int64_t num, int32_t denom)
{
  /* Scale the numerator and denominator down by 1000 to avoid
     the possibility of overflow. */
  ASSERT (denom % 1000 == 0);
  busy_wait (loops_per_tick * num / 1000 * TIMER_FREQ / (denom / 1000)); 
}
