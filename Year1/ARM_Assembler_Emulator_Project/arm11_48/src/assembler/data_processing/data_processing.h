#ifndef DATA_N
#define DATA_N

#include "../../assembler_defs.h"

void assemble_data_processing (instruction_t instruction, FILE *file);

byte_t get_shift (char *);

#endif
