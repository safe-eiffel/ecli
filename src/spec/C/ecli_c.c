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

EIF_INTEGER ecli_c_connect (EIF_POINTER con, EIF_POINTER data_source, EIF_POINTER user, EIF_POINTER password)  {
    /* connect 'con' on 'data_source' for 'user' with 'password' */
	return (EIF_INTEGER) SQLConnect((SQLHDBC)con,
								(SQLCHAR*) data_source, SQL_NTS,
		                        (SQLCHAR*) user, SQL_NTS,
		                        (SQLCHAR*) password, SQL_NTS);
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

EIF_INTEGER ecli_c_bind_parameter (EIF_POINTER stmt,
								   EIF_INTEGER index,
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
							(SQLSMALLINT)	SQL_PARAM_INPUT,
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
		return (EIF_INTEGER) SQLDescribeParam (
								(SQLHSTMT) 		stmt,
								(SQLUSMALLINT) 	column_number,
								(SQLSMALLINT *)	sql_type,
								(SQLUINTEGER *)	sql_size,
								(SQLSMALLINT *)	sql_decimal_digits,
								(SQLSMALLINT *)	sql_nullability);
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
		return (EIF_INTEGER) SQLDescribeCol (
								(SQLHSTMT) 		stmt,
								(SQLUSMALLINT) 	column_number,
								(SQLCHAR *)		col_name,
								(SQLSMALLINT)	max_name_length,
								(SQLSMALLINT *)	actual_name_length,
								(SQLSMALLINT *)	sql_type,
								(SQLUINTEGER *)	sql_size,
								(SQLSMALLINT *)	sql_decimal_digits,
								(SQLSMALLINT *)	sql_nullability);
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

EIF_INTEGER ecli_c_fetch (EIF_POINTER handle) {
	return (EIF_INTEGER) SQLFetch ((SQLHSTMT) handle);
}


EIF_INTEGER ecli_c_close_cursor (EIF_POINTER handle) {
	return (EIF_INTEGER) SQLCloseCursor ((SQLHSTMT) handle);
}

EIF_INTEGER ecli_c_environment_error (EIF_POINTER handle,
				EIF_INTEGER record_index,
				EIF_POINTER state,
				EIF_POINTER native_error,
				EIF_POINTER message,
				EIF_INTEGER buffer_length,
				EIF_POINTER length_indicator)  {
	return (EIF_INTEGER) SQLGetDiagRec(
		(SQLSMALLINT)		SQL_HANDLE_ENV,
		(SQLHANDLE)			handle,
		(SQLSMALLINT)		record_index,
		(SQLCHAR *)			state,
		(SQLINTEGER *)		native_error,
		(SQLCHAR *)			message,
		(SQLSMALLINT)		buffer_length,
		(SQLSMALLINT *)		length_indicator);
}

EIF_INTEGER ecli_c_session_error (EIF_POINTER handle, EIF_INTEGER record_index, EIF_POINTER state, EIF_POINTER native_error, EIF_POINTER message, EIF_INTEGER buffer_length, EIF_POINTER length_indicator)  {
	return (EIF_INTEGER) SQLGetDiagRec(
		(SQLSMALLINT)		SQL_HANDLE_DBC,
		(SQLHANDLE)			handle,
		(SQLSMALLINT)		record_index,
		(SQLCHAR *)			state,
		(SQLINTEGER *)		native_error,
		(SQLCHAR *)			message,
		(SQLSMALLINT)		buffer_length,
		(SQLSMALLINT *)		length_indicator);
}

EIF_INTEGER ecli_c_statement_error (EIF_POINTER handle, EIF_INTEGER record_index, EIF_POINTER state, EIF_POINTER native_error, EIF_POINTER message, EIF_INTEGER buffer_length, EIF_POINTER length_indicator)  {
	return (EIF_INTEGER) SQLGetDiagRec(
		(SQLSMALLINT)		SQL_HANDLE_STMT,
		(SQLHANDLE)			handle,
		(SQLSMALLINT)		record_index,
		(SQLCHAR *)			state,
		(SQLINTEGER *)		native_error,
		(SQLCHAR *)			message,
		(SQLSMALLINT)		buffer_length,
		(SQLSMALLINT *)		length_indicator);
}

/* Accessors and Modifiers for struct ecli_c_value data type */

EIF_POINTER ecli_c_alloc_value (EIF_INTEGER c_buffer_length) {
	struct ecli_c_value *res;

	res = (struct ecli_c_value *) malloc(sizeof(struct ecli_c_value)+c_buffer_length);
	if (res)
		res->length = (long) c_buffer_length;
	return (EIF_POINTER) res;
}

void ecli_c_free_value (EIF_POINTER ptr) {
	free (ptr);
}

void ecli_c_value_set_length_indicator (EIF_POINTER v, EIF_INTEGER li) {
	((struct ecli_c_value*)v)->length_indicator = (long) li;
}

EIF_INTEGER ecli_c_value_get_length (EIF_POINTER v) {
	return (EIF_INTEGER) 	((struct ecli_c_value*)v)->length;
}

EIF_INTEGER ecli_c_value_get_length_indicator (EIF_POINTER v) {
	return (EIF_INTEGER) 	((struct ecli_c_value*)v)->length_indicator;
}

EIF_POINTER ecli_c_value_get_length_indicator_pointer (EIF_POINTER v) {
	return (EIF_POINTER) 	&(((struct ecli_c_value*)v)->length_indicator);
}

void ecli_c_value_set_value (EIF_POINTER v, EIF_POINTER new_value, EIF_INTEGER actual_length) {
	memcpy ((void*)((struct ecli_c_value*)v)->value, (const void*)new_value, actual_length);
}

EIF_POINTER ecli_c_value_get_value (EIF_POINTER v) {
	return (EIF_POINTER) ((struct ecli_c_value*)v)->value;
}

void ecli_c_value_copy_value (EIF_POINTER v, EIF_POINTER dest) {
	memcpy ((void*)dest, (void*) ((struct ecli_c_value*)v)->value, ((struct ecli_c_value*)v)->length);
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


/* Return codes */

EIF_INTEGER	ecli_c_ok () {
		return (EIF_INTEGER) SQL_SUCCESS	;
}

EIF_INTEGER	ecli_c_ok_with_info () {
		return (EIF_INTEGER) SQL_SUCCESS_WITH_INFO	;
}

EIF_INTEGER	ecli_c_no_data () {
		return (EIF_INTEGER) SQL_NO_DATA	;
}

EIF_INTEGER	ecli_c_error () {
		return (EIF_INTEGER) SQL_ERROR	;
}

EIF_INTEGER	ecli_c_invalid_handle () {
		return (EIF_INTEGER) SQL_INVALID_HANDLE	;
}

EIF_INTEGER	ecli_c_need_data () {
		return (EIF_INTEGER) SQL_NEED_DATA	;
}

EIF_INTEGER	ecli_c_null_data () {
		return (EIF_INTEGER) SQL_NULL_DATA	;
}

EIF_INTEGER ecli_c_no_total () {
		return (EIF_INTEGER) SQL_NO_TOTAL;
}

EIF_INTEGER ecli_c_no_nulls () {
		return (EIF_INTEGER) SQL_NO_NULLS;
}

EIF_INTEGER ecli_c_nullable () {
		return (EIF_INTEGER) SQL_NULLABLE;
}

EIF_INTEGER ecli_c_nullable_unknown () {
		return (EIF_INTEGER) SQL_NULLABLE_UNKNOWN;
}

/* SQL Data types */
EIF_INTEGER ecli_c_sql_char () {
	return (EIF_INTEGER) SQL_CHAR  ;
}


EIF_INTEGER ecli_c_sql_numeric () {
	return (EIF_INTEGER) SQL_NUMERIC  ;
}


EIF_INTEGER ecli_c_sql_decimal () {
	return (EIF_INTEGER) SQL_DECIMAL ;
}


EIF_INTEGER ecli_c_sql_integer () {
	return (EIF_INTEGER) SQL_INTEGER ;
}


EIF_INTEGER ecli_c_sql_smallint () {
	return (EIF_INTEGER) SQL_SMALLINT ;
}


EIF_INTEGER ecli_c_sql_float () {
	return (EIF_INTEGER) SQL_FLOAT   ;
}


EIF_INTEGER ecli_c_sql_real () {
	return (EIF_INTEGER) SQL_REAL ;
}


EIF_INTEGER ecli_c_sql_double () {
	return (EIF_INTEGER) SQL_DOUBLE ;
}


EIF_INTEGER ecli_c_sql_varchar () {
	return (EIF_INTEGER) SQL_VARCHAR ;
}



EIF_INTEGER ecli_c_sql_type_date () {
	return (EIF_INTEGER) SQL_TYPE_DATE ;
}


EIF_INTEGER ecli_c_sql_type_time () {
	return (EIF_INTEGER) SQL_TYPE_TIME ;
}


EIF_INTEGER ecli_c_sql_type_timestamp () {
	return (EIF_INTEGER) SQL_TYPE_TIMESTAMP  ;
}


EIF_INTEGER ecli_c_sql_longvarchar () {
	return (EIF_INTEGER) SQL_LONGVARCHAR  ;
}

/* SQL C Types */

EIF_INTEGER ecli_c_sql_c_char () {
	return (EIF_INTEGER) SQL_C_CHAR  ;
}


EIF_INTEGER ecli_c_sql_c_long () {
	return (EIF_INTEGER) SQL_C_LONG   ;
}


EIF_INTEGER ecli_c_sql_c_short () {
	return (EIF_INTEGER) SQL_C_SHORT  ;
}


EIF_INTEGER ecli_c_sql_c_float () {
	return (EIF_INTEGER) SQL_C_FLOAT   ;
}


EIF_INTEGER ecli_c_sql_c_double () {
	return (EIF_INTEGER) SQL_C_DOUBLE   ;
}


EIF_INTEGER ecli_c_sql_c_numeric () {
	return (EIF_INTEGER)	SQL_C_NUMERIC	 ;
}


EIF_INTEGER ecli_c_sql_c_default () {
	return (EIF_INTEGER) SQL_C_DEFAULT ;
}

EIF_INTEGER ecli_c_sql_c_type_date () {
	return (EIF_INTEGER) SQL_C_TYPE_DATE    ;
}


EIF_INTEGER ecli_c_sql_c_type_time () {
	return (EIF_INTEGER) SQL_C_TYPE_TIME    ;
}


EIF_INTEGER ecli_c_sql_c_type_timestamp () {
	return (EIF_INTEGER) SQL_C_TYPE_TIMESTAMP   ;
}



