CC = cl
ISE_PLATFORM=$(ISE_PLATFORM)
CFLAGS = -c -Ox -W3 -I"$(ISE_EIFFEL)\studio\spec\$(ISE_PLATFORM)\include" -I.
OBJ = ecli_msc.obj

all:: ecli_var clean ecli_msc.lib

.c.obj:
	$(CC) $(CFLAGS) ..\..\C\$< 

ecli_msc.lib: $(OBJ) ..\..\C\ecli_c.h
	-del $@
	lib /OUT:$@ $(OBJ)

ecli_msc.obj: ecli_var ..\..\C\ecli_c.c ..\..\C\ecli_c.h
	$(CC) $(CFLAGS) ..\..\C\ecli_c.c
	-rename ecli_c.obj ecli_msc.obj

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
! IFNDEF ISE_EIFFEL
!    ERROR ISE_EIFFEL environment variable not set ! Set it first, then make the build. Valid values are windows, linux.
! ENDIF