SHELL = /bin/sh
CC = cc
AR = ar
RANLIB = ranlib
PLATFORM = linux-glibc2.1
SMALLEIFFELDIR=$(SmallEiffel:/sys/system.se=)
CFLAGS =  -O -I$(SMALLEIFFELDIR)/sys/runtime -I. -I/usr/local/include
RM = /bin/rm -f
SRC = $(ECLI)/src/spec/c
OBJ = ecli_c.o io.o

all: libecli_c.a 

.c.o:
	$(CC) $(CFLAGS) -c $(SRC)/$<

libecli_c.a: $(OBJ)
	$(AR) -ru $@ $(OBJ)
	$(RANLIB) $@

ecli_c.o:  $(SRC)/ecli_c.c
	$(CC) $(CFLAGS) -c $<

io.o:  $(SRC)/io.c
	$(CC) $(CFLAGS) -c $<

clean:
	$(RM) libecli_c.a $(OBJ)

