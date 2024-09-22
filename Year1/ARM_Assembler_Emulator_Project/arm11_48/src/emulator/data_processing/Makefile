CC     = gcc
CFLAGS = -Wall -g -D_POSIX_SOURCE -D_DEFAULT_SOURCE -std=c99 -Werror -pedantic -I../common_functions
LDLIBS = -L../common_functions
LIB    = libdata_processing.a
LIBOBJ = data_processing.o 
BUILD  = $(LIB)

all: $(BUILD)

clean: 
	/bin/rm -f $(BUILD) *.o core

$(LIB): $(LIBOBJ)
	ar rcs $(LIB) $(LIBOBJ)



