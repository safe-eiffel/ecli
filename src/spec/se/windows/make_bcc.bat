set PLATFORM=windows
set SMALLEIFFELDIR=m:\elj-win32\smalleiffel
bcc32 -c -I%SMALLEIFFELDIR%\sys\runtime -I. -oecli_c.obj %ECLI%\src\spec\C\ecli_c.c 
bcc32 -c -I%SMALLEIFFELDIR%\sys\runtime -I. -oio.obj %ECLI%\src\spec\C\io.c
del ecli_c.lib
tlib ecli_c.lib +ecli_c.obj +io.obj

