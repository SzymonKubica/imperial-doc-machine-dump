/*
 * Matrix multiply example for studying cache performance
 *
 * Variant 4
 *
 * Paul Kelly  Imperial College London  January 2005
 */


#include <stdio.h>
#include <math.h>
#include <time.h>

/* We bravely assume SZ is divisible by BLOCKSIZE to avoid overheads of min */

/* #define min(aaa, bbb) ((aaa) < (bbb) ? (aaa) : (bbb)) */
#define min(aaa, bbb) (aaa)

#define FLOATTYPE double

/* In this version we declare the matrix as ARRAYSZxARRAYSZ.  SZ
 * controls the size of the matrix multiply we actually do, which
 * must be smaller.
 */
/* #define ARRAYSZ 1024 */
/* #define ARRAYSZ 2048 */
#ifndef ARRAYSZ
#define ARRAYSZ 8192
#endif

#ifndef TEST
#ifndef SZ
#define SZ (2048+128)
#endif
#ifndef BLOCKSIZE
#define BLOCKSIZE 32
#endif
#endif

#ifdef TEST
#define SZ 16
#define BLOCKSIZE 8
#define PRINTMATRICES
#define PRINTTABLES
#endif

FLOATTYPE A[ARRAYSZ][ARRAYSZ];
/* int pad1[1]; */
FLOATTYPE B[ARRAYSZ][ARRAYSZ];
/* int pad2[1]; */
FLOATTYPE C[ARRAYSZ][ARRAYSZ];

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

/* The blocked version from Lam, Rothberg and Wolf
 */
void mm3(A,B,C,blocksize)
     FLOATTYPE A[ARRAYSZ][ARRAYSZ], B[ARRAYSZ][ARRAYSZ], C[ARRAYSZ][ARRAYSZ];
     int blocksize;
{
  int i, j, k, kk, jj;
  FLOATTYPE r;

  for (kk = 0; kk < SZ; kk += blocksize){
    for (jj = 0; jj < SZ; jj += blocksize){
      for (i = 0; i < SZ; i++){
	for (k = kk; k < min(kk+blocksize,SZ); k++){
	  r = A[i][k];
	  for (j = jj; j < min(jj+blocksize, SZ); j++){
	    C[i][j] += r * B[k][j];
	  }
	}
      }
    }
  }
}

void fillmatrix(A)
     FLOATTYPE A[ARRAYSZ][ARRAYSZ];
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
     FLOATTYPE A[ARRAYSZ][ARRAYSZ];
{
  int i, j;
  
  for (i = 0; i < SZ; i++){
    for (j = 0; j < SZ; j++){
      A[i][j] = 0.0;
    }
  }
}

void printmatrix(A)
     FLOATTYPE A[ARRAYSZ][ARRAYSZ];
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
  double time,mflops;
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
  mm3(A,B,C, BLOCKSIZE);
  time = ((double)(clock()-lasttime))/CLOCKS_PER_SEC;
  mflops = SZ*(SZ*(SZ*2.0))/time;
  printf("mm4: %f s, %f MFLOPS\n", time, mflops/1000000);

#ifdef PRINTMATRICES  
  printf("Matrix C:\n");
  printmatrix(C);
#endif
  return 0;
}
