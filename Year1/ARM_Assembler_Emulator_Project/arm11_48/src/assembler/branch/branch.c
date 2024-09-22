#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "../../assembler_defs.h"
#include "branch.h"

/*
 * Branch Instructions Assembler module: implementation
 */

#define cond_offset 28
#define pipeline_offset 8
#define byte_length 8
#define bytes_in_a_word 4

// Possible values of the Cond field.
#define eq 0
#define ne 1
#define ge 10 // 1010
#define lt 11 // 1011
#define gt 12 // 1100
#define le 13 // 1101
#define al 14 // 1110

static word_t get_branch_instruction_template(void) {
	return 0x5 /* 101 */ << 25;
}

static nibble_t get_cond(char *mnemonic) {
	assert(*mnemonic == 'b');
	if (strlen(mnemonic) == 1) {
		return al;
	}
	char first_letter = mnemonic[1];
	char second_letter = mnemonic[2];

	if (first_letter == 'e') {
		// cond == "eq"
		return eq;
	}

	if (first_letter == 'n') {
		// cond == "ne"
		return ne;
	}

	if (first_letter == 'g') {

		if (second_letter == 'e') {
			// cond == "ge"
			return ge;
		} else {
			// cond == "gt"
			return gt;
		}

	} else if (first_letter == 'l') {

		if (second_letter == 'e') {
			// cond == "le"
			return le;
		} else {
			// cond == "lt"
			return lt;
		}
	}
	return al;
}

static void set_cond(word_t *instruction, nibble_t cond) {
	*instruction |= cond << cond_offset;
}

static word_t compute_offset(int offset) {
	if (offset >= 0) {
		// Positive value - no sign adjustment needed.
		// Excess 0s are truncated.
		return offset >> 2;
	}

	// Value is negative, the representation needs adjustment.
	// Before we shift we need to represent the offset as a 
	// 26 bit signed integer.
	word_t result = 1 << 25;

	// Now the bits that will be set need to add up so that:
	// -2^25 + new_offset = old_32_bit_offset.
	word_t new_offset = offset + (1 << 25);
	result |= new_offset;
	// Now it needs to be shifted:
	result >>= 2;
	return result;
}

static void set_offset(word_t *instruction, word_t offset) {
	*instruction |= offset;
}

// Returns nth byte in a word instruction, byte indices start at 1.
static byte_t get_Nth_byte(int n, word_t word) {
	return (byte_t) (word >> ((bytes_in_a_word - n) * byte_length));
}

// Writes to the file in little Endian.
void write_word(word_t word, FILE *file) {
	fputc(get_Nth_byte(4, word), file);
	fputc(get_Nth_byte(3, word), file);
	fputc(get_Nth_byte(2, word), file);
	fputc(get_Nth_byte(1, word), file);
}

void assemble_branch(
	instruction_t instruction,
	FILE *file,
	symbol_table_t *table, 
	int current_address) 
{
	// TODO: implement the case when the <expression> is not a label.
	char *label = (instruction.operand_fields)[0];
	nibble_t cond = get_cond(instruction.mnemonic); 

	word_t binary_instruction = get_branch_instruction_template();


	set_cond(&binary_instruction, cond);

	int destination_address = get_address(table, label);

	int offset_32_bits = destination_address - current_address - pipeline_offset;

	word_t offset_24_bits = compute_offset(offset_32_bits);

	set_offset(&binary_instruction, offset_24_bits);

	write_word(binary_instruction, file);
}
