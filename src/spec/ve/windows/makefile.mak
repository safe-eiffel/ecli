CC = cl
PLATFORM=windows
CFLAGS = -c -Ox -W3 -Zl -Id:\user\programs\ObjectTools\VisualEiffel\bin -I.
OBJ = ecli_c.obj

all:: ecli_msc.lib

.c.obj:
	$(CC) $(CFLAGS) ..\..\C\$< 

ecli_msc.lib: $(OBJ) ..\..\C\ecli_c.h
	-del $@
	lib /OUT:$@ $(OBJ)

ecli_c.obj: ..\..\C\ecli_c.c ..\..\C\ecli_c.h
	$(CC) $(CFLAGS) ..\..\C\ecli_c.c

clean:
	-del *.obj
	-del *.lib
