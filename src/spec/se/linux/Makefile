SHELL 		= /bin/sh
SMALLEIFFEL= /usr/local/pgc/SmallEiffel
CC 		= cc
AR 		= ar
RANLIB 		= ranlib
PLATFORM 	= linux-glibc2.1
CFLAGS 		=  -O -I$(SMALLEIFFEL)/sys/runtime -I. -I/usr/local/include
RM 		= /bin/rm -f
OBJ 		= ecli_c.o io.o
ECLI 		= /home/pgc/eiffel/library/ecli

SRC 		= $(ECLI)/spec/c


all: libecli_c.a 

.c.o:
	$(CC) $(CFLAGS) -c ($SRC)/$<

libecli_c.a: $(OBJ)
	$(AR) -ru $< $(OBJ)
	$(RANLIB) $<
 
ecli_c.o:  $(SRC)/ecli_c.c $(SRC)/io.c
	$(CC) $(CFLAGS) -c $<
 
clean:
 libecli_c.a $(OBJ)
	$(RM) $@


 

