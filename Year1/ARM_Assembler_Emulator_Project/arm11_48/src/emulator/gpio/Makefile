CC     = gcc
CFLAGS = -Wall -g -D_POSIX_SOURCE -D_DEFAULT_SOURCE -std=c99 -Werror -pedantic -I../common_functions 
LDLIBS = -L../common_functions/ -lcommon
LIB    = libgpio.a
LIBOBJ = gpio.o
BUILD  = $(LIB) 

all: $(BUILD)

clean: 
	/bin/rm -f $(BUILD) *.o core

$(LIB): $(LIBOBJ)
	ar rcs $(LIB) $(LIBOBJ)

gpio.o: gpio.h
