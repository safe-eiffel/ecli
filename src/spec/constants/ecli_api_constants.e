indexing

	description:
	
			"CLI/ODBC misc. API constants"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_API_CONSTANTS

feature {NONE} -- statement attributes

	Sql_attr_row_bind_type : INTEGER is 5
	Sql_attr_row_bind_offset_ptr: INTEGER is 23
	Sql_attr_row_operation_ptr: INTEGER is 24
	Sql_attr_row_status_ptr: INTEGER is 25
	Sql_attr_rows_fetched_ptr: INTEGER is 26
	Sql_attr_row_array_size: INTEGER is 27
	Sql_attr_metadata_id: INTEGER is 10014

	Sql_attr_param_bind_type 	: INTEGER is 18
	Sql_attr_paramset_size	: INTEGER is 22
	Sql_attr_param_status_ptr	: INTEGER is 20
	Sql_attr_params_processed_ptr	: INTEGER is 21

feature {NONE} -- row status

	Sql_row_success: INTEGER is 0
	Sql_row_deleted: INTEGER is 1
	Sql_row_updated: INTEGER is 2
	Sql_row_norow: INTEGER is 3
	Sql_row_added: INTEGER is 4
	Sql_row_error: INTEGER is 5
	Sql_row_success_with_info: INTEGER is 6

feature {NONE} -- Binding modes

	Sql_bind_by_column : INTEGER is 0
	Sql_parameter_bind_by_column : INTEGER is 0

feature {NONE} -- boolean values

	Sql_false: INTEGER is 0
	Sql_true: INTEGER is 1

feature {NONE} -- fetch operations for SQLDataSources or SQLFetchScroll

	Sql_fetch_next  : INTEGER is    1
	Sql_fetch_first  : INTEGER is   2
	Sql_fetch_first_user: INTEGER is 31
	Sql_fetch_first_system: INTEGER is 32

feature {NONE} -- Procedure types

	Sql_pt_unknown: INTEGER is 0
	Sql_pt_procedure: INTEGER is 1
	Sql_pt_function: INTEGER is 2

feature {NONE} -- Options for SQLDriverConnect

	Sql_driver_noprompt : INTEGER is 0
	Sql_driver_complete : INTEGER is 1
	Sql_driver_prompt : INTEGER is 2
	Sql_driver_complete_required : INTEGER is 3

feature {NONE} -- Options for SQLConfigDatasource

	Odbc_add_dsn : INTEGER is 1 --  Add data source
	Odbc_config_dsn : INTEGER is 2 --  Configure (edit) data source
	Odbc_remove_dsn : INTEGER is 3 --  Remove data source

	Odbc_add_sys_dsn : INTEGER is 4 --  add a system DSN -- ODBCVER >= 0x0250
	Odbc_config_sys_dsn : INTEGER is 5 --  Configure a system DSN  -- ODBCVER >= 0x0250
	Odbc_remove_sys_dsn : INTEGER is 6 --  remove a system DSN -- ODBCVER >= 0x0250
	
	Odbc_remove_default_dsn : INTEGER is 7 --  remove the default DSN -- ODBCVER >= 0x0300

end
