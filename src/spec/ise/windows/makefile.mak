CC = cl
PLATFORM=windows
CFLAGS = -c -Ox -W3 -I$(ISE_EIFFEL)\studio\spec\$(PLATFORM)\include -I.
OBJ = ecli_c.obj

all:: clean ecli_c.lib

.c.obj:
	$(CC) $(CFLAGS) ..\..\C\$< 

ecli_c.lib: $(OBJ) ..\..\C\ecli_c.h
		-del $@
		lib /OUT:$@ $(OBJ)

ecli_c.obj: ..\..\C\ecli_c.c ..\..\C\ecli_c.h
	$(CC) $(CFLAGS) ..\..\C\ecli_c.c

clean:
	-del *.obj
	-del *.lib
