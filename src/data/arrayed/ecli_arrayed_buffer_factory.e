note

	description:

			"Objects that create arrayed buffers for rowset commands."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_BUFFER_FACTORY

inherit

	ECLI_BUFFER_FACTORY
		redefine
			value_factory, value_anchor, default_buffer_value
		end

create

	make

feature {NONE} -- Initialization

	make (a_row_count : INTEGER)
			-- make buffer for 'a_row_count'
		do
			row_count := a_row_count
			default_create
		ensure
			row_count_set: row_count = a_row_count
		end

feature -- Access

feature -- Measurement

	row_count : INTEGER

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

	value_factory : ECLI_ARRAYED_VALUE_FACTORY
		do
			if attached impl_value_factory as l_factory then
				Result := l_factory
			else
				create Result.make (row_count)
				impl_value_factory := Result
			end
		end

	value_anchor : detachable ECLI_ARRAYED_VALUE
			--
		do
		end

	default_buffer_value : ECLI_ARRAYED_VALUE
		do
			create {ECLI_ARRAYED_CHAR}Result.make (1, row_count)
		end

invariant
	invariant_clause: -- Your invariant here

end
