#include "symbol_table.h"
#include "../../defns.h"

/*
 * Branch Instructions Assembler module.
 */

void assemble_branch(
	instruction_t instruction,
	FILE *file,
	symbol_table_t *table,
	int current_address);
