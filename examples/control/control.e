class
	CONTROL

inherit
	KL_SHARED_FILE_SYSTEM
		redefine
			file_system
		end

create
	make

feature

	make
		local
			d : DT_TIME_DURATION
			api_tracing : BOOLEAN
			i : INTEGER
			one_second : DT_TIME_DURATION
			l_data_source, l_username, l_password: STRING
		do
			create session.make_default
			api_tracing := session.is_api_tracing
			io.put_string ("Data Source: ")
			io.read_line
			l_data_source := io.last_string.twin
			io.put_string ("User name  : ")
			io.read_line l_username := io.last_string.twin
			io.put_string ("Password   : ")
			io.read_line
			l_password := io.last_string.twin

			create login.make (l_data_source, l_username, l_password)
			d := session.login_timeout
			session.set_api_trace_filename ("control_api_trace.log", file_system)
			session.enable_api_tracing
			create one_second.make_canonical (1)
			session.set_login_timeout (one_second)
			api_tracing := session.is_api_tracing
			d := session.login_timeout
			session.set_login_strategy (login)
			i := session.network_packet_size
			session.connect
			d := session.login_timeout
			i := session.network_packet_size
			session.disable_api_tracing
			session.disconnect
			session.close
		end

	session : ECLI_SESSION
	login : ECLI_SIMPLE_LOGIN

feature -- Access

	file_system : attached KL_FILE_SYSTEM
		once
			check attached Precursor as l_result then
				Result := l_result
			end
		end

	ecli_api_constants : detachable  ECLI_API_CONSTANTS
	ecli_arrayed_buffer_factory : detachable  ECLI_ARRAYED_BUFFER_FACTORY
	ecli_arrayed_char : detachable  ECLI_ARRAYED_CHAR
	ecli_arrayed_date : detachable  ECLI_ARRAYED_DATE
	ecli_arrayed_date_time : detachable  ECLI_ARRAYED_DATE_TIME
	ecli_arrayed_double : detachable  ECLI_ARRAYED_DOUBLE
	ecli_arrayed_float : detachable  ECLI_ARRAYED_FLOAT
	ecli_arrayed_integer : detachable  ECLI_ARRAYED_INTEGER
	ecli_arrayed_longvarchar : detachable  ECLI_ARRAYED_LONGVARCHAR
	ecli_arrayed_real : detachable  ECLI_ARRAYED_REAL
	ecli_arrayed_time : detachable  ECLI_ARRAYED_TIME
	ecli_arrayed_timestamp : detachable  ECLI_ARRAYED_TIMESTAMP
	ecli_arrayed_value : detachable  ECLI_ARRAYED_VALUE
	ecli_arrayed_value_factory : detachable  ECLI_ARRAYED_VALUE_FACTORY
	ecli_arrayed_varchar : detachable  ECLI_ARRAYED_VARCHAR
	ecli_binary : detachable  ECLI_BINARY
	ecli_buffer_factory : detachable  ECLI_BUFFER_FACTORY
	ecli_char : detachable  ECLI_CHAR
	ecli_column : detachable  ECLI_COLUMN
	ecli_column_description : detachable  ECLI_COLUMN_DESCRIPTION
	ecli_columns_cursor : detachable  ECLI_COLUMNS_CURSOR
	ecli_connection_attribute_constants : detachable  ECLI_CONNECTION_ATTRIBUTE_CONSTANTS
	ecli_cursor : detachable  ECLI_CURSOR
	ecli_data_description : detachable  ECLI_DATA_DESCRIPTION
	ecli_data_source : detachable  ECLI_DATA_SOURCE
	ecli_data_sources_cursor : detachable  ECLI_DATA_SOURCES_CURSOR
	ecli_date : detachable  ECLI_DATE
	ecli_date_format : detachable  ECLI_DATE_FORMAT
	ecli_date_time : detachable  ECLI_DATE_TIME
	ecli_decimal : detachable  ECLI_DECIMAL
	ecli_driver_login : detachable  ECLI_DRIVER_LOGIN
	ecli_driver : detachable  ECLI_DRIVER
	ecli_drivers_cursor : detachable  ECLI_DRIVERS_CURSOR
	ecli_double : detachable  ECLI_DOUBLE
	ecli_environment : detachable  ECLI_ENVIRONMENT
	ecli_external_api : detachable  ECLI_EXTERNAL_API
	ecli_float : detachable  ECLI_FLOAT
	ecli_foreign_key : detachable  ECLI_FOREIGN_KEY
	ecli_foreign_key_constants : detachable  ECLI_FOREIGN_KEY_CONSTANTS
	ecli_foreign_keys_cursor : detachable  ECLI_FOREIGN_KEYS_CURSOR
	ecli_format_integer : detachable  ECLI_FORMAT_INTEGER
	ecli_functions_constants : detachable  ECLI_FUNCTIONS_CONSTANTS
	ecli_handle : detachable  ECLI_HANDLE
	ecli_input_output_parameter : detachable  ECLI_INPUT_OUTPUT_PARAMETER
	ecli_input_parameter : detachable  ECLI_INPUT_PARAMETER
	ecli_integer : detachable  ECLI_INTEGER
	ecli_iso_format_constants : detachable  ECLI_ISO_FORMAT_CONSTANTS
	ecli_length_indicator_constants : detachable  ECLI_LENGTH_INDICATOR_CONSTANTS
	ecli_longvarbinary : detachable  ECLI_LONGVARBINARY
	ecli_filevarbinary : detachable  ECLI_FILE_VARBINARY
	ecli_filevarchar : detachable  ECLI_FILE_VARCHAR
	ecli_filelongvarbinary: detachable  ECLI_FILE_LONGVARBINARY
	ecli_filelongvarchar : detachable  ECLI_FILE_LONGVARCHAR

	ecli_longvarchar : detachable  ECLI_LONGVARCHAR
	ecli_metadata_cursor : detachable  ECLI_METADATA_CURSOR
	ecli_named_metadata : detachable  ECLI_NAMED_METADATA
	ecli_nullability_constants : detachable  ECLI_NULLABILITY_CONSTANTS
	ecli_nullable_metadata : detachable  ECLI_NULLABLE_METADATA
	ecli_output_parameter : detachable  ECLI_OUTPUT_PARAMETER
	ecli_parameter_description : detachable  ECLI_PARAMETER_DESCRIPTION
	ecli_primary_key : detachable  ECLI_PRIMARY_KEY
	ecli_primary_key_cursor : detachable  ECLI_PRIMARY_KEY_CURSOR
	ecli_procedure_column : detachable  ECLI_PROCEDURE_COLUMN
	ecli_procedure_columns_cursor : detachable  ECLI_PROCEDURE_COLUMNS_CURSOR
	ecli_procedure_metadata : detachable  ECLI_PROCEDURE_METADATA
	ecli_procedure_type_metadata : detachable  ECLI_PROCEDURE_TYPE_METADATA
	ecli_procedure_type_metadata_constants : detachable  ECLI_PROCEDURE_TYPE_METADATA_CONSTANTS
	ecli_procedures_cursor : detachable  ECLI_PROCEDURES_CURSOR
	ecli_query : detachable  ECLI_QUERY
	ecli_real : detachable  ECLI_REAL
	ecli_row_cursor : detachable  ECLI_ROW_CURSOR
	ecli_row_status_constants : detachable  ECLI_ROW_STATUS_CONSTANTS
	ecli_rowset_capable : detachable  ECLI_ROWSET_CAPABLE
	ecli_rowset_cursor : detachable  ECLI_ROWSET_CURSOR
	ecli_rowset_modifier : detachable  ECLI_ROWSET_MODIFIER
	ecli_rowset_status : detachable  ECLI_ROWSET_STATUS
	ecli_session : detachable  ECLI_SESSION
	ecli_shared_environment : detachable  ECLI_SHARED_ENVIRONMENT
	ecli_sql_parser : detachable  ECLI_SQL_PARSER
	ecli_sql_parser_callback : detachable  ECLI_SQL_PARSER_CALLBACK
	ecli_sql_type : detachable  ECLI_SQL_TYPE
	ecli_sql_types_cursor : detachable  ECLI_SQL_TYPES_CURSOR
	ecli_statement : detachable  ECLI_STATEMENT
	ecli_statement_parameter : detachable  ECLI_STATEMENT_PARAMETER
	ecli_status : detachable  ECLI_STATUS
	ecli_status_constants : detachable  ECLI_STATUS_CONSTANTS
	ecli_stored_procedure : detachable  ECLI_STORED_PROCEDURE
	ecli_string_routines : detachable  ECLI_STRING_ROUTINES
	ecli_table : detachable  ECLI_TABLE
	ecli_tables_cursor : detachable  ECLI_TABLES_CURSOR
	ecli_time : detachable  ECLI_TIME
	ecli_time_format : detachable  ECLI_TIME_FORMAT
	ecli_timestamp : detachable  ECLI_TIMESTAMP
	ecli_timestamp_format : detachable  ECLI_TIMESTAMP_FORMAT
	ecli_traceable : detachable  ECLI_TRACEABLE
	ecli_tracer : detachable  ECLI_TRACER
	ecli_transaction_capability_constants : detachable  ECLI_TRANSACTION_CAPABILITY_CONSTANTS
	ecli_transaction_isolation : detachable  ECLI_TRANSACTION_ISOLATION
	ecli_transaction_isolation_constants : detachable  ECLI_TRANSACTION_ISOLATION_CONSTANTS
	ecli_type_constants : detachable  ECLI_TYPE_CONSTANTS
	ecli_type_catalog : detachable  ECLI_TYPE_CATALOG
	ecli_value : detachable  ECLI_VALUE
	ecli_value_factory : detachable  ECLI_VALUE_FACTORY
	ecli_varbinary : detachable  ECLI_VARBINARY
	ecli_varchar : detachable  ECLI_VARCHAR

end -- class CONTROL

