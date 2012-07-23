indexing

	description:

		"SQL TIMESTAMP values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TIMESTAMP

inherit

	ECLI_GENERIC_VALUE [DT_DATE_TIME]
		redefine
			create_impl_item, impl_item, is_equal, out,
			item
		end

create

	make, make_first, make_default, make_null

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
			create_impl_item
		ensure
			not_null: not is_null
			year_set: year = a_year
			month_set: month = a_month
			day_set: day = a_day
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
			nanosecond_set: nanosecond = a_nanosecond
		end

	make_default is
			-- make default time_stamp value
		do
			--allocate_buffer
			--set_date (1,1,1)
			make (1, 1, 1, 0,0,0,0)
		ensure
			not_null: not is_null
			day_one: year = 1 and then month = 1 and then day = 1
			hour_set: hour = 0
			minute_set: minute = 0
			second_set: second = 0
			nanosecond_set: nanosecond = 0
		end

	make_first is
			-- make first day of Christian era
		obsolete "Use `make_default' instead"
		do
			make_default
		ensure
			not_null: not is_null
			day_one:
		end

	make_null is
			-- make null
		do
			make_default
			set_null
		ensure
			is_null: is_null
		end

feature -- Access

	item : DT_DATE_TIME is
		do
			impl_item.set_year_month_day (year,month,day)
			impl_item.set_precise_hour_minute_second (hour, minute, second,nanosecond // 1_000_000)
			Result := impl_item
		end

	year : INTEGER is
		do
			if not is_null then
				Result := ecli_c_date_get_year (to_external)
			end
		end

	month : INTEGER is
		do
			if not is_null then
				Result := ecli_c_date_get_month (to_external)
			end
		end

	day : INTEGER is
		do
			if not is_null then
				Result := ecli_c_date_get_day (to_external)
			end
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

	c_type_code: INTEGER is
		once
			Result := sql_c_type_timestamp
		end

	sql_type_code: INTEGER is
		once
			Result := sql_type_timestamp
		end

feature -- Measurement

	days_in_month (a_month, a_year : INTEGER) : INTEGER is
			-- number of days in 'a_month' for 'a_year'
			-- feature is delegated to a DT_GREGORIAN_CALENDAR object
			-- Feature to be deleted when smalleiffel 075 has been fixed
		require
			month_ok: a_month >= 1 and a_month <= 12
		do
			Result := calendar.days_in_month(a_month, a_year)
		ensure
			days_in_month_positive: Result > 0
			days_in_month_not_more_31: Result <= 31
		end

	size : INTEGER_64 is
		local
			l_decimal_digits : INTEGER
		do
			l_decimal_digits := decimal_digits
			if l_decimal_digits > 0 then
				Result := 20 + l_decimal_digits
			else
				Result := 19
			end
		end

	decimal_digits: INTEGER
			-- number of digits allowed in the fractional seconds part

	display_size: INTEGER is
		do
			Result := size.as_integer_32
		end

feature -- Status report

	convertible_as_string : BOOLEAN is
			--
		do
			Result := True
		end

	convertible_as_timestamp : BOOLEAN is
			-- is Current convertible to a timestamp ?
		do
			Result := True
		end

	convertible_as_character : BOOLEAN is
			-- Is this value convertible to a character ?
		do
			Result := False
		end

	convertible_as_boolean : BOOLEAN is
			-- Is this value convertible to a boolean ?
		do
			Result := False
		end

	convertible_as_integer : BOOLEAN is
			-- Is this value convertible to an integer ?
		do
			Result := False
		end

	convertible_as_integer_64 : BOOLEAN is
			-- Is this value convertible to an integer_64 ?
		do
			Result := False
		end

	convertible_as_real : BOOLEAN is
			-- Is this value convertible to a real ?
		do
			Result := False
		end

	convertible_as_double : BOOLEAN is
			-- Is this value convertible to a double ?
		do
			Result := False
		end

	convertible_as_decimal : BOOLEAN is
			-- Is this value convertible to a decimal ?
		do
			Result := False
		end

	convertible_as_date : BOOLEAN is
			-- Is this value convertible to a date ?
		do
			Result := True
		end

	convertible_as_time : BOOLEAN is
			-- Is this value convertible to a time ?
		do
			Result := False
		end

feature -- Element change

	set_date (a_year, a_month, a_day : INTEGER ) is
		require
			month: a_month >= 1 and a_month <= 12
			day: a_day >= 1 and a_day <= days_in_month (a_month, a_year)
		do
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
			set_date_external (to_external, a_year, a_month, a_day)
			set_time_external (to_external, 0, 0, 0, 0)
		ensure
			not_null: not is_null
			year_set: year = a_year
			month_set: month = a_month
			day_set: day = a_day
			time_set: hour = 0 and minute = 0 and second = 0 and nanosecond = 0
		end

	set_time (a_hour, a_minute, a_second, a_nanosecond : INTEGER ) is
		require
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999

		do
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
			set_time_external (to_external, a_hour, a_minute, a_second, a_nanosecond)
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
			not_null: not is_null
			year_set: year = a_year
			month_set: month = a_month
			day_set: day = a_day
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
			nanosecond_set: nanosecond = a_nanosecond
		end

	set_item (other : DT_DATE_TIME) is
		do
			set_date (other.year, other.month,other.day)
			set_time (other.hour, other.minute, other.second, other.millisecond * 1_000_000)
		end

	set_decimal_digits (n : INTEGER) is
			-- set `decimal_digits' to `n'
			-- this value is data source dependent;
			-- get type information using ECLI_SQL_TYPES_CURSOR
		require
			valid_number: n <= 9
		do
			decimal_digits := n
		ensure
			decimal_digits_set: decimal_digits = n
		end

feature -- Conversion

	as_string : STRING is
			--
		do
			Result := out
		end

	out : STRING is
		do
			if not is_null then
				create Result.make (10)
				Result.append_string (Integer_format.pad_integer_4 (year))
				Result.append_character ('-')
				Result.append_string (Integer_format.pad_integer_2 (month))
				Result.append_character ('-')
				Result.append_string (Integer_format.pad_integer_2 (day))
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
			else
				Result := out_null
			end
		end

	as_timestamp : DT_DATE_TIME is
		do
			Result := item.twin
		end

	as_date : DT_DATE is
		do
			Result := item.date
		end

	as_character : CHARACTER is
			-- Current converted to CHARACTER
		do
		end

	as_boolean : BOOLEAN is
			-- Current converted to BOOLEAN
		do
		end

	as_integer : INTEGER is
			-- Current converted to INTEGER
		do
		end

	as_integer_64 : INTEGER_64 is
			-- Current converted to INTEGER_64
		do
		end

	as_real : REAL is
			-- Current converted to REAL
		do
		end

	as_double : DOUBLE is
			-- Current converted to DOUBLE
		do
		end

	as_decimal : MA_DECIMAL is
			-- Current converted to MA_DECIMAL.
		do
			check False then
				create Result.make_zero
			end
		end

	as_time : DT_TIME is
			-- Current converted to DT_TIME
		do
			check False then
				create Result.make_from_second_count (0)
			end
		end

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_timestamp (Current)
		end

	is_equal (other : like Current) : BOOLEAN is
		do
			Result := year = other.year and then
				month = other.month and
				day = other.day and
				hour = other.hour and
				minute = other.minute and
				second = other.second and
				nanosecond = other.nanosecond
		end

feature -- Inapplicable

	transfer_octet_length : INTEGER_64 is
		do
			Result := ecli_c_sizeof_timestamp_struct
		end

feature {NONE} -- Implementation

	ecli_c_sizeof_timestamp_struct : INTEGER is
		external "C"
		end

	create_impl_item is
			--
		local
			dt : DT_DATE_TIME
		do
			create dt.make (0,1,1,0,0,0)
			impl_item := dt
		end

	allocate_buffer is
		do
			if buffer = default_pointer then
				buffer := ecli_c_alloc_value (transfer_octet_length)
				check_valid
			end
		end

	integer_format : 	ECLI_FORMAT_INTEGER is
			-- format integer routines
		once
			create Result
		end

	impl_item : DT_DATE_TIME

	calendar : DT_GREGORIAN_CALENDAR is once create Result end

	set_date_external (pointer : POINTER; a_year, a_month, a_day : INTEGER ) is
			-- set date part of external `pointer'
		require
			pointer_not_default: pointer /= default_pointer
			month: a_month >= 1 and a_month <= 12
			day: a_day >= 1 and a_day <= days_in_month (a_month, a_year)
		do
			ecli_c_date_set_year (pointer, a_year)
			ecli_c_date_set_month (pointer, a_month)
			ecli_c_date_set_day (pointer, a_day)
		ensure
			year_set: ecli_c_date_get_year (pointer) = a_year
			month_set: ecli_c_date_get_month (pointer) = a_month
			day_set: ecli_c_date_get_day (pointer) = a_day
		end

	set_time_external (pointer : POINTER; a_hour, a_minute, a_second, a_nanosecond : INTEGER ) is
			-- Set time part of external structure referenced by `pointer'
		require
			pointer_not_default: pointer /= default_pointer
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
			nanosecond: a_nanosecond >= 0 and a_nanosecond <= 999_999_999
		do
			ecli_c_timestamp_set_hour (pointer, a_hour)
			ecli_c_timestamp_set_minute (pointer, a_minute)
			ecli_c_timestamp_set_second (pointer, a_second)
			ecli_c_timestamp_set_fraction (pointer, a_nanosecond)
		ensure
			hour_set: ecli_c_timestamp_get_hour (pointer) = a_hour
			minute_set: ecli_c_timestamp_get_minute (pointer) = a_minute
			second_set: ecli_c_timestamp_get_second (pointer) = a_second
			fraction_set: ecli_c_timestamp_get_fraction (pointer) = a_nanosecond
		end
end
