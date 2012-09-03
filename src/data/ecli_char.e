note

	description:

		"SQL CHAR (n) values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_CHAR

inherit

	ECLI_STRING_VALUE
		redefine
			make,
			count,
			item,
			formatted
		end

create

	make, make_force_maximum_capacity

feature {NONE} -- Initialization

	make (n : INTEGER)
		do
			Precursor (n)
			count := n
		ensure then
			count = capacity
		end

feature -- Access

	default_maximum_capacity : INTEGER
		once
			Result := 255
		end

	count : INTEGER

	item : STRING
		do
			if not is_null then
				Result := Precursor
				format (Result)
			end
		ensure then
			Result.count = count
		end

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

	pad (s : STRING)
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

	format (s : STRING)
			-- format 's' according to 'capacity'
		require
			s_not_void: s /= Void
		do
			if s.count > count then
				s.keep_head (capacity)
			else
				pad (s)
			end
		end

invariant

	count_capacity: count = capacity

end
