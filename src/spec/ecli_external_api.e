indexing

	description:
	
			"CLI C Interface"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_EXTERNAL_API

inherit

	ECLI_API_CONSTANTS
	
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

	ecli_c_set_integer_statement_attribute (StatementHandle : POINTER; Attribute : INTEGER; ValuePtr : INTEGER)  : INTEGER is
		external "C"
		end

	ecli_c_set_pointer_statement_attribute (StatementHandle : POINTER; Attribute : INTEGER; ValuePtr : POINTER; StringLength : INTEGER)  : INTEGER is
		external "C"
		end

	ecli_c_set_integer_connection_attribute (ConnectionHandle : POINTER; Attribute : INTEGER; ValuePtr : INTEGER)  : INTEGER is
		external "C"
		end

	ecli_c_set_pointer_connection_attribute (ConnectionHandle : POINTER; Attribute : INTEGER; ValuePtr : POINTER; StringLength : INTEGER)  : INTEGER is
		external "C"
		end

	ecli_c_get_integer_connection_attribute (ConnectionHandle : POINTER; Attribute : INTEGER; ValuePtr : POINTER)  : INTEGER is
		external "C"
		end

	ecli_c_connect (con : POINTER; data_source, user, password : POINTER) : INTEGER is
			-- connect 'con' on 'data_source' for 'user' with 'password'
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
		external "C" 
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
	
	ecli_c_bind_parameter (stmt : POINTER;
			index, direction, c_type, sql_type, sql_size, sql_decimal_digits : INTEGER;
			value : POINTER; buffer_length : INTEGER; ptr_value_length : POINTER) : INTEGER  is
		external "C"
		end
	
	ecli_c_bind_result (stmt : POINTER; index, c_type : INTEGER; value : POINTER; buffer_length : INTEGER; len_indicator : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_describe_parameter (stmt : POINTER; index : INTEGER; sql_type, sql_size, sql_decimal_digits, sql_nullability : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_describe_column (stmt : POINTER; index : INTEGER; col_name : POINTER; max_name_length : INTEGER; actual_name_length : POINTER; sql_type, sql_size, sql_decimal_digits, sql_nullability : POINTER) : INTEGER is
		external "C"
		end

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

	ecli_c_get_data (stmt : POINTER; column_number, c_type : INTEGER; target_pointer : POINTER; buffer_length : INTEGER; len_indicator_pointer : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_param_data (stmt, value_ptr_ptr : POINTER)  : INTEGER is
		external "C"
		end

	ecli_c_put_data (stmt, data_ptr : POINTER; str_len_or_ind : INTEGER)  : INTEGER is
		external "C"
		end

	ecli_c_len_data_at_exe (len : INTEGER) : INTEGER is
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

--ConnectionHandle	:	SQLHDBC;
--		   InfoType	:	INTEGER ; -- SQLUSMALLINT
--		 InfoValue	:	SQLPOINTER;
--		   BufferLength	:	INTEGER ; -- SQLSMALLINT
--		 StringLength	:	POINTER -- *POINTER -- *SQLSMALLINT			
feature {NONE} -- Value handling functions

	ecli_c_alloc_value (buffer_length : INTEGER) : POINTER is
		external "C"
		end

	ecli_c_free_value (pointer : POINTER) is
		external "C"
		end

	ecli_c_value_set_length_indicator (pointer : POINTER; length : INTEGER) is
		external "C"
		end

	ecli_c_value_get_length (pointer : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_value_get_length_indicator (pointer : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_value_get_length_indicator_pointer (pointer : POINTER) : POINTER is
		external "C"
		end

	ecli_c_value_set_value (pointer, new_value : POINTER; actual_length : INTEGER) is
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

	ecli_c_alloc_array_value (c_buffer_length : INTEGER; a_count : INTEGER)  : POINTER is
		external "C"
		end

	ecli_c_free_array_value (ptr : POINTER) is
		external "C"
		end

	ecli_c_array_value_get_length (v : POINTER)  : INTEGER is
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

	ecli_c_array_value_set_length_indicator_at (v : POINTER; li : INTEGER; index : INTEGER) is
			-- set `index'th length indicator
		external "C"
		end

	ecli_c_array_value_get_length_indicator_at (v : POINTER; index : INTEGER)  : INTEGER is
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
