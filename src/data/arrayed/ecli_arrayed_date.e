indexing
	description: "ISO CLI DATE arrayed value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ARRAYED_DATE

inherit
	ECLI_GENERIC_ARRAYED_VALUE [DT_DATE]
		undefine
			set_item, is_equal, out_item_at
		redefine
		select
			is_equal, copy
		end

	ECLI_DATE
		rename
			make as make_single, make_default as make_default_single, set as set_date,
			is_equal as is_equal_item, copy as copy_item
		export
			{NONE} make_single, make_default_single
		undefine
			release_handle, length_indicator_pointer, to_external, is_null, set_null, out, set_item, as_string
		redefine
			item, trace, allocate_buffer, year, month, day, set_date --, transfer_octet_length
		end
	
creation
	make

feature {NONE} -- Initialization
		
	make (a_capacity : INTEGER) is
			-- make array of null dates
		do
			capacity := a_capacity
			count := capacity
			allocate_buffer
			set_all_null
			create_impl_item
		end
		
feature -- Access

	item_at (index : INTEGER) : DT_DATE is
		local
			save_index : INTEGER
		do
			save_index := cursor_index
			cursor_index := index
			Result := item
			cursor_index := save_index
		end
		
	item : DT_DATE is
		do
			--!!Result.make (year, month, day)
			impl_item.set_year_month_day (year, month, day)
			Result := impl_item
		end

	year : INTEGER is
			-- year_at (cursor_index)
		do
			if not off then
				Result := year_at (cursor_index)
			end
		ensure then
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
		ensure then
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
		ensure then
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

		
feature -- Status report

--	transfer_octet_length: INTEGER is
--		do
--			Result := ecli_c_array_value_get_length (buffer)
--		end

feature -- Status setting

feature -- Element change

	set_item (other : DT_DATE) is
		do
			set_item_at (other, cursor_index)
		ensure then
			item_set: item.is_equal (other)
		end

	set_item_at (other : DT_DATE; index : INTEGER) is
		do
			set_date_at (other.year, other.month, other.day, index)
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

	set_date (a_year, a_month, a_day : INTEGER) is
		do
			set_date_at (a_year, a_month, a_day, cursor_index)
		end
		
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out_item_at (index : INTEGER) : STRING is
		local
			save_index : INTEGER
		do
			!!Result.make (10)
			if is_null_at (index) then
				Result.append_string ("NULL")
			else
				save_index := cursor_index
				cursor_index := index
				Result.append_string (Integer_format.pad_integer_4 (year))
				Result.append_character ('-')
				Result.append_string (Integer_format.pad_integer_2 (month))
				Result.append_character ('-')
				Result.append_string (Integer_format.pad_integer_2 (day))
				cursor_index := save_index
			end
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

	allocate_buffer is
		do
			if buffer = default_pointer then
				buffer := ecli_c_alloc_array_value (transfer_octet_length, capacity)
			end
		end
		
invariant
	month:	(not is_null) implies (month >= 1 and month <= 12)
	day:  	(not is_null) implies (day >= 1 and day <= days_in_month (month, year))

end -- class ECLI_ARRAYED_DATE
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
