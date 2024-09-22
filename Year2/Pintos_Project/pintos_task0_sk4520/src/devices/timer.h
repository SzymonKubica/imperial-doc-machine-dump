#ifndef DEVICES_TIMER_H
#define DEVICES_TIMER_H

#include <round.h>
#include <stdint.h>
#include "list.h"

/* Number of timer interrupts per second. */
#define TIMER_FREQ 100

void timer_init (void);
void timer_calibrate (void);

int64_t timer_ticks (void);
int64_t timer_elapsed (int64_t);

/* Sleep and yield the CPU to other threads. */
void timer_sleep (int64_t ticks);
void timer_msleep (int64_t milliseconds);
void timer_usleep (int64_t microseconds);
void timer_nsleep (int64_t nanoseconds);

/* Busy waits. */
void timer_mdelay (int64_t milliseconds);
void timer_udelay (int64_t microseconds);
void timer_ndelay (int64_t nanoseconds);

void timer_print_stats (void);

/* struct sleeping_thread represents a list entry in a list
   of threads that are currently sleeping. Each instance
   of sleeping_thread contains a semaphore which is downed
   when the thread is sleeping and try_to_wake_up_threads
   ups the semaphore to unblock a thread. This struct also
   contains the number of ticks when a given thread is 
   supposed to end sleeping. The last member sleep_elem
   is used to bind this each instance of the struct to
   the list of sleeping threads. The reason why there is
   no struct thread member in struct sleeping_thread is
   that the sleeping_thread is automatically added to 
   the list of waiters of the semaphore sema when we down it */
struct sleeping_thread
  {
    struct semaphore *sema;
    int64_t sleep_end_time_in_ticks;
    struct list_elem sleep_elem;
  };

#endif /* devices/timer.h */
