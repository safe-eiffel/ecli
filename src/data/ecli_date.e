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
			item, set_item, out, is_equal
		select
		end

creation
	make, make_first

feature {NONE} -- Initialization

	make (a_year, a_month, a_day : INTEGER) is
		require
			year: a_year > 0
			month: a_month > 0 and a_month <= 12
			day: a_day > 0 and a_day <= 31
--((<<1,3,5,7,8,10,12>>).has (a_month) and a_day <= 31
--				or else (<<4,6,9,11>>).has (a_month) and a_day <= 30
--				or else a_month = 2 and ( 
--					( -- leap
--					   ((a_year \\ 400 = 0) or else ((a_year \\ 4 = 0) and (a_year \\ 100 /= 0))) and a_day <= 29)
--					  or else -- not leap
--					   a_day <= 28))
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
		do
			allocate_buffer
			set (1,1,1)
		ensure
			year_set: year = 1
			month_set: month = 1
			day_set: day = 1
		end
		
feature -- Access

	item : ECLI_DATE is
		do
			Result := Current
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

feature -- Status report

	c_type_code: INTEGER is
		once
			Result := sql_c_type_date
		end

	column_precision: INTEGER is
		do
			Result := 10
		end

	db_type_code: INTEGER is
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
			Result := ecli_c_value_get_length (buffer)
		end

feature -- Status setting

	set (a_year, a_month, a_day : INTEGER) is
		require
			year: a_year > 0
			month: a_month > 0 and a_month <= 12
			day: a_day > 0 and a_day <= 31
--((<<1,3,5,7,8,10,12>>).has (a_month) and a_day <= 31
--				or else (<<4,6,9,11>>).has (a_month) and a_day <= 30
--				or else a_month = 2 and ( 
--					( -- leap
--					   ((a_year \\ 400 = 0) or else ((a_year \\ 4 = 0) and (a_year \\ 100 /= 0))) and a_day <= 29)
--					  or else -- not leap
--					   a_day <= 28))
		do
			ecli_c_date_set_year (to_external, a_year)
			ecli_c_date_set_month (to_external, a_month)
			ecli_c_date_set_day (to_external, a_day)
		ensure
			year_set: year = a_year
			month_set: month = a_month
			day_set: day = a_day
		end

feature -- Cursor movement

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
				create Result.make (10)
				Result.append (pad_integer_4 (year))
				Result.append_character ('-')
				Result.append (pad_integer_2 (month))
				Result.append_character ('-')
				Result.append (pad_integer_2 (day))
			end
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	is_equal (other : like Current) : BOOLEAN is
		do
			Result := year = other.year and
				month = other.month and
				day = other.day
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	pad_integer_4 (value : INTEGER) : STRING is
		do
			create Result.make (4)
			if value < 10 then
				Result.append ("000")
			elseif value < 100 then
				Result.append ("00")
			elseif value < 1000 then
				Result.append ("0")
			end
			Result.append (value.out)
		end

	pad_integer_2 (value : INTEGER) : STRING is
		do
			create Result.make (2)
			if value < 10 then
				Result.append ("0")
			end
			Result.append (value.out)
		end

	allocate_buffer is
		do
			if buffer = default_pointer then
				buffer := ecli_c_alloc_value (octet_size)
			end
		end

	octet_size : INTEGER is
		do
			Result := 6
		end

invariant
	null_or_valid: is_null or
		(
			year > 0 and
			month > 0 and month <= 12 and
			day > 0 and day <= 31
--((<<1,3,5,7,8,10,12>>).has (month) and day <= 31
--				or else (<<4,6,9,11>>).has (month) and day <= 30
--				or else month = 2 and ( 
--					( -- leap
--					   ((year \\ 400 = 0) or else ((year \\ 4 = 0) and (year \\ 100 /= 0))) and day <= 29)
--					  or else -- not leap
--					   day <= 28))
		)

end -- class ECLI_DATE
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
