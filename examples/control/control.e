class
	CONTROL

creation
	make
	
feature

	make is
		local
			a, b : UNSIGNED_32
		do
			b := not a
			z := b.from_hex ("FFE9")
			print (b.out) print ("%N")
			print (z.out) print ("%N")
			t := b.from_integer (-1)
			t := t * a.from_integer (2)
			t := t or b
			t := t xor b
			
		end
		
	z, t : UNSIGNED_32

feature -- Gobo file system

	f : KI_FILE
	fi : KI_INPUT_FILE	
	si : KI_INPUT_STREAM[CHARACTER]
	d : KI_DIRECTORY
	tif : KI_TEXT_INPUT_FILE
	tis : KI_TEXT_INPUT_STREAM
	tof : KI_TEXT_OUTPUT_FILE
	tos : KI_TEXT_OUTPUT_STREAM
	ip : KI_PATHNAME
	p : KL_PATHNAME
	fs : KL_SHARED_FILE_SYSTEM
	sis : KL_STRING_INPUT_STREAM
	sos : KL_STRING_OUTPUT_STREAM
	nt : KL_NULL_TEXT_OUTPUT_STREAM
	mac : KL_MACOS_INPUT_FILE
	maco : KL_MACOS_OUTPUT_FILE
	proxi : KL_PROXY_CHARACTER_INPUT_STREAM
	proxo : KL_PROXY_CHARACTER_OUTPUT_STREAM
	sst : KL_SHARED_STREAMS
	
feature

	ecli_api_constants : ECLI_API_CONSTANTS
	ecli_arrayed_buffer_factory : ECLI_ARRAYED_BUFFER_FACTORY
	ecli_arrayed_char : ECLI_ARRAYED_CHAR
	ecli_arrayed_date : ECLI_ARRAYED_DATE
	ecli_arrayed_date_time : ECLI_ARRAYED_DATE_TIME
	ecli_arrayed_double : ECLI_ARRAYED_DOUBLE
	ecli_arrayed_float : ECLI_ARRAYED_FLOAT
	ecli_arrayed_integer : ECLI_ARRAYED_INTEGER
	ecli_arrayed_longvarchar : ECLI_ARRAYED_LONGVARCHAR
	ecli_arrayed_real : ECLI_ARRAYED_REAL
	ecli_arrayed_time : ECLI_ARRAYED_TIME
	ecli_arrayed_timestamp : ECLI_ARRAYED_TIMESTAMP
	ecli_arrayed_value : ECLI_ARRAYED_VALUE
	ecli_arrayed_value_factory : ECLI_ARRAYED_VALUE_FACTORY
	ecli_arrayed_varchar : ECLI_ARRAYED_VARCHAR
	ecli_binary : ECLI_BINARY
	ecli_buffer_factory : ECLI_BUFFER_FACTORY
	ecli_char : ECLI_CHAR
	ecli_column : ECLI_COLUMN
	ecli_column_description : ECLI_COLUMN_DESCRIPTION
	ecli_columns_cursor : ECLI_COLUMNS_CURSOR
	ecli_connection_attribute_constants : ECLI_CONNECTION_ATTRIBUTE_CONSTANTS
	ecli_cursor : ECLI_CURSOR
	ecli_data_description : ECLI_DATA_DESCRIPTION
	ecli_data_source : ECLI_DATA_SOURCE
	ecli_data_sources_cursor : ECLI_DATA_SOURCES_CURSOR
	ecli_date : ECLI_DATE
	ecli_date_format : ECLI_DATE_FORMAT
	ecli_date_time : ECLI_DATE_TIME
	ecli_decimal : ECLI_DECIMAL
	ecli_driver_login : ECLI_DRIVER_LOGIN
	ecli_driver : ECLI_DRIVER
	ecli_drivers_cursor : ECLI_DRIVERS_CURSOR
	ecli_double : ECLI_DOUBLE
	ecli_environment : ECLI_ENVIRONMENT
	ecli_external_api : ECLI_EXTERNAL_API
	ecli_float : ECLI_FLOAT
	ecli_foreign_key : ECLI_FOREIGN_KEY
	ecli_foreign_key_constants : ECLI_FOREIGN_KEY_CONSTANTS
	ecli_foreign_keys_cursor : ECLI_FOREIGN_KEYS_CURSOR
	ecli_format_integer : ECLI_FORMAT_INTEGER
	ecli_functions_constants : ECLI_FUNCTIONS_CONSTANTS
	ecli_handle : ECLI_HANDLE
	ecli_input_output_parameter : ECLI_INPUT_OUTPUT_PARAMETER
	ecli_input_parameter : ECLI_INPUT_PARAMETER
	ecli_integer : ECLI_INTEGER
	ecli_iso_format_constants : ECLI_ISO_FORMAT_CONSTANTS
	ecli_length_indicator_constants : ECLI_LENGTH_INDICATOR_CONSTANTS
	ecli_longvarbinary : ECLI_LONGVARBINARY
	ecli_filevarbinary : ECLI_FILE_VARBINARY
	ecli_filevarchar : ECLI_FILE_VARCHAR
	ecli_filelongvarbinary: ECLI_FILE_LONGVARBINARY
	ecli_filelongvarchar : ECLI_FILE_LONGVARCHAR
	
	ecli_longvarchar : ECLI_LONGVARCHAR
	ecli_metadata_cursor : ECLI_METADATA_CURSOR
	ecli_named_metadata : ECLI_NAMED_METADATA
	ecli_nullability_constants : ECLI_NULLABILITY_CONSTANTS
	ecli_nullable_metadata : ECLI_NULLABLE_METADATA
	ecli_output_parameter : ECLI_OUTPUT_PARAMETER
	ecli_parameter_description : ECLI_PARAMETER_DESCRIPTION
	ecli_primary_key : ECLI_PRIMARY_KEY
	ecli_primary_key_cursor : ECLI_PRIMARY_KEY_CURSOR
	ecli_procedure_column : ECLI_PROCEDURE_COLUMN
	ecli_procedure_columns_cursor : ECLI_PROCEDURE_COLUMNS_CURSOR
	ecli_procedure_metadata : ECLI_PROCEDURE_METADATA
	ecli_procedure_type_metadata : ECLI_PROCEDURE_TYPE_METADATA
	ecli_procedure_type_metadata_constants : ECLI_PROCEDURE_TYPE_METADATA_CONSTANTS
	ecli_procedures_cursor : ECLI_PROCEDURES_CURSOR
	ecli_query : ECLI_QUERY
	ecli_real : ECLI_REAL
	ecli_row_cursor : ECLI_ROW_CURSOR
	ecli_row_status_constants : ECLI_ROW_STATUS_CONSTANTS
	ecli_rowset_capable : ECLI_ROWSET_CAPABLE
	ecli_rowset_cursor : ECLI_ROWSET_CURSOR
	ecli_rowset_modifier : ECLI_ROWSET_MODIFIER
	ecli_rowset_status : ECLI_ROWSET_STATUS
	ecli_session : ECLI_SESSION
	ecli_shared_environment : ECLI_SHARED_ENVIRONMENT
	ecli_sql_parser : ECLI_SQL_PARSER
	ecli_sql_parser_callback : ECLI_SQL_PARSER_CALLBACK
	ecli_sql_type : ECLI_SQL_TYPE
	ecli_sql_types_cursor : ECLI_SQL_TYPES_CURSOR
	ecli_statement : ECLI_STATEMENT
	ecli_statement_parameter : ECLI_STATEMENT_PARAMETER
	ecli_status : ECLI_STATUS
	ecli_status_constants : ECLI_STATUS_CONSTANTS
	ecli_stored_procedure : ECLI_STORED_PROCEDURE
	ecli_string_routines : ECLI_STRING_ROUTINES
	ecli_table : ECLI_TABLE
	ecli_tables_cursor : ECLI_TABLES_CURSOR
	ecli_time : ECLI_TIME
	ecli_time_format : ECLI_TIME_FORMAT
	ecli_timestamp : ECLI_TIMESTAMP
	ecli_timestamp_format : ECLI_TIMESTAMP_FORMAT
	ecli_traceable : ECLI_TRACEABLE
	ecli_tracer : ECLI_TRACER
	ecli_transaction_capability_constants : ECLI_TRANSACTION_CAPABILITY_CONSTANTS
	ecli_transaction_isolation : ECLI_TRANSACTION_ISOLATION
	ecli_transaction_isolation_constants : ECLI_TRANSACTION_ISOLATION_CONSTANTS
	ecli_type_constants : ECLI_TYPE_CONSTANTS
	ecli_type_catalog : ECLI_TYPE_CATALOG
	ecli_value : ECLI_VALUE
	ecli_value_factory : ECLI_VALUE_FACTORY
	ecli_varbinary : ECLI_VARBINARY
	ecli_varchar : ECLI_VARCHAR

end -- class CONTROL

