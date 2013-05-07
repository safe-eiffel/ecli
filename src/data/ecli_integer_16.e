note
	description:

		"SQL SMALLINT values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_INTEGER_16

inherit

	ECLI_GENERIC_VALUE [INTEGER_16]
		redefine
			item,
			out
		end

	XS_C_MEMORY_ROUTINES
		undefine
			copy,out, is_equal
		end

create

	make

feature -- Initialization

	make
		do
			buffer := ecli_c_alloc_value (octet_size)
			check_valid
			set_null
		ensure
			is_null: is_null
		end

feature -- Access

	item : INTEGER_16
		do
			Result := c_memory_get_int16 (ecli_c_value_get_value (buffer)).to_integer_16
		end

	c_type_code: INTEGER
		once
			Result := sql_c_long
		end

	sql_type_code: INTEGER
		once
			Result := sql_smallint
		end

feature -- Measurement

	size : INTEGER_64
		do
			Result := 5
		end

	decimal_digits: INTEGER
		do
			Result := 0
		end

	display_size: INTEGER
		do
			Result := 6
		end

	transfer_octet_length: INTEGER_64
		do
			Result := 2
		ensure then
			integer_16: Result = 2
		end

feature -- Status report

	convertible_as_integer : BOOLEAN
		do
			Result := True
		end

	convertible_as_integer_64 : BOOLEAN
		do
			Result := True
		end

	convertible_as_double : BOOLEAN
		do
			Result := True
		end

	convertible_as_decimal : BOOLEAN
		do
			Result := True
		end

	convertible_as_real : BOOLEAN
		do
			Result := True
		end

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

feature -- Cursor movement

feature -- Element change

	set_item (value : INTEGER_16)
			-- set item to 'value', truncating if necessary
		do
			--impl_item := value
			--ecli_c_value_set_value (buffer, $impl_item, transfer_octet_length)
			c_memory_put_int16 (ecli_c_value_get_value(buffer), value)
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	as_integer : INTEGER
		do
			Result := item
		end

	as_integer_64 : INTEGER_64
		do
			Result := item.to_integer_64
		end

	as_decimal : MA_DECIMAL
			-- Current converted to MA_DECIMAL.
		local
			ctx : MA_DECIMAL_CONTEXT
		do
			create ctx.make_double
			create Result.make_from_string_ctx (item.out, ctx)
		end

	as_real : REAL
		do
			Result := item
		end

	as_double : DOUBLE
		do
			Result := item
		end

	as_string : STRING
			-- Current converted to STRING
		do
			Result := item.out
		end

	as_character : CHARACTER
			-- Current converted to CHARACTER
		do
		end

	as_boolean : BOOLEAN
			-- Current converted to BOOLEAN
		do
		end

	as_date : DT_DATE
			-- Current converted to DATE
		do
			create Result.make_from_day_count (0)
		end

	as_time : DT_TIME
			-- Current converted to DT_TIME
		do
			create Result.make_from_second_count (0)
		end

	as_timestamp : DT_DATE_TIME
			-- Current converted to DT_DATE_TIME
		do
			create Result.make_from_epoch (0)
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	out : STRING
		do
			if is_null then
				Result := out_null
			else
				Result := item.out
			end
		end

	trace (a_tracer : ECLI_TRACER)
		do
			a_tracer.put_integer_16 (Current)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	octet_size : INTEGER
		do
			Result := 2
		ensure
			result_is_2: Result = 2
		end

end
