indexing
	description: "ISO CLI TIME value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_TIME

inherit
	ECLI_GENERIC_VALUE [DT_TIME]
		redefine
			to_time, is_equal, out, set_item, item, create_impl_item, impl_item
		end
		
creation
	make, make_default
	
feature {NONE} -- Initialization

	make (a_hour, a_minute, a_second : INTEGER) is --, a_nanosecond : INTEGER) is
		require
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
--			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999
		do
			allocate_buffer
			set (a_hour, a_minute, a_second) --, a_nanosecond)
			create_impl_item
		ensure
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
--			nanosecond_set: nanosecond = a_nanosecond
		end

	make_default is
		do
--			allocate_buffer
--			set (0, 0, 0)
			make (0,0,0)
		ensure
			hour_set: hour = 0
			minute_set: minute = 0
			second_set: second = 0
--			nanosecond_set: nanosecond = 0
		end

feature -- Access

	item : DT_TIME is
		do
			impl_item.set_hour_minute_second (hour,minute,second)
			Result := impl_item
		ensure then
			no_millisecond: Result.millisecond = 0
		end

	hour : INTEGER is
		do
			if not is_null then
				Result := ecli_c_time_get_hour (to_external)
			end
		end

	minute : INTEGER is
		do
			if not is_null then
				Result := ecli_c_time_get_minute (to_external)
			end
		end

	second : INTEGER is
		do
			if not is_null then
				Result := ecli_c_time_get_second (to_external)
			end
		end

feature -- Measurement



feature -- Status report

	c_type_code: INTEGER is
		once
			Result := sql_c_type_time
		end

	size : INTEGER is
		do
			Result := 8
		end

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_sizeof_time_struct --ecli_c_value_get_length (buffer)
		end

	sql_type_code: INTEGER is
		once
			Result := sql_type_time
		end
	
	decimal_digits: INTEGER is
		do
			Result := 0
		end

	display_size: INTEGER is
		do
			Result := size
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set (a_hour, a_minute, a_second : INTEGER) is
			-- set from `a_hour', `a_minute', `a_second'
		require
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
--			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999

		do
			ecli_c_time_set_hour (to_external, a_hour)
			ecli_c_time_set_minute (to_external, a_minute)
			ecli_c_time_set_second (to_external, a_second)
--			ecli_c_timestamp_set_fraction (to_external, a_nanosecond)
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
		ensure
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
--			nanosecond_set: nanosecond = a_nanosecond
		end

	set_item (other : DT_TIME) is
		do
			set (other.hour, other.minute, other.second)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out : STRING is
		do
			!!Result.make (0)
			if not is_null then
				Result.append_character (' ')
				Result.append_string (Integer_format.pad_integer_2 (hour))
				Result.append_character (':')
				Result.append_string (Integer_format.pad_integer_2 (minute))
				Result.append_character (':')
				Result.append_string (Integer_format.pad_integer_2 (second))
--				if nanosecond > 0 then
--					Result.append_character ('.')
--					Result.append_string (nanosecond.out)
--				end
			end
		end
			
	to_time : DT_TIME is
		do
			Result := item
		end
		
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
				buffer := ecli_c_alloc_value (transfer_octet_length)
			end
		end

feature -- Inapplicable

feature {NONE} -- Implementation
	
	ecli_c_sizeof_time_struct : INTEGER is
		external "C"
		end

	create_impl_item is
			-- 
		local
			t : DT_TIME
		do
			create t.make (0,0,0)
			impl_item := t			
		end

	integer_format : 	ECLI_FORMAT_INTEGER is
			-- format integer routines
		once
			create Result
		end
		
	impl_item : DT_TIME
	
invariant
	impl_item_not_void: impl_item /= Void

end -- class ECLI_TIME
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
