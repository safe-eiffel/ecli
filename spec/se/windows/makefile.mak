CC = lcc
PLATFORM=windows
SMALLEIFFEL=c:\user\dev\elj-win32\smalleiffel
CFLAGS = -o -I$(SMALLEIFFEL)\sys\runtime -I.
OBJ = ecli_c.obj

all:: clean ecli_c.lib

.c.obj:
	$(CC) $(CFLAGS) ..\..\C\$< 

ecli_c.lib: $(OBJ) ..\..\C\ecli_c.h
		del $@
		lcclib /out:$@ $(OBJ)

ecli_c.obj: ..\..\C\ecli_c.c ..\..\C\ecli_c.h
	$(CC) $(CFLAGS) ..\..\C\ecli_c.c

clean:
	del *.obj *.lib
