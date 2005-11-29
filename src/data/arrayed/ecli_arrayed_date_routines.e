indexing

	description: 
	
		"Routines for handling arrayed buffers of DATEs or date part of TIMESTAMPs."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_ARRAYED_DATE_ROUTINES

inherit

	ECLI_EXTERNAL_API
		export 
			{NONE} all
		end
	
	ANY
	
feature -- Access

	buffer : POINTER is
		deferred
		end

	transfer_octet_length : INTEGER is
		deferred
		end
		
	cursor_index : INTEGER is
		deferred
		end
		
	year : INTEGER is
			-- year_at (cursor_index)
		do
			if not off then
				Result := year_at (cursor_index)
			end
		ensure
			value_at_cursor_index: (not (is_null or else off)) implies Result = year_at (cursor_index)
			zero_when_null: is_null implies Result = 0
			zero_when_off: off implies Result = 0
		end

	month : INTEGER is
			-- month_at (cursor_index)
		do
			if not off then
				Result := month_at (cursor_index)
			end
		ensure
			value_at_cursor_index: (not (is_null or else off)) implies Result = month_at (cursor_index)
			zero_when_null: is_null implies Result = 0
			zero_when_off: off implies Result = 0
		end

	day : INTEGER is
			-- day_at (cursor_index)
		do
			if not off then
				Result := day_at (cursor_index)
			end
		ensure
			value_at_cursor_index: (not (is_null or else off)) implies Result = day_at (cursor_index)
			zero_when_null: is_null implies Result = 0
			zero_when_off: off implies Result = 0
		end

	year_at (index : INTEGER) : INTEGER is
		require
			valid_index: index >= 1 and then index <= upper
		local
			date_pointer : POINTER
		do
			date_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_date_get_year (date_pointer)
			end
		end

	month_at (index : INTEGER) : INTEGER is
		require
			valid_index: index >= 1 and then index <= upper
		local
			date_pointer : POINTER
		do
			date_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_date_get_month (date_pointer)
			end
		end

	day_at (index : INTEGER) : INTEGER is
		require
			valid_index: index >= 1 and then index <= upper
		local
			date_pointer : POINTER
		do
			date_pointer := ecli_c_array_value_get_value_at (buffer, index)
			if not is_null_at (index) then
				Result := ecli_c_date_get_day (date_pointer)
			end
		end

feature -- Measurement

	lower : INTEGER is
		deferred
		end

	upper : INTEGER is
		deferred
		end
		
		
feature -- Status report

	is_null : BOOLEAN is
		deferred
		end
		
	off : BOOLEAN is
		deferred
		end
		
	is_null_at (index : INTEGER) : BOOLEAN is
		deferred
		end
		
feature -- Status setting

feature -- Cursor movement

feature -- Element change

	go (ith : INTEGER) is
			-- advance internal cursor
		deferred
		ensure
			cursor_index = ith
		end

	set_date_at (a_year, a_month, a_day : INTEGER; index : INTEGER ) is
		local
			date_pointer : POINTER
		do
			date_pointer := ecli_c_array_value_get_value_at (buffer, index)
			ecli_c_date_set_year (date_pointer, a_year)
			ecli_c_date_set_month (date_pointer, a_month)
			ecli_c_date_set_day (date_pointer, a_day)			
			ecli_c_array_value_set_length_indicator_at (buffer, transfer_octet_length,index)
		ensure
			year_set: year_at (index) = a_year
			month_set: month_at (index) = a_month
			day_set: day_at (index) = a_day
		end
		
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	as_string : STRING is
		do
			Result := out_item_at (cursor_index)
		end
		
	out_item_at (index : INTEGER) : STRING is
		local
			save_index : INTEGER
		do
			!!Result.make (10)
			if is_null_at (index) then
				Result.append_string ("NULL")
			else
				save_index := cursor_index
				go (index)
				Result.append_string (Integer_format.pad_integer_4 (year))
				Result.append_character ('-')
				Result.append_string (Integer_format.pad_integer_2 (month))
				Result.append_character ('-')
				Result.append_string (Integer_format.pad_integer_2 (day))
				go (save_index)
			end
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	Integer_format : ECLI_FORMAT_INTEGER is
		deferred
		end
		
invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_ARRAYED_DATE_ROUTINES
