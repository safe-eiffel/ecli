indexing

	description: 

		"Objects that represent typed values to be exchanged with the database"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_VALUE

inherit

	ECLI_TRACEABLE
		undefine
			is_equal
		end

	ECLI_HANDLE
		rename
			handle as buffer
		export
			{NONE} release_handle
		undefine
			is_equal
		end

	ECLI_EXTERNAL_API
		undefine
			is_equal
		end

	ECLI_TYPE_CONSTANTS
		undefine
			is_equal
		end

	ECLI_DATA_DESCRIPTION
		export
			{ANY} all
		undefine
			is_equal
		end

	ECLI_LENGTH_INDICATOR_CONSTANTS
		export 
			{NONE} all
		undefine
			is_equal
		end
		
feature -- Status report

	is_null : BOOLEAN is
			-- Is this a NULL value (in RDBMS sense) ?
		do
			Result := ecli_c_value_get_length_indicator (buffer) = Sql_null_data
		end

	convertible_as_string : BOOLEAN is
			-- Is this value convertible to a string ?
		deferred
		end

	convertible_as_character : BOOLEAN is
			-- Is this value convertible to a character ?
		deferred
		end

	convertible_as_boolean : BOOLEAN is
			-- Is this value convertible to a boolean ?
		deferred
		end

	convertible_as_integer : BOOLEAN is
			-- Is this value convertible to an integer ?
		deferred
		end

	convertible_as_real : BOOLEAN is
			-- Is this value convertible to a real ?
		deferred
		end

	convertible_as_double : BOOLEAN is
			-- Is this value convertible to a double ?
		deferred
		end

	convertible_as_date : BOOLEAN is
			-- Is this value convertible to a date ?
		deferred
		end

	convertible_as_time : BOOLEAN is
			-- Is this value convertible to a time ?
		deferred
		end

	convertible_as_timestamp : BOOLEAN is
			-- Is this value convertible to a timestamp ?
		deferred
		end

	frozen convertible_to_character : BOOLEAN is
		obsolete "Use `convertible_as_character' instead"
		do
			Result := convertible_as_character
		end

	frozen convertible_to_boolean : BOOLEAN is
		obsolete "Use `convertible_as_boolean' instead"
		do
			Result := convertible_as_boolean
		end

	frozen convertible_to_integer : BOOLEAN is
		obsolete "Use `convertible_as_integer' instead"
		do
			Result := convertible_as_integer
		end

	frozen convertible_to_real : BOOLEAN is
		obsolete "Use `convertible_as_real' instead"
		do
			Result := convertible_as_real
		end

	frozen convertible_to_double : BOOLEAN is
		obsolete "Use `convertible_as_double' instead"
		do
			Result := convertible_as_double
		end

	frozen convertible_to_date : BOOLEAN is
		obsolete "Use `convertible_as_date' instead"
		do
			Result := convertible_as_date
		end

	frozen convertible_to_time : BOOLEAN is
		obsolete "Use `convertible_as_time' instead"
		do
			Result := convertible_as_time
		end

	frozen convertible_to_timestamp : BOOLEAN is
		obsolete "Use `convertible_as_timestamp' instead"
		do
			Result := convertible_as_timestamp		
		end

	can_trace : BOOLEAN is
		do
			Result := True
		ensure then
			ok: Result
		end
		
feature {ECLI_VALUE, ECLI_STATEMENT} -- Status Report

	c_type_code : INTEGER is
			-- (redefine in descendant classes)
		deferred
		end

	transfer_octet_length : INTEGER is
			-- Actual buffer capacity for underlying data transfer.
			-- (redefine in descendant classes)
		deferred
		end

	display_size : INTEGER is
			-- Display size.
			-- (redefine in descendant classes)
		deferred
		end

	length_indicator : INTEGER is
			-- Length indicator for database Xfer.
		do
			Result := ecli_c_value_get_length_indicator (buffer)
		end

feature -- Element change

	set_null is
			-- Set item to null.
		do
			ecli_c_value_set_length_indicator (buffer, Sql_null_data)
		ensure
			null_value: is_null 
		end

feature -- Transformation

feature -- Conversion

	as_string : STRING is
			-- Current converted to STRING.
		require
			convertible: convertible_as_string
			not_null: not is_null
		deferred
		ensure
			no_aliasing: True -- Result /= old Result
		end

	as_character : CHARACTER is
			-- Current converted to CHARACTER .
		require
			convertible: convertible_as_character
			not_null: not is_null
		deferred
		end

	as_boolean : BOOLEAN is
			-- Current converted to BOOLEAN.
		require
			convertible: convertible_as_boolean
			not_null: not is_null
		deferred
		end

	as_integer : INTEGER is
			-- Current converted to INTEGER.
		require
			convertible: convertible_as_integer
			not_null: not is_null
		deferred
		end

	as_real : REAL is
			-- Current converted to REAL.
		require
			convertible: convertible_as_real
			not_null: not is_null
		deferred
		end

	as_double : DOUBLE is
			-- Current converted to DOUBLE.
		require
			convertible: convertible_as_double
			not_null: not is_null
		deferred
		end

	as_date : DT_DATE is
			-- Current converted to DATE.
		require
			convertible: convertible_as_date
			not_null: not is_null
		deferred
		ensure
			no_aliasing: True -- Result /= old Result
		end

	as_time : DT_TIME is
			-- Current converted to DT_TIME.
		require
			convertible: convertible_as_time
			not_null: not is_null
		deferred
		ensure
			no_aliasing: True -- Result /= old Result
		end

	as_timestamp : DT_DATE_TIME is
			-- Current converted to DT_DATE_TIME.
		require
			convertible: convertible_as_timestamp
			not_null: not is_null
		deferred
		ensure
			no_aliasing: True -- Result /= old Result
		end

	frozen to_character : CHARACTER is 
		obsolete "Use `as_character' instead"
			-- Current converted to CHARACTER .
		require
			convertible: convertible_to_character
			not_null: not is_null
		do
			Result := as_character
		end

	frozen to_boolean : BOOLEAN is 
		obsolete "Use `as_boolean' instead"
			-- Current converted to BOOLEAN.
		require
			convertible: convertible_to_boolean
			not_null: not is_null
		do
			Result := as_boolean
		end

	frozen to_integer : INTEGER is 
		obsolete "Use `as_integer' instead"
			-- Current converted to INTEGER.
		require
			convertible: convertible_to_integer
			not_null: not is_null
		do
			Result := as_integer
		end

	frozen to_real : REAL is 
		obsolete "Use `as_real' instead"
			-- Current converted to REAL.
		require
			convertible: convertible_to_real
			not_null: not is_null
		do
			Result := as_real
		end

	frozen to_double : DOUBLE is 
		obsolete "Use `as_double' instead"
			-- Current converted to DOUBLE.
		require
			convertible: convertible_to_double
			not_null: not is_null
		do
			Result := as_double
		end

	frozen to_date : DT_DATE is 
		obsolete "Use `as_date' instead"
			-- Current converted to DATE.
		require
			convertible: convertible_to_date
			not_null: not is_null
		do
			Result := as_date
		ensure
			no_aliasing: True -- Result /= old Result
		end

	frozen to_time : DT_TIME is 
		obsolete "Use `as_time' instead"
			-- Current converted to DT_TIME.
		require
			convertible: convertible_to_time
			not_null: not is_null
		do
			Result := as_time
		ensure
			no_aliasing: True -- Result /= old Result
		end

	frozen to_timestamp : DT_DATE_TIME is 
		obsolete "Use `as_timestamp' instead"
			-- Current converted to DT_DATE_TIME.
		require
			convertible: convertible_to_timestamp
			not_null: not is_null
		do
			Result := as_timestamp
		ensure
			no_aliasing: True -- Result /= old Result
		end

feature {NONE} -- Implementation

	release_handle is
		do
			ecli_c_free_value (buffer)
			buffer := default_pointer
		end

	to_external : POINTER is
			-- External 'C' address of value.
		do
			Result := ecli_c_value_get_value (buffer)
		ensure
			not_null: Result /= default_pointer	
		end

	length_indicator_pointer : POINTER is
			-- External 'C' address of length indicator.
		do
			Result := ecli_c_value_get_length_indicator_pointer (buffer)
		end

feature {ECLI_STATEMENT, ECLI_STATEMENT_PARAMETER} -- Basic operations

	read_result (stmt : ECLI_STATEMENT; index : INTEGER) is
			-- Read value from current result column 'index' of 'stmt'.
		require
			stmt: stmt /= Void and then (stmt.is_executed and not stmt.off)
			positive_index: index > 0
		do
			stmt.set_status (ecli_c_get_data (
					stmt.handle,
					index,
					c_type_code,
					to_external,
					transfer_octet_length,
					length_indicator_pointer)
				)
		end

	bind_as_result  (stmt : ECLI_STATEMENT; index: INTEGER) is
			-- Bind Current as a result value.
		require
			stmt: stmt /= Void 
			positive_index: index > 0
		do
			stmt.set_status (ecli_c_bind_result (
					stmt.handle,
					index,
					c_type_code,
					to_external,
					transfer_octet_length,
					length_indicator_pointer)
				)
		end
		
	bind_as_parameter (stmt : ECLI_STATEMENT; index: INTEGER) is
			-- Bind this value as input parameter 'index' of 'stmt'.
		require
			stmt: stmt /= Void and then stmt.parameters_count > 0
			positive_index: index > 0
		do
			stmt.set_status (ecli_c_bind_parameter (stmt.handle,
				index,
				Parameter_directions.Sql_param_input,
				c_type_code,
				sql_type_code,
				size,
				decimal_digits,
				to_external,
				transfer_octet_length,
				length_indicator_pointer))
		end

	bind_as_input_output_parameter (stmt : ECLI_STATEMENT; index: INTEGER) is
			-- Bind this value as input/output parameter 'index' of 'stmt'.
		require
			stmt: stmt /= Void and then stmt.parameters_count > 0
			positive_index: index > 0
		do
			stmt.set_status (ecli_c_bind_parameter (stmt.handle,
				index,
				Parameter_directions.Sql_param_input_output,
				c_type_code,
				sql_type_code,
				size,
				decimal_digits,
				to_external,
				transfer_octet_length,
				length_indicator_pointer))
		end

	bind_as_output_parameter (stmt : ECLI_STATEMENT; index: INTEGER) is
			-- Bind this value as output parameter 'index' of 'stmt'.
		require
			stmt: stmt /= Void and then stmt.parameters_count > 0
			positive_index: index > 0
		do
			stmt.set_status (ecli_c_bind_parameter (stmt.handle,
				index,
				Parameter_directions.Sql_param_output,
				c_type_code,
				sql_type_code,
				size,
				decimal_digits,
				to_external,
				transfer_octet_length,
				length_indicator_pointer))
		end

	put_parameter (stmt : ECLI_STATEMENT; index : INTEGER) is
			-- Put parameter 'index' data at execution of 'stmt'.
			-- Redefine in descendant classes if needed.
		require
			stmt: stmt /= Void
			positive_index: index > 0
		do
		end

feature {NONE} -- Implementation values

	is_ready_for_disposal : BOOLEAN is True
	
	disposal_failure_reason : STRING is do	end
	
	parameter_directions : ECLI_PROCEDURE_TYPE_METADATA_CONSTANTS is
			-- Parameter direction constants.
		once
			create Result
		end

invariant
	is_valid: is_valid
	
end
