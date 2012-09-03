note

	description:

			"Procedure columns metadata : parameters, result, result_set."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_PROCEDURE_COLUMN

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

create

	make

feature -- Initialization

	make (cursor : ECLI_PROCEDURE_COLUMNS_CURSOR)
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

end
