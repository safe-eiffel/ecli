indexing
	description: "ISO CLI CHAR (n) values"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_CHAR

inherit
	ECLI_VARCHAR
		rename
		export
		undefine
		redefine
			make, count, db_type_code, item
		select
		end

creation
	make

feature {NONE} -- Initialization

	make (n : INTEGER) is
		do
			Precursor (n)
			count := n
		ensure then
			count = capacity
		end
		

feature -- Access

	count : INTEGER
	

	item : STRING is
		do
			if not is_null then
				Result := Precursor
				if Result.count > count then
					Result.head (capacity)
				else
					pad (Result)
				end
			end
		ensure then
			Result.count = count
		end

feature -- Measurement

feature -- Status report

	db_type_code: INTEGER is
		once
			Result := sql_varchar
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	pad (s : STRING) is
			-- pad 's' with blanks
		do
			from
			until
				s.count = capacity
			loop
				s.append_character (' ')
			end
		ensure
			s.count = capacity
		end
	
invariant
	count_capacity: count = capacity

end -- class ECLI_CHAR
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
