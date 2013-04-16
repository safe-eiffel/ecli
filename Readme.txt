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

Structure
=========
	ecli
	+ doc		---- documentation; see index.html and tutorial.html
	+ src		---- sources
	+ examples	---- some examples
	+ tools		---- tools, like 'query assistant'

DOCUMENTATION : doc/index.html, tutorial.html
