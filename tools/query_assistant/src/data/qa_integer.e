indexing
	description: "CLI SQL INTEGER value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_INTEGER

inherit
	ECLI_INTEGER
	
	QA_VALUE


creation
	make
	
feature

	ecli_type : STRING is "ECLI_INTEGER"
		
	value_type : STRING is "INTEGER"

	creation_call : STRING is
		do
			Result := make_call
		end
	
end -- class QA_INTEGER
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
