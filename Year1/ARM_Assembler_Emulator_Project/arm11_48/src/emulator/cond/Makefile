CC     = gcc
CFLAGS = -Wall -g -D_POSIX_SOURCE -D_DEFAULT_SOURCE -std=c99 -Werror -pedantic  -I../../lib
LDLIBS = -L../../lib -lbinaryString
LIB    = libcond.a
LIBOBJ = cond.o
BUILD  = $(LIB) 

all: $(BUILD) 

clean: 
	/bin/rm -f $(BUILD) *.o core
	

$(LIB): $(LIBOBJ)
	ar rcs $(LIB) $(LIBOBJ)

cond.o: cond.h
