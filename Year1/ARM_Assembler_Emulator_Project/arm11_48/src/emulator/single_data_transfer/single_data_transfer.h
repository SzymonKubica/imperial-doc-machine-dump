#include"../../defns.h"

/*
 * Single data transfer module: 
 * Decodes and executes a 32 bit single data transfer instruction.
 */

void execute_single_data_transfer(
		byte_t *firstByte, 
		word_t *registers, 
		byte_t *memory,
		byte_t *gpio_memory);
