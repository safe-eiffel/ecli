rem 
rem -- Variable definition
rem 
ECLI=c:\user\pgc\ecli
rem
rem -- Compile
rem
compile -boost -case_insensitive -no_style_warning -subsystem console %ECLI%\src\spec\se\windows\ecli_c.lib C:\User\Dev\elj-win32\lcc\lib\ODBC32.lib qa_example make 
 
