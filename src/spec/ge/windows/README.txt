Building the ecli_c.lib library : 

* using MSVC dompiler : nmake -f makefile.mak
* using Borland compiler : make -f makefile.bcc
	* only works with ISE 5.0 *
	makefile.bcc uses full-pathed commands.  Borland compiler and utilities are expected
	to be in $(ISE_EIFFEL)\bcc55.  Change makefile's variables if needed.

