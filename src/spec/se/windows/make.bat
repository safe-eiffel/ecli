@echo off
set PLATFORM=windows
set SMARTEIFFELDIR=d:\user\programs\smarteiffel

if exist %SMARTEIFFELDIR% goto seexist
echo Variable SMARTEIFFELDIR not set to existing path.
echo Please update this script
echo SMARTEIFFELDIR='%SMARTEIFFELDIR%'
goto doexit

:seexist

lcc  -I%SMARTEIFFELDIR%\sys\runtime -I. %ECLI%\src\spec\C\ecli_c.c
del ecli_lcc.lib
lcclib /out:ecli_lcc.lib ecli_c.obj

:doexit

echo exiting...