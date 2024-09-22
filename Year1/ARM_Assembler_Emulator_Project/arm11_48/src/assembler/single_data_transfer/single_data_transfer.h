#include "../../defns.h"
#include "../../assembler_defs.h"

/*
 * Single Data Transfer Instruction Assembler module.
 */

void assemble_single_data_transfer(
	instruction_t instruction, 
	FILE *file,
	int current_address,
	int end_address,
	char *appended_memory,
	int *num_appended);
