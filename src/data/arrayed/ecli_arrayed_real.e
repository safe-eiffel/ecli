indexing
	description: "CLI SQL REAL arrayed value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ARRAYED_REAL

inherit
	ECLI_GENERIC_ARRAYED_VALUE [REAL]
		undefine
		redefine
			out_item_at
		end

	ECLI_REAL
		rename
			make as make_single
		undefine
			release_handle, length_indicator_pointer, to_external,
			is_null, set_null, out, item, transfer_octet_length, set_item, to_string
		end

	KL_IMPORTED_STRING_ROUTINES
		undefine
			out
		end

creation
	make

feature {NONE} -- Initialization

	make (a_capacity : INTEGER) is
		do
			buffer := ecli_c_alloc_array_value (4, a_capacity)
			capacity := a_capacity
			count := capacity
			set_all_null
		end

feature -- Access

	item_at (index : INTEGER) : REAL is
			--
		do
			ecli_c_array_value_copy_value_at (buffer, $impl_item, index)
			Result := impl_item
		end

	item : REAL is
			--
		do
			Result := item_at (cursor_index)
		end

feature -- Measurement

feature -- Status report

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_array_value_get_length (buffer)
		end

feature -- Cursor movement

feature -- Element change

	set_item_at (value : REAL; index : INTEGER) is
			-- set item to 'value', truncating if necessary
		do
			impl_item := value.item
			ecli_c_array_value_set_value_at (buffer, $impl_item, transfer_octet_length,index)
			ecli_c_array_value_set_length_indicator_at (buffer, transfer_octet_length,index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	out_item_at (index : INTEGER) : STRING is
			--
		local
			message_buffer : C_STRING
			ext : ECLI_EXTERNAL_TOOLS
		do
			create ext
			create message_buffer.make (50) 
			sprintf_real (message_buffer.handle, item_at (index).item)
			Result := ext.pointer_to_string(message_buffer.handle)
		end

feature {NONE} -- Implementation

end -- class ECLI_ARRAYED_REAL
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
