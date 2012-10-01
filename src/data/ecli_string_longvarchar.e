note

	description:

		"Objects that map database LONGVARCHAR data to Eiffel STRING instances."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"


class
	ECLI_STRING_LONGVARCHAR

inherit
	ECLI_STRING
		redefine
			sql_type_code
		end

create
	make


feature -- Access

	sql_type_code: INTEGER
		do
			Result := sql_longvarchar
		end

feature -- Measurement

feature -- Comparison

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

feature -- Constants

feature {NONE} -- Implementation

invariant
	invariant_clause: -- Your invariant here

end

