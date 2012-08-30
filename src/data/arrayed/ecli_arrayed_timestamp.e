note

	description:

			"SQL TIMESTAMP arrayed values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_TIMESTAMP

inherit

	ECLI_GENERIC_ARRAYED_VALUE [DT_DATE_TIME]
		redefine
			out_item_at, set_item
		select
			is_equal, copy
		end

	ECLI_ARRAYED_DATE_ROUTINES
		undefine
			is_equal, copy, out
		redefine
			out_item_at
		end

	ECLI_TIMESTAMP
		rename
			make as make_single, set as set_single_timestamp,
			copy as copy_item, is_equal as is_equal_item
		export
			{NONE} make_single, set_single_timestamp, make_default
		undefine
			allocate_buffer,
			day,
			is_null, set_null,
			length_indicator_pointer,
			month,
			out,
			release_handle,
			set_item,
			to_external,
			as_string,
			year, hour, minute, second, nanosecond
		redefine
			impl_item, create_impl_item
		end

create

	make

feature {NONE} -- Initialization

	make (a_capacity : INTEGER)
			-- make array of null dates
		do
			capacity := a_capacity
			count := capacity
			allocate_buffer
			set_all_null
			create_impl_item
		end

feature -- Access

	item_at (index: INTEGER) : DT_DATE_TIME
			--
		local
			save_index : INTEGER
		do
			save_index := cursor_index
			cursor_index := index
			Result := item
			cursor_index := save_index
		end

	hour : INTEGER
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_hour (timestamp_pointer)
			end
		end

	minute : INTEGER
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_minute (timestamp_pointer)
			end
		end

	second : INTEGER
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_second (timestamp_pointer)
			end
		end

	nanosecond : INTEGER
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_fraction (timestamp_pointer)
			end
		end

	hour_at (index : INTEGER) : INTEGER
		require
			valid_index: index >= 1 and index <= upper
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_timestamp_get_hour (timestamp_pointer)
			end
		end

	minute_at (index : INTEGER) : INTEGER
		require
			valid_index: index >= 1 and index <= upper
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_timestamp_get_minute (timestamp_pointer)
			end
		end

	second_at (index : INTEGER) : INTEGER
		require
			valid_index: index >= 1 and index <= upper
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_timestamp_get_second (timestamp_pointer)
			end
		end

	nanosecond_at (index : INTEGER) : INTEGER
		require
			valid_index: index >= 1 and index <= upper
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_timestamp_get_fraction (timestamp_pointer)
			end
		end

feature -- Measurement

	set_time_at (a_hour, a_minute, a_second, a_nanosecond : INTEGER; index : INTEGER )
		require
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999
			valid_index: index >= 1 and index <= count
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, index)
--			ecli_c_timestamp_set_hour (timestamp_pointer, a_hour)
--			ecli_c_timestamp_set_minute (timestamp_pointer, a_minute)
--			ecli_c_timestamp_set_second (timestamp_pointer, a_second)
--			ecli_c_timestamp_set_fraction (timestamp_pointer, a_nanosecond)
			set_time_external (timestamp_pointer, a_hour, a_minute, a_second, a_nanosecond)
		ensure
			hour_set: hour_at (index) = a_hour
			minute_set: minute_at (index) = a_minute
			second_set: second_at (index) = a_second
			nanosecond_set: nanosecond_at (index) = a_nanosecond
		end

	set_at (a_year, a_month, a_day, a_hour, a_minute, a_second, a_nanosecond : INTEGER; index : INTEGER)
		require
			month: a_month > 0 and a_month <= 12
			day: a_day > 0 and a_day <= days_in_month (a_month, a_year)
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999
			valid_index: index >= 1 and index <= count
		do
			set_date_at (a_year, a_month, a_day, index)
			set_time_at (a_hour, a_minute, a_second, a_nanosecond, index)
		ensure
			year_set: item_at (index).year = a_year
			month_set: item_at (index).month = a_month
			day_set: item_at (index).day = a_day
			hour_set: item_at (index).hour = a_hour
			minute_set: item_at (index).minute = a_minute
			second_set: item_at (index).second = a_second
			nanosecond_set: item_at (index).millisecond = a_nanosecond // 1_000_000
			not_null: not is_null_at (index)
		end

	set_item (other : like item)
		do
			set_at (other.year, other.month, other.day,
				other.hour, other.minute, other.second,
				other.millisecond * 1_000_000,
				cursor_index)
		end

	set_item_at (other : like item; index : INTEGER)
		do
			set_at (other.year, other.month, other.day,
				other.hour, other.minute, other.second,
				other.millisecond * 1_000_000,
				index)
		end

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out_item_at (index : INTEGER) : STRING
		local
			save_index : INTEGER
		do
			save_index := cursor_index
			cursor_index := index
			Result := Precursor {ECLI_ARRAYED_DATE_ROUTINES} (index)
			if not is_null then
				Result.append_character (' ')
				Result.append_string (Integer_format.pad_integer_2 (hour))
				Result.append_character (':')
				Result.append_string (Integer_format.pad_integer_2 (minute))
				Result.append_character (':')
				Result.append_string (Integer_format.pad_integer_2 (second))
				if nanosecond > 0 then
					Result.append_character ('.')
					Result.append_string (nanosecond.out)
				end
			end
			cursor_index := save_index
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

--	trace (a_tracer : ECLI_TRACER) is
--		do
--			a_tracer.put_timestamp (Current)
--		end

--	is_equal (other : like Current) : BOOLEAN is
--		do
--
--		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	allocate_buffer
		do
			if buffer = default_pointer then
				buffer := ecli_c_alloc_array_value (transfer_octet_length, capacity)
			end
		end

	create_impl_item
			do
				 Precursor {ECLI_TIMESTAMP}
			end

	impl_item : DT_DATE_TIME

invariant
	invariant_clause: -- Your invariant here

end
