set PLATFORM=windows
set SMARTEIFFELDIR=D:\User\Programs\SmartEiffel
lcc  -I%SMARTEIFFELDIR%\sys\runtime -I. %ECLI%\src\spec\C\ecli_c.c
lcc  -I%SMARTEIFFELDIR%\sys\runtime -I. %ECLI%\src\spec\C\io.c
del ecli_c.lib
lcclib /out:ecli_c.lib ecli_c.obj io.obj

