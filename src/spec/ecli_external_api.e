indexing

	description:

			"CLI C Interface."

	implementation_note: "[
			64 bit:
			
			All sizes/length are 64 bit; if current platform is 32 bit, a precondition tests the value.

			]"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_EXTERNAL_API

inherit

	ECLI_API_CONSTANTS

	KL_SHARED_PLATFORM

feature -- Status report

	platform_compatible_length (a_length : INTEGER_64) : BOOLEAN
		local
			max_bits : INTEGER_32
			max_val : INTEGER_64
			l_natural : NATURAL_64
		do
			max_bits := platform.pointer_bits
			if max_bits > 32 then
				max_val := platform.maximum_integer_64
			else
				max_val := platform.maximum_integer
			end
			Result := a_length <= max_val
		end

feature {NONE} -- Implementation

	ecli_c_allocate_environment (penv : POINTER) : INTEGER is
			-- allocate new environment handle
		external "C"
		end

	ecli_c_free_environment (env : POINTER) : INTEGER is
			-- free environment handle
		external "C"
		end

	ecli_c_allocate_connection (env : POINTER; pcon : POINTER) : INTEGER is
			-- allocate new connection handle
		external "C"
		end

	ecli_c_free_connection (con : POINTER) : INTEGER is
			-- free connection handle
		external "C"
		end

	ecli_c_allocate_statement (con : POINTER; pstmt : POINTER) : INTEGER is
			-- allocate statement handle
		external "C"
		end

	ecli_c_free_statement (stmt : POINTER) : INTEGER is
			-- free statement handle
		external "C"
		end

	ecli_c_set_integer_statement_attribute (StatementHandle : POINTER; an_attribute : INTEGER; ValuePtr : INTEGER)  : INTEGER is
		external "C"
		end

	ecli_c_set_pointer_statement_attribute (StatementHandle : POINTER; an_attribute : INTEGER; ValuePtr : POINTER; StringLength : INTEGER)  : INTEGER is
		external "C"
		end

	ecli_c_set_integer_connection_attribute (ConnectionHandle : POINTER; an_attribute : INTEGER; ValuePtr : INTEGER)  : INTEGER is
		external "C"
--SQLSetConnectAttr
--When the Attribute parameter has one of the following values, a 64-bit value is passed in Value:
--SQL_ATTR_QUIET_MODE
--SQLSetConnectAttr
--When the Option parameter has one of the following values, a 64-bit value is passed in *Value:
--SQL_MAX_LENGTH
--SQL_MAX_ROWS
--SQL_ROWSET_SIZE
--SQL_KEYSET_SIZE
		end

	ecli_c_get_integer_connection_attribute (ConnectionHandle : POINTER; an_attribute : INTEGER; ValuePtr : POINTER)  : INTEGER is
--SQLGetConnectAttr
--When the Attribute parameter has one of the following values, a 64-bit value is returned in Value:
--SQL_ATTR_QUIET_MODE

		external "C"
		end

	ecli_c_set_pointer_connection_attribute (ConnectionHandle : POINTER; an_attribute : INTEGER; ValuePtr : POINTER; StringLength : INTEGER)  : INTEGER is
		external "C"
		end

	ecli_c_get_pointer_connection_attribute (ConnectionHandle : POINTER; an_attribute : INTEGER; ValuePtr : POINTER; BufferLength : INTEGER; StringLengthPtr : POINTER)  : INTEGER is
		external "C"
		end


	ecli_c_connect (con : POINTER; data_source, user, password : POINTER) : INTEGER is
			-- connect 'con' on 'data_source' for 'user' with 'password'
		external "C"
		end

	ecli_c_driver_connect (ConnectionHandle : POINTER;
				WindowHandle : POINTER;
				InConnectionString : POINTER;
				StringLength1 : INTEGER;
				OutConnectionString : POINTER;
				BufferLength : INTEGER;
				StringLength2Ptr : POINTER;
				DriverCompletion : INTEGER) : INTEGER is
			-- connect directly to driver
		external "C"
		end

	ecli_c_disconnect (con : POINTER) : INTEGER is
			-- disconnect 'con'
		external "C"
		end

	ecli_c_set_manual_commit (con : POINTER; flag_manual : BOOLEAN) : INTEGER is
			-- set 'manual commit mode' to 'flag_manual'
		external "C"
		end

	ecli_c_is_manual_commit (con : POINTER; flag_manual : POINTER) : INTEGER is
			-- set 'flag_manual' to True if in manual commit mode
		external "C"
		end

	ecli_c_commit (con : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_rollback (con : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_row_count (stmt : POINTER; count : POINTER) : INTEGER is
			-- Note: 64 bit
		external "C inline use <sql.h>"
--SQLRowCount (SQLHSTMT StatementHandle, SQLLEN* RowCount);
		alias
			"[
				return (EIF_INTEGER) 
					(SQLRowCount (
						(SQLHSTMT) $stmt, 
						(SQLLEN*) $count)
					);
			]"
		end

	ecli_c_parameter_count (stmt : POINTER; count : POINTER) : INTEGER  is
		external "C"
		end

	ecli_c_result_column_count (stmt : POINTER; count : POINTER) : INTEGER  is
		external "C"
		end

	ecli_c_prepare (stmt : POINTER; sql : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_execute_direct (stmt : POINTER; sql : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_execute (stmt : POINTER) : INTEGER  is
		external "C"
		end

	ecli_c_more_results (stmt : POINTER) : INTEGER  is
		external "C"
		end

	ecli_c_bind_parameter (stmt : POINTER;
			index, direction, c_type, sql_type: INTEGER;
			sql_size : INTEGER_64;
			sql_decimal_digits : INTEGER;
			value : POINTER;
			buffer_length : INTEGER_64;
			ptr_value_length : POINTER) : INTEGER  is
		require
			buffer_length_platform_compatible: platform_compatible_length (buffer_length)
			sql_size_platform_compatible: platform_compatible_length (sql_size)
		external "C inline use <sql.h>"
--SQLBindParameter (
-- 	* SQLHSTMT hstmt,
--	* SQLUSMALLINT ipar,
--  * SQLSMALLINT fParamType,
--	*  SQLSMALLINT fCType,
--  * SQLSMALLINT fSqlType,
--	* SQLULEN cbColDef,
-- 	* SQLSMALLINT ibScale,
--  * SQLPOINTER rgbValue,
--	 SQLLEN cbValueMax,
--	 SQLLEN *pcbValue);
		alias "[
			return (EIF_INTEGER) SQLBindParameter(
									(SQLHSTMT) 		$stmt,
									(SQLUSMALLINT)	$index,
									(SQLSMALLINT)	$direction,
									(SQLSMALLINT)	$c_type,
									(SQLSMALLINT)	$sql_type,
									(SQLULEN)		$sql_size,
									(SQLSMALLINT)	$sql_decimal_digits,
									(SQLPOINTER)	$value,
									(SQLLEN)		$buffer_length,
									(SQLLEN *)		$ptr_value_length);
			]"
		end

	ecli_c_bind_result (stmt : POINTER; index, c_type : INTEGER; value : POINTER; buffer_length : INTEGER_64; len_indicator : POINTER) : INTEGER is
			-- note: 64bit
		require
			buffer_length_ok: platform_compatible_length (buffer_length)
		external "C inline use <ecli_c.h>"
--SQLBindCol (SQLHSTMT StatementHandle, SQLUSMALLINT ColumnNumber,
--   SQLSMALLINT TargetType, SQLPOINTER TargetValue, SQLLEN BufferLength,
--   SQLLEN * StrLen_or_Ind);
		alias "[
			return (EIF_INTEGER) (SQLBindCol(
					(SQLHSTMT)			$stmt,
					(SQLUSMALLINT)	    $index,
					(SQLSMALLINT)		$c_type,
					(SQLPOINTER)		$value,
					(SQLLEN)			$buffer_length,
					(SQLLEN*)		$len_indicator));
		]"
		end

	ecli_c_describe_parameter (stmt : POINTER; index : INTEGER; sql_type, sql_size, sql_decimal_digits, sql_nullability : POINTER) : INTEGER is
		external "C inline use <ecli_c.h>"
--SQLDescribeParam (
-- SQLHSTMT hstmt,
-- SQLUSMALLINT ipar,
-- SQLSMALLINT *pfSqlType,
-- SQLULEN *pcbParamDef,
-- SQLSMALLINT *pibScale,
-- SQLSMALLINT *pfNullable);
		alias "[
				SQLSMALLINT p_sql_type;
				SQLUINTEGER p_sql_size;
				SQLSMALLINT p_sql_decimal_digits;
				SQLSMALLINT p_sql_nullability;
				EIF_INTEGER res;
				res = (EIF_INTEGER) SQLDescribeParam (
											(SQLHSTMT) 		$stmt,
											(SQLUSMALLINT) 	$index,
											(SQLSMALLINT *)	&p_sql_type,
											(SQLULEN *)	&p_sql_size,
											(SQLSMALLINT *)	&p_sql_decimal_digits,
											(SQLSMALLINT *)	&p_sql_nullability);
				*((EIF_INTEGER*) $sql_type)= (EIF_INTEGER) p_sql_type;
				*((EIF_INTEGER_64*) $sql_size)= (EIF_INTEGER_64) p_sql_size;
				*((EIF_INTEGER*) $sql_decimal_digits)= (EIF_INTEGER) p_sql_decimal_digits;
				*((EIF_INTEGER*) $sql_nullability)= (EIF_INTEGER) p_sql_nullability;
				return res;
		]"
		end

	ecli_c_describe_column (stmt : POINTER; index : INTEGER; col_name : POINTER; max_name_length : INTEGER; actual_name_length : POINTER; sql_type, sql_size, sql_decimal_digits, sql_nullability : POINTER) : INTEGER is
		external "C"
--SQLDescribeCol (SQLHSTMT StatementHandle, SQLUSMALLINT ColumnNumber,
--   SQLCHAR *ColumnName, SQLSMALLINT BufferLength,
--   SQLSMALLINT *NameLength, SQLSMALLINT *DataType, SQLULEN *ColumnSize,
--   SQLSMALLINT *DecimalDigits, SQLSMALLINT *Nullable);

		end --FIXME 64 bits: verify for sql_size

	ecli_c_get_type_info (stmt : POINTER; data_type : INTEGER) : INTEGER is
		external "C"
		end

	ecli_c_get_tables ( StatementHandle : POINTER ;  CatalogName : POINTER ;  NameLength1 : INTEGER ; SchemaName : POINTER ;  NameLength2 : INTEGER ; TableName : POINTER ;  NameLength3 : INTEGER ; TableType : POINTER ;  NameLength4 : INTEGER) : INTEGER is
		external "C"
		end

	ecli_c_get_procedures ( StatementHandle : POINTER ;  CatalogName : POINTER ;  NameLength1 : INTEGER ; SchemaName : POINTER ;  NameLength2 : INTEGER ; ProcedureName : POINTER ;  NameLength3 : INTEGER) : INTEGER is
		external "C"
		end

	ecli_c_get_columns ( StatementHandle : POINTER ;  CatalogName : POINTER ;  NameLength1 : INTEGER ; SchemaName : POINTER ;  NameLength2 : INTEGER ; TableName : POINTER ;  NameLength3 : INTEGER ; ColumnName : POINTER ;  NameLength4 : INTEGER) : INTEGER is
		external "C"
		end

	ecli_c_get_procedure_columns ( StatementHandle : POINTER ;  CatalogName : POINTER ;  NameLength1 : INTEGER ; SchemaName : POINTER ;  NameLength2 : INTEGER ; ProcedureName : POINTER ;  NameLength3 : INTEGER ; ColumnName : POINTER ;  NameLength4 : INTEGER) : INTEGER is
		external "C"
		end

	ecli_c_get_primary_keys ( StatementHandle : POINTER ;  CatalogName : POINTER ;  NameLength1 : INTEGER ; SchemaName : POINTER ;  NameLength2 : INTEGER ; TableName : POINTER ;  NameLength3 : INTEGER) : INTEGER is
		external "C"
		end

	ecli_c_get_foreign_keys ( StatementHandle : POINTER ;
			CatalogName : POINTER ;  NameLength1 : INTEGER ; SchemaName : POINTER ;  NameLength2 : INTEGER ; TableName : POINTER ;  NameLength3 : INTEGER;
			FKCatalogName : POINTER ;  NameLength4 : INTEGER ; FKSchemaName : POINTER ;  NameLength5 : INTEGER ; FKTableName : POINTER ;  NameLength6 : INTEGER) : INTEGER is
		external "C"
		end

	ecli_c_get_datasources ( env : POINTER ;  operation : INTEGER ;  source_name : POINTER; source_name_length : INTEGER ; actual_source_name_length : POINTER ; description : POINTER ;  description_length : INTEGER; actual_description_length : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_get_data (stmt : POINTER; column_number, c_type : INTEGER; target_pointer : POINTER; buffer_length : INTEGER_64; len_indicator_pointer : POINTER) : INTEGER is
		require
			platform_compatible_buffer_length: platform_compatible_length (buffer_length)
		external "C"
--SQLGetData (SQLHSTMT StatementHandle, SQLUSMALLINT ColumnNumber,
--   SQLSMALLINT TargetType, SQLPOINTER TargetValue, SQLLEN BufferLength,
--   SQLLEN *StrLen_or_Ind);

		end

	ecli_c_param_data (stmt, value_ptr_ptr : POINTER)  : INTEGER is
		external "C"
		end

	ecli_c_put_data (stmt, data_ptr : POINTER; str_len_or_ind : INTEGER_64)  : INTEGER is
		external "C"
--SQLPutData (SQLHSTMT StatementHandle, SQLPOINTER Data,
--   SQLLEN StrLen_or_Ind);
		end

	ecli_c_len_data_at_exe (len : INTEGER_64) : INTEGER_64 is
		external "C"
		end

	ecli_c_fetch (stmt : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_close_cursor (stmt : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_environment_error (handle : POINTER; record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_session_error (handle : POINTER; record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_statement_error (handle : POINTER; record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_transaction_capable (handle : POINTER;  capable : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_sql_get_functions (handle : POINTER; function : INTEGER; supported : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_sql_get_info (handle : POINTER; info_type: INTEGER; info_value_ptr: POINTER; buffer_length : INTEGER; string_length_ptr: POINTER) : INTEGER is
		external "C"
--SQLGetInfo
--When the InfoType parameter has one of the following values, a 64-bit value is returned in *InfoValuePtr:
--SQL_DRIVER_HENV
--SQL_DRIVER_HDBC
--SQL_DRIVER_HLIB
--When InfoType has either of the following 2 values *InfoValuePtr is 64-bits on both input and ouput:
--SQL_DRIVER_HSTMT
--SQL_DRIVER_HDESC
		end

	ecli_c_sql_drivers (handle : POINTER;
			Direction : INTEGER;
			DriverDescription : POINTER;
			BufferLength1 : INTEGER;
			DescriptionLengthPtr : POINTER;
			DriverAttributes : POINTER;
			BufferLength2 : INTEGER
			AttributesLengthPtr : POINTER) : INTEGER is
     	external "C"
     	end


feature {NONE} -- Data Srouce Configuration

	ecli_c_sql_config_datasource (hwndParent : POINTER; fRequest : INTEGER; lpszDriver : POINTER; lpszAttributes : POINTER) : BOOLEAN is
		external "C"
		end

--ConnectionHandle	:	SQLHDBC;
--		   InfoType	:	INTEGER ; -- SQLUSMALLINT
--		 InfoValue	:	SQLPOINTER;
--		   BufferLength	:	INTEGER ; -- SQLSMALLINT
--		 StringLength	:	POINTER -- *POINTER -- *SQLSMALLINT			
feature {NONE} -- Value handling functions

	ecli_c_alloc_value (buffer_length : INTEGER_64) : POINTER is
-- 64 bit: length of elementary data cannot be larger than 2**32-1
		require
			platform_compatible_length (buffer_length)
		external "C"
		end

	ecli_c_free_value (pointer : POINTER) is
		external "C"
		end

	ecli_c_value_get_length (pointer : POINTER) : INTEGER_64 is
			-- Length of buffer
		external "C"
		end

	ecli_c_value_set_length_indicator (pointer : POINTER; length : INTEGER_64) is
-- 64 bit: length indicator = actual length of data.
		require
			platform_compatible_length (length)
		external "C inline use <ecli_c.h>"
		alias
			"[
				((struct ecli_c_value*) $pointer)->length_indicator = (SQLLEN) $length;
			]"
		end

	ecli_c_value_get_length_indicator (pointer : POINTER) : INTEGER_64 is
			-- Actual length of data
		external "C"
		end

	ecli_c_value_get_length_indicator_pointer (pointer : POINTER) : POINTER is
		external "C"
		end

	ecli_c_value_set_value (pointer, new_value : POINTER; actual_length : INTEGER) is
			-- FIXME: Do we only support 32 bit length for values ?
		external "C"
		end

	ecli_c_value_get_value (pointer : POINTER) : POINTER is
		external "C"
		end

	ecli_c_value_copy_value (pointer, dest : POINTER) is
			-- copy value referred to by 'pointer' into 'dest',
			-- assuming that value->length octets have to be transferred
		external "C"
		end

feature {NONE} -- Value handling functions for ARRAYED values

	ecli_c_alloc_array_value (c_buffer_length : INTEGER_64; a_count : INTEGER)  : POINTER is
		require
			platform_compatible_length (c_buffer_length)
		external "C"
		end

	ecli_c_free_array_value (ptr : POINTER) is
		external "C"
		end

	ecli_c_array_value_get_length (v : POINTER)  : INTEGER_64 is
			-- maximum length of elements
		external "C"
		end

	ecli_c_array_value_get_length_indicator_pointer (av : POINTER)  : POINTER is
			-- pointer to array of length indicators
		external "C"
		end

	ecli_c_array_value_get_value (av : POINTER)  : POINTER is
			-- pointer to array of values
		external "C"
		end

	ecli_c_array_value_set_length_indicator_at (v : POINTER; li : INTEGER_64; index : INTEGER) is
			-- set `index'th length indicator
		external "C"
		end

	ecli_c_array_value_get_length_indicator_at (v : POINTER; index : INTEGER)  : INTEGER_64 is
			-- get `index'th length indicator
		external "C"
		end

	ecli_c_array_value_get_length_indicator_pointer_at (v : POINTER; index : INTEGER)  : POINTER is
		external "C"
		end

	ecli_c_array_value_set_value_at (v : POINTER; new_array_value : POINTER; actual_length : INTEGER; index : INTEGER) is
			-- set `index'th value
		external "C"
		end

	ecli_c_array_value_get_value_at (v : POINTER; index : INTEGER)  : POINTER is
			-- get `index'th value	
		external "C"
		end

	ecli_c_array_value_copy_value_at (v : POINTER; dest : POINTER; index : INTEGER) is
			-- copy `index'th value	to `dest'
		external "C"
		end

feature {NONE} -- TIME, DATE, TIMESTAMP getter and setter functions

	ecli_c_date_get_year (dt : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_date_get_month (dt : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_date_get_day (dt : POINTER) : INTEGER is
		external "C"
		end

	 ecli_c_date_set_year (dt : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_date_set_month (dt : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_date_set_day (dt : POINTER; v : INTEGER) is
		external "C"
		end

	-- TIME getters and setters
	ecli_c_time_get_hour (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_time_get_minute (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_time_get_second (tm : POINTER) : INTEGER is
		external "C"
		end

	 ecli_c_time_set_hour (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_time_set_minute (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_time_set_second (tm : POINTER; v : INTEGER) is
		external "C"
		end

	-- TIMESTAMP time getters and setters
	ecli_c_timestamp_get_hour (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_timestamp_get_minute (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_timestamp_get_second (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_timestamp_get_fraction (tm : POINTER) : INTEGER is
		external "C"
		end

	 ecli_c_timestamp_set_hour (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_timestamp_set_minute (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_timestamp_set_second (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_timestamp_set_fraction (tm : POINTER; v : INTEGER) is
		external "C"
		end

end
