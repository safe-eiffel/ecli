indexing

	description:
	
			"CLI SQL REAL arrayed value."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_REAL

inherit

	ECLI_GENERIC_ARRAYED_VALUE [REAL]
		undefine
		redefine
			out_item_at
		select
			is_equal, copy
		end

	ECLI_REAL
		rename
			make as make_single,
			copy as copy_item, is_equal as is_equal_item
		undefine
			release_handle, length_indicator_pointer, to_external,
			is_null, set_null, out, item, transfer_octet_length, set_item, as_string
		end

	KL_IMPORTED_STRING_ROUTINES
		undefine
			out, is_equal, copy
		end

create

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
			--ecli_c_array_value_copy_value_at (buffer, $impl_item, index)
			--Result := impl_item
			Result := c_memory_get_real (ecli_c_array_value_get_value_at(buffer,index))
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
--			impl_item := value.item
--			ecli_c_array_value_set_value_at (buffer, $impl_item, transfer_octet_length,index)
			c_memory_put_real (ecli_c_array_value_get_value_at(buffer,index),value)
			ecli_c_array_value_set_length_indicator_at (buffer, transfer_octet_length,index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	as_string : STRING is
			-- 
		do
			Result := out_item_at (cursor_index)
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	out_item_at (index : INTEGER) : STRING is
			--
		local
			message_buffer : XS_C_STRING
		do
			create message_buffer.make (50) 
			sprintf_real (message_buffer.handle, item_at (index).item)
			Result := message_buffer.as_string -- ext.pointer_to_string(message_buffer.handle)
		end

feature {NONE} -- Implementation

end
