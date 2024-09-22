#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#include "branch.h"
#include "binaryString.h"

void testcond(bool condition, char *test_name) {
		printf( "T %s: %s\n", test_name, (condition ? "OK" : "FAIL"));
}

int main(void) {

	// Hard-coding the instruction:
	byte_t *instruction = malloc(4);
	// bne loop from page 17 in the spec.
	instruction[0] = readBinary("00011010");
	instruction[1] = readBinary("11111111");
	instruction[2] = readBinary("11111111");
	instruction[3] = readBinary("11111010");
	//byte_t *memory = malloc(65536);
	word_t *registers = malloc(17 * sizeof(word_t));

	for (int i = 0; i < 17; i++) {
		registers[i] = 0;
	}

	execute_branch(instruction, registers);


	return 0;
}

