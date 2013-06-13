Eiffel Library to ISO/CLI (Call Level Interface) compatible DB systems

Author : Paul G. Crismer <pgcrism@users.sourceforge.net>
License: Released under the Eiffel Forum License
Copyright: 2000-2013 - Paul G. Crismer 

Abstract
========
	ECLI is an Eiffel wrapper around the X/Open ISO/CLI (Call Level Interface).
This interfaces defines an API to RDBMS drivers, and uses SQL92.
ISO/CLI is also known as ODBC under MS-Windows.  This interface has implementations on other platforms.

ECLI wants to be portable across (1) Platforms, (2) Eiffel Compilers.

(1) Platform portability : ECLI works on any platform that has an ISO/CLI Implementation.

(2) Eiffel Compiler Portability : ECLI uses as "standard" Eiffel as possible.
The GOBO Library is used for specific data structures.

Some tricks have been used to be free from the idiosyncrasies of any Eiffel Compiler.
It is a pity that even for basic/kernel classes it seems impossible for compiler vendors/providers to
agree on some standard.

Compiler portability
====================
* ISE Eiffel
* Gobo Eiffel

	Platforms :
* Windows
* Linux

Voidsafety
==========
Void "confident" is the name we have chosen for code that is designed to be voidsafe, but that use void-unsafe libraries.

The settings are 
- Full class checking
- Entities attached by default
- On demand void safety

a) depends on http://www.github.com/pgcrism/gobo.git
   This fork defines some voidconfident ecf files (only difference with gobo project).
   Some clusters have no void-safety settings. Some have full voidsafety settings.
   
b) void confidence = code is voidsafe but uses unsafe libraries (gobo)
   b.1) xace: 
       VOIDCONFIDENT is an environment variable that selects the voidsafety settings.
       All ECLI xaces use this environment variable.
    
   	  VOIDCONFIDENT=true     -  Systems use voidconfident settings.
   	  VOIDCONFIDENT=false    -  Systems use void-unsafe settings.
  
       The $ECLI/xace directory contains adapted xace files compatible with the development version of GOBO (see on Github).
    
   b.2) ecf:

     Until we find an appropriate solution to have a single ECF file for both settings types, we use the same
     system as Eiffel software.  As many ECF files as available settings.  The name of the files reflect the settings.
     
   	<name>.ecf             -  void unsafe settings.
   	<name>-confident.ecf   -  void confident settings.
   	
   	
Structure
=========
	ecli
	+ doc			---- documentation; see index.html and tutorial.html
	+ src			---- sources
	+ examples		---- some examples
	+ tools			---- tools, like 'query assistant'

DOCUMENTATION
=============
	Readme.txt		-- This file
	INSTALL_INFO.txt	-- Howto install et setup ECLI
	RELEASENOTES.txt	-- Release notes
	doc/index.html		-- A general introduction
	doc/tutorial.odt	-- Tutorial on how to use classes
	doc/class_index.html	-- Index with class catalog, class hierarchies
