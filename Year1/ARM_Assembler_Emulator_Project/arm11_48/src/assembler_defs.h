#ifndef ASSEMBLER_DEFS_H
#define ASSEMBLER_DEFS_H
#include <stdbool.h>
#include <stdio.h>

#include "defns.h"

/*
union struct {
	nibble_t reg;
	word_t value;
} field_t;


typedef struct {
	bool type; //register or number
	field_t field;
} operand_t;
*/

typedef struct {
	char *mnemonic;
	char **operand_fields; 
} instruction_t;

typedef enum {
	AND = 0x0,
	EOR = 0x1,
	SUB = 0x2,
	RSB = 0x3,
	ADD = 0x4,
	TST = 0x8,
	TEQ = 0x9,
	CMP = 0xa,
	ORR = 0xc,
	MOV = 0xd,
	MUL,
	MLA,
	LDR,
	STR,
	BEQ,
	BNE,
	BGE,
	BLT,
	BGT,
	BLE,
	B,
	LSL,
	ANDEQ
} mnemonic; 	

// Returns register number i.e r0 -> 0
byte_t get_Register (char *string);

// Returns mnemonic enum value i.e "and" -> AND (0x0)
mnemonic get_Mnemonic (char *m);

// Writes Instruction word in Little Endian Encoding to FILE file 
void write_to_file (FILE *file, byte_t firstByte, byte_t secondByte, byte_t thirdByte, byte_t fourthByte); 

#endif
