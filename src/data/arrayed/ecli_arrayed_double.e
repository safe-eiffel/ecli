note

	description:

			"CLI SQL DOUBLE arrayed value."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_DOUBLE

inherit

	ECLI_GENERIC_ARRAYED_VALUE [DOUBLE]
		redefine
			out
		select
			is_equal, copy
		end

	ECLI_DOUBLE
		rename
			make as make_double, copy as copy_item, is_equal as is_equal_item
		undefine
			release_handle, length_indicator_pointer, to_external,
			is_null, set_null, out, item, transfer_octet_length, set_item
			--, as_string
		end

create

	make

feature {NONE} -- Initialization

	make (a_capacity : INTEGER)
		do
			buffer := ecli_c_alloc_array_value (8, a_capacity)
			capacity := a_capacity
			count := capacity
			set_all_null
		end

feature -- Access

	item : DOUBLE
		do
			Result := item_at (cursor_index)
		end

	item_at (index : INTEGER) : DOUBLE
		do
			--ecli_c_array_value_copy_value_at (buffer, $impl_item, index)
			--Result := impl_item
			Result := c_memory_get_double (ecli_c_array_value_get_value_at(buffer, index))
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

	transfer_octet_length: INTEGER_64
		do
			Result := ecli_c_array_value_get_length (buffer).as_integer_32
		end

feature -- Cursor movement

feature -- Element change

	set_item_at (value : DOUBLE; index : INTEGER)
			-- set item to 'value', truncating if necessary
		do
--			impl_item := value.item
--			ecli_c_array_value_set_value_at (buffer, $impl_item, transfer_octet_length, index)
			c_memory_put_double (ecli_c_array_value_get_value_at(buffer, index), value)
			ecli_c_array_value_set_length_indicator_at (buffer, transfer_octet_length, index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	out : STRING
		local
			message_buffer : XS_C_STRING
			i : INTEGER
		do
			from
				i := 1
				create Result.make (10)
				Result.append_string ("<<")
				create message_buffer.make (50)
			until i = count
			loop
				if is_null_at (i) then
					Result.append_string (out_null)
				else
					sprintf_double (message_buffer.handle, item_at (i).item)
					Result.append_string (message_buffer.as_string)
				end
				if i < count then
					Result.append_string (",")
				end
				i := i + 1
			end
			Result.append_string (">>")
		end

feature {NONE} -- Implementation

end
