indexing
	description: "ISO CLI TIMESTAMP values"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ARRAYED_TIMESTAMP

inherit
	ECLI_ARRAYED_DATE
		rename 
			make_single as make_single_date, make_default_single as make_default_1, 
			set_item as set_date_item
		undefine
			c_type_code,
			column_precision, 
			convertible_to_string,
			sql_type_code, 
			decimal_digits, 
			display_size, 
			item,  
			octet_size, 
			to_time, 
			to_timestamp, 
			trace, 
			transfer_octet_length 
		redefine
			is_equal, out_item_at, set_item_at --, set_item, set_item_at, 
		select
			make_default_1, make_single_date, set_date_item
		end

	ECLI_TIMESTAMP
		rename
			make as make_single, make_default as make_default_2, set as set_single
		export
			{NONE} make_single, set_single, make_default_2
		undefine
			allocate_buffer, 
			day, 
			is_equal,
			is_null, 
			length_indicator_pointer,
			month, 
			out, 
			release_handle, 
			set_date,
			set_item, 
			to_external, 
			to_string, 
			year
		redefine
			trace, hour, minute, second, nanosecond
		end
	
creation
	make_default

feature {NONE} -- Initialization

--	make_default (a_capacity : INTEGER) is
--			-- 
--		do
--			capacity := a_capacity
--			count := capacity
--			allocate_buffer
--		ensure
--			capacity_set: capacity = a_capacity
--			count_set: count = capacity
--		end
		
feature -- Access

	hour : INTEGER is
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_hour (timestamp_pointer)
			end
		end

	minute : INTEGER is
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_minute (timestamp_pointer)
			end
		end

	second : INTEGER is
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_second (timestamp_pointer)
			end
		end

	nanosecond : INTEGER is
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			if not is_null then
				Result := ecli_c_timestamp_get_fraction (timestamp_pointer)
			end
		end

feature -- Measurement

	set_time_at (a_hour, a_minute, a_second, a_nanosecond : INTEGER; index : INTEGER ) is
		require
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999
			valid_index: index >= 1 and index <= count
		local
			timestamp_pointer : POINTER
		do
			timestamp_pointer := ecli_c_array_value_get_value_at (buffer, cursor_index)
			ecli_c_timestamp_set_hour (timestamp_pointer, a_hour)
			ecli_c_timestamp_set_minute (timestamp_pointer, a_minute)
			ecli_c_timestamp_set_second (timestamp_pointer, a_second)
			ecli_c_timestamp_set_fraction (timestamp_pointer, a_nanosecond)
		ensure
			hour_set: item_at (index).hour = a_hour
			minute_set: item_at (index).minute = a_minute
			second_set: item_at (index).second = a_second
			nanosecond_set: item_at (index).millisecond = a_nanosecond // 1_000_000
		end

	set_at (a_year, a_month, a_day, a_hour, a_minute, a_second, a_nanosecond : INTEGER; index : INTEGER) is
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
		end

	set_item (other : like item) is
		do
			set_at (other.year, other.month, other.day, 
				other.hour, other.minute, other.second, 
				other.millisecond * 1_000_000,
				cursor_index)
		end

	set_item_at (other : like item; index : INTEGER) is
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

	out_item_at (index : INTEGER) : STRING is
		local
			save_index : INTEGER
		do
			save_index := cursor_index
			cursor_index := index
			Result := {ECLI_ARRAYED_DATE}Precursor (index)
			if not is_null then
				Result.append_character (' ')
				Result.append (pad_integer_2 (hour))
				Result.append_character (':')
				Result.append (pad_integer_2 (minute))
				Result.append_character (':')
				Result.append (pad_integer_2 (second))
				if nanosecond > 0 then
					Result.append_character ('.')
					Result.append (nanosecond.out)
				end
			end
			cursor_index := save_index
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_timestamp (Current)
		end

	is_equal (other : like Current) : BOOLEAN is
		do
			
		end
			
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
			
invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_ARRAYED_TIMESTAMP
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
