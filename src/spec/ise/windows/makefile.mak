CC = cl
ISE_PLATFORM=windows
CFLAGS = -c -Ox -W3 -I$(ISE_EIFFEL)\studio\spec\$(ISE_PLATFORM)\include -I.
OBJ = ecli_c.obj

all:: ecli_var clean ecli_c.lib

.c.obj:
	$(CC) $(CFLAGS) ..\..\C\$< 

ecli_c.lib: $(OBJ) ..\..\C\ecli_c.h
	-del $@
	lib /OUT:$@ $(OBJ)

ecli_c.obj: ecli_var ..\..\C\ecli_c.c ..\..\C\ecli_c.h
	$(CC) $(CFLAGS) ..\..\C\ecli_c.c

clean:
	-del *.obj
	-del *.lib

ecli_var:
! IFNDEF ECLI
!    ERROR ECLI environment variable not set ! Set it first, then make the build.
! ENDIF
! IFNDEF ISE_EIFFEL
!    ERROR ISE_EIFFEL environment variable not set ! Set it first, then make the build.
! ENDIF