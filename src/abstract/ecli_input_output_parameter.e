indexing
	description: "Input/Output parameters in SQL statements."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_INPUT_OUTPUT_PARAMETER

inherit
	ECLI_STATEMENT_PARAMETER

creation
	make
	
feature -- Access

feature -- Measurement

feature -- Status report

	is_input : BOOLEAN is do Result := False end
	is_input_output : BOOLEAN is do Result := True end
	is_output : BOOLEAN is do Result := False end
	
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

	bind (statement : ECLI_STATEMENT; position : INTEGER) is
			-- 
		do
			item.bind_as_input_output_parameter (statement, position)
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_INPUT_OUTPUT_PARAMETER
