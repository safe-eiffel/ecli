indexing
	description: "ISO CLI TIMESTAMP values"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_TIMESTAMP

inherit
	ECLI_DATE
		rename
			make as make_date, set as set_date
		export
		undefine
		redefine
			make_first, item, set_item, 
			set_date, octet_size,
			c_type_code, column_precision, db_type_code, 
			decimal_digits, display_size, out, is_equal,
			to_timestamp, trace
		select
		end

creation
	make, make_first

feature {NONE} -- Initialization

	make (a_year, a_month, a_day, a_hour, a_minute, a_second, a_nanosecond : INTEGER) is
		require
			month: a_month >= 1 and a_month <= 12
			day: a_day >= 1 and a_day <= days_in_month (a_month, a_year)
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999
		do
			allocate_buffer
			set (a_year, a_month, a_day, a_hour, a_minute, a_second, a_nanosecond)
		ensure
			year_set: year = a_year
			month_set: month = a_month
			day_set: day = a_day
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
			nanosecond_set: nanosecond = a_nanosecond
		end

	make_first is
		do
			allocate_buffer
			set_date (1,1,1)
		ensure then
			hour_set: hour = 0
			minute_set: minute = 0
			second_set: second = 0
			nanosecond_set: nanosecond = 0
		end

feature -- Access

	item : DT_DATE_TIME is
		do
			!!Result.make_precise (year,month,day,hour, minute, second,nanosecond // 1_000_000)
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

	set_date (a_year, a_month, a_day : INTEGER ) is
		do
			Precursor (a_year, a_month, a_day)
			set_time (0, 0, 0, 0)
		ensure then
			time_set: hour = 0 and minute = 0 and second = 0 and nanosecond = 0
		end

	set_time (a_hour, a_minute, a_second, a_nanosecond : INTEGER ) is
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

	set (a_year, a_month, a_day, a_hour, a_minute, a_second, a_nanosecond : INTEGER) is
		require
			month: a_month > 0 and a_month <= 12
			day: a_day > 0 and a_day <= days_in_month (a_month, a_year)
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999
		do
			set_date (a_year, a_month, a_day)
			set_time (a_hour, a_minute, a_second, a_nanosecond)
		ensure
			year_set: year = a_year
			month_set: month = a_month
			day_set: day = a_day
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
			nanosecond_set: nanosecond = a_nanosecond
		end

	set_item (other : like item) is
		do
			Precursor (other)
			set_time (other.hour, other.minute, other.second, other.millisecond * 1_000_000)
		end

feature -- Status report

	c_type_code: INTEGER is
		once
			Result := sql_c_type_timestamp
		end

	column_precision: INTEGER is
		do
			Result := 20+decimal_digits
		end

	db_type_code: INTEGER is
		once
			Result := sql_type_timestamp
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
			Result := Precursor
			if not is_null then
				Result.append_character (' ')
				Result.append (pad_integer_2 (hour))
				Result.append_character (':')
				Result.append (pad_integer_2 (minute))
				Result.append_character (':')
				Result.append (pad_integer_2 (second))
				Result.append_character ('.')
				Result.append (nanosecond.out)
			end
		end
			
	to_timestamp : DT_DATE_TIME is
		do
			Result := item
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
			Result := Precursor (other) and
				hour = other.hour and
				minute = other.minute and
				second = other.second and
				nanosecond = other.nanosecond
		end
			
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	octet_size : INTEGER is
		do
			Result := ecli_c_sizeof_timestamp_struct
		end
	
	ecli_c_sizeof_timestamp_struct : INTEGER is
		external "C"
		end
			
invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_TIMESTAMP
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
