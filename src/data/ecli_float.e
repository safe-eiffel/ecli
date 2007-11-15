indexing

	description: 
		
		"SQL FLOAT values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_FLOAT

inherit

	ECLI_DOUBLE
		redefine
			column_precision, sql_type_code, decimal_digits, display_size
		end

create

	make

feature -- Initialization

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

	column_precision: INTEGER is
		do
			Result := 15
		end

	sql_type_code: INTEGER is
		once
			Result := sql_float
		end
	
	decimal_digits: INTEGER is
		do 
			Result := 0
		end

	display_size: INTEGER is
		do
			Result := 22
		end

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature {NONE} -- Implementation

end
