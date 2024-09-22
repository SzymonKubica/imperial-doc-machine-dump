CC      = gcc
EMULATOR_DIRECTORIES = $(sort $(dir $(wildcard emulator/*/)))
EMULATOR_FLAGS = $(foreach EMULATOR_DIRECTORIES, $(EMULATOR_DIRECTORIES), -I$(EMULATOR_DIRECTORIES)) -Iemulator
ASSEMBLER_DIRECTORIES = $(sort $(dir $(wildcard ./assembler/*/)))
ASSEMBLER_FLAGS = $(foreach ASSEMBLER_DIRECTORIES, $(ASSEMBLER_DIRECTORIES), -I$(ASSEMBLER_DIRECTORIES)) -Iassembler
CFLAGS  = -Wall -g -D_POSIX_SOURCE -D_DEFAULT_SOURCE -std=c99 -Werror -pedantic  
EMULATOR_LDLIBS = -Lemulator/data_processing -ldata_processing -Lemulator/multiply -lmultiply -Lemulator/branch -lbranch -Lemulator/single_data_transfer -lsingle_data_transfer -Lemulator/cond -lcond -Lemulator/common_functions -lcommon -Lemulator/gpio -lgpio
ASSEMBLER_LDLIBS  =  -Lassembler/data_processing -ldata_processing -Lassembler/multiply -lmultiply -Lassembler/single_data_transfer -lsingle_data_transfer -Lassembler/branch -lbranch -lspecial -Lassembler/special -Lassembler/symbol_table -lsymbol_table 
BUILD   = libs assemble emulate

.SUFFIXES: .c .o

.PHONY: all clean

all: $(BUILD)  

clean:
	/bin/rm -f $(BUILD) *.o core
	cd emulator; make clean
	cd assembler; make clean

libs:
	cd assembler; make
	cd emulator; make


assemble: assembler_defs.o assemble.o
	$(CC) $^ $(ASSEMBLER_LDLIBS)  -o $@
assembler_defs.o: assembler_defs.h
	$(CC) -c assembler_defs.c $(ASSEMBLER_FLAGS) $(CFLAGS) 
assemble.o: assembler_defs.h assembler/assembly_functions.h
	$(CC) $(CFLAGS) $(ASSEMBLER_FLAGS) -c assemble.c


emulate: emulate.o
	$(CC) $^ $(EMULATOR_LDLIBS) -o $@
emulate.o: defns.h emulator/emulator_functions.h
	$(CC) -c emulate.c $(CFLAGS) $(EMULATOR_FLAGS)   

# $(CC) $(CFLAGS) $(LDLIBS) 

# 	$(CC) $(ASSEMBLER_LDLIBS) $<
#	$(CC) -c assemble.c $(ASSEMBLER_FLAGS) $(CFLAGS) 
# 	$(CC) -c assembler_defs.c $(ASSEMBLER_FLAGS) $(CFLAGS) 
