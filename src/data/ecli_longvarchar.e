indexing
	description: 
	
		"SQL LONGVARCHAR (n) values"
		
	author: "Paul-G.Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_LONGVARCHAR

inherit
	ECLI_STRING_VALUE
	
creation
	make

feature -- Access

	max_capacity : INTEGER is
		do
			Result := 1_000_000
		end

	sql_type_code: INTEGER is
		once
			Result := sql_longvarchar
		end
	
end -- class ECLI_LONGVARCHAR
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
