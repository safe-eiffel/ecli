indexing

	description:

		"SQL REAL values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_REAL

inherit

	ECLI_GENERIC_VALUE [REAL]
		redefine
			item, out
		end

	XS_C_MEMORY_ROUTINES
		undefine
			copy,out, is_equal
		end

create

	make

feature -- Initialization

	make is
		do
			buffer := ecli_c_alloc_value (transfer_octet_length)
			check_valid
			set_null
		ensure
			is_null: is_null
		end

feature -- Access

	item : REAL is
		do
				Result := c_memory_get_real (ecli_c_value_get_value (buffer))
		end

	c_type_code: INTEGER is
		once
			Result := sql_c_float --  !!!
		end

	sql_type_code: INTEGER is
		once
			Result := sql_real
		end

feature -- Measurement

	size : INTEGER_64 is
		do
			Result := 7
		end

	decimal_digits: INTEGER is
		do
			Result := 0
		end

	display_size: INTEGER is
		do
			Result := 13
		end

	transfer_octet_length: INTEGER is
		do
			Result := 4
		end

feature -- Status report

	convertible_as_real : BOOLEAN is
		do
			Result := True
		end

	convertible_as_double : BOOLEAN is
		do
			Result := True
		end

	convertible_as_integer : BOOLEAN is
		do
			Result := True
		end

	convertible_as_integer_64 : BOOLEAN is
		do
			Result := True
		end

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

	convertible_as_decimal : BOOLEAN is
			-- Is this value convertible to a MA_DECIMAL?
		do
			Result := True
		end

	convertible_as_date : BOOLEAN is
			-- Is this value convertible to a date ?
		do
			Result := False
		end

	convertible_as_time : BOOLEAN is
			-- Is this value convertible to a time ?
		do
			Result := False
		end

	convertible_as_timestamp : BOOLEAN is
			-- Is this value convertible to a timestamp ?
		do
			Result := False
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_item (value : REAL) is
			-- set item to 'value', truncating if necessary
		do
			c_memory_put_real (ecli_c_value_get_value (buffer), value)
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	as_real : REAL is
		do
			Result := item
		end

	as_double : DOUBLE is
		do
			Result := item
		end

	as_decimal : MA_DECIMAL is
			-- Current converted to MA_DECIMAL.
		local
			ctx : MA_DECIMAL_CONTEXT
		do
			create ctx.make_default
			create Result.make_from_string_ctx (as_real.out, ctx)
		end

	as_integer : INTEGER is
		do
			Result := item.truncated_to_integer
		end

	as_integer_64 : INTEGER_64 is
		do
			Result := item.truncated_to_integer_64
		end

	as_string : STRING is
			-- Current converted to STRING
		do
			Result := item.out
		end

	as_character : CHARACTER is
			-- Current converted to CHARACTER
		do
		end

	as_boolean : BOOLEAN is
			-- Current converted to BOOLEAN
		do
		end

	as_date : DT_DATE is
			-- Current converted to DATE
		do
		end

	as_time : DT_TIME is
			-- Current converted to DT_TIME
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
			a_tracer.put_real (Current)
		end

	out : STRING is
		local
			message_buffer : XS_C_STRING
		do
			if is_null then
				Result := out_null
			else
				create message_buffer.make (50)
				sprintf_real (message_buffer.handle, item.item)
				Result := message_buffer.as_string
			end
		end

feature {NONE} -- Implementation

	octet_size : INTEGER is
		do
			Result := 4
		ensure
			result_is_4: Result = 4
		end

	sprintf_real (s : POINTER; r : REAL) is
			--
		external "C"
		alias "ecli_c_sprintf_real"
		end

end
