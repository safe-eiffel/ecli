Eiffel Library to ISO/CLI (Call Level Interface) comptabile DB systems

Author : Paul G. Crismer <pgcrism@attglobal.net>
License: Released under the Eiffel Forum License
Copyright: 2000 - Paul G. Crismer 

Table of contents

	Abstract
	Section 0 : Current Status
	Section 1 : Design choices
	Section 2 : Implementation notes
	Section 3 : TODO

Abstract

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

Section 0 : Current Status

	Simple Database access :
1) Connect/Disconnect to a database
2) Issue SQL Statements
	with or without parameters
3) Get result set data.

For the moment, only CHAR, VARCHAR, INTEGER, FLOAT, DOUBLE, DATE and TIMESTAMP data are supported.

Since databases can convert automatically CHAR values to other SQL data types, it is possible
to use ECLI in the current state of development for common RDBMS access.

	Compiler portability :
* ISE Eiffel
* SmallEiffel

	Platforms :
* Windows
( Linux to come ...)

 
Section 1 : Design choices

D1. Rationale

	The X/Open Call Level Interface is a standard API for database access.
It is available on various platforms, i.e. Unix, Linux, Win32.  This is one of the
only standards that all vendors, including M$, fully support without "modifying" it.

D2. Simplicity

	This Eiffel interface is close to CLI, and hides some implementation details as
well.  This is a very simple wrapper.  

The main goal is to give a clear and simple database access for common applications.
Since it is a thin wrapper, performance should be as good as possible.

D3. What it is not

	It is not an OO-to-Relational wrapper framework.  This interface can be a component
of such a framework

Section 2 : Implementation notes

I1. Transactions

	CLI allows only one transaction per connection/session.  There is no subtransaction
mechanism.

I2. Error diagnostic

	Class ECLI_STATUS implements the necessary mechanisms.

I3. Data transfer between Database and Program space

	Modules that transfer data between database and program space should know the
database data type and the program data type.  That is why data-transfer-values are encapsulated
in the class ECLI_VALUE and its descendants.
Descendant classes map CLI specific database values : CHAR, VARCHAR, INTEGER, ...

Section 3 : TODO

T0. Implement other data values : Time, LONGVARCHAR, BINARY, LONGVARBINARY, ...
Those data values should serve
for data transfer, not as implementation of corresponding Abstract Data Types.
ADT should be defined as clients or extension by inheritance.

T1. Documentation.

T2. Long Variable Data (LONGVARCHAR, LONGVARBINARY) : Result set columns currently are retrieved
one column at a time (using SQLGetData).  Very long data cannot be stored in computer memory.
Those ECLI_LONGVARCHAR and ECLI_LONGVARBINARY classes should provide an interface that allows
reading/writing data to a file. For example, 'item' would be of FILE type. 

T3. Test cases

T4. Examples

T5. Port to Unix/Linux.  This should be fairly easy using UnixODBC : www.unixodbc.org

T6. Getting various metadata : Result-set metadata, Tables/Columns/Indexes catalog metadata,
SQL Datatypes metadata.

T7. Refactoring ... Make better use of inheritance, if possible.

T8. Allow Bulk data transfers : a cursor is not a single line, but an array of lines.  This is interesting for
performance reasons. (Nice to have).