note

	description:
	
			"Connection attribute constants : keys and values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_CONNECTION_ATTRIBUTE_CONSTANTS

feature -- Keys

	--  connection attributes 
	Sql_access_mode	:	INTEGER =	101
	Sql_autocommit	:	INTEGER =	102
	Sql_login_timeout	:	INTEGER =	103
	Sql_opt_trace	:	INTEGER =	104
	Sql_opt_tracefile	:	INTEGER =	105
	Sql_translate_dll	:	INTEGER =	106
	Sql_translate_option	:	INTEGER =	107
	Sql_txn_isolation	:	INTEGER =	108
	Sql_current_qualifier	:	INTEGER =	109
	Sql_odbc_cursors	:	INTEGER =	110
	Sql_quiet_mode	:	INTEGER =	111
	Sql_packet_size	:	INTEGER =	112

	--  connection attributes with new names 
	 -- IF (ODBCVER >= 0x0300)
	Sql_attr_access_mode	:	INTEGER = 101
	Sql_attr_autocommit	:	INTEGER = 102
	Sql_attr_connection_timeout	:	INTEGER =	113
	Sql_attr_current_catalog	:	INTEGER = 109
	Sql_attr_disconnect_behavior	:	INTEGER =	114
	Sql_attr_enlist_in_dtc	:	INTEGER =	1207
	Sql_attr_enlist_in_xa	:	INTEGER =	1208
	Sql_attr_login_timeout	:	INTEGER = 103
	Sql_attr_odbc_cursors	:	INTEGER = 110
	Sql_attr_packet_size	:	INTEGER = 112
	Sql_attr_quiet_mode	:	INTEGER = 111
	Sql_attr_trace	:	INTEGER = 104
	Sql_attr_tracefile	:	INTEGER = 105
	Sql_attr_translate_lib	:	INTEGER = 106
	Sql_attr_translate_option	:	INTEGER = 107
	Sql_attr_txn_isolation	:	INTEGER = 108
	Sql_attr_connection_dead	:	INTEGER =	1209	 --  GetConnectAttr only 

--SQL_ATTR_ACCESS_MODE
--	Either[1]
--	(ODBC 1.0)
--	An SQLUINTEGER value. SQL_MODE_READ_ONLY is used by the driver or data source as an indicator that the connection is not required to support SQL statements that cause updates to occur. This mode can be used to optimize locking strategies, transaction management, or other areas as appropriate to the driver or data source. The driver is not required to prevent such statements from being submitted to the data source. The behavior of the driver and data source when asked to process SQL statements that are not read-only during a read-only connection is implementation-defined. SQL_MODE_READ_WRITE is the default. 

--SQL_ATTR_ASYNC_ENABLE
--	Either[2]
--	(ODBC 3.0)
--	An SQLUINTEGER value that specifies whether a function called with a statement on the specified connection is executed asynchronously: 
--	SQL_ASYNC_ENABLE_OFF = Off (the default)
--	SQL_ASYNC_ENABLE_ON = On
--	
--	Setting SQL_ASYNC_ENABLE_ON enables asynchronous execution for all future statement handles allocated on this connection. It is driver-defined whether this enables asynchronous execution for existing statement handles associated with this connection. An error is returned if asynchronous execution is enabled while there is an active statement on the connection.
--	
--	This attribute can be set whether SQLGetInfo with the SQL_ASYNC_MODE information type returns SQL_AM_CONNECTION or SQL_AM_STATEMENT.
--	
--	After a function has been called asynchronously, only the original function, SQLAllocHandle, SQLCancel, SQLGetDiagField, or SQLGetDiagRec can be called on the statement or the connection associated with StatementHandle, until the original function returns a code other than SQL_STILL_EXECUTING. Any other function called on StatementHandle or the connection associated with StatementHandle returns SQL_ERROR with an SQLSTATE of HY010 (Function sequence error). Functions can be called on other statements. For more information, see Asynchronous Execution.
--	
--	In general, applications should execute functions asynchronously only on single-thread operating systems. On multithread operating systems, applications should execute functions on separate threads rather than executing them asynchronously on the same thread. Drivers that operate only on multithread operating systems do not need to support asynchronous execution.
--	
--	The following functions can be executed asynchronously:
--	
--	SQLBulkOperations
--	SQLColAttribute
--	SQLColumnPrivileges
--	SQLColumns
--	SQLCopyDesc
--	SQLDescribeCol
--	SQLDescribeParam
--	SQLExecDirect
--	SQLExecute
--	SQLFetch
--	SQLFetchScroll
--	SQLForeignKeys
--	SQLGetData
--	SQLGetDescField[1]
--	SQLGetDescRec[1]
--	SQLGetDiagField
--	SQLGetDiagRec
--	SQLGetTypeInfo
--	SQLMoreResults
--	SQLNumParams
--	SQLNumResultCols
--	SQLParamData
--	SQLPrepare
--	SQLPrimaryKeys
--	SQLProcedureColumns
--	SQLProcedures
--	SQLPutData
--	SQLSetPos
--	SQLSpecialColumns
--	SQLStatistics
--	SQLTablePrivileges
--	SQLTables

--SQL_ATTR_AUTO_IPD
--	(ODBC 3.0)
--	A read-only SQLUINTEGER value that specifies whether automatic population of the IPD after a call to SQLPrepare is supported: 
--	SQL_TRUE = Automatic population of the IPD after a call to SQLPrepare is supported by the driver.
--	
--	SQL_FALSE = Automatic population of the IPD after a call to SQLPrepare is not supported by the driver. Servers that do not support prepared statements will not be able to populate the IPD automatically. 
--	
--	If SQL_TRUE is returned for the SQL_ATTR_AUTO_IPD connection attribute, the statement attribute SQL_ATTR_ENABLE_AUTO_IPD can be set to turn automatic population of the IPD on or off. If SQL_ATTR_AUTO_IPD is SQL_FALSE, SQL_ATTR_ENABLE_AUTO_IPD cannot be set to SQL_TRUE. The default value of SQL_ATTR_ENABLE_AUTO_IPD is equal to the value of SQL_ATTR_AUTO_IPD.
--	
--	This connection attribute can be returned by SQLGetConnectAttr but cannot be set by SQLSetConnectAttr.

--SQL_ATTR_AUTOCOMMIT
--	Either
--	(ODBC 1.0)
--	An SQLUINTEGER value that specifies whether to use autocommit or manual-commit mode: 
--	SQL_AUTOCOMMIT_OFF = The driver uses manual-commit mode, and the application must explicitly commit or roll back transactions with SQLEndTran.
--	
--	SQL_AUTOCOMMIT_ON = The driver uses autocommit mode. Each statement is committed immediately after it is executed. This is the default. Any open transactions on the connection are committed when SQL_ATTR_AUTOCOMMIT is set to SQL_AUTOCOMMIT_ON to change from manual-commit mode to autocommit mode.
--	
--	For more information, see Commit Mode.
--	
--	Important   Some data sources delete the access plans and close the cursors for all statements on a connection each time a statement is committed; autocommit mode can cause this to happen after each nonquery statement is executed or when the cursor is closed for a query. For more information, see the SQL_CURSOR_COMMIT_BEHAVIOR and SQL_CURSOR_ROLLBACK_BEHAVIOR information types in SQLGetInfo and Effect of Transactions on Cursors and Prepared Statements.
--	When a batch is executed in autocommit mode, two things are possible. The entire batch can be treated as an autocommitable unit, or each statement in a batch is treated as an autocommitable unit. Certain data sources can support both these behaviors and may provide a way of choosing one or the other. It is driver-defined whether a batch is treated as an autocommitable unit or whether each individual statement within the batch is autocommitable.

--	SQL_ATTR_CONNECTION_DEAD 
--	(ODBC 3.5)
--	 An SQLUINTERGER value that indicates the state of the connection. If SQL_CD_TRUE, the connection has been lost. If SQL_CD_FALSE, the connection is still active. 

--SQL_ATTR_CONNECTION_TIMEOUT
--	Either
--	(ODBC 3.0)
--	An SQLUINTEGER value corresponding to the number of seconds to wait for any request on the connection to complete before returning to the application. The driver should return SQLSTATE HYT00 (Timeout expired) anytime that it is possible to time out in a situation not associated with query execution or login.
--	If ValuePtr is equal to 0 (the default), there is no timeout.

--SQL_ATTR_CURRENT_CATALOG
--	Either[1]
--	(ODBC 2.0)
--	A character string containing the name of the catalog to be used by the data source. For example, in SQL Server, the catalog is a database, so the driver sends a USE database statement to the data source, where database is the database specified in *ValuePtr. For a single-tier driver, the catalog might be a directory, so the driver changes its current directory to the directory specified in *ValuePtr. 

--SQL_ATTR_LOGIN_TIMEOUT
--	Before
--	(ODBC 1.0)
--	An SQLUINTEGER value corresponding to the number of seconds to wait for a login request to complete before returning to the application. The default is driver-dependent. If ValuePtr is 0, the timeout is disabled and a connection attempt will wait indefinitely. 
--	If the specified timeout exceeds the maximum login timeout in the data source, the driver substitutes that value and returns SQLSTATE 01S02 (Option value changed).

--SQL_ATTR_METADATA_ID
--	Either
--	(ODBC 3.0)
--	An SQLUINTEGER value that determines how the string arguments of catalog functions are treated. 
--	If SQL_TRUE, the string argument of catalog functions are treated as identifiers. The case is not significant. For nondelimited strings, the driver removes any trailing spaces and the string is folded to uppercase. For delimited strings, the driver removes any leading or trailing spaces and takes literally whatever is between the delimiters. If one of these arguments is set to a null pointer, the function returns SQL_ERROR and SQLSTATE HY009 (Invalid use of null pointer). 
--	
--	If SQL_FALSE, the string arguments of catalog functions are not treated as identifiers. The case is significant. They can either contain a string search pattern or not, depending on the argument.
--	
--	The default value is SQL_FALSE.
--	
--	The TableType argument of SQLTables, which takes a list of values, is not affected by this attribute.
--	
--	SQL_ATTR_METADATA_ID can also be set on the statement level. (It is the only connection attribute that is also a statement attribute.)
--	
--	For more information, see Arguments in Catalog Functions.

--SQL_ATTR_ODBC_CURSORS
--	Before
--	(ODBC 2.0)
--	An SQLUINTEGER value specifying how the Driver Manager uses the ODBC cursor library: 
--	SQL_CUR_USE_IF_NEEDED = The Driver Manager uses the ODBC cursor library only if it is needed. If the driver supports the SQL_FETCH_PRIOR option in SQLFetchScroll, the Driver Manager uses the scrolling capabilities of the driver. Otherwise, it uses the ODBC cursor library.
--	
--	SQL_CUR_USE_ODBC = The Driver Manager uses the ODBC cursor library.
--	
--	SQL_CUR_USE_DRIVER = The Driver Manager uses the scrolling capabilities of the driver. This is the default setting.
--	
--	For more information about the ODBC cursor library, see Appendix F: ODBC Cursor Library.

--SQL_ATTR_PACKET_SIZE
--	Before
--	(ODBC 2.0)
--	An SQLUINTEGER value specifying the network packet size in bytes. 
--	Note   Many data sources either do not support this option or only can return but not set the network packet size.
--	If the specified size exceeds the maximum packet size or is smaller than the minimum packet size, the driver substitutes that value and returns SQLSTATE 01S02 (Option value changed).
--	
--	If the application sets packet size after a connection has already been made, the driver will return SQLSTATE HY011 (Attribute cannot be set now).

--SQL_ATTR_QUIET_MODE
--	Either
--	(ODBC 2.0)
--	A 32-bit window handle (hwnd). 
--	If the window handle is a null pointer, the driver does not display any dialog boxes.
--	
--	If the window handle is not a null pointer, it should be the parent window handle of the application. This is the default. The driver uses this handle to display dialog boxes.
--	
--	Note   The SQL_ATTR_QUIET_MODE connection attribute does not apply to dialog boxes displayed by SQLDriverConnect. 

--SQL_ATTR_TRACE
--	Either
--	(ODBC 1.0)
--	An SQLUINTEGER value telling the Driver Manager whether to perform tracing: 
--	SQL_OPT_TRACE_OFF = Tracing off (the default)
--	
--	SQL_OPT_TRACE_ON = Tracing on
--	
--	When tracing is on, the Driver Manager writes each ODBC function call to the trace file.
--	
--	Note   When tracing is on, the Driver Manager can return SQLSTATE IM013 (Trace file error) from any function.
--	An application specifies a trace file with the SQL_ATTR_TRACEFILE option. If the file already exists, the Driver Manager appends to the file. Otherwise, it creates the file. If tracing is on and no trace file has been specified, the Driver Manager writes to the file SQL.LOG in the root directory. 
--	
--	An application can set the variable ODBCSharedTraceFlag to enable tracing dynamically. Tracing is then enabled for all ODBC applications currently running. If an application turns tracing off, it is turned off only for that application.
--	
--	If the Trace keyword in the system information is set to 1 when an application calls SQLAllocHandle with a HandleType of SQL_HANDLE_ENV, tracing is enabled for all handles. It is enabled only for the application that called SQLAllocHandle.
--	
--	Calling SQLSetConnectAttr with an Attribute of SQL_ATTR_TRACE does not require that the ConnectionHandle argument be valid and will not return SQL_ERROR if ConnectionHandle is NULL. This attribute applies to all connections.

--SQL_ATTR_TRACEFILE
--	Either
--	(ODBC 1.0)
--	A null-terminated character string containing the name of the trace file. 
--	The default value of the SQL_ATTR_TRACEFILE attribute is specified with the TraceFile keyword in the system information. For more information, see ODBC Subkey.
--	
--	Calling SQLSetConnectAttr with an Attribute of SQL_ATTR_ TRACEFILE does not require the ConnectionHandle argument to be valid and will not return SQL_ERROR if ConnectionHandle is invalid. This attribute applies to all connections.

--SQL_ATTR_TRANSLATE_LIB
--	After
--	(ODBC 1.0)
--	A null-terminated character string containing the name of a library containing the functions SQLDriverToDataSource and SQLDataSourceToDriver that the driver accesses to perform tasks such as character set translation. This option may be specified only if the driver has connected to the data source. The setting of this attribute will persist across connections. For more information about translating data, see Translation DLLs and Translation DLL Function Reference. 

--SQL_ATTR_TRANSLATE_OPTION
--	After
--	(ODBC 1.0)
--	A 32-bit flag value that is passed to the translation DLL. This attribute can be specified only if the driver has connected to the data source. For information about translating data, see Translation DLLs. 


feature -- Values

	--  Sql_access_mode options 
	Sql_mode_read_write	:	INTEGER =	0
	Sql_mode_read_only	:	INTEGER =	1
	Sql_mode_default	:	INTEGER = 0 -- Sql_mode_read_write

	--  Sql_autocommit options 
	Sql_autocommit_off	:	INTEGER =	0
	Sql_autocommit_on	:	INTEGER =	1
	Sql_autocommit_default	:	INTEGER = 1 -- Sql_autocommit_on

	--  Sql_login_timeout options 
	Sql_login_timeout_default	:	INTEGER =	15

	--  Sql_opt_trace options 
	Sql_opt_trace_off	:	INTEGER =	0
	Sql_opt_trace_on	:	INTEGER =	1
	Sql_opt_trace_default	:	INTEGER = 0 -- Sql_opt_trace_off
	Sql_opt_trace_file_default	:	STRING =	"\SQL.LOG"

	--  Sql_odbc_cursors options 
	Sql_cur_use_if_needed	:	INTEGER =	0
	Sql_cur_use_odbc	:	INTEGER =	1
	Sql_cur_use_driver	:	INTEGER =	2
	Sql_cur_default	:	INTEGER = 2 -- Sql_cur_use_driver

	 -- IF (ODBCVER >= 0x0300)
	--  values for Sql_attr_disconnect_behavior 
	Sql_db_return_to_pool	:	INTEGER =	0
	Sql_db_disconnect	:	INTEGER =	1
	Sql_db_default	:	INTEGER = 0 -- Sql_db_return_to_pool

	--  values for Sql_attr_enlist_in_dtc 
	Sql_dtc_done	:	INTEGER =	0
	 -- ENDIF   --  ODBCVER >= 0x0300 

	--  values for Sql_attr_connection_dead 
	Sql_cd_true	:	INTEGER =	1		 --  Connection is	closed/dead 
	Sql_cd_false	:	INTEGER =	0	 --  Connection is	open/available 

end
