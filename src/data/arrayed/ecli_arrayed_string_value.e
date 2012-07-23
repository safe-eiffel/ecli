indexing

	description:

			"Arrayed buffers of string."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_ARRAYED_STRING_VALUE

inherit

	ECLI_STRING_VALUE
		rename
			make as make_single, capacity as content_capacity, maximum_capacity as maximum_content_capacity,
			count as content_count, is_equal as is_equal_item, copy as copy_item
		undefine
			release_handle, length_indicator_pointer, to_external, is_null, set_null, out, trace,
			set_item, transfer_octet_length--,
		redefine
			item, content_capacity, content_count
		end

	ECLI_GENERIC_ARRAYED_VALUE [STRING]
		rename
			make as make_arrayed
		redefine
			set_item, out_item_at
		select
			is_equal, copy
		end

feature {NONE} -- Initialization

	make (a_content_capacity : INTEGER; a_capacity : INTEGER) is
		require
			valid_content_capacity: a_content_capacity > 0 and a_content_capacity < maximum_content_capacity
			valid_capacity: a_capacity >= 1
		local
			s : STRING
		do
			buffer := ecli_c_alloc_array_value (a_content_capacity+1, a_capacity)
			capacity := a_capacity
			count := capacity
			create s.make (0)
			impl_item := s
			--| create ext_item, with dummy values
			create ext_item.make_shared_from_pointer (ecli_c_array_value_get_value_at (buffer, 1),
				ecli_c_array_value_get_length_indicator_at(buffer,1).as_integer_32)
			set_all_null
		ensure
			content_capacity_set: content_capacity = a_content_capacity
			capacity_set: capacity = a_capacity
			count_set: count = capacity
			cursor_before: before
			all_null: is_all_null -- foreach i in 1..count : is_null_at (i)
		end

	make_arrayed (a_capacity : INTEGER) is
			-- dummy one
		do
		end

feature -- Access

	item_at (index : INTEGER) : STRING is
		do
			if is_null_at (index) then
				Result := Void
			else
				ext_item.make_shared_from_pointer (ecli_c_array_value_get_value_at (buffer, index),
					ecli_c_array_value_get_length_indicator_at(buffer,index).as_integer_32)
				ext_item.copy_to (impl_item)
				Result := impl_item
			end
		end

	item : STRING is
			--
		do
			Result := item_at (cursor_index)
		end

	content_capacity : INTEGER is
		do
			Result := (ecli_c_array_value_get_length (buffer) - 1).as_integer_32
		end

	content_count : INTEGER is
			-- actual length of item
		do
			Result := content_count_at (cursor_index)
		end

	content_count_at (index : INTEGER) : INTEGER is
			-- length of `index'th
		do
			if not is_null_at (index) then
				Result := ecli_c_array_value_get_length_indicator_at (buffer, index).as_integer_32
			end
		end

feature -- Measurement

	transfer_octet_length: INTEGER_64 is
		do
			Result := ecli_c_array_value_get_length (buffer)
		end

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_item (value : like item) is
			-- set item to 'value', truncating if necessary
		do
			set_item_at (value, cursor_index)
		end

	set_item_at (value : like item; index : INTEGER) is
		local
			actual_length, transfer_length : INTEGER
		do
			if value.count > content_capacity then
				actual_length := content_capacity
				transfer_length := content_capacity
			else
				actual_length := value.count + 1
				transfer_length := actual_length - 1
			end
			ext_item.make_shared_from_pointer (ecli_c_array_value_get_value_at (buffer, index), transfer_length )
			ext_item.from_string (value)
			--ecli_c_array_value_set_value_at (buffer, string_to_pointer (value), actual_length, index)
			ecli_c_array_value_set_length_indicator_at (buffer, transfer_length, index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

--		as_string : STRING is
--				--
--			do
--				Result := item_at (cursor_index).out
--			end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_string (Current)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	out_item_at (index : INTEGER) : STRING is
		do
			create Result.make (10)
			Result.append_string ("'")
			Result.append_string (item_at (index).out)
			Result.append_string ("'")
		end

end
