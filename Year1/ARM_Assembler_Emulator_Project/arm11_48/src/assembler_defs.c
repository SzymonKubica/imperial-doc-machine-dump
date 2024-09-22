#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>

#include "assembler_defs.h"

byte_t get_Register (char *string){
        assert (*string == 'r');
        return strtol(++string, NULL, 10);
}

mnemonic get_Mnemonic (char *m){
	if (strcmp(m, "add") == 0){
		return (mnemonic) ADD;
	}
	else if (strcmp(m, "sub") == 0){
		return (mnemonic) SUB;
	}
	else if (strcmp(m, "rsb") == 0){
		return (mnemonic) RSB;
	}
	else if (strcmp(m, "and") == 0){
		return (mnemonic) AND;
	}
	else if (strcmp(m, "eor") == 0){
		return (mnemonic) EOR;
	}
	else if (strcmp(m, "orr") == 0){
		return (mnemonic) ORR;
	}
	else if (strcmp(m, "mov") == 0){
		return (mnemonic) MOV;
	}
	else if (strcmp(m, "tst") == 0){
		return (mnemonic) TST;
	}
	else if (strcmp(m, "teq") == 0){
		return (mnemonic) TEQ;
	}
	else if (strcmp(m, "cmp") == 0){
		return (mnemonic) CMP;
	}
	else if (strcmp(m, "mul") == 0){
		return (mnemonic) MUL;
	}
	else if (strcmp(m, "mla") == 0){
		return (mnemonic) MLA;
	}
	else if (strcmp(m, "ldr") == 0){
		return (mnemonic) LDR;
	}
	else if (strcmp(m, "str") == 0){
		return (mnemonic) STR;
	}
	else if (strcmp(m, "beq") == 0){
		return (mnemonic) BEQ;
	}
	else if (strcmp(m, "bne") == 0){
		return (mnemonic) BNE;
	}
	else if (strcmp(m, "bge") == 0){
		return (mnemonic) BGE;
	}
	else if (strcmp(m, "bgt") == 0){
		return (mnemonic) BGT;
	}
	else if (strcmp(m, "ble") == 0){
		return (mnemonic) BLE;
	}
	else if (strcmp(m, "blt") == 0){
		return (mnemonic) BLT;
	}
	else if (strcmp(m, "b") == 0){
		return (mnemonic) B;
	}
	else if (strcmp(m, "lsl") == 0){
		return (mnemonic) LSL;
	}
	else if (strcmp(m, "andeq") == 0){
		return (mnemonic) ANDEQ;
	} else {
		perror("mnemonic not found");
		exit(EXIT_FAILURE);
	}
}

void write_to_file (FILE *file, byte_t firstByte, byte_t secondByte, byte_t thirdByte, byte_t fourthByte) {
	fputc(fourthByte, file);
	fputc(thirdByte, file);
	fputc(secondByte, file);
	fputc(firstByte, file);
}	

