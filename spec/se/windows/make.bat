set PLATFORM=windows
set SMALLEIFFELDIR=c:\user\dev\elj-win32\smalleiffel
lcc -o -I%SMALLEIFFEL%\sys\runtime -I. ..\..\C\ecli_c.c
del ecli_c.lib
lcclib /out:ecli_c.lib ecli_c.obj

