note

	description:

		"SQL Boolean"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"


class

	ECLI_BOOLEAN


inherit

	ECLI_GENERIC_VALUE [BOOLEAN]
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
			buffer := ecli_c_alloc_value (1)
			check_valid
			set_null
		ensure
			is_null: is_null
		end

feature -- Access

	item : BOOLEAN
		do
			Result := c_memory_get_int8 (ecli_c_value_get_value (buffer)) /= 0
		end

	c_type_code: INTEGER
		once
			Result := sql_c_bit
		end

	sql_type_code: INTEGER
		once
			Result := sql_bit
		end

feature -- Measurement

	size : INTEGER_64
		do
			Result := 1
		end

	decimal_digits: INTEGER
		do
			Result := 0
		end

	display_size: INTEGER
		do
			Result := 1
		end

	transfer_octet_length: INTEGER_64 = 1

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
			Result := True
		end

	convertible_as_boolean : BOOLEAN
			-- Is this value convertible to a boolean ?
		do
			Result := True
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

	set_item (value : BOOLEAN)
			-- set item to 'value', truncating if necessary
		do
			c_memory_put_int8 (ecli_c_value_get_value(buffer), value.to_integer)
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	as_integer : INTEGER
		do
			Result := item.to_integer
		end

	as_integer_64 : INTEGER_64
		do
			Result := item.to_integer
		end

	as_decimal : MA_DECIMAL
			-- Current converted to MA_DECIMAL.
		local
			ctx : MA_DECIMAL_CONTEXT
		do
			create ctx.make_double
			create Result.make_from_string_ctx (as_real.out, ctx)
		end

	as_real : REAL
		do
			Result := item.to_integer.to_real
		end

	as_double : DOUBLE
		do
			Result := item.to_integer.to_double
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
			Result := item
		end

	as_date : DT_DATE
			-- Current converted to DATE
		do
		end

	as_time : DT_TIME
			-- Current converted to DT_TIME
		do
		end

	as_timestamp : DT_DATE_TIME
			-- Current converted to DT_DATE_TIME
		do
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
			-- 2017-04-06: doesn't compile, don't understand why
			-- a_tracer.put_boolean (Current)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	octet_size : INTEGER = 1


end
