indexing
	description: "ISO CLI CHAR (n) arrayed values"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ARRAYED_CHAR

inherit
	ECLI_ARRAYED_VARCHAR
		rename
		export
		undefine
		redefine
			make, content_count, sql_type_code, item_at, formatted
		select
		end

	ECLI_STRING_ROUTINES
		export
			{NONE} all
		undefine
			out, is_equal, copy
		end

creation
	make

feature {NONE} -- Initialization

	make (a_content_capacity : INTEGER; a_array_capacity : INTEGER) is
		do
			Precursor (a_content_capacity, a_array_capacity)
			content_count := content_capacity
		ensure then
			content_count = content_capacity
		end


feature -- Access

	content_count : INTEGER

	item_at (index : INTEGER) : like item is
		do
			if not is_null_at (index) then
				Result := Precursor (index)
				format (Result)
			end
		ensure then
			Result.count = content_count
		end

feature -- Measurement

feature -- Status report

	sql_type_code: INTEGER is
		once
			Result := sql_varchar
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

	formatted (v : like item) : like item is
		do
			create Result.make_from_string (v)
			format (Result)
		end

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	format (s : STRING) is
			-- format 's' according to 'capacity'
		require
			s_not_void: s /= Void
		do
			if s.count > content_count then
				s.keep_head (content_capacity)
			else
				pad (s, content_capacity)
			end
		end

invariant
--	count_capacity: count <= capacity

end -- class ECLI_ARRAYED_CHAR
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
