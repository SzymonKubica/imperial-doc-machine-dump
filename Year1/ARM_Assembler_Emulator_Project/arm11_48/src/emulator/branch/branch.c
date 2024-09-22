#include <stdio.h> 
#include "../../defns.h"
#include "common.h"

#define PC 15

/*
 * Branch Instructions Module: implementation.
 */

// Offset is specified by bytes 2, 3 and 4 in a 32b instruction.
static word_t get_offset(byte_t *firstByte) {
	return ((firstByte[1] << 16) | (firstByte[2] << 8)) | firstByte[3];
}

static int get_sign_extended_offset(word_t offset) {
	// Pre: Offset is precisely 26 bits long after shifting.
  if ((offset >> 25) == 1) { 

		// If the most significant bit is non-zero.
		// Copy the leftmost bit (1) 6 times.
		word_t filler = 0xfc000000; // 1111 1100 0000 0000 0000 0000 0000 0000
		return (int) (filler | offset);

	} else {

		// The leftmost bit is zero, adding it 8 times doesn't alter the offset.
		return (int) offset;
	}
}

void execute_branch(byte_t *firstByte, word_t *registers) {
	word_t offset = get_offset(firstByte); 
	// Offset is shifted 2 times leftwards as outlined in the ARM documentation.
	// Therefore, PC is offset by a multiple of 4, as memory is byte addressable.
	offset = offset << 2;
	word_t extended_offset = get_sign_extended_offset(offset);
	registers[PC] += extended_offset;
}
