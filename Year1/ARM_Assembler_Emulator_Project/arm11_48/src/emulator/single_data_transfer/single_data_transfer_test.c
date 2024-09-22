#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#include "single_data_transfer.h"
#include "binaryString.h"

void testcond(bool condition, char *test_name) {
	printf( "T %s: %s\n", test_name, (condition ? "OK" : "FAIL"));
}

int main(void) {

	// Hard-coding the instruction:
	byte_t *instruction = malloc(4);
	// str r2, [r3] from page 17 in the spec.
	instruction[0] = readBinary("11100101");
	instruction[1] = readBinary("10000011");
	instruction[2] = readBinary("00100000");
	instruction[3] = readBinary("00000000");

	byte_t *memory = malloc(65536);
	word_t *registers = malloc(17 * sizeof(word_t));

	for (int i = 0; i < 17; i++) {
		registers[i] = 0;
	}

	// Hard-coding some data in the register r2:
	registers[readBinary("0010" /* register r2 */)] = readBinaryWord(
		"00000000 00000000 00000000 00001000" // data stored: 16;
	);

	execute_single_data_transfer(instruction, registers, memory);

	testcond(memory[registers[readBinary("0011" /* r3 */)]] == 8, "execute");

	return 0;
}
