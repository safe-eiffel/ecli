indexing
	description: "Procedure columns metadata : parameters, result, result_set."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_PROCEDURE_COLUMN

inherit
	ECLI_COLUMN
		redefine
			make
		end
	
	ECLI_PROCEDURE_TYPE_METADATA
		export
			{ANY} column_type
		undefine
			out
		end
		
creation
	make
	
feature -- Initialization

	make (cursor : ECLI_PROCEDURE_COLUMNS_CURSOR) is
			-- create from `cursor' current position
		do
			Precursor (cursor)
			column_type := cursor.buffer_column_type.item	
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

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_PROCEDURE_COLUMN
