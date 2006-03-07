indexing

	description: 
	
		"SQL CHAR (n) values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
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

creation

	make, make_force_maximum_capacity
	
feature {NONE} -- Initialization

	make (n : INTEGER) is
		do
			Precursor (n)
			count := n
		ensure then
			count = capacity
		end

feature -- Access

	default_maximum_capacity : INTEGER is
		once
			Result := 255
		end
		
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

feature -- Status report

	sql_type_code: INTEGER is
		once
			Result := sql_varchar
		end

feature -- Transformation

	formatted (v : like item) : like item is
		do
			create Result.make_from_string (v)
			format (Result)
		end

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
				s.keep_head (capacity)
			else
				pad (s)
			end
		end
	
invariant

	count_capacity: count = capacity

end
