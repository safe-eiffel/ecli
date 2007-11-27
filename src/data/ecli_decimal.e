indexing

	description:

		"SQL DECIMAL (precision, decimal_digits) values."

	please_note: "[
		 Data transfers are made through string representations.
		 Some databases like Oracle are sensible to National Language Support settings.
		 Please configure the ODBC driver so that it uses US settings because ECLI is not
		 capable of determining the National Language Support that is used.
		 ]"

	library: "GOBO Eiffel Decimal Arithmetic Library"
	copyright: "Copyright (c) 2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DECIMAL

inherit

	ECLI_GENERIC_VALUE [MA_DECIMAL]
		redefine
			item, out,
			impl_item,
			bind_as_parameter,
			formatted,
			valid_item
		end

	MA_DECIMAL_CONTEXT_CONSTANTS
		undefine
			is_equal, copy, out
		end

create

	make

feature {NONE} -- Initialization

	make (new_precision, new_decimal_digits : INTEGER) is
			-- Create with `new_precision' and `new_decimal_digits'.
		require
			valid_new_precision: new_precision > 0
			valid_new_decimal_digits: new_decimal_digits >=0 and new_decimal_digits <= new_precision
		do
			make_with_rounding (new_precision, new_decimal_digits, Default_rounding_mode)
		ensure
			is_null: is_null
			precision_set: precision = new_precision
			decimal_digits_set: decimal_digits = new_decimal_digits
			rounding_context_set: rounding_context /= Void and then rounding_context.digits = new_precision
			default_round_mode: rounding_context.rounding_mode = Default_rounding_mode
		end

	make_with_rounding (new_precision, new_decimal_digits, new_rounding_mode : INTEGER) is
			-- Create with `new_precision' and `new_decimal_digits' and `new_rounding_mode'.
		require
			valid_new_precision: new_precision > 0
			valid_new_decimal_digits: new_decimal_digits >=0 and new_decimal_digits <= new_precision
			valid_rounding_mode: new_rounding_mode >= Round_up and then new_rounding_mode <= Round_unnecessary
		do
			precision := new_precision
			decimal_digits := new_decimal_digits
			create rounding_context.make (precision, new_rounding_mode)
			buffer := ecli_c_alloc_value (new_precision + 3)
			set_null
			create ext_item.make_shared_from_pointer (ecli_c_value_get_value (buffer), transfer_octet_length)
		ensure
			is_null: is_null
			precision_set: precision = new_precision
			decimal_digits_set: decimal_digits = new_decimal_digits
			rounding_context_set: rounding_context /= Void and then rounding_context.digits = new_precision
			round_mode_set: rounding_context.rounding_mode = new_rounding_mode
		end

feature -- Access

	rounding_context : MA_DECIMAL_CONTEXT
			-- Context used for rounding to (precision, decimal_digits).

	item : MA_DECIMAL is
			-- Current value.
		do
			if is_null then
				Result := Void
			else
				create Result.make_from_string_ctx (ext_item.as_string, rounding_context)
			end
		end


feature -- Measurement

	precision : INTEGER
			-- Number of significant digits.

	decimal_digits : INTEGER
			-- Number of digits after the decimal point.

	display_size: INTEGER is
		do
			Result := precision + 2
		end

	size: INTEGER is
			-- Size as synonym of precision.
		do
			Result := precision
		ensure then
			synonym_of_precision: Result = precision
		end

feature -- Status report

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
			-- Is this value convertible to a decimal ?
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

	convertible_as_string : BOOLEAN is
			-- Is this value convertible to a string ?
		do
			Result := True
		end

	convertible_as_integer : BOOLEAN is
			-- Is this value convertible to an integer ?
		do
			Result := not is_null
		end

	convertible_as_double : BOOLEAN is
			-- Is this value convertible to a double ?
		do
			Result := not is_null
		end


	convertible_as_real : BOOLEAN is
			-- Is this value convertible to a real ?
		do
			Result := not is_null
		end

	valid_item (value : MA_DECIMAL) : BOOLEAN is
			-- Is `value' valid as item.
		do
			Result := Precursor (value)
			Result := Result and then value.count + value.exponent <= precision
			Result := Result and then (value.exponent <= 0 implies - (value.exponent) <= decimal_digits)
			Result := Result and then not value.is_special
		ensure then
			value_precision_compatible: Result implies (value.count + value.exponent <= precision)
			decimal_digits_compatible: Result implies (value.exponent <= 0 implies -(value.exponent) <= decimal_digits)
			no_specials_allowed: Result implies not value.is_special
		end

feature {ECLI_VALUE, ECLI_STATEMENT} -- Status report

	c_type_code: INTEGER is
			-- Type code of the underlying memory representation.
		once
			Result := sql_c_char
		end

	sql_type_code: INTEGER is
			-- Type code of the SQL data.
		once
			Result := Sql_decimal
		end

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_value_get_length (buffer)
		end

feature -- Element change

	set_item (value : MA_DECIMAL) is
		local
			l : MA_DECIMAL
			s : STRING
		do
			l := value.rescale (-decimal_digits, rounding_context)
			s := l.to_scientific_string
			if s.count <= transfer_octet_length then
				ext_item.from_string (s)
			end
			ecli_c_value_set_length_indicator (buffer, s.count)
		end

feature -- Conversion

	as_string : STRING is
			-- Conversion to STRING value
		do
			Result := item.to_scientific_string
		end

	as_integer : INTEGER is
		do
			Result := item.to_integer
		end

	as_double : DOUBLE is
		do
			Result := item.to_double
		end

	as_real : REAL is
		do
			Result := as_string.to_real
		end

	out : STRING is
		do
			if is_null then
				Result := "NULL"
			else
				Result := item.to_scientific_string
			end
		end

	as_decimal : MA_DECIMAL is
		do
			Result := item
		end

	as_character : CHARACTER is
			-- Current converted to CHARACTER
		do
			do_nothing
		end

	as_boolean : BOOLEAN is
			-- Current converted to BOOLEAN
		do
			do_nothing
		end

	as_date : DT_DATE is
			-- Current converted to DATE
		do
			do_nothing
		end

	as_time : DT_TIME is
			-- Current converted to DT_TIME
		do
			do_nothing
		end

	as_timestamp : DT_DATE_TIME is
			-- Current converted to DT_DATE_TIME
		do
			do_nothing
		end

	formatted (v : MA_DECIMAL) : MA_DECIMAL is
		do
			Result := v.rescale (- decimal_digits, rounding_context)
		ensure then
			definition: Result.is_equal (v.rescale (- decimal_digits, rounding_context))
		end

feature {ECLI_TRACER} -- Basic operations

	trace (a_tracer : ECLI_TRACER) is
			-- Trace content into `a_tracer'.
		do
			a_tracer.put_decimal (Current)
		end

feature {ECLI_STATEMENT, ECLI_STATEMENT_PARAMETER} -- Basic operations

	bind_as_parameter (stmt : ECLI_STATEMENT; index: INTEGER) is
			-- Bind this value as input parameter 'index' of 'stmt'.
		do
			stmt.set_status (ecli_c_bind_parameter (stmt.handle,
				index,
				Parameter_directions.Sql_param_input,
				c_type_code,
				sql_type_code,
				size,
				decimal_digits,
				to_external,
				length_indicator,
				length_indicator_pointer))
		end

feature {NONE} -- Implementation

	impl_item : MA_DECIMAL

	ext_item : XS_C_STRING

invariant

	rounding_context_not_void: rounding_context /= Void

end
