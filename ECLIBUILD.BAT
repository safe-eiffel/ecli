@echo off
rem -- ECLI build procedure
rem -- (c) 2000-2001 - Paul G. Crismer
rem -- Released under the Eiffel-Forum Licence : see forum.txt

echo ** ECLI build procedure **

rem -- path of ECLI
if "%ECLI%"=="" goto vareclierr

rem -- compilation variables
set LIBS=%ECLI%\src\spec\se\windows\ecli_c.lib ODBC32.lib
set SEFLAGS=-case_insensitive -no_style_warning
set BUILDFLAGS=-subsystem console

rem
rem -- Test for target and creation feature
rem
if "%1%"=="" goto targeterr
set TARGET=%1%
if "%2%"=="" goto creationerr
set CREATION=%2%

echo *  Building %TARGET% creation %CREATION%

rem -- Compile
 
compile %SEFLAGS% %BUILDFLAGS% %LIBS% %TARGET% %CREATION%
goto done

:targeterr
echo    Missing argument "target-class"

:creationerr
echo    Missing argument "creation-feature"

:usage
echo Usage : "ECLIBUILD <target-class> <creation-feature>"
goto done

:vareclierr
echo Error : ECLI variable not set !

:done
 
