indexing
	description: "SQL TIME arrayed value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ARRAYED_TIME

inherit
	ECLI_GENERIC_ARRAYED_VALUE [DT_TIME]
		redefine
			is_equal, out_item_at --to_time, 
		select
			is_equal, copy
		end

	ECLI_TIME
		rename
			make as make_single, make_default as make_default_single, set as set_single,
			is_equal as is_equal_item, copy as copy_item
		export
			{NONE} make_single, set_single, make_default_single
		undefine
			release_handle, length_indicator_pointer, as_external, 
			is_null, set_null, 
			-- is_equal, 
			out, set_item, as_string
		redefine
			item, trace, allocate_buffer, hour, minute, second --out, , nanosecond --transfer_octet_length,
		end

creation
	make

feature {NONE} -- Initialization

	make (a_capacity : INTEGER) is
		do
			capacity := a_capacity
			count := capacity
			allocate_buffer
			set_all_null
			create_impl_item
		end

feature -- Access

	item : DT_TIME is
		do
			!!Result.make_precise (hour, minute, second,0)
		end

	item_at (index : INTEGER) : like item is
		do
			!! Result.make (hour_at (index), minute_at (index), second_at (index))
		end

	hour : INTEGER is
		local
			time_pointer : POINTER
		do
			time_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_hour (time_pointer)
			end
		end

	minute : INTEGER is
		local
			time_pointer : POINTER
		do
			time_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_minute (time_pointer)
			end
		end

	second : INTEGER is
		local
			time_pointer : POINTER
		do
			time_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_second (time_pointer)
			end
		end

--	nanosecond : INTEGER is
--		local
--			time_pointer : POINTER
--		do
--			time_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
--			if not is_null then
--				Result := ecli_c_timestamp_get_fraction (time_pointer)
--			end
--		end

	hour_at (index : INTEGER) : INTEGER is
		require
			valid_index: index >= 1 and index <= count
		local
			time_pointer : POINTER
		do
			time_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_time_get_hour (time_pointer)
			end
		end

	minute_at (index : INTEGER) : INTEGER is
		require
			valid_index: index >= 1 and index <= count
		local
			time_pointer : POINTER
		do
			time_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_time_get_minute (time_pointer)
			end
		end

	second_at (index : INTEGER) : INTEGER is
		require
			valid_index: index >= 1 and index <= count
		local
			time_pointer : POINTER
		do
			time_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_time_get_second (time_pointer)
			end
		end

--	nanosecond_at (index : INTEGER) : INTEGER is
--		require
--			valid_index: index >= 1 and index <= count
--		local
--			time_pointer : POINTER
--		do
--			time_pointer := ecli_c_array_value_get_value_at (buffer, index)
--			if not is_null_at (index) then
--				Result := ecli_c_time_get_fraction (time_pointer)
--			end
--		end

feature -- Measurement

	set_at (a_hour, a_minute, a_second, index : INTEGER) is --, a_nanosecond : INTEGER; index : INTEGER ) is
		require
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
--			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999
			valid_index: index >= 1 and index <= count
		local
			time_pointer : POINTER
		do
			time_pointer := ecli_c_array_value_get_value_at (buffer, index)
			ecli_c_time_set_hour (time_pointer, a_hour)
			ecli_c_time_set_minute (time_pointer, a_minute)
			ecli_c_time_set_second (time_pointer, a_second)
--			ecli_c_time_set_hour (time_pointer, a_nanosecond)
			ecli_c_array_value_set_length_indicator_at (buffer, transfer_octet_length,index)
		ensure
			hour_set: hour_at (index) = a_hour
			minute_set: minute_at (index) = a_minute
			second_set: second_at (index) = a_second
--			nanosecond_set: nanosecond_at (index) = a_nanosecond
		end


	set_item_at (other : like item; index : INTEGER) is
		do
			set_at (other.hour, other.minute, other.second, index) --, other.millisecond * 1_000_000, index)
		end

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

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_time (Current)
		end

	is_equal (other : like Current) : BOOLEAN is
		do
			Result := hour = other.hour and
				minute = other.minute and
				second = other.second
		end

feature -- Obsolete

	allocate_buffer is
		do
			if buffer = default_pointer then
				buffer := ecli_c_alloc_array_value (transfer_octet_length, capacity)
			end
		end

feature -- Inapplicable

feature {NONE} -- Implementation

	out_item_at (index : INTEGER) : STRING is
		local
			save_index : INTEGER
		do
			save_index := cursor_index
			cursor_index := index
			!!Result.make (0)
			if not is_null then
				Result.append_character (' ')
				Result.append_string (Integer_format.pad_integer_2 (hour_at (index)))
				Result.append_character (':')
				Result.append_string (Integer_format.pad_integer_2 (minute_at (index)))
				Result.append_character (':')
				Result.append_string (Integer_format.pad_integer_2 (second_at (index)))
--				if nanosecond > 0 then
--					Result.append_character ('.')
--					Result.append_string (nanosecond.out)
--				end
			end
			cursor_index := save_index
		end

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_ARRAYED_TIME
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
