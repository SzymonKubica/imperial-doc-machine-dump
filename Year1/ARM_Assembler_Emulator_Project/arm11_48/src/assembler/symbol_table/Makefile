CC     = gcc
CFLAGS = -Wall -g -D_POSIX_SOURCE -D_DEFAULT_SOURCE -std=c99 -Werror -pedantic 
LIB    = libsymbol_table.a
LIBOBJ = symbol_table.o 
BUILD  = $(LIB)

all: $(BUILD)

clean: 
	/bin/rm -f $(BUILD) *.o core

$(LIB): $(LIBOBJ)
	ar rcs $(LIB) $(LIBOBJ)

test: symbol_table_test

symbol_table.o: symbol_table.h

symbol_table_test: symbol_table_test.o symbol_table.o
symbol_table_test.o: symbol_table.h





