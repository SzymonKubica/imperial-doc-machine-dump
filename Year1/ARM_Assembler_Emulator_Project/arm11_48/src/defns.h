#ifndef DEFN
#define DEFN

#include <stdint.h>

/*
 * Type definitions for groups of bits of varying length. 
 */

#include <stdint.h>

/*
 * The type definitions for unsigned char provide additional information
 * about the size of a specific sequence of bits. Although they all represent
 * 8 bits of information, they give insight about what portion of a word 
 * instruction is being considered. 
 */

// 1 bit 
typedef unsigned char bit_t; 

// 4 bits (half-byte)
typedef unsigned char nibble_t;

// 8 bits
typedef unsigned char byte_t;

// 32 bits
typedef uint32_t word_t;

#endif

