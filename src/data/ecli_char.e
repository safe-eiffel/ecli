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
			make, count, db_type_code, item, truncated
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
				format (Result)
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

	truncated (v : like item) : like item is
		do
			Result := clone (v)
			format (Result)
		end

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

	format (s : STRING) is
			-- format 's' according to 'capacity'
		require
			s_not_void: s /= Void
		do
			if s.count > count then
				s.head (capacity)
			else
				pad (s)
			end
		end
	
invariant
	count_capacity: count = capacity

end -- class ECLI_CHAR
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
