set PLATFORM=windows
set SMARTEIFFELDIR=c:\user\dev\smarteiffel
lcc -o -I%SMARTEIFFELDIR%\sys\runtime\c -I. %ECLI%\src\spec\C\ecli_c.c
lcc -o -I%SMARTEIFFELDIR%\sys\runtime\c -I. %ECLI%\src\spec\C\io.c
del ecli_c.lib
lcclib /out:ecli_c.lib ecli_c.obj io.obj

