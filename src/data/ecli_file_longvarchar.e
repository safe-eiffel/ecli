indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_FILE_LONGVARCHAR

inherit

	ECLI_FILE_VALUE
		redefine
			get_transfer_length
		end

creation
	make_input, make_output
	
feature -- Access
		
	sql_type_code : INTEGER is
		do
			Result := Sql_longvarchar
		end
		
feature -- Measurement
	
feature -- Status report

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

	get_transfer_length : INTEGER is
		do
			Result := Precursor
			if ext_item.item (Result) = '%U' then
				Result := Result - 1
			end			
		end
		
invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_FILE_LONGVARCHAR
