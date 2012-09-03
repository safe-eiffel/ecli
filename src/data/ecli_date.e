note

	description:

		"SQL DATE values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DATE

inherit

	ECLI_GENERIC_VALUE [DT_DATE]
		redefine
			item, out, is_equal,
			create_impl_item, impl_item
		end

create

	make, make_default, make_null

feature {NONE} -- Initialization

	make (a_year, a_month, a_day : INTEGER)
		require
			month: a_month >= 1 and a_month <= 12
			day: a_day >= 1 and a_day <= days_in_month (a_month, a_year)
		do
			allocate_buffer
			set (a_year, a_month, a_day)
			create_impl_item
		ensure
			year_set: year = a_year
			month_set: month = a_month
			day_set: day = a_day
		end

	make_default
			-- make default date as first day of Christian Era : January 1st, 1
		do
			make (1, 1, 1)
		ensure
			not_null: not is_null
			year_set: year = 1
			month_set: month = 1
			day_set: day = 1
		end

	make_null
		do
			make_default
			set_null
		ensure
			is_null: is_null
		end

feature -- Access

	item : DT_DATE
		do
			impl_item.set_year_month_day (year,month,day)
			Result := impl_item
		end

	year : INTEGER
		do
			if not is_null then
				Result := ecli_c_date_get_year (to_external)
			end
		end

	month : INTEGER
		do
			if not is_null then
				Result := ecli_c_date_get_month (to_external)
			end
		end

	day : INTEGER
		do
			if not is_null then
				Result := ecli_c_date_get_day (to_external)
			end
		end

	c_type_code: INTEGER
		once
			Result := sql_c_type_date
		end

	sql_type_code: INTEGER
		once
			Result := sql_type_date
		end

feature -- Status report

	convertible_as_string : BOOLEAN
			-- Is this value convertible to a string ?
		do
			Result := True
		end

	convertible_as_character : BOOLEAN
			-- Is this value convertible to a character ?
		do
			Result := False
		end

	convertible_as_boolean : BOOLEAN
			-- Is this value convertible to a boolean ?
		do
			Result := False
		end

	convertible_as_decimal : BOOLEAN
			-- Is this value convertible to a decimal ?
		do
			Result := False
		end

	convertible_as_integer : BOOLEAN
			-- Is this value convertible to an integer ?
		do
			Result := False
		end

	convertible_as_integer_64 : BOOLEAN
			-- Is this value convertible to an integer_64 ?
		do
			Result := False
		end

	convertible_as_real : BOOLEAN
			-- Is this value convertible to a real ?
		do
			Result := False
		end

	convertible_as_double : BOOLEAN
			-- Is this value convertible to a double ?
		do
			Result := False
		end

	convertible_as_date : BOOLEAN
			-- Is this value convertible to a date ?
		do
			Result := True
		end

	convertible_as_time : BOOLEAN
			-- Is this value convertible to a time ?
		do
			Result := False
		end

	convertible_as_timestamp : BOOLEAN
			-- Is this value convertible to a timestamp ?
		do
			Result := True
		end

feature -- Measurement

	days_in_month (a_month, a_year : INTEGER) : INTEGER
			-- number of days in 'a_month' for 'a_year'
			-- feature is delegated to a DT_GREGORIAN_CALENDAR object
			-- Feature to be deleted when smalleiffel 075 has been fixed
		require
			month_ok: a_month >= 1 and a_month <= 12
		do
			Result := calendar.days_in_month(a_month, a_year)
		end

	size : INTEGER_64
		do
			Result := 10
		end

	decimal_digits: INTEGER
		do
			Result := 0
		end

	display_size: INTEGER
		do
			Result := 10
		end

	transfer_octet_length: INTEGER_64
		do
			Result := ecli_c_sizeof_date_struct
		end

feature -- Status setting

	set (a_year, a_month, a_day : INTEGER)
		require
			month: a_month >= 1 and a_month <= 12
			day: a_day >= 1 and a_day <= days_in_month (a_month, a_year)
		do
			ecli_c_date_set_year (to_external, a_year)
			ecli_c_date_set_month (to_external, a_month)
			ecli_c_date_set_day (to_external, a_day)
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
		ensure
			year_set: year = a_year
			month_set: month = a_month
			day_set: day = a_day
		end

feature -- Element change

	set_item (other : DT_DATE)
		do
			set (other.year, other.month, other.day)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out : STRING
		do
			if is_null then
				Result := out_null
			else
				create Result.make (10)
				Result.append_string (integer_format.pad_integer_4 (year))
				Result.append_character ('-')
				Result.append_string (integer_format.pad_integer_2 (month))
				Result.append_character ('-')
				Result.append_string (integer_format.pad_integer_2 (day))
			end
		end

	as_date : DT_DATE
			-- Current converted to date
		do
			Result := item.twin
		end

	as_timestamp : DT_DATE_TIME
			-- Current converted to timestamp
		do
			create Result.make(year, month, day, 0, 0, 0)
		end

	as_string : STRING
			-- Current converted to STRING
		do
			Result := out
		end

	as_character : CHARACTER
			-- Current converted to CHARACTER
		do
		end

	as_boolean : BOOLEAN
			-- Current converted to BOOLEAN
		do
		end

	as_integer : INTEGER
			-- Current converted to INTEGER
		do
		end

	as_integer_64 : INTEGER_64
			-- Current converted to INTEGER_64
		do
		end

	as_real : REAL
			-- Current converted to REAL
		do
		end

	as_double : DOUBLE
			-- Current converted to DOUBLE
		do
		end

	as_decimal : MA_DECIMAL
			-- Current converted to MA_DECIMAL.
		do
		end

	as_time : DT_TIME
			-- Current converted to DT_TIME
		do
		end

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER)
		do
			a_tracer.put_date (Current)
		end

	is_equal (other : like Current) : BOOLEAN
		do
			Result := year = other.year and
				month = other.month and
				day = other.day
		end

feature {NONE} -- Implementation

	allocate_buffer
		do
			if buffer = default_pointer then
				buffer := ecli_c_alloc_value (transfer_octet_length)
				check_valid
			end
		end

	ecli_c_sizeof_date_struct : INTEGER
		external "C"
		end

	create_impl_item
		local
			d : DT_DATE
		do
			create d.make (0,1,1)
			impl_item := d
		end

	integer_format : 	ECLI_FORMAT_INTEGER
			-- format integer routines
		once
			create Result
		end

	impl_item : DT_DATE

	calendar :  DT_GREGORIAN_CALENDAR once create Result end

invariant
	month:	(not is_null) implies (month >= 1 and month <= 12)
	day:  	(not is_null) implies (day >= 1 and day <= days_in_month (month, year))

end
