note

	description:

			"Buffers for exchanging string-based values between application and database."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_STRING_VALUE

inherit

	ECLI_GENERIC_VALUE[STRING]
		redefine
			item,
			out,
			impl_item
		end

feature {NONE} -- Initialization

	make (n : INTEGER)
			-- Make with capacity `n', within limits of `maximum_capacity'.
		require
			valid_n: n > 0 and n <= maximum_capacity
		local
			s : STRING
		do
			buffer := ecli_c_alloc_value (n+1)
			check_valid
			create s.make (0)
			impl_item := s
			set_null
			create ext_item.make_shared_from_pointer (ecli_c_value_get_value (buffer), capacity)
		ensure
			is_null: is_null
			capacity: capacity = n
--			maximum_capacity: maximum_capacity = default_maximum_capacity
		end

	make_force_maximum_capacity (n : INTEGER)
			-- Make with capacity `n', forcing `maximum_capacity'.
		require
			valid_n: n > 0
		do
			maximum_capacity_impl := n
			make (n)
		ensure
			is_null: is_null
			capacity_set: capacity = n
			maximum_capacity_set: maximum_capacity = n
		end

feature -- Access

	item : STRING
		do
			if is_null then
				create Result.make_empty
			else
				ext_item.copy_to (impl_item)
				Result := impl_item
			end
		end

	max_capacity : INTEGER
		obsolete "Use `maximum_capacity' instead."
		do
			Result := maximum_capacity
		end

	maximum_capacity : INTEGER
		do
			if maximum_capacity_impl > 0 then
				Result := maximum_capacity_impl
			else
				Result := default_maximum_capacity
			end
		end

	capacity : INTEGER
		do
			Result := (ecli_c_value_get_length (buffer) - 1).as_integer_32
		end

	count : INTEGER
			-- actual length of item
		do
			if not is_null then
				Result := ecli_c_value_get_length_indicator (buffer).as_integer_32 -- FIXME 64/32 bits
			end
		end

	c_type_code: INTEGER
		do
			Result := sql_c_char
		end

feature -- Measurement

	size: INTEGER_64
		do
			Result := display_size
		end

	decimal_digits: INTEGER
		do
			Result := 0
		end

	display_size: INTEGER
		do
			Result := transfer_octet_length.as_integer_32 - 1
		end

	transfer_octet_length: INTEGER_64
		do
			Result := ecli_c_value_get_length (buffer).as_integer_32 -- FIXME 64/32 bits
		end

feature -- Status report

	convertible_as_string : BOOLEAN
		do
			Result := True
		end

	convertible_as_integer : BOOLEAN
		do
			Result := not is_null and then item.is_integer
		end

	convertible_as_integer_64 : BOOLEAN
		do
			Result := not is_null and then item.is_integer_64
		end

	convertible_as_double : BOOLEAN
		do
			Result := not is_null and then item.is_double
		end

	convertible_as_decimal : BOOLEAN
			-- Is this value convertible to a decimal ?
		local
			parser : MA_DECIMAL_TEXT_PARSER
		do
			create parser.make
			parser.parse (item)
			Result := not parser.error
		end

	convertible_as_character : BOOLEAN
		do
			Result := count > 0
		end

	convertible_as_boolean : BOOLEAN
			-- Is this value convertible to a boolean ?
		do
			Result := not is_null and then item.is_boolean
		end

	convertible_as_real : BOOLEAN
			-- Is this value convertible to a real ?
		do
			Result := not is_null and then item.is_real
		end

	convertible_as_date : BOOLEAN
			-- Is this value convertible to a date ?
		do
			Result := False
		end

	convertible_as_time : BOOLEAN
			-- Is this value convertible to a time ?
		do
			Result := False
		end

	convertible_as_timestamp : BOOLEAN
			-- Is this value convertible to a timestamp ?
		do
			Result := False
		end

feature -- Element change

	set_item (value : STRING)
			-- set item to 'value', truncating if necessary
		local
			actual_length, transfer_length : INTEGER
		do
			if value.count > capacity then
				actual_length := capacity
				transfer_length := capacity
			else
				actual_length := value.count + 1
				transfer_length := actual_length - 1
			end
			if value.count > 0 and transfer_length > 0 then
				ext_item.from_substring (value, 1 , transfer_length)
			else
				ext_item.from_string("")
			end
			ecli_c_value_set_length_indicator (buffer, transfer_length)
		end

feature -- Conversion

	out : STRING
		do
			if is_null then
				Result := out_null
			else
				Result := item
			end
		end

	as_string : STRING
			-- Conversion to STRING value
		local
			l_item : like item
		do
			l_item := item
			Result := l_item.substring (1, l_item.count)
		end

	as_character : CHARACTER
			-- Conversion to CHARACTER value
		do
			Result := item @ 1
		ensure then
			result_is_first_character: Result = item @ 1
		end

	as_integer : INTEGER
			-- Conversion to INTEGER value
		do
			Result := item.to_integer
		end

	as_integer_64 : INTEGER_64
			-- Conversion to INTEGER_64 value
		do
			Result := item.to_integer_64
		end

	as_double : DOUBLE
			--
		do
			Result := item.to_double
		end

	as_decimal : MA_DECIMAL
			-- Current converted to MA_DECIMAL.
		local
			ctx : MA_DECIMAL_CONTEXT
			s : STRING
		do
			s := as_string
			create ctx.make_double_extended
			ctx.set_digits (s.count)
			create Result.make_from_string_ctx (s, ctx)
		end

	as_boolean : BOOLEAN
			-- Current converted to BOOLEAN
		do
			Result := item.to_boolean
		end

	as_real : REAL
			-- Current converted to REAL
		do
			Result := item.to_real
		end

	as_date : DT_DATE
			-- Current converted to DATE
		do
			check False then
				create Result.make_from_day_count (0)
			end
		end

	as_time : DT_TIME
			-- Current converted to DT_TIME
		do
			check False then
				create Result.make_from_second_count (0)
			end
		end

	as_timestamp : DT_DATE_TIME
			-- Current converted to DT_DATE_TIME
		do
			check False then
				create Result.make_from_epoch (0)
			end
		end

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER)
			-- trace content into `a_tracer'
		do
			a_tracer.put_string (Current)
		end

	append_substring_to (i_start, i_end : INTEGER; string : STRING)
			-- append substring [i_start..i_end] to string
		require
			i_start_ok: i_start > 0 and i_start <= i_end
			i_end_ok: i_end > 0 and i_end <= count
			string_not_void: string /= Void --FIXME: VS-DEL
			not_null: not is_null
		do
			ext_item.append_substring_to (i_start, i_end, string)
		ensure
			string_set: string.substring (
				(old (string.count)) + 1,
				string.count).is_equal (item.substring (i_start, i_end))
		end

feature -- Constants

	default_maximum_capacity : INTEGER
			-- default maximum capacity
		deferred
		end

feature -- Inapplicable

feature {NONE} -- Implementation

	octet_size : INTEGER
			-- FIXME: 64 bits
		do
			Result := transfer_octet_length.as_integer_32
		end

	impl_item : STRING

	ext_item : XS_C_STRING

	maximum_capacity_impl : INTEGER

invariant

	ext_item_not_void: ext_item /= Void --FIXME: VS-DEL
	impl_item_not_void: impl_item /= Void --FIXME: VS-DEL

end
