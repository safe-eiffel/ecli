set PLATFORM=windows
set SMARTEIFFELDIR=C:\User\Dev\SmartEiffel
lcc  -I%SMARTEIFFELDIR%\sys\runtime\c -I. %ECLI%\src\spec\C\ecli_c.c
del ecli_lcc.lib
lcclib /out:ecli_lcc.lib ecli_c.obj

