indexing

	description: 
	
		"SQL TIME values"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TIME

inherit

	ECLI_GENERIC_VALUE [DT_TIME]
		redefine
--			convertible_as_time, as_time, 
			is_equal, out, 
			item,
			create_impl_item, impl_item
		end
		
creation

	make, make_default, make_null
	
feature {NONE} -- Initialization

	make (a_hour, a_minute, a_second : INTEGER) is --, a_nanosecond : INTEGER) is
		require
			hour: a_hour >= 0 and a_hour <= 23
			minute: a_minute >= 0 and a_minute <= 59
			second: a_second >= 0 and a_second <= 61 -- to maintain synchronization of sidereal time (?)
		do
			allocate_buffer
			set (a_hour, a_minute, a_second) --, a_nanosecond)
			create_impl_item
		ensure
			not_null: not is_null
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
		end

	make_default is
			-- Make zero
		do
			make (0,0,0)
		ensure
			not_null: not is_null
			hour_set: hour = 0
			minute_set: minute = 0
			second_set: second = 0
		end

	make_null is
			-- Make null.
		do
			make_default
			set_null
		ensure
			is_null: is_null
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

	c_type_code: INTEGER is
		once
			Result := sql_c_type_time
		end

	sql_type_code: INTEGER is
		once
			Result := sql_type_time
		end

feature -- Status report

	convertible_as_string : BOOLEAN is
			-- Is this value convertible to a string ?
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

	convertible_as_date : BOOLEAN is
			-- Is this value convertible to a date ?
		do
			Result := False
		end

	convertible_as_time : BOOLEAN is
			-- Is this value convertible to a time ?
		do
			Result := True
		end

	convertible_as_timestamp : BOOLEAN is
			-- Is this value convertible to a timestamp ?
		do
			Result := False
		end

feature -- Measurement

	size : INTEGER is
		do
			Result := 8
		end

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_sizeof_time_struct
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

		do
			ecli_c_time_set_hour (to_external, a_hour)
			ecli_c_time_set_minute (to_external, a_minute)
			ecli_c_time_set_second (to_external, a_second)
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
		ensure
			hour_set: hour = a_hour
			minute_set: minute = a_minute
			second_set: second = a_second
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
			else
				Result := out_null
			end
		end
			
	as_time : DT_TIME is
		do
			Result := clone (item)
		end

	as_string : STRING is
			-- Current converted to STRING
		do
			Result := out
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

	as_real : REAL is
			-- Current converted to REAL
		do
		end

	as_double : DOUBLE is
			-- Current converted to DOUBLE
		do
		end

	as_date : DT_DATE is
			-- Current converted to DATE
		do
		end

	as_timestamp : DT_DATE_TIME is
			-- Current converted to DT_DATE_TIME
		do
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
				check_valid
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

end
