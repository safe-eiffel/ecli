CC = lcc
PLATFORM=windows
SMALLEIFFEL=c:\user\dev\elj-win32\smalleiffel
CFLAGS = -o -I$(SMALLEIFFEL)\sys\runtime -I.
OBJ = ecli_c.obj
SRC = $(ECLI)\src\spec\C
all:: clean ecli_c.lib

.c.obj:
	$(CC) $(CFLAGS) $< 

ecli_c.lib: $(OBJ) ..\..\C\ecli_c.h
		del $@
		lcclib /out:$@ $(OBJ)

ecli_c.obj: $(SRC)\ecli_c.c $(SRC)\ecli_c.h
	$(CC) $(CFLAGS) $(SRC)\ecli_c.c

clean:
	del *.obj *.lib
