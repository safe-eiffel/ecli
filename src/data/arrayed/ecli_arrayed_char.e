note

	description:

			"SQL CHAR (n) arrayed values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_CHAR

inherit

	ECLI_ARRAYED_STRING_VALUE
		redefine
			make,
			content_count,
			item_at, formatted
		end

	ECLI_STRING_ROUTINES
		export
			{NONE} all
		undefine
			out, is_equal, copy
		end

create

	make

feature {NONE} -- Initialization

	make (a_content_capacity : INTEGER; a_array_capacity : INTEGER)
		do
			Precursor (a_content_capacity, a_array_capacity)
			content_count := content_capacity
		ensure then
			content_count = content_capacity
		end

feature -- Access

	content_count : INTEGER

	item_at (index : INTEGER) : like item
		do
			if not is_null_at (index) then
				Result := Precursor (index)
				format (Result)
			end
		ensure then
			Result.count = content_count
		end

feature -- Measurement

--	max_content_capacity : INTEGER is
--		do
--			Result := 255
--		end

feature -- Status report

	sql_type_code: INTEGER
		once
			Result := sql_varchar
		end

feature -- Transformation

	formatted (v : like item) : like item
		do
			create Result.make_from_string (v)
			format (Result)
		end

feature {NONE} -- Implementation

	format (s : STRING)
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

feature {NONE} -- Implementation

	default_maximum_capacity : INTEGER = 255

end
