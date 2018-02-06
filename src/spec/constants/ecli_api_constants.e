note

	description:

			"CLI/ODBC API constants."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_API_CONSTANTS

feature {NONE} -- statement attributes

	Sql_attr_async_enable: INTEGER is 4
	Sql_attr_row_bind_type : INTEGER = 5
	Sql_attr_row_bind_offset_ptr: INTEGER = 23
	Sql_attr_row_operation_ptr: INTEGER = 24
	Sql_attr_row_status_ptr: INTEGER = 25
	Sql_attr_rows_fetched_ptr: INTEGER = 26
	Sql_attr_row_array_size: INTEGER = 27
	Sql_attr_metadata_id: INTEGER = 10014

	Sql_attr_param_bind_type 	: INTEGER = 18
	Sql_attr_paramset_size	: INTEGER = 22
	Sql_attr_param_status_ptr	: INTEGER = 20
	Sql_attr_params_processed_ptr	: INTEGER = 21


feature {NONE} -- row status

	Sql_row_success: INTEGER = 0
	Sql_row_deleted: INTEGER = 1
	Sql_row_updated: INTEGER = 2
	Sql_row_norow: INTEGER = 3
	Sql_row_added: INTEGER = 4
	Sql_row_error: INTEGER = 5
	Sql_row_success_with_info: INTEGER = 6

feature {NONE} -- Binding modes

	Sql_bind_by_column : INTEGER = 0
	Sql_parameter_bind_by_column : INTEGER = 0

feature {NONE} -- Asynchronous execution modes

	Sql_async_enable_off: INTEGER is 0
	Sql_async_enable_on: INTEGER is 1

feature {NONE} -- boolean values

	Sql_false: INTEGER = 0
	Sql_true: INTEGER = 1

feature {NONE} -- fetch operations for SQLDataSources or SQLFetchScroll

	Sql_fetch_next  : INTEGER =    1
	Sql_fetch_first  : INTEGER =   2
	Sql_fetch_first_user: INTEGER = 31
	Sql_fetch_first_system: INTEGER = 32

feature {NONE} -- Procedure types

	Sql_pt_unknown: INTEGER = 0
	Sql_pt_procedure: INTEGER = 1
	Sql_pt_function: INTEGER = 2

feature {NONE} -- Options for SQLDriverConnect

	Sql_driver_noprompt : INTEGER = 0
	Sql_driver_complete : INTEGER = 1
	Sql_driver_prompt : INTEGER = 2
	Sql_driver_complete_required : INTEGER = 3

feature {NONE} -- Options for SQLConfigDatasource

	Odbc_add_dsn : INTEGER = 1 --  Add data source
	Odbc_config_dsn : INTEGER = 2 --  Configure (edit) data source
	Odbc_remove_dsn : INTEGER = 3 --  Remove data source

	Odbc_add_sys_dsn : INTEGER = 4 --  add a system DSN -- ODBCVER >= 0x0250
	Odbc_config_sys_dsn : INTEGER = 5 --  Configure a system DSN  -- ODBCVER >= 0x0250
	Odbc_remove_sys_dsn : INTEGER = 6 --  remove a system DSN -- ODBCVER >= 0x0250

	Odbc_remove_default_dsn : INTEGER = 7 --  remove the default DSN -- ODBCVER >= 0x0300

end
