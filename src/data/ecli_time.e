indexing
	description: "ISO CLI TIME value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_TIME

inherit
	ECLI_VALUE
		redefine
			to_time, is_equal, out, set_item, item 
		end

	ECLI_FORMAT_INTEGER
		undefine
			out, is_equal
		end
	
creation
	make, make_default
	
feature {NONE} -- Initialization

	make (a_hour, a_minute, a_second, a_nanosecond : INTEGER) is
		require
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999
		do
			allocate_buffer
			set (a_hour, a_minute, a_second, a_nanosecond)
		ensure
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
			nanosecond_set: nanosecond = a_nanosecond
		end

	make_default is
		do
			allocate_buffer
		ensure
			hour_set: hour = 0
			minute_set: minute = 0
			second_set: second = 0
			nanosecond_set: nanosecond = 0
		end

feature -- Access

	item : DT_TIME is
		do
			!!Result.make_precise (hour, minute, second,nanosecond // 1_000_000)
		end

	hour : INTEGER is
		do
			if not is_null then
				Result := ecli_c_timestamp_get_hour (to_external)
			end
		end

	minute : INTEGER is
		do
			if not is_null then
				Result := ecli_c_timestamp_get_minute (to_external)
			end
		end

	second : INTEGER is
		do
			if not is_null then
				Result := ecli_c_timestamp_get_second (to_external)
			end
		end

	nanosecond : INTEGER is
		do
			if not is_null then
				Result := ecli_c_timestamp_get_fraction (to_external)
			end
		end

feature -- Measurement


	set (a_hour, a_minute, a_second, a_nanosecond : INTEGER ) is
		require
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999

		do
			ecli_c_timestamp_set_hour (to_external, a_hour)
			ecli_c_timestamp_set_minute (to_external, a_minute)
			ecli_c_timestamp_set_second (to_external, a_second)
			ecli_c_timestamp_set_fraction (to_external, a_nanosecond)
		ensure
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
			nanosecond_set: nanosecond = a_nanosecond
		end

	set_item (other : like item) is
		do
			set (other.hour, other.minute, other.second, other.millisecond * 1_000_000)
		end

feature -- Status report

	c_type_code: INTEGER is
		once
			Result := sql_c_type_time
		end

	column_precision: INTEGER is
		do
			Result := 9+decimal_digits
		end

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_value_get_length (buffer)
		end

	db_type_code: INTEGER is
		once
			Result := sql_type_time
		end
	
	decimal_digits: INTEGER is
		do 
			Result := 9
		end

	display_size: INTEGER is
		do
			Result := column_precision
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out : STRING is
		do
			!!Result.make (0)
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
				second = other.second and
				nanosecond = other.nanosecond
		end
			
feature -- Obsolete

	allocate_buffer is
		do
			if buffer = default_pointer then
				buffer := ecli_c_alloc_value (octet_size)
			end
		end

feature -- Inapplicable

feature {NONE} -- Implementation

	octet_size : INTEGER is
		do
			Result := ecli_c_sizeof_time_struct
		end
	
	ecli_c_sizeof_time_struct : INTEGER is
		external "C"
		end

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_TIME
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
