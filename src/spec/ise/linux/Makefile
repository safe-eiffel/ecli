SHELL = /bin/sh
CC = cc
AR = ar
RANLIB = ranlib
PLATFORM = linux-glibc2.1
CFLAGS =  -O -I$(ISE_EIFFEL)/studio/spec/$(ISE_PLATFORM)/include -I. -I/usr/include
RM = /bin/rm -f
SRC = $(ECLI)/src/spec/C
OBJ = ecli_c.o

.c.o:
	$(CC) $(CFLAGS) -c $(SRC)/$<

libecli_c.a: eclivar $(OBJ)
	$(AR) -ru $@ $(OBJ)
	$(RANLIB) $@

ecli_c.o:  $(SRC)/ecli_c.c
	$(CC) $(CFLAGS) -c $<

.PHONY: all clean eclivar

clean:
	$(RM) libecli_c.a $(OBJ)

all: eclivar libecli_c.a 

eclivar:
	@if test -z "$(ECLI)" ; then \
		 echo "* ERROR * -- ECLI variable not set "; \
		 echo "*         -- Please set it first, then make the build !" ;  \
	fi
