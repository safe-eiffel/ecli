indexing

	description:

			"CLI SQL INTEGER arrayed value."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_INTEGER

inherit

	ECLI_GENERIC_ARRAYED_VALUE [INTEGER]
		redefine
			set_item, out
		select
			is_equal, copy
		end

	ECLI_INTEGER
		rename
			make as make_single, is_equal as is_equal_item, copy as copy_item
		export
			{NONE} make_single
		undefine
			release_handle, length_indicator_pointer,
			to_external, is_null, set_null, set_item
--			, as_string
		redefine
			item, transfer_octet_length, out, trace
		end

create

	make

feature {NONE} -- Initialization

	make (a_capacity : INTEGER) is
			-- make with `capacity' values
		do
			buffer := ecli_c_alloc_array_value (4, a_capacity)
			capacity := a_capacity
			count := capacity
			set_all_null
		end

feature -- Access

	item : INTEGER is
		do
			Result := item_at (cursor_index)
		end

	item_at (index : INTEGER) : INTEGER is
			--
		do
			--ecli_c_array_value_copy_value_at (buffer, $impl_item, index)
			--Result := impl_item
			Result := c_memory_get_int32 (ecli_c_array_value_get_value_at(buffer,index))
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_array_value_get_length (buffer)
		end

feature -- Cursor movement

feature -- Element change

	set_item (value : INTEGER) is
			-- set item to 'value', truncating if necessary
		do
			set_item_at (value, cursor_index)
		end

	set_item_at (value : INTEGER; index : INTEGER) is
			-- set item to 'value', truncating if necessary
		do
			--impl_item := value
			--ecli_c_array_value_set_value_at (buffer, $impl_item, transfer_octet_length, index)
			c_memory_put_int32 (ecli_c_array_value_get_value_at(buffer,index), value)
			ecli_c_array_value_set_length_indicator_at (buffer, transfer_octet_length, index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	out : STRING is
		local
			i : INTEGER
		do
			from i := 1
				create Result.make (10)
				Result.append_string ("<<")
			until i > count
			loop
				if is_null_at (i) then
					Result.append_string (out_null)
				else
					Result.append_string (item_at (i).out)
				end
				i := i + 1
				if i <= count then
					Result.append_string (", ")
				end
			end
			Result.append_string (">>")
		end

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_integer (Current)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: -- Your invariant here

end
