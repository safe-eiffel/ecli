indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ROWSET_STATUS

inherit

	ANY

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end

	ECLI_EXTERNAL_API
		export
			{NONE} all
		end

	ECLI_EXTERNAL_TOOLS
		export
			{NONE} all
		end

creation
	make

feature -- Initialization

	make (a_count : INTEGER) is
			--
		do
			count := a_count
			row_status := STRING_.make_buffer (count * 2)
		ensure
			count_set: count = a_count
		end

feature -- Access

feature -- Measurement

	count : INTEGER

feature -- Status report

	is_ok (index : INTEGER) : BOOLEAN is
			--
		require
			valid_index: index >= 1 and index <= count
		do
			Result := (item (index) = Sql_row_success) or else (item (index) = Sql_row_success_with_info)
		end

	is_error (index : INTEGER) : BOOLEAN is
			--
		require
			valid_index: index >= 1 and index <= count
		do
			Result := (item (index) = Sql_row_error)
		end
	item (index : INTEGER) : INTEGER is
			--
		require
			valid_index: index >= 1 and index <= count
		do
			Result := row_status.item (index * 2 - 1).code
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	to_external : POINTER is
			--
		do
			Result := string_to_pointer (row_status)
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	row_status : STRING

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_ROWSET_STATUS
