#include "ecli_c.h"

EIF_INTEGER ecli_c_allocate_environment (EIF_POINTER p_env)  {
    /* allocate new environment handle */
	SQLRETURN  retcode;

	retcode = SQLAllocHandle(
				SQL_HANDLE_ENV,
				SQL_NULL_HANDLE,
				(SQLHENV*) p_env);
	if (retcode == SQL_SUCCESS || retcode == SQL_SUCCESS_WITH_INFO) {
		/* Set the ODBC version environment attribute */
		retcode = SQLSetEnvAttr(*((SQLHENV*)p_env), SQL_ATTR_ODBC_VERSION, (void*)SQL_OV_ODBC3,0);
	}
	return retcode;
}

EIF_INTEGER ecli_c_free_environment (EIF_POINTER env)  {
    /* free environment handle */
	return (EIF_INTEGER) SQLFreeHandle(SQL_HANDLE_ENV, (SQLHENV) env);
}

EIF_INTEGER ecli_c_allocate_connection (EIF_POINTER env, EIF_POINTER p_con)  {
    /* allocate new connection handle */
	return (EIF_INTEGER) SQLAllocHandle(SQL_HANDLE_DBC, (SQLHENV) env, (SQLHDBC*) p_con);
}

EIF_INTEGER ecli_c_free_connection (EIF_POINTER con)  {
    /* free connection handle */
	return (EIF_INTEGER) SQLFreeHandle(SQL_HANDLE_DBC, (SQLHDBC) con);
}

EIF_INTEGER ecli_c_allocate_statement (EIF_POINTER con, EIF_POINTER p_stmt)  {
    /* allocate statement handle */
	return (EIF_INTEGER) SQLAllocHandle(SQL_HANDLE_STMT, (SQLHDBC) con, (SQLHSTMT*) p_stmt);
}

EIF_INTEGER ecli_c_free_statement (EIF_POINTER stmt)  {
    /* free statement handle */
	return (EIF_INTEGER) SQLFreeHandle(SQL_HANDLE_STMT, (SQLHSTMT) stmt);
}

EIF_INTEGER ecli_c_set_integer_statement_attribute (EIF_POINTER StatementHandle, EIF_INTEGER Attribute, EIF_INTEGER ValuePtr) {
	return (EIF_INTEGER) SQLSetStmtAttr (
				(SQLHSTMT)		StatementHandle,
				(SQLINTEGER)	Attribute,
				(SQLPOINTER)	ValuePtr,
				(SQLINTEGER)	SQL_IS_UINTEGER);
}

EIF_INTEGER ecli_c_set_pointer_statement_attribute (EIF_POINTER StatementHandle, EIF_INTEGER Attribute, EIF_POINTER ValuePtr, EIF_INTEGER StringLength) {
	return (EIF_INTEGER) SQLSetStmtAttr (
				(SQLHSTMT)		StatementHandle,
				(SQLINTEGER)	Attribute,
				(SQLPOINTER)	ValuePtr,
				(SQLINTEGER)	StringLength);
}

EIF_INTEGER ecli_c_set_integer_connection_attribute (EIF_POINTER ConnectionHandle, EIF_INTEGER Attribute, EIF_INTEGER ValuePtr) {
	return (EIF_INTEGER) SQLSetConnectAttr (
				(SQLHDBC)		ConnectionHandle,
				(SQLINTEGER)	Attribute,
				(SQLPOINTER)	ValuePtr,
				(SQLINTEGER)	SQL_IS_UINTEGER);
}

EIF_INTEGER ecli_c_get_integer_connection_attribute (EIF_POINTER ConnectionHandle, EIF_INTEGER Attribute, EIF_POINTER ValuePtr) {
	return (EIF_INTEGER) SQLGetConnectAttr (
				(SQLHDBC)		ConnectionHandle,
				(SQLINTEGER)	Attribute,
				(SQLPOINTER)	ValuePtr,
				(SQLINTEGER)	SQL_IS_UINTEGER,
				NULL);
}

EIF_INTEGER ecli_c_set_pointer_connection_attribute (EIF_POINTER ConnectionHandle, EIF_INTEGER Attribute, EIF_POINTER ValuePtr, EIF_INTEGER StringLength) {
	return (EIF_INTEGER) SQLSetConnectAttr (
				(SQLHDBC)		ConnectionHandle,
				(SQLINTEGER)	Attribute,
				(SQLPOINTER)	ValuePtr,
				(SQLINTEGER)	StringLength);
}

EIF_INTEGER ecli_c_get_pointer_connection_attribute (EIF_POINTER ConnectionHandle, EIF_INTEGER Attribute, EIF_POINTER ValuePtr, EIF_INTEGER BufferLength, EIF_POINTER StringLength) {
	return (EIF_INTEGER) SQLGetConnectAttr (
				(SQLHDBC)		ConnectionHandle,
				(SQLINTEGER)	Attribute,
				(SQLPOINTER)	ValuePtr,
				(SQLINTEGER)	BufferLength,
				(SQLINTEGER*)	StringLength);
}

EIF_INTEGER ecli_c_connect (EIF_POINTER con, EIF_POINTER data_source, EIF_POINTER user, EIF_POINTER password)  {
    /* connect 'con' on 'data_source' for 'user' with 'password' */
	return (EIF_INTEGER) SQLConnect((SQLHDBC)con,
								(SQLCHAR*) data_source, SQL_NTS,
		                        (SQLCHAR*) user, SQL_NTS,
		                        (SQLCHAR*) password, SQL_NTS);
}

EIF_INTEGER ecli_c_driver_connect (EIF_POINTER ConnectionHandle,
     EIF_POINTER     WindowHandle,
     EIF_POINTER     InConnectionString,
     EIF_INTEGER     StringLength1,
     EIF_POINTER     OutConnectionString,
     EIF_INTEGER     BufferLength,
     EIF_POINTER     StringLength2Ptr,
     EIF_INTEGER     DriverCompletion)

{
	return (EIF_INTEGER) SQLDriverConnect(
     (SQLHDBC)     ConnectionHandle,
     (SQLHWND)     WindowHandle,
     (SQLCHAR *)     InConnectionString,
     (SQLSMALLINT)     StringLength1,
     (SQLCHAR *)     OutConnectionString,
     (SQLSMALLINT)     BufferLength,
     (SQLSMALLINT *)     StringLength2Ptr,
     (SQLUSMALLINT)     DriverCompletion);
}

EIF_INTEGER ecli_c_disconnect (EIF_POINTER con)  {
    /* disconnect 'con' */
	return (EIF_INTEGER) SQLDisconnect((SQLHDBC)con);

}

EIF_INTEGER ecli_c_set_manual_commit (EIF_POINTER con, EIF_BOOLEAN flag_manual)  {
    /* set 'manual commit mode' to 'flag_manual' */
	return (EIF_INTEGER) SQLSetConnectAttr ((SQLHDBC)con,
							SQL_ATTR_AUTOCOMMIT,
							(SQLPOINTER)((flag_manual)?SQL_AUTOCOMMIT_OFF:SQL_AUTOCOMMIT_ON),
							SQL_IS_UINTEGER);
}

EIF_INTEGER ecli_c_is_manual_commit (EIF_POINTER con, EIF_POINTER flag_manual)  {
    /* set 'flag_manual' to True if in manual commit mode */
	SQLINTEGER length;
	SQLRETURN  retcode;
	SQLUINTEGER flag;

	retcode = SQLGetConnectAttr ((SQLHDBC)con,
							SQL_ATTR_AUTOCOMMIT,
							(SQLPOINTER)&flag,
							SQL_IS_UINTEGER,
							&length);
	*((EIF_BOOLEAN*)flag_manual) = (SQL_AUTOCOMMIT_OFF==flag)?1:0;
	return (EIF_INTEGER) retcode;
}

EIF_INTEGER ecli_c_commit (EIF_POINTER con)  {
	return (EIF_INTEGER) SQLEndTran(SQL_HANDLE_DBC,(SQLHDBC) con, SQL_COMMIT);
}

EIF_INTEGER ecli_c_rollback (EIF_POINTER con)  {
	return (EIF_INTEGER) SQLEndTran(SQL_HANDLE_DBC,(SQLHDBC) con, SQL_ROLLBACK);
}

EIF_INTEGER ecli_c_row_count (EIF_POINTER stmt, EIF_POINTER count)  {
	SQLINTEGER row_count;
	SQLRETURN retcode;

	retcode = SQLRowCount ((SQLHSTMT)stmt, &row_count);
	*((EIF_INTEGER*)count) = (EIF_INTEGER) row_count;
	return (EIF_INTEGER) retcode;
}

EIF_INTEGER ecli_c_parameter_count (EIF_POINTER stmt, EIF_POINTER count)  {
	SQLSMALLINT param_count;
	SQLRETURN retcode;

	retcode = SQLNumParams ((SQLHSTMT)stmt, &param_count);
	*((EIF_INTEGER*)count) = (EIF_INTEGER) param_count;
	return (EIF_INTEGER) retcode;
}

EIF_INTEGER ecli_c_result_column_count (EIF_POINTER stmt, EIF_POINTER count)  {
	SQLSMALLINT result_count;
	SQLRETURN retcode;

	retcode = SQLNumResultCols ((SQLHSTMT)stmt, &result_count);
	*((EIF_INTEGER*)count) = (EIF_INTEGER) result_count;
	return (EIF_INTEGER) retcode;
}

EIF_INTEGER ecli_c_prepare (EIF_POINTER stmt, EIF_POINTER sql)  {
	return (EIF_INTEGER) SQLPrepare ((SQLHSTMT)stmt, (SQLCHAR*) sql, SQL_NTS);
}

EIF_INTEGER ecli_c_execute_direct (EIF_POINTER stmt, EIF_POINTER sql)  {
	return (EIF_INTEGER) SQLExecDirect((SQLHSTMT)stmt, (SQLCHAR*) sql, SQL_NTS);
}

EIF_INTEGER ecli_c_execute (EIF_POINTER stmt)  {
	return (EIF_INTEGER) SQLExecute((SQLHSTMT)stmt);
}

EIF_INTEGER ecli_c_more_results (EIF_POINTER stmt) {
	return (EIF_INTEGER) SQLMoreResults ((SQLHSTMT)stmt);
}

EIF_INTEGER ecli_c_bind_parameter (EIF_POINTER stmt,
								   EIF_INTEGER index,
								   EIF_INTEGER direction,
								   EIF_INTEGER c_type,
								   EIF_INTEGER sql_type,
								   EIF_INTEGER sql_size,
								   EIF_INTEGER sql_decimal_digits,
								   EIF_POINTER value,
								   EIF_INTEGER buffer_length,
								   EIF_POINTER ptr_value_length)  {
	return (EIF_INTEGER) SQLBindParameter(
							(SQLHSTMT)stmt,
							(SQLUSMALLINT)	index,
							(SQLSMALLINT)	direction,
							(SQLSMALLINT)		c_type,
							(SQLSMALLINT)		sql_type,
							(SQLUINTEGER)		sql_size,
							(SQLSMALLINT)		sql_decimal_digits,
							(SQLPOINTER)		value,
							(SQLINTEGER)		buffer_length,
							(SQLINTEGER *)		ptr_value_length);

}

EIF_INTEGER ecli_c_bind_result (EIF_POINTER stmt,
								EIF_INTEGER index,
								EIF_INTEGER c_type,
								EIF_POINTER value,
								EIF_INTEGER buffer_length,
								EIF_POINTER len_indicator)  {
	return (EIF_INTEGER) SQLBindCol(
			(SQLHSTMT)			stmt,
			(SQLUSMALLINT)	index,
			(SQLSMALLINT)		c_type,
			(SQLPOINTER)		value,
			(SQLINTEGER)		buffer_length,
			(SQLINTEGER *)		len_indicator);
}


EIF_INTEGER	ecli_c_describe_parameter (EIF_POINTER stmt,
							 EIF_INTEGER 	column_number,
							 EIF_POINTER 	sql_type,
							 EIF_POINTER  	sql_size,
							 EIF_POINTER  	sql_decimal_digits,
							 EIF_POINTER  	sql_nullability)
{
	SQLSMALLINT p_sql_type;
	SQLUINTEGER p_sql_size;
	SQLSMALLINT p_sql_decimal_digits;
	SQLSMALLINT p_sql_nullability;
	EIF_INTEGER res;
	res = (EIF_INTEGER) SQLDescribeParam (
								(SQLHSTMT) 		stmt,
								(SQLUSMALLINT) 	column_number,
								(SQLSMALLINT *)	&p_sql_type,
								(SQLUINTEGER *)	&p_sql_size,
								(SQLSMALLINT *)	&p_sql_decimal_digits,
								(SQLSMALLINT *)	&p_sql_nullability);
	*((EIF_INTEGER*) sql_type)= (EIF_INTEGER) p_sql_type;
	*((EIF_INTEGER*) sql_size)= (EIF_INTEGER) p_sql_size;
	*((EIF_INTEGER*) sql_decimal_digits)= (EIF_INTEGER) p_sql_decimal_digits;
	*((EIF_INTEGER*) sql_nullability)= (EIF_INTEGER) p_sql_nullability;
	return res;
}

EIF_INTEGER	ecli_c_describe_column (EIF_POINTER stmt,
							 EIF_INTEGER 	column_number,
							 EIF_POINTER 	col_name,
							 EIF_INTEGER 	max_name_length,
							 EIF_POINTER  	actual_name_length,
							 EIF_POINTER  	sql_type,
							 EIF_POINTER  	sql_size,
							 EIF_POINTER  	sql_decimal_digits,
							 EIF_POINTER  	sql_nullability)
{
	SQLSMALLINT p_actual_name_length;
	SQLSMALLINT p_sql_type;
	SQLUINTEGER p_sql_size;
	SQLSMALLINT p_sql_decimal_digits;
	SQLSMALLINT p_sql_nullability;
	EIF_INTEGER res;
	res = (EIF_INTEGER) SQLDescribeCol (
								(SQLHSTMT) 		stmt,
								(SQLSMALLINT) 	column_number,
								(SQLCHAR *)		col_name,
								(SQLSMALLINT)	max_name_length,
								(SQLSMALLINT *)	&p_actual_name_length,
								(SQLSMALLINT *)	&p_sql_type,
								(SQLUINTEGER *)	&p_sql_size,
								(SQLSMALLINT *)	&p_sql_decimal_digits,
								(SQLSMALLINT *)	&p_sql_nullability);
	*((EIF_INTEGER*) actual_name_length) = 	(EIF_INTEGER) p_actual_name_length;
	*((EIF_INTEGER*) sql_type) = 			(EIF_INTEGER) p_sql_type;
	*((EIF_INTEGER*) sql_size) = 			(EIF_INTEGER) p_sql_size;
	*((EIF_INTEGER*) sql_decimal_digits) = 	(EIF_INTEGER) p_sql_decimal_digits;
	*((EIF_INTEGER*) sql_nullability) = 	(EIF_INTEGER) p_sql_nullability;

return res;
}

EIF_INTEGER ecli_c_get_type_info (EIF_POINTER stmt, EIF_INTEGER data_type) {
	return (EIF_INTEGER) SQLGetTypeInfo( (SQLHSTMT) stmt, (SQLSMALLINT) data_type);
}

EIF_INTEGER ecli_c_get_tables (EIF_POINTER stmt,
		EIF_POINTER catalog_name, EIF_INTEGER catalog_name_length,
		EIF_POINTER schema_name, EIF_INTEGER schema_name_length,
		EIF_POINTER table_name, EIF_INTEGER table_name_length,
		EIF_POINTER table_type, EIF_INTEGER table_type_length) {
	return (EIF_INTEGER) SQLTables (	(SQLHSTMT)		stmt,
			(SQLCHAR *)		catalog_name,
			(SQLSMALLINT)	catalog_name_length,
			(SQLCHAR *)		schema_name,
			(SQLSMALLINT)	schema_name_length,
			(SQLCHAR *)		table_name,
			(SQLSMALLINT)	table_name_length,
			(SQLCHAR *)	table_type,
			(SQLSMALLINT)	table_type_length
		);
}

EIF_INTEGER ecli_c_get_procedures (EIF_POINTER stmt,
		EIF_POINTER catalog_name, EIF_INTEGER catalog_name_length,
		EIF_POINTER schema_name, EIF_INTEGER schema_name_length,
		EIF_POINTER procedure_name, EIF_INTEGER procedure_name_length) {
	return (EIF_INTEGER) SQLProcedures (	(SQLHSTMT)		stmt,
			(SQLCHAR *)		catalog_name,
			(SQLSMALLINT)	catalog_name_length,
			(SQLCHAR *)		schema_name,
			(SQLSMALLINT)	schema_name_length,
			(SQLCHAR *)		procedure_name,
			(SQLSMALLINT)	procedure_name_length
		);
}

EIF_INTEGER ecli_c_get_columns (EIF_POINTER stmt,
		EIF_POINTER catalog_name, EIF_INTEGER catalog_name_length,
		EIF_POINTER schema_name, EIF_INTEGER schema_name_length,
		EIF_POINTER table_name, EIF_INTEGER table_name_length,
		EIF_POINTER column_name, EIF_INTEGER column_name_length) {
	return (EIF_INTEGER) SQLColumns (	(SQLHSTMT)		stmt,
			(SQLCHAR *)		catalog_name,
			(SQLSMALLINT)	catalog_name_length,
			(SQLCHAR *)		schema_name,
			(SQLSMALLINT)	schema_name_length,
			(SQLCHAR *)		table_name,
			(SQLSMALLINT)	table_name_length,
			(SQLCHAR *)	column_name,
			(SQLSMALLINT)	column_name_length
		);
}

EIF_INTEGER ecli_c_get_procedure_columns (EIF_POINTER stmt,
		EIF_POINTER catalog_name, EIF_INTEGER catalog_name_length,
		EIF_POINTER schema_name, EIF_INTEGER schema_name_length,
		EIF_POINTER procedure_name, EIF_INTEGER procedure_name_length,
		EIF_POINTER column_name, EIF_INTEGER column_name_length) {
	return (EIF_INTEGER) SQLProcedureColumns (	(SQLHSTMT)		stmt,
			(SQLCHAR *)		catalog_name,
			(SQLSMALLINT)	catalog_name_length,
			(SQLCHAR *)		schema_name,
			(SQLSMALLINT)	schema_name_length,
			(SQLCHAR *)		procedure_name,
			(SQLSMALLINT)	procedure_name_length,
			(SQLCHAR *)	column_name,
			(SQLSMALLINT)	column_name_length
		);
}

EIF_INTEGER ecli_c_get_statistics (EIF_POINTER stmt,
		EIF_POINTER catalog_name, EIF_INTEGER catalog_name_length,
		EIF_POINTER schema_name, EIF_INTEGER schema_name_length,
		EIF_POINTER table_name, EIF_INTEGER table_name_length,
		EIF_INTEGER unique_or_all, EIF_INTEGER reserved ) {
	return SQLStatistics(
		 (SQLHSTMT)     	stmt,
		 (SQLCHAR *)     	catalog_name,
		 (SQLSMALLINT)     	catalog_name_length,
		 (SQLCHAR *)     	schema_name,
		 (SQLSMALLINT)     	schema_name_length,
		 (SQLCHAR *)     	table_name,
		 (SQLSMALLINT)     	table_name_length,
		 (SQLUSMALLINT)     unique_or_all,
		 (SQLUSMALLINT)     reserved);
}

EIF_INTEGER ecli_c_get_primary_keys (EIF_POINTER stmt,
		EIF_POINTER catalog_name, EIF_INTEGER catalog_name_length,
		EIF_POINTER schema_name, EIF_INTEGER schema_name_length,
		EIF_POINTER table_name, EIF_INTEGER table_name_length) {
	return (EIF_INTEGER) SQLPrimaryKeys (	(SQLHSTMT)		stmt,
			(SQLCHAR *)		catalog_name,
			(SQLSMALLINT)	catalog_name_length,
			(SQLCHAR *)		schema_name,
			(SQLSMALLINT)	schema_name_length,
			(SQLCHAR *)		table_name,
			(SQLSMALLINT)	table_name_length
		);
}

EIF_INTEGER ecli_c_get_foreign_keys (EIF_POINTER stmt,
		EIF_POINTER PKcatalog_name, EIF_INTEGER PKcatalog_name_length,
		EIF_POINTER PKschema_name, EIF_INTEGER PKschema_name_length,
		EIF_POINTER PKtable_name, EIF_INTEGER PKtable_name_length,
		EIF_POINTER FKcatalog_name, EIF_INTEGER FKcatalog_name_length,
		EIF_POINTER FKschema_name, EIF_INTEGER FKschema_name_length,
		EIF_POINTER FKtable_name, EIF_INTEGER FKtable_name_length)
		{
	return (EIF_INTEGER) SQLForeignKeys (	(SQLHSTMT)		stmt,
			(SQLCHAR *)		PKcatalog_name, (SQLSMALLINT)	PKcatalog_name_length,
			(SQLCHAR *)		PKschema_name,  (SQLSMALLINT)	PKschema_name_length,
			(SQLCHAR *)		PKtable_name,   (SQLSMALLINT)	PKtable_name_length,
			(SQLCHAR *)		FKcatalog_name, (SQLSMALLINT)	FKcatalog_name_length,
			(SQLCHAR *)		FKschema_name,  (SQLSMALLINT)	FKschema_name_length,
			(SQLCHAR *)		FKtable_name,   (SQLSMALLINT)	FKtable_name_length
		);
}

EIF_INTEGER ecli_c_get_datasources (EIF_POINTER env,
	EIF_INTEGER operation, EIF_POINTER source_name, EIF_INTEGER source_name_length, EIF_POINTER actual_source_name_length,
	EIF_POINTER description, EIF_INTEGER description_length, EIF_POINTER actual_description_length) {
	return (EIF_INTEGER) SQLDataSources (
		(SQLHENV)		env,
		(SQLUSMALLINT) operation,
		(SQLCHAR *)		source_name,
		(SQLSMALLINT)	source_name_length,
		(SQLSMALLINT*)  actual_source_name_length,
		(SQLCHAR *)		description,
		(SQLSMALLINT)	description_length,
		(SQLSMALLINT*)	actual_description_length
	);
}

EIF_INTEGER ecli_c_get_data (EIF_POINTER stmt,
							 EIF_INTEGER column_number,
							 EIF_INTEGER c_type,
							 EIF_POINTER target_pointer,
							 EIF_INTEGER buffer_length,
							 EIF_POINTER len_indicator_pointer) {
	return (EIF_INTEGER) SQLGetData(
		(SQLHSTMT)			stmt,
		(SQLUSMALLINT)	column_number,
		(SQLSMALLINT)		c_type,
		(SQLPOINTER)		target_pointer,
		(SQLINTEGER)		buffer_length,
		(SQLINTEGER *)		len_indicator_pointer);
}

EIF_INTEGER ecli_c_param_data (EIF_POINTER stmt, EIF_POINTER value_ptr_ptr) {
	return (EIF_INTEGER) SQLParamData(
     	(SQLHSTMT)     stmt,
     	(SQLPOINTER *)     value_ptr_ptr);
}

EIF_INTEGER ecli_c_put_data (EIF_POINTER stmt,
							 EIF_POINTER data_ptr,
							 EIF_INTEGER str_len_or_ind) {
	return (EIF_INTEGER) SQLPutData(
     	(SQLHSTMT)     stmt,
     	(SQLPOINTER)     data_ptr,
     	(SQLINTEGER)     str_len_or_ind);
}

EIF_INTEGER ecli_c_len_data_at_exe (EIF_INTEGER len) {
	return (EIF_INTEGER) (SQL_LEN_DATA_AT_EXEC(len));
}

EIF_INTEGER ecli_c_fetch (EIF_POINTER handle) {
	return (EIF_INTEGER) SQLFetch ((SQLHSTMT) handle);
}


EIF_INTEGER ecli_c_close_cursor (EIF_POINTER handle) {
	return (EIF_INTEGER) SQLCloseCursor ((SQLHSTMT) handle);
}

static EIF_INTEGER ecli_c_get_error_diagnostic (SQLSMALLINT handle_type,
			EIF_POINTER handle,
			EIF_INTEGER record_index,
			EIF_POINTER state,
			EIF_POINTER native_error,
			EIF_POINTER message,
			EIF_INTEGER buffer_length,
			EIF_POINTER length_indicator)  {
	SQLSMALLINT	p_length_indicator;
	EIF_INTEGER res;
	res = (EIF_INTEGER) SQLGetDiagRec(
		(SQLSMALLINT)		handle_type,
		(SQLHANDLE)			handle,
		(SQLSMALLINT)		record_index,
		(SQLCHAR *)			state,
		(SQLINTEGER *)		native_error,
		(SQLCHAR *)			message,
		(SQLSMALLINT)		buffer_length,
		(SQLSMALLINT *)		&p_length_indicator);
	*((EIF_INTEGER*) length_indicator)= (EIF_INTEGER) p_length_indicator;
return res;
}

EIF_INTEGER ecli_c_environment_error (EIF_POINTER handle,
				EIF_INTEGER record_index,
				EIF_POINTER state,
				EIF_POINTER native_error,
				EIF_POINTER message,
				EIF_INTEGER buffer_length,
				EIF_POINTER length_indicator)
{
	return (EIF_INTEGER) ecli_c_get_error_diagnostic(
		SQL_HANDLE_ENV,
		handle,
		record_index,
		state,
		native_error,
		message,
		buffer_length,
		length_indicator);
}

EIF_INTEGER ecli_c_session_error (EIF_POINTER handle, EIF_INTEGER record_index, EIF_POINTER state, EIF_POINTER native_error, EIF_POINTER message, EIF_INTEGER buffer_length, EIF_POINTER length_indicator)  {
	return (EIF_INTEGER) ecli_c_get_error_diagnostic(
		SQL_HANDLE_DBC,
		handle,
		record_index,
		state,
		native_error,
		message,
		buffer_length,
		length_indicator);
}

EIF_INTEGER ecli_c_statement_error (EIF_POINTER handle, EIF_INTEGER record_index, EIF_POINTER state, EIF_POINTER native_error, EIF_POINTER message, EIF_INTEGER buffer_length, EIF_POINTER length_indicator)  {
	return (EIF_INTEGER) ecli_c_get_error_diagnostic(
		SQL_HANDLE_STMT,
		handle,
		record_index,
		state,
		native_error,
		message,
		buffer_length,
		length_indicator);
}


EIF_INTEGER ecli_c_transaction_capable (EIF_POINTER handle, EIF_POINTER capable) {
	SQLUSMALLINT	capability;
	EIF_INTEGER		res;
	res = (EIF_INTEGER) SQLGetInfo ((SQLHSTMT) handle, SQL_TXN_CAPABLE, &capability, 0, NULL);
	*((EIF_INTEGER*)capable)= (EIF_INTEGER) capability;
	return res;
}

EIF_INTEGER ecli_c_sql_get_info (EIF_POINTER handle, EIF_INTEGER info_type, EIF_POINTER info_value_ptr, EIF_INTEGER buffer_length, EIF_POINTER string_length_ptr) {
	EIF_INTEGER res;

	res = (EIF_INTEGER) SQLGetInfo(	 (SQLHDBC)      handle,
									 (SQLUSMALLINT) info_type,
									 (SQLPOINTER)   info_value_ptr,
									 (SQLSMALLINT)  buffer_length,
									 (SQLSMALLINT *)string_length_ptr);
	return res;
}

EIF_INTEGER ecli_c_sql_get_functions (EIF_POINTER handle, EIF_INTEGER function, EIF_POINTER supported) {
	SQLUSMALLINT support;
	EIF_INTEGER res;
	res = (EIF_INTEGER) SQLGetFunctions ((SQLHDBC) handle, (SQLUSMALLINT) function, (SQLUSMALLINT*) &support);
	*((EIF_INTEGER*)supported)= (EIF_INTEGER) support;
	return res;
}

EIF_INTEGER ecli_c_sql_drivers (EIF_POINTER handle,
     EIF_INTEGER     Direction,
     EIF_POINTER     DriverDescription,
     EIF_INTEGER     BufferLength1,
     EIF_POINTER     DescriptionLengthPtr,
     EIF_POINTER     DriverAttributes,
     EIF_INTEGER     BufferLength2,
     EIF_POINTER     AttributesLengthPtr)

{
	return (EIF_INTEGER) SQLDrivers(
     (SQLHENV)     handle,
     (SQLUSMALLINT)     Direction,
     (SQLCHAR *)     DriverDescription,
     (SQLSMALLINT)     BufferLength1,
     (SQLSMALLINT *)     DescriptionLengthPtr,
     (SQLCHAR *)     DriverAttributes,
     (SQLSMALLINT)     BufferLength2,
     (SQLSMALLINT *)     AttributesLengthPtr);
}

/* Installation routines */

EIF_BOOLEAN ecli_c_sql_config_datasource (EIF_POINTER hwndParent, EIF_INTEGER fRequest, EIF_POINTER lpszDriver, EIF_POINTER lpszAttributes)
{
	return (EIF_BOOLEAN) SQLConfigDataSource((HWND) hwndParent,(UINT) fRequest, (LPCSTR) lpszDriver, (LPCSTR) lpszAttributes);
}

/* Accessors and Modifiers for struct ecli_c_value data type */
/* WARNING: 64 bit sensible */

/*64 bit*/
EIF_POINTER ecli_c_alloc_value (EIF_INTEGER_64 c_buffer_length) {
	struct ecli_c_value *res;

	res = (struct ecli_c_value *) calloc(sizeof(struct ecli_c_value)+c_buffer_length, 1); /* conversion from EIF_INTEGER_64 to size_t : possible loss of data */
	if (res)
		res->length = (SQLLEN) c_buffer_length;
	return (EIF_POINTER) res;
}

void ecli_c_free_value (EIF_POINTER ptr) {
	free (ptr);
}

/*64 bit*/

/* length: buffer length */
EIF_INTEGER_64 ecli_c_value_get_length (EIF_POINTER v) {
	return (EIF_INTEGER_64) 	((struct ecli_c_value*)v)->length;
}

/* length_indicator: element length */
void ecli_c_value_set_length_indicator (EIF_POINTER v, EIF_INTEGER_64 li) {
	((struct ecli_c_value*)v)->length_indicator = (SQLLEN) li;
}

EIF_INTEGER_64 ecli_c_value_get_length_indicator (EIF_POINTER v) {
	return (EIF_INTEGER_64) 	((struct ecli_c_value*)v)->length_indicator;
}

EIF_POINTER ecli_c_value_get_length_indicator_pointer (EIF_POINTER v) {
	return (EIF_POINTER) 	&(((struct ecli_c_value*)v)->length_indicator);
}

/* value */
void ecli_c_value_set_value (EIF_POINTER v, EIF_POINTER new_value, EIF_INTEGER actual_length) {
	memcpy ((void*)((struct ecli_c_value*)v)->value, (const void*)new_value, actual_length);
}

EIF_POINTER ecli_c_value_get_value (EIF_POINTER v) {
	return (EIF_POINTER) ((struct ecli_c_value*)v)->value;
}

void ecli_c_value_copy_value (EIF_POINTER v, EIF_POINTER dest) {
	memcpy ((void*)dest, (void*) ((struct ecli_c_value*)v)->value, ((struct ecli_c_value*)v)->length);
}

/* Accessors and modifiers for ecli_c_array_value */
EIF_POINTER ecli_c_alloc_array_value (EIF_INTEGER_64 c_buffer_length, EIF_INTEGER a_count) {
	struct ecli_c_array_value *res;

	res = (struct ecli_c_array_value *) calloc(
				(sizeof(struct ecli_c_array_value) + 	/* header */
				  + (sizeof(SQLLEN)* a_count) 			/* array of length indicators */
				  + (c_buffer_length * a_count)			/* array of values */
				 ) /* conversion of EIF_INTEGER_64 to size_t : possible loss of data */
				 , 1
			);
    if (res) {
		res->length = (SQLLEN) c_buffer_length;
		res->count = (long) a_count;
		res->length_indicators = (SQLLEN*) (res->buffer);
		res->values= (char *) (res->buffer + (sizeof (SQLLEN) * a_count));
    }
	return (EIF_POINTER) res;
}

void ecli_c_free_array_value (EIF_POINTER ptr) {
	free (ptr);
}

/* static SQLLEN * AV_LENGTH_INDICATOR_ARRAY_ADDRESS (struct ecli_c_array_value* av) {
	return (SQLLEN *)(av->buffer);
}

static SQLLEN AV_LENGTH_INDICATOR (struct ecli_c_array_value* av, long i) {
	return (AV_LENGTH_INDICATOR_ARRAY_ADDRESS (av) [i]);
}

static  SQLLEN * AV_LENGTH_INDICATOR_PTR (struct ecli_c_array_value* av, long i) {
	return ((SQLLEN *)  &(AV_LENGTH_INDICATOR_ARRAY_ADDRESS(av) [i]));
}

static  SQLLEN AV_LENGTH_SIZE (struct ecli_c_array_value* av)  {
	return (sizeof (SQLLEN) * av->count);
}

static  char * AV_VALUE_ARRAY_ADDRESS (struct ecli_c_array_value* av)  {
//	return (char *)(av->buffer + AV_LENGTH_SIZE (av));
	return av->values;
}

*/

static  char * AV_VALUE (struct ecli_c_array_value* av, long i)  {
	return (char *) (av->values + i * av->length); //(AV_VALUE_ARRAY_ADDRESS (av) + i * av->length);
}

/*
static  SQLLEN AV_BUFFER_LENGTH (struct ecli_c_array_value* av)  {
	return (AV_LENGTH_SIZE (av) + av->length * av->count);
}
*/

EIF_INTEGER_64 ecli_c_array_value_get_length (EIF_POINTER v) {
	return (EIF_INTEGER_64) 	((struct ecli_c_array_value*)v)->length;
}

EIF_POINTER ecli_c_array_value_get_length_indicator_pointer (EIF_POINTER av) {
	return (EIF_POINTER) ((struct ecli_c_array_value *) av)->length_indicators; //AV_LENGTH_INDICATOR_ARRAY_ADDRESS ((struct ecli_c_array_value *) av);
}

EIF_POINTER ecli_c_array_value_get_value (EIF_POINTER av) {
	return (EIF_POINTER) ((struct ecli_c_array_value *) av)->values; //AV_VALUE_ARRAY_ADDRESS ((struct ecli_c_array_value*)av);
}

void ecli_c_array_value_set_length_indicator_at (EIF_POINTER av, EIF_INTEGER_64 li, EIF_INTEGER index) {
	(((struct ecli_c_array_value *) av)->length_indicators)[index-1]=(SQLLEN)li; //*(AV_LENGTH_INDICATOR_PTR ((struct ecli_c_array_value*)v, index-1))= (SQLLEN) li;
//printf("SQLLEN[%ld]=%ld",(long)index,(long)li);
}

EIF_INTEGER_64 ecli_c_array_value_get_length_indicator_at (EIF_POINTER av, EIF_INTEGER index) {
	return (EIF_INTEGER_64) ((((struct ecli_c_array_value *) av)->length_indicators)[index-1]); // AV_LENGTH_INDICATOR ((struct ecli_c_array_value*)v, (long) index-1);
}

EIF_POINTER ecli_c_array_value_get_length_indicator_pointer_at (EIF_POINTER av, EIF_INTEGER index) {
	return (EIF_POINTER) &((((struct ecli_c_array_value *) av)->length_indicators)[index-1]); // AV_LENGTH_INDICATOR_PTR((struct ecli_c_array_value*)v, (long) index-1);
}

void ecli_c_array_value_set_value_at (EIF_POINTER v, EIF_POINTER new_array_value, EIF_INTEGER actual_length, EIF_INTEGER index) {
	memcpy (
		(void*)(AV_VALUE((struct ecli_c_array_value*)v, (long) index-1)),
		(const void*)new_array_value,
		actual_length);
}

EIF_POINTER ecli_c_array_value_get_value_at (EIF_POINTER v, EIF_INTEGER index) {
	return (EIF_POINTER) AV_VALUE((struct ecli_c_array_value*)v, (long) index-1);
}

void ecli_c_array_value_copy_value_at (EIF_POINTER v, EIF_POINTER dest, EIF_INTEGER index) {
	memcpy ((void*)dest,
		(void*) AV_VALUE((struct ecli_c_array_value*)v, (long) index-1),
		((struct ecli_c_array_value*)v)->length);
}


/* Accessors and Modifiers for DATE, TIME, and TIMESTAMP */
/*														 */

/* Access to date information for DATE and TIMESTAMP are the same ! */
EIF_INTEGER ecli_c_date_get_year (EIF_POINTER dt) { return (EIF_INTEGER) ((DATE_STRUCT*)dt)->year;}
EIF_INTEGER ecli_c_date_get_month (EIF_POINTER dt) { return (EIF_INTEGER) ((DATE_STRUCT*)dt)->month;}
EIF_INTEGER ecli_c_date_get_day (EIF_POINTER dt) { return (EIF_INTEGER) ((DATE_STRUCT*)dt)->day;}

void ecli_c_date_set_year (EIF_POINTER dt, EIF_INTEGER v) { ((DATE_STRUCT*)dt)->year = (SQLSMALLINT)v;}
void ecli_c_date_set_month (EIF_POINTER dt, EIF_INTEGER v) { ((DATE_STRUCT*)dt)->month = (SQLUSMALLINT)v;}
void ecli_c_date_set_day (EIF_POINTER dt, EIF_INTEGER v) { ((DATE_STRUCT*)dt)->day = (SQLUSMALLINT)v;}

/* TIME getters and setters */
EIF_INTEGER ecli_c_time_get_hour (EIF_POINTER tm) { return (EIF_INTEGER) ((TIME_STRUCT*)tm)->hour;}
EIF_INTEGER ecli_c_time_get_minute (EIF_POINTER tm) { return (EIF_INTEGER) ((TIME_STRUCT*)tm)->minute;}
EIF_INTEGER ecli_c_time_get_second (EIF_POINTER tm) { return (EIF_INTEGER) ((TIME_STRUCT*)tm)->second;}

void ecli_c_time_set_hour (EIF_POINTER tm, EIF_INTEGER v) { ((TIME_STRUCT*)tm)->hour = (SQLUSMALLINT) v;}
void ecli_c_time_set_minute (EIF_POINTER tm, EIF_INTEGER v) { ((TIME_STRUCT*)tm)->minute = (SQLUSMALLINT) v;}
void ecli_c_time_set_second (EIF_POINTER tm, EIF_INTEGER v) { ((TIME_STRUCT*)tm)->second = (SQLUSMALLINT) v;}


/* TIMESTAMP time getters and setters */
EIF_INTEGER ecli_c_timestamp_get_hour (EIF_POINTER tm) { return (EIF_INTEGER) ((TIMESTAMP_STRUCT*)tm)->hour;}
EIF_INTEGER ecli_c_timestamp_get_minute (EIF_POINTER tm) { return (EIF_INTEGER) ((TIMESTAMP_STRUCT*)tm)->minute;}
EIF_INTEGER ecli_c_timestamp_get_second (EIF_POINTER tm) { return (EIF_INTEGER) ((TIMESTAMP_STRUCT*)tm)->second;}
EIF_INTEGER ecli_c_timestamp_get_fraction (EIF_POINTER tm) {return (EIF_INTEGER) ((TIMESTAMP_STRUCT*)tm)->fraction;}

void ecli_c_timestamp_set_hour (EIF_POINTER tm, EIF_INTEGER v) { ((TIMESTAMP_STRUCT*)tm)->hour = (SQLUSMALLINT) v;}
void ecli_c_timestamp_set_minute (EIF_POINTER tm, EIF_INTEGER v) { ((TIMESTAMP_STRUCT*)tm)->minute = (SQLUSMALLINT) v;}
void ecli_c_timestamp_set_second (EIF_POINTER tm, EIF_INTEGER v) { ((TIMESTAMP_STRUCT*)tm)->second = (SQLUSMALLINT) v;}
void ecli_c_timestamp_set_fraction (EIF_POINTER tm, EIF_INTEGER v) { ((TIMESTAMP_STRUCT*)tm)->fraction = (SQLUINTEGER) v;}


/* size of structures */
EIF_INTEGER ecli_c_sizeof_date_struct () {return sizeof(DATE_STRUCT);}
EIF_INTEGER ecli_c_sizeof_time_struct () {return sizeof(TIME_STRUCT);}
EIF_INTEGER ecli_c_sizeof_timestamp_struct () {return sizeof(TIMESTAMP_STRUCT);}

/* formatting routines */

void ecli_c_sprintf_double (EIF_POINTER p_result, EIF_DOUBLE d) {
	sprintf ((char*) p_result, "%.15g", d);
}

void ecli_c_sprintf_real (EIF_POINTER p_result, EIF_REAL r) {
	sprintf ((char *) p_result, "%.7g", r);
}

