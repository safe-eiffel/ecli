set PLATFORM=windows
set SMALLEIFFELDIR=D:\elj-win32\smalleiffel
lcc -o -I%SMALLEIFFELDIR%\sys\runtime -I. %ECLI%\src\spec\C\ecli_c.c
lcc -o -I%SMALLEIFFELDIR%\sys\runtime -I. %ECLI%\src\spec\C\io.c
del ecli_c.lib
lcclib /out:ecli_c.lib ecli_c.obj io.obj

