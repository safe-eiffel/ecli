indexing
	description:

		 "Objects that represent statements that manipulate %
		% a database. They are defined on a connected session.  %
		% Provide CLI/ODBC CORE and some Level 1 functionalities."

	author: 	"Paul G. Crismer"
	date: 		"$Date$"
	revision: 	"$Revision$"
	licensing: 	"See notice at end of class"

class
	ECLI_STATEMENT

inherit
	ECLI_ABSTRACT_STATEMENT [ECLI_VALUE,ECLI_VALUE]

creation
	make

end -- class ECLI_STATEMENT
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
