#include <stdio.h>
#include "../../defns.h"
#include "data_processing.h"
#include "common.h"

#define and 0 // 0b0000
#define eor 1 // 0b0001
#define sub 2 // 0b0010
#define rsb 3 // 0b0011
#define add 4 // 0b0100
#define tst 8 // 0b1000
#define teq 9 // 0b1001
#define cmp 10// 0b1010
#define orr 12// 0b1100
#define mov 13// 0b1101

#define lsl 0 //0b00
#define lsr 1 //0b01
#define asr 2 //0b10
#define ror 3 //0b11

static bit_t get_immediate_operand(byte_t firstByte) {
	return (firstByte & 2) >> 1;
}

static nibble_t get_OpCode(byte_t firstByte, byte_t secondByte) {
	return ((firstByte & 1) << 3) | ((secondByte) >> 5);
}

static nibble_t get_Rn(byte_t secondByte) {
	return secondByte & 0xf /* 1111 */;
}

static nibble_t get_Rd(byte_t thirdByte) {
	return thirdByte >> 4;
}

static nibble_t get_S(byte_t secondByte) {
	return get_First_Nibble(secondByte) & 1;
}

static word_t get_Operand2(byte_t thirdByte, byte_t fourthByte, 
		bit_t immediate_operand, word_t *registers, bit_t *carry) {

	// Operand2 immediate value
	if (immediate_operand) {
		byte_t rotation = (thirdByte & 0xf) << 1; 
		return shifter (3, rotation, fourthByte, carry);
	}

	// Operand2 register
	else {		
		nibble_t Rm = fourthByte & 0xf;

		// The shift is specified by the second nibble of the thirdByte and the 
		// first nibble of the fourthByte.

		byte_t shift = ((thirdByte & 0xf) << 4) | (fourthByte >> 4);
		nibble_t shiftType = (shift & 0x6 /* 110 */) >> 1;

		word_t wordToShift = registers[Rm];

		if (!(shift & 1)) { 

			// Bit 4 is 0: shift by a constant.
			byte_t integer = shift >> 3;
			return shifter (shiftType, integer, wordToShift, carry); 

		} else {

			// Bit 4 is 1: shift by a specified register.
			byte_t Rs = get_Second_Nibble (thirdByte);
			return shifter (shiftType, registers[Rs], wordToShift, carry);
		}
	}
}

static void set_CPSR(word_t result, word_t *cpsr, bit_t logical_op, bit_t carry) {
	// Set N-bit
	*cpsr &= 0x7fffffff;
	*cpsr |= ((result >> 30) & 1) << 31;
	
	// Set Z-bit 
	if(!result) {
		*cpsr |= 0x40000000;
	} else {
		*cpsr &= 0xbfffffff;
	}

	// Set C-bit to 0
	*cpsr &= 0xdfffffff;
	*cpsr |= (carry << 29);
}


void execute_data_processing(byte_t *firstByte, word_t *registers) {
	bit_t carry = 0;
	word_t operand2 
		= get_Operand2(firstByte[2], firstByte[3], 
				get_immediate_operand(firstByte[0]), registers,
				&carry); 

	nibble_t Rn = get_Rn(firstByte[1]);
	nibble_t Rd = get_Rd(firstByte[2]);

	nibble_t opCode = get_OpCode(firstByte[0], firstByte[1]);
	word_t result = 0; 
	bit_t logical_op = 0; 

	switch (opCode) {
		case and:
			registers[Rd] = registers[Rn] & operand2;
			result = registers[Rd];
			logical_op = 1;	
			break;
		case eor:
			registers[Rd] = registers[Rn] ^ operand2;
			result = registers[Rd];
			logical_op = 1;
			break;
		case sub:
			registers[Rd] = registers[Rn] - operand2;
			result = registers[Rd]; 
			//logical_op = -1;
			carry = operand2 > registers[Rn] ? 0 : 1;
			break;
		case rsb:
			registers[Rd] = operand2 - registers[Rn];
			result = registers[Rd];
		  //logical_op = -1;
			carry = operand2 > registers[Rn] ? 0 : 1;
			break;
		case add:
			registers[Rd] = registers[Rn] + operand2;
			result = registers[Rd];
			// if carry set C to 1
			carry = (registers[Rn] + operand2) >> 31 ? 1 : 0;
			break;
		case tst:
			result = registers[Rn] & operand2; 
			logical_op = 1; 
			break;
		case teq: 
			result = registers[Rn] ^ operand2; 
			logical_op = 1;
			break;
		case cmp:
			// if borrow carry = 1
			result = registers[Rn] - operand2; 
			//logical_op = -1;
			carry = operand2 > registers[Rn] ? 0 : 1;
			break;
		case orr:
			registers[Rd] = registers[Rn] | operand2; 
			result = registers[Rd];
			logical_op = 1; 
			break;
		case mov:
			registers[Rd] = operand2; 
			result = registers[Rd];
			logical_op = 1; 	
			break; 	
	}

	if (get_S(firstByte[1])) {
		set_CPSR(result, &registers[16], logical_op, carry); 
	}
}

