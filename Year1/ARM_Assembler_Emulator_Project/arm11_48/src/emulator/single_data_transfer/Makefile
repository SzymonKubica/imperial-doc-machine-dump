CC     = gcc
CFLAGS = -Wall -g -D_POSIX_SOURCE -D_DEFAULT_SOURCE -std=c99 -Werror -pedantic -I../common_functions -I../gpio
LDLIBS = -L../common_functions/ -lcommon -L../gpio/ -lgpio
LIB    = libsingle_data_transfer.a
LIBOBJ = single_data_transfer.o
BUILD  = $(LIB) 

all: $(BUILD)

clean: 
	/bin/rm -f $(BUILD) *.o core

$(LIB): $(LIBOBJ)
	ar rcs $(LIB) $(LIBOBJ)

test: single_data_transfer_test

single_data_transfer_test: single_data_transfer_test.o single_data_transfer.o 
single_data_transfer_test.o: single_data_transfer.h
single_data_transfer.o: single_data_transfer.h
