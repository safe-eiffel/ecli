indexing
	description: "ISO CLI VARCHAR (n) values"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_VARCHAR

inherit
	ECLI_LONGVARCHAR
		redefine
			max_capacity, sql_type_code
		end

creation
	make

feature -- Access

	max_capacity : INTEGER is
		do
			Result := 255
		end

feature -- Status report

	sql_type_code: INTEGER is
		once
			Result := sql_varchar
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_VARCHAR
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
