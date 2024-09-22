#include <stdlib.h>
#include <stdio.h>
#include <string.h> 
#include <assert.h>

#include "defns.h"
#include "assembler_defs.h"
#include "assembler/assembly_functions.h"


#define MAX_LINE_LENGTH 512 
#define MAX_NUM_INSTRUCTIONS (65536 / 4)

void parse_first (
	symbol_table_t *table, 
	instruction_t **instructions_p, 
	int *num_instructions, 
	char *arg) 
{
	FILE *file;
	file = fopen(arg,"r");
	char line[MAX_LINE_LENGTH]; 
	int address = 0;
	*num_instructions = 0;
	instruction_t **instructions = instructions_p;

	if(file) {
		while (fgets(line, sizeof(line), file)) {
			if (strchr(line, ':') != NULL) {
				char *label = strtok(line, ":");
				add_entry(table, label, address);
			} else {
				char *mnemonic = strtok(line, " ,\n");
				char **operand_fields = (char**) calloc (4, sizeof(char *));
				
				char *token = mnemonic;
				token = strtok(NULL, " ,\n");

				for(int i = 0; token != NULL; i++) {
					char *string = malloc (sizeof (char) *MAX_LINE_LENGTH);
					strcpy(string, token);

					if (get_shift (string)) {
						token = strtok(NULL, " ,\n");	
						strcat(string, " ");
						strcat(string, token);
					}

					operand_fields[i] = string;
					
					token = strtok(NULL, " ,\n");
				}

				instruction_t *inst = malloc(sizeof(instruction_t *));

				char *string = malloc(sizeof(char) *MAX_LINE_LENGTH);
				strcpy (string, mnemonic);

				inst->mnemonic = string;
				inst->operand_fields = operand_fields; 
				// (instruction_t) {.mnemonic = mnemonic,.operand_fields = operand_fields}
				*instructions = inst;
				// printf("%s",(*instructions_p)->mnemonic);
				instructions++;
				*num_instructions = *num_instructions + 1;
			}
			address+= 4;
		}
		fclose(file);
	}

}

// void parse_second(label_t *labels, char **instructions);

void print_instruction (instruction_t instruction){
	printf("%s : ", instruction.mnemonic);
	for (int i = 0; i < 4; i++)
		printf("%s ", instruction.operand_fields[i]);
	printf("\n");
}

void free_instructions(instruction_t **instructions) {	
	for (; instructions != NULL && (*instructions != NULL); instructions++ ) {
		
		free((*instructions)->mnemonic);
		for (int i = 0; i < 4; i++)
			free((*instructions)->operand_fields [i]);
		
		free((*instructions)->operand_fields);
		free(*instructions);
	}

}

int get_end_address(int num_instructions, int num_appended) {
	return 4 * (num_instructions + num_appended - 1);
}

int main(int argc, char **argv) {
	setbuf(stdout, NULL);
	if (argc != 3) {
		perror("invalid number of arguments");
		return EXIT_FAILURE;
	}

	char *assembly = argv[1];

	instruction_t **instructions = calloc(MAX_NUM_INSTRUCTIONS, sizeof(instruction_t *));
	assert(instructions != NULL);

	symbol_table_t *table = malloc(sizeof(symbol_table_t));
	assert(table != NULL);

	char *appended_memory = malloc(MAX_NUM_INSTRUCTIONS * 4);
	char *appended_memory_ptr = appended_memory;
	int num_instructions;
	int num_appended;
	int end_address;

	symbol_table_init(table);
	
	parse_first (table, instructions, &num_instructions, assembly);

	instruction_t **head = instructions;
	
	FILE *file = fopen(argv[2], "wb");

	int address = 0;
	
	for (; (*head) != NULL && (head) != NULL; (head)++, address += 4) {
		switch(get_Mnemonic((*head)->mnemonic)) {
			case (mnemonic) ADD:
			case (mnemonic) SUB:
			case (mnemonic) RSB:
			case (mnemonic) AND:
			case (mnemonic) EOR:
			case (mnemonic) ORR:
			case (mnemonic) MOV:
			case (mnemonic) TST:
			case (mnemonic) TEQ:
			case (mnemonic) CMP:
				assemble_data_processing(**head, file);
				break;
			case (mnemonic) MUL:
			case (mnemonic) MLA:
				assemble_multiply(**head, file);
				break;
			case (mnemonic) LDR:
			case (mnemonic) STR:
				end_address = get_end_address(num_instructions, num_appended);
				assemble_single_data_transfer(
					**head, 
					file, 
					address, 
					end_address, 
					appended_memory_ptr,
					&num_appended);
				break;
			case (mnemonic) BEQ:
			case (mnemonic) BNE:
			case (mnemonic) BGE:
			case (mnemonic) BGT: 
			case (mnemonic) BLE:
			case (mnemonic) BLT:
			case (mnemonic) B:
				assemble_branch(**head, file, table, address);
				break;
			case (mnemonic) LSL:
				{ 
				char *string = malloc(5 * sizeof(char));
				strcpy(string, "lsl ");
				strcat(string, (*head)->operand_fields[1]);
				char *op_fields[4] = { (*head)->operand_fields[0],
							(*head)->operand_fields[0],
							string};	
				instruction_t lsl = (instruction_t) {.mnemonic = "mov", .operand_fields = op_fields}; 
				assemble_data_processing(lsl, file);

				free(string);
				break;
				}
			case (mnemonic) ANDEQ:
				assemble_andeq(file);
		}
	}

	// Additional memory addresses created by ldr with large arguments is appended.
	for (; *appended_memory_ptr != 0; appended_memory_ptr+=4) {
		// Ensures that an entire word is loaded into the memory.
		fputc(appended_memory_ptr[0], file);
		fputc(appended_memory_ptr[1], file);
		fputc(appended_memory_ptr[2], file);
		fputc(appended_memory_ptr[3], file);
	}

	free_instructions(instructions);
	free(instructions);
	table_destroy(table);

	return EXIT_SUCCESS;
}
