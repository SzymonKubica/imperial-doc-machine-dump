#include <stdio.h> 
#include "../../defns.h"
#include "common.h"

/*
 * Multiply Instruction Module: implementation.
 */

static nibble_t get_Rn_multiply(byte_t thirdByte) {
	return get_First_Nibble(thirdByte); 
}

static nibble_t get_Rd_multiply(byte_t secondByte) {
	return get_Second_Nibble(secondByte);
}

static nibble_t get_Rs(byte_t thirdByte) {
	return get_Second_Nibble(thirdByte); 
}

static nibble_t get_Rm(byte_t fourthByte) {
	return get_Second_Nibble(fourthByte);
}

static bit_t get_A(byte_t secondByte) {
	return get_First_Nibble(secondByte) >> 1;
}

static bit_t get_S(byte_t secondByte) {
	return get_First_Nibble(secondByte) & 1;
}

static void set_CPSR(word_t result, word_t *cpsr) {
	*cpsr &= 0x7fffffff;
	*cpsr |= (result >> 31) << 31;

	if(!result) {
		*cpsr |= 0x40000000;
	}	       
}

void execute_multiply(byte_t *firstByte, word_t *registers) {

	nibble_t Rd = get_Rd_multiply(firstByte[1]); 
	nibble_t Rs = get_Rs(firstByte[2]);
	nibble_t Rm = get_Rm(firstByte[3]);

	if (get_A(firstByte[1])) {
		nibble_t Rn = get_Rn_multiply(firstByte[2]);

		registers[Rd] = registers[Rm] * registers[Rs] + registers[Rn];
	} else {

		registers[Rd] = registers[Rm] * registers[Rs]; 
	}
	
	if (get_S(firstByte[1])) {
		set_CPSR(registers[Rd], &registers[16]);
	}
}
