indexing
	description: "ISO CLI DATE value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_DATE

inherit
	ECLI_VALUE
		rename
		export
		undefine
		redefine
			item, set_item, out, is_equal, convertible_to_date, to_date,
			convertible_to_timestamp, to_timestamp
		select
		end

	ECLI_FORMAT_INTEGER
		undefine
			out, is_equal
		end

--| FIXME: uncomment when SmallEiffel 075 has been fixed
--
--	DT_GREGORIAN_CALENDAR 
--		export 
--			{NONE} all;
--			{ANY} days_in_month
--		undefine
--			is_equal, out
--		end
		
creation
	make, make_first, make_default

feature {NONE} -- Initialization

	make (a_year, a_month, a_day : INTEGER) is
		require
			month: a_month >= 1 and a_month <= 12
			day: a_day >= 1 and a_day <= days_in_month (a_month, a_year)
		do
			allocate_buffer
			set (a_year, a_month, a_day)
		ensure
			year_set: year = a_year
			month_set: month = a_month
			day_set: day = a_day
		end

	make_first is
			-- make as first day of Christian Era : January 1st, 1
		obsolete "please use make_default instead."
		do
			make_default
		end
		
	make_default is
			-- make default date as first day of Christian Era : January 1st, 1
		do
			allocate_buffer
			set (1,1,1)
		ensure
			not_null: not is_null
			year_set: year = 1
			month_set: month = 1
			day_set: day = 1
		end
		
feature -- Access

	item : DT_DATE is
		do
			!!Result.make (year, month, day)
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

feature -- Measurement

	days_in_month (a_month, a_year : INTEGER) : INTEGER is
			-- number of days in 'a_month' for 'a_year'
			-- feature is delegated to a DT_GREGORIAN_CALENDAR object
			-- Feature to be deleted when smalleiffel 075 has been fixed
		require
			month_ok: a_month >= 1 and a_month <= 12
		local
			calendar : expanded DT_GREGORIAN_CALENDAR
		do
			Result := calendar.days_in_month(a_month, a_year)
		end
		
feature -- Status report

	convertible_to_date : BOOLEAN is 
		do
			Result := True
		end
	
	convertible_to_timestamp : BOOLEAN is
			-- is Current convertible to timestamp ?
		do 
			Result := True
		end
		
	c_type_code: INTEGER is
		once
			Result := sql_c_type_date
		end

	column_precision: INTEGER is
		do
			Result := 10
		end

	sql_type_code: INTEGER is
		once
			Result := sql_type_date
		end

	decimal_digits: INTEGER is
		do
			Result := 0
		end

	display_size: INTEGER is
		do
			Result := 10
		end

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_sizeof_date_struct
		end

feature -- Status setting

	set (a_year, a_month, a_day : INTEGER) is
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

	set_item (other : like item) is
		do
			set (other.year, other.month, other.day)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out : STRING is
		do
			if is_null then
				Result := "NULL"
			else
				Result:= string_routines.make (10)
				Result.append (pad_integer_4 (year))
				Result.append_character ('-')
				Result.append (pad_integer_2 (month))
				Result.append_character ('-')
				Result.append (pad_integer_2 (day))
			end
		end

	to_date : DT_DATE is
			-- Current converted to date
		do
			Result := item
		end
		
	to_timestamp : DT_DATE_TIME is
			-- Current converted to timestamp
		do
			!!Result.make(year, month, day, 0, 0, 0)
		end
		
feature -- Basic operations

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_date (Current)
		end

	is_equal (other : like Current) : BOOLEAN is
		do
			Result := year = other.year and
				month = other.month and
				day = other.day
		end

feature {NONE} -- Implementation

	string_routines : expanded KL_STRING_ROUTINES


	allocate_buffer is
		do
			if buffer = default_pointer then
				buffer := ecli_c_alloc_value (transfer_octet_length)
			end
		end
	
	ecli_c_sizeof_date_struct : INTEGER is
		external "C"
		end

invariant
	month:	(not is_null) implies (month >= 1 and month <= 12)
	day:  	(not is_null) implies (day >= 1 and day <= days_in_month (month, year))

end -- class ECLI_DATE
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
