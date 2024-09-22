CC     = gcc
CFLAGS = -Wall -g -D_POSIX_SOURCE -D_DEFAULT_SOURCE -std=c99 -Werror -pedantic -I../symbol_table
LDLIBS = -L../symbol_table -lsymbol_table
LIB    = libbranch.a
LIBOBJ = branch.o
BUILD  = $(LIB)

all: $(BUILD)

clean: 
	/bin/rm -f $(BUILD) *.o core

$(LIB): $(LIBOBJ)
	ar rcs $(LIB) $(LIBOBJ)

test: branch_test

branch.o: branch.h

branch_test: branch_test.o branch.o
branch_test.o: branch.h



