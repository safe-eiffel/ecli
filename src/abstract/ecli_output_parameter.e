indexing

	description:
	
			"Output parameters in SQL statements."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_OUTPUT_PARAMETER

inherit

	ECLI_STATEMENT_PARAMETER

create

	make
	
feature -- Access

feature -- Measurement

feature -- Status report

	is_input : BOOLEAN is do Result := False end
	is_input_output : BOOLEAN is do Result := False end
	is_output : BOOLEAN is do Result := True end
	
feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature {ECLI_STATEMENT} -- Basic operations

	bind (statement : ECLI_STATEMENT; position : INTEGER) is
		do
			item.bind_as_output_parameter (statement, position)
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	is_output: is_output
	
end
