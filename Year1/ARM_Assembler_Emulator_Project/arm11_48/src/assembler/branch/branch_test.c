#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#include "../../assembler_defs.h"
#include "../../defns.h"
#include "branch.h"

void testcond(bool condition, char *test_name) {
	printf( "T %s: %s\n", test_name, (condition ? "OK" : "FAIL"));
}

void print_byte(byte_t byte) {
	bit_t bits[8];
	for (int i = 1; i <= 8; i++) {
		bits[8 - i] = byte & 1;
		byte >>= 1;
	}
	for (int i = 0; i < 8; i++) {
		printf("%d", bits[i]);
	}
	printf(" ");
}

void print_binary(word_t word) {
	for (int i = 0; i < 4; i++, word >>= 8) {
		print_byte(word & 255);
	}
	printf("\n");
}

word_t get_word(byte_t buffer[4]) {
	word_t result = 0;
	for (int i = 0; i < 4; i++) {
		result |= buffer[3 - i];
		if (i != 3 ) {
			result <<= 8;
		}
	}
	return result;
}

void log_output(word_t output) {
	printf("Value of output in memory: \n");

	// Prints the result in the same format as on p17 in the spec.
	print_binary(output);

	// Prints the hex value of output for finding expected values.
	printf("Hex value: %08x\n", output);
}

void run_test(
	char *test_name,
	char *mnemonic, 
	char *label, 
	char *file_name,
	int label_address, 
	int current_address, 
	word_t expected_result,
	bool is_logging_enabled) 
{

	// Initialising arguments.
	char **operand_fields = (char **) calloc(4, sizeof(char *));
	operand_fields[0] = label;
	instruction_t instruction = {mnemonic, operand_fields};

	// Populating symbol table.
	symbol_table_t *table = malloc(sizeof(symbol_table_t));
	symbol_table_init(table);
	add_entry(table, operand_fields[0], label_address);

	FILE *file;
	file = fopen(file_name, "wb");

	if (file) {
		assemble_branch(instruction, file, table, current_address);
	}

	fclose(file);

	FILE *file_read;
	file_read = fopen(file_name, "rb");

	byte_t buffer[4];
	fread(buffer, sizeof(buffer), 1, file_read);
	word_t result = get_word(buffer);

	fclose(file_read);
	table_destroy(table);
	free(operand_fields);

	testcond(result == expected_result, test_name);

	if (is_logging_enabled) {
		log_output(result);
	}

}

int main(void) {

	// This test case simulates the assembly of a bne loop instruction from p17.
	run_test("bne loop", "bne", "loop", "test_binaries/test1.bin", 0x8, 0x18, 0x1afffffa, false);

	// This test case simulates the assembly of a b foo instruction from test suite.
	run_test("b foo", "b", "foo", "test_binaries/test2.bin", 0xc, 0x4, 0xea000000, false);

	// This test case simulates the assembly of a beq foo instruction from test suite.
	run_test("beq foo", "beq", "foo", "test_binaries/test3.bin", 0x14, 0xc, 0xa000000, false);
}
