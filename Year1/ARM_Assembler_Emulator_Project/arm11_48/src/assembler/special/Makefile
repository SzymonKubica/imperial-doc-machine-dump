C     = gcc
CFLAGS = -Wall -g -D_POSIX_SOURCE -D_DEFAULT_SOURCE -std=c99 -Werror -pedantic
LIB    = libspecial.a
LIBOBJ = special.o
BUILD  = $(LIB)

all: $(BUILD)

clean: 
	        /bin/rm -f $(BUILD) *.o core

$(LIB): $(LIBOBJ)
	        ar rcs $(LIB) $(LIBOBJ)
