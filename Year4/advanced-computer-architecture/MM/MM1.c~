/*
 * Matrix multiply example for studying cache performance
 *
 * Variant 1
 *
 * Paul Kelly  Imperial College London  January 2005
 */


#include <stdio.h>
#include <math.h>
#include <time.h>

#define FLOATTYPE double

/* Matrix size.  Not a power or two but divisible by the largest tile size 
 * we're interested in
 */
#ifndef TEST
#ifndef SZ
#define SZ (2048+128)
#endif
#endif

#ifdef TEST
#define SZ 16
#define PRINTMATRICES
#define PRINTTABLES
#endif

FLOATTYPE A[SZ][SZ];
/* int pad1[1]; */
FLOATTYPE B[SZ][SZ];
/* int pad2[1]; */
FLOATTYPE C[SZ][SZ];

#ifndef USE_LIBRARY_DRAND48
/* Define our own random number generator since simplescalar's gcc
 * doesn't come with it */

/* Linear congruential random number generator
 *   x[n+1] = a * x[n] mod m */
/* http://remus.rutgers.edu/~rhoads/Code/random.c no recommendation implied! */

static unsigned int SEED = 93186752;

/* return the next random number x: 0 <= x < 1*/
double drand48 ()  
{
  static unsigned int a = 1588635695, m = 4294967291U, q = 2, r = 1117695901;
  SEED = a*(SEED % q) - r*(SEED / q);
  return ((double)SEED / (double)m);
}

/* seed the generator */
void srand48 (unsigned int init) {if (init != 0) SEED = init;}
#endif

/* 
 * mm
 *
 * Multiply A by B leaving the result in C.
 * A is assumed to be an l x m matrix, B an m x n matrix.
 * The result matrix C is of course l x n.
 * The result matrix is assumed to be initialised to zero.
 *
 * Dumbest possible
 */
void mm1(A,B,C)
     FLOATTYPE A[SZ][SZ], B[SZ][SZ], C[SZ][SZ];
{
  int i, j, k;

  for (i = 0; i < SZ; i++){
    for (j = 0; j < SZ; j++){
      for (k = 0; k < SZ; k++){
	C[i][j] += A[i][k] * B[k][j];
      }
    }
  }
}

void fillmatrix(A)
     FLOATTYPE A[SZ][SZ];
{
  int i, j;
  FLOATTYPE drand48();
  
  for (i = 0; i < SZ; i++){
    for (j = 0; j < SZ; j++){
      A[i][j] = drand48();
    }
  }
}

void zeromatrix(A)
     FLOATTYPE A[SZ][SZ];
{
  int i, j;
  
  for (i = 0; i < SZ; i++){
    for (j = 0; j < SZ; j++){
      A[i][j] = 0.0;
    }
  }
}

void printmatrix(A)
     FLOATTYPE A[SZ][SZ];
{
  int i, j;
  
  for (i = 0; i < SZ; i++){
    for (j = 0; j < SZ; j++){
      printf("%1.1f ", A[i][j]);
    }
    printf("\n");
  }
}

int main()
{
  double time;
  double mflops;
  long lasttime;
  long clock();

  lasttime = clock();

  srand48(8897);
  fillmatrix(A);  
  fillmatrix(B);

  printf("Initialisation: %ld\n", clock()-lasttime);
  lasttime = clock();

#ifdef PRINTMATRICES  
  printf("Matrix A:\n");
  printmatrix(A);

  printf("Matrix B:\n");
  printmatrix(B);
#endif

  zeromatrix(C);
  lasttime = clock();
  mm1(A,B,C);
  time = ((double)(clock()-lasttime))/CLOCKS_PER_SEC;
  mflops = SZ*(SZ*(SZ*2.0))/time;
  printf("mm1: %f s, %f MFLOPS\n", time, mflops/1000000);

#ifdef PRINTMATRICES  
  printf("Matrix C:\n");
  printmatrix(C);
#endif
  return 0;
}
