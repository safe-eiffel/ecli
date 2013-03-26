note

	description:

		"Objects that represent a session to a database."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_SESSION

inherit

	ECLI_STATUS
		export
			{ECLI_LOGIN_STRATEGY} set_status
		redefine
			default_create
		end

	ECLI_HANDLE
		export
			{ANY} is_valid;
			{ECLI_LOGIN_STRATEGY, ECLI_HANDLE, ECLI_DBMS_INFORMATION} handle
		undefine
			default_create
		end

	ECLI_SHARED_ENVIRONMENT
		undefine
			default_create
		end

	PAT_PUBLISHER [ECLI_STATEMENT]
		rename
			subscribe as register_statement,
			unsubscribe as unregister_statement,
			has_subscribed as is_registered_statement,
			subscribers as statements,
			count as statements_count
		export
			{ECLI_STATEMENT}
				register_statement,
				unregister_statement,
				is_registered_statement
		redefine
			default_create
		end

	PAT_SUBSCRIBER[ECLI_ENVIRONMENT]
		rename
			publisher as environment,
			published as environment_release,
			has_publisher as has_environment,
			unsubscribed as is_closed
		undefine
			default_create
		redefine
			environment_release,
			environment
		end


	ECLI_TRANSACTION_CAPABILITY_CONSTANTS
		undefine
			default_create
		end

create

	make_default

feature -- Initialization

	make_default
			-- Default creation.
		require
			is_closed: is_closed
		do
			default_create
			create error_handler.make_null
			allocate
			reset_implementation
		ensure
			valid: is_valid
			open: not is_closed
		end

feature {NONE} -- Initialization

	default_create
		do
			Precursor {ECLI_STATUS}
			Precursor {PAT_PUBLISHER}
		end

feature -- Access

	login_strategy : detachable ECLI_LOGIN_STRATEGY
			-- Login strategy used for connection.

	data_source : STRING
			-- Data source used for connection
		obsolete "[2004-12-23]Use `login_strategy' instead."
		do
			Result := simple_login.datasource_name
		end

	user_name : STRING
			-- User name used for connection
		obsolete "[2004-12-23]Use `login_strategy' instead."
		do
			Result := simple_login.user_name
		end

	password : STRING
			-- Password used for connection
		obsolete "[2004-12-23]Use `login_strategy' instead."
		do
			Result := simple_login.password
		end

	info : ECLI_DBMS_INFORMATION
			-- Various informations about underlying DBMS.
		do
			if attached impl_info as l_info then
				Result := l_info
			else
				create Result.make (Current)
				impl_info := Result
			end
		end

	transaction_capability : INTEGER
			-- Transaction capability of established session
		require
			connected: is_connected
		do
			--| evaluate capability
			if impl_transaction_capability < sql_tc_none then
				set_status ("ecli_c_transaction_capable", ecli_c_transaction_capable (handle, ext_transaction_capability.handle))
			end
			Result := impl_transaction_capability
		ensure
			definition: Result = Sql_tc_all or else Result = Sql_tc_ddl_commit or else Result = Sql_tc_ddl_ignore
				or else Result = Sql_tc_dml or else Result = Sql_tc_none
		end

	tracer : detachable ECLI_TRACER
			-- Tracer of all SQL. Void implies no trace.

	api_trace_filename : STRING
			-- Name of the api trace file.
		local
			ext_string: XS_C_STRING
			int32: XS_C_INT32
		do
			create ext_string.make (2048)
			create int32.make
			set_status ("ecli_c_get_pointer_connection_attribute", ecli_c_get_pointer_connection_attribute (handle, att.sql_attr_tracefile, ext_string.handle, ext_string.capacity, int32.handle))
			Result := ext_string.substring (1, int32.item)
		ensure
			api_trace_filename_not_void: Result /= Void --FIXME: VS-DEL
		end

	transaction_isolation : ECLI_TRANSACTION_ISOLATION
			-- Current active transaction isolation options
		local
			ext_txn_isolation : XS_C_UINT32
		do
			create ext_txn_isolation.make
			set_status ("ecli_c_get_integer_connection_attribute", ecli_c_get_integer_connection_attribute (handle, att.Sql_attr_txn_isolation , ext_txn_isolation.handle))
			create Result.make (ext_txn_isolation.item)
		ensure
			transaction_isolation_not_void: Result /= Void --FIXME: VS-DEL
		end

	connection_timeout : DT_TIME_DURATION
			-- Duration corresponding to the number of seconds to wait for any request on the connection
			-- to complete before returning to the application.
			-- Result.second_count = 0 means no timeout
		local
			ext_connection_timeout: XS_C_UINT32
		do
			create ext_connection_timeout.make
			set_status ("ecli_c_get_integer_connection_attribute", ecli_c_get_integer_connection_attribute (handle, att.sql_attr_connection_timeout, ext_connection_timeout.handle))
			create Result.make_canonical (ext_connection_timeout.item)
		ensure
			connection_timeout_not_void: Result /= Void --FIXME: VS-DEL
		end

	login_timeout : DT_TIME_DURATION
			-- Duration corresponding to the number of seconds to wait for a login request to complete
			-- before returning to the application. The default is driver-dependent.
			-- Result.second_count = 0 means not timeout and a connection attempt will wait indefinitely.
		local
			ext_connection_timeout: XS_C_UINT32
		do
			create ext_connection_timeout.make
			set_status ("ecli_c_get_integer_connection_attribute", ecli_c_get_integer_connection_attribute (handle, att.sql_attr_login_timeout, ext_connection_timeout.handle))
			create Result.make_canonical (ext_connection_timeout.item)
		ensure
			login_timeout_not_void: Result /= Void --FIXME: VS-DEL
		end

	network_packet_size : INTEGER
			-- Network packet size.
			-- Note:   Many data sources either do not support this option or only can return but not set
			--         the network packet size.
		local
			uint32 : XS_C_UINT32
		do
			create uint32.make
			set_status ("ecli_c_get_integer_connection_attribute", ecli_c_get_integer_connection_attribute (handle, att.sql_attr_packet_size, uint32.handle))
			Result := uint32.item
		end

	set_network_packet_size (new_size : INTEGER)
			--  If the specified size exceeds the maximum packet size
			--  or is smaller than the minimum packet size, the driver substitutes that value and
			--  returns SQLSTATE 01S02 (Option value changed).
		require
			new_size_positive: new_size > 0
			not_connected: not is_connected
		do
			set_status ("ecli_c_set_integer_connection_attribute", ecli_c_set_integer_connection_attribute(handle, att.sql_attr_packet_size, new_size))
		ensure
			network_packet_size_set: (is_ok and not cli_state.is_equal ("01S02")) implies network_packet_size = new_size
		end

feature -- Status report

	has_pending_transaction : BOOLEAN
			-- Has the session a pending transaction ?
		do
			Result := impl_has_pending_transaction
		end

	is_manual_commit : BOOLEAN
			-- Is this session in 'manual commit mode' ?
		require
			valid: is_valid
			connected: is_connected
		do
			set_status ("ecli_c_is_manual_commit", ecli_c_is_manual_commit (handle, ext_is_manual_commit.handle))
			Result := impl_is_manual_commit
		end

	is_ready_to_connect : BOOLEAN
			-- Is this session ready to be connected ?
		do
			Result := attached login_strategy
		ensure
			definition: Result = (attached login_strategy)
		end

	is_connected : BOOLEAN
			-- Is this session connected to a database ?
		do
			Result := impl_is_connected
		ensure
			connected_valid: Result implies is_valid
		end

	is_connection_dead : BOOLEAN
			-- Is the connection dead ?
		local
			uint_result : XS_C_UINT32
		do
			create uint_result.make
			set_status ("ecli_c_get_integer_connection_attribute", ecli_c_get_integer_connection_attribute (handle, att.Sql_attr_connection_dead,uint_result.handle))
			Result := (uint_result.item = att.Sql_cd_true)
		end

	is_transaction_capable : BOOLEAN
		require
			connected: is_connected
		do
			Result := transaction_capability /= sql_tc_none
		ensure
			capability: Result implies (transaction_capability = sql_tc_all or
				transaction_capability = sql_tc_dml or
				transaction_capability = sql_tc_ddl_commit or
				transaction_capability = sql_tc_ddl_ignore )
		end

	is_describe_parameters_capable : BOOLEAN
			-- Can 'ECLI_STATEMENT.describe_parameters' be called ?
		local
			functions : ECLI_FUNCTIONS_CONSTANTS
		do
			create functions
			if impl_describe_parameters_capability < sql_false then
				set_status ("ecli_c_sql_get_functions", ecli_c_sql_get_functions (handle, functions.Sql_api_sqldescribeparam, ext_describe_parameters_capability.handle))
			end
			Result := impl_describe_parameters_capability = sql_true
		end

	is_bind_arrayed_parameters_capable : BOOLEAN
			-- Can arrayed parameters be used in rowset operations ?
		local
			dummy_statement : ECLI_STATEMENT
		do
			if impl_is_bind_arrayed_parameters_capability < 0 then
				create dummy_statement.make (Current)
				if dummy_statement.can_use_arrayed_parameters then
					impl_is_bind_arrayed_parameters_capability := 1
				else
					impl_is_bind_arrayed_parameters_capability := 0
				end
				dummy_statement.close
			end
			Result := impl_is_bind_arrayed_parameters_capability = 1
		end

	is_bind_arrayed_results_capable : BOOLEAN
			-- Can arrayed results be used  ?
		local
			dummy_statement : ECLI_STATEMENT
		do
			if impl_is_bind_arrayed_results_capability < 0 then
				create dummy_statement.make (Current)
				if dummy_statement.can_use_arrayed_results then
					impl_is_bind_arrayed_results_capability := 1
				else
					impl_is_bind_arrayed_results_capability := 0
				end
				dummy_statement.close
			end
			Result := impl_is_bind_arrayed_results_capability = 1
		end

	is_tracing : BOOLEAN
			-- Is this session tracing SQL statements ?
		do
			Result := attached tracer
		ensure
			tracing_is_tracer_not_void: Result = (attached tracer)
		end

	is_api_tracing : BOOLEAN
			-- Is this session tracing ODBC/CLI api calls ?
		local
			uint32 : XS_C_UINT32
		do
			create uint32.make
			set_status ("ecli_c_get_integer_connection_attribute", ecli_c_get_integer_connection_attribute (handle, att.sql_attr_trace,uint32.handle))
			Result := (uint32.item = att.sql_opt_trace_on)
		end

feature -- Status setting

	set_manual_commit
			-- Set commit mode to `manual'
		require
			valid: is_valid
			connected: is_connected
			capable : is_transaction_capable
		do
			--| actual setting of manual commit
			set_status ("ecli_c_set_manual_commit", ecli_c_set_manual_commit (handle, True))
		ensure
			is_manual_commit
		end

	set_automatic_commit
			-- Set commit mode to `automatic'
		require
			valid: is_valid
			connected: is_connected
		do
			--| actual setting of automatic commit
			set_status ("ecli_c_set_manual_commit", ecli_c_set_manual_commit (handle, False))
		ensure
			automatic_commit: not is_manual_commit
		end

	disable_tracing
			-- Disable SQL tracing.
		require
			tracing: is_tracing
		do
			tracer := Void
		ensure
			not_tracing: not is_tracing
			no_tracer: not attached tracer
		end

	enable_api_tracing
			-- Enable ODBC API tracing into `api_trace_filename'.
--		require
--			-- FIXME: api_trace_filename set.
		do
			set_status ("ecli_c_set_integer_connection_attribute", ecli_c_set_integer_connection_attribute (handle, att.sql_attr_trace , att.sql_opt_trace_on))
		end

	disable_api_tracing
			-- Disable ODBC API tracing.
		do
			set_status ("ecli_c_set_integer_connection_attribute", ecli_c_set_integer_connection_attribute (handle, att.sql_attr_trace , att.sql_opt_trace_off))
		end

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

feature -- Element change

	set_login_strategy (new_login : ECLI_LOGIN_STRATEGY)
			-- Change `login_strategy' to `new_login'.
		require
			not_connected: not is_connected
			new_login_not_void: new_login /= Void
		do
			login_strategy := new_login
		ensure
			login_strategy_set: login_strategy = new_login
			ready_to_connect: is_ready_to_connect
		end

	set_user_name(a_user_name: STRING)
			-- Set `user' to `a_user'
		obsolete "[2004-12-23]Use `login_strategy' instead."
		require
			not_connected: not is_connected
			a_user_ok: a_user_name/= Void --FIXME: VS-DEL
		do
			simple_login.set_user_name (a_user_name)
		ensure
			user_name_set: user_name.is_equal (a_user_name)
		end

	set_data_source (a_data_source : STRING)
			-- Set `data_source' to `a_data_source'
		obsolete "[2004-12-23]Use `set_login_strategy' instead."
		require
			not_connected: not is_connected
			a_data_source_ok: a_data_source /= Void --FIXME: VS-DEL
		do
			simple_login.set_datasource_name (a_data_source)
		ensure
			data_source_set: data_source.is_equal (a_data_source)
		end

	set_password (a_password : STRING)
			-- Set password to 'a_password
		obsolete "[2004-12-23]Use `set_login_strategy' instead."
		require
			not_connected: not is_connected
			a_password_ok: a_password /= Void --FIXME: VS-DEL
		do
			simple_login.set_password (a_password)
		ensure
			password_set: password.is_equal (a_password)
		end

	set_tracer (a_tracer : ECLI_TRACER)
			-- Trace SQL with `a_tracer'.
		require
			tracer_ok: a_tracer /= Void --FIXME: VS-DEL
		do
			tracer := a_tracer
		ensure
			tracer_set: tracer = a_tracer
			tracing: is_tracing
		end

	set_transaction_isolation (an_isolation : ECLI_TRANSACTION_ISOLATION)
			-- Change transaction isolation level
		require
			an_isolation_not_void: an_isolation /= Void --FIXME: VS-DEL
			no_pending_transaction: not has_pending_transaction
		do
			set_status ("ecli_c_set_integer_connection_attribute", ecli_c_set_integer_connection_attribute (handle, att.Sql_attr_txn_isolation,  an_isolation.value))
		ensure
			done_when_ok: is_ok implies (transaction_isolation.is_equal (an_isolation))
		end

	set_login_timeout (duration : DT_TIME_DURATION)
			-- Set `login_timeout' to `duration'.
			-- If the specified timeout exceeds the maximum login timeout in the data source,
			-- the driver substitutes that value and returns SQLSTATE 01S02 (Option value changed).
		require
			not_connected: not is_connected
			duration_not_void: duration /= Void --FIXME: VS-DEL
		local
			uint32: XS_C_UINT32
		do
			create uint32.make
			uint32.put (duration.second_count)
			set_status ("ecli_c_set_integer_connection_attribute", ecli_c_set_integer_connection_attribute (handle, att.sql_attr_login_timeout,  uint32.item))
		ensure
			login_timeout_set: (is_ok and not cli_state.is_equal ("01S02")) implies login_timeout.is_equal (duration)
		end

	set_connection_timeout (duration : DT_TIME_DURATION)
			-- Set `connection_timeout' to `duration'.
			-- If the specified timeout exceeds the maximum connection timeout in the data source,
			-- the driver substitutes that value and returns SQLSTATE 01S02 (Option value changed).
		require
			not_connected: not is_connected
			duration_not_void: duration /= Void --FIXME: VS-DEL
		local
			uint32: XS_C_UINT32
		do
			create uint32.make
			uint32.put (duration.second_count)
			set_status ("ecli_c_set_integer_connection_attribute", ecli_c_set_integer_connection_attribute (handle, att.sql_attr_connection_timeout,  uint32.item))
		ensure
			connection_timeout_set: (is_ok and not cli_state.is_equal ("01S02")) implies connection_timeout.is_equal (duration)
		end

	set_api_trace_filename (filename : STRING; file_system : KI_FILE_SYSTEM)
			-- Set `api_trace_filename' to `filename'.
		require
			filename_not_void: filename /= Void --FIXME: VS-DEL
			file_system_not_void: file_system /= Void --FIXME: VS-DEL
			file_name_valid: file_system.directory_exists (file_system.dirname (filename))
			not_api_tracing: not is_api_tracing
		local
			xs_string : XS_C_STRING
		do
			create xs_string.make_from_string (filename)
			set_status ("ecli_c_set_pointer_connection_attribute", ecli_c_set_pointer_connection_attribute (handle, att.sql_attr_tracefile, xs_string.handle, filename.count))
		ensure
			api_trace_filename_set: is_ok implies attached file_system.basename (api_trace_filename) as f_api and then attached file_system.basename (filename) as fn and then f_api.is_equal (fn)
		end

feature -- Basic Operations

	begin_transaction
			-- Begin a new transaction
		require
			connected: is_connected
			capable : is_transaction_capable
		do
			set_manual_commit
			if is_ok then
				impl_has_pending_transaction := True
			end
			if is_tracing then
				tracer.trace_begin
			end
		ensure
			manual_commit:	is_manual_commit implies is_ok
			has_pending_transaction: has_pending_transaction implies is_ok
		end

	commit
			-- Commit current transaction
		require
			valid: is_valid
			connected: is_connected
			manual_commit: is_manual_commit
			pending_transaction: has_pending_transaction
		do
			set_status ("ecli_c_commit", ecli_c_commit (handle))
			if is_ok then
				impl_has_pending_transaction := False
			end
			set_automatic_commit
			if is_tracing then
				tracer.trace_commit
			end
		ensure
			no_pending_transaction: not has_pending_transaction implies is_ok
			automatic_commit : not is_manual_commit
		end

	rollback
			-- Rollback current transaction
		require
			valid: is_valid
			connected: is_connected
			manual_commit: is_manual_commit
			pending_transaction: has_pending_transaction
		do
			set_status ("ecli_c_rollback", ecli_c_rollback (handle))
			if is_ok then
				impl_has_pending_transaction := False
			end
			set_automatic_commit
			if is_tracing then
				tracer.trace_rollback
			end
		ensure
			no_pending_transaction: not has_pending_transaction implies is_ok
			automatic_commit : not is_manual_commit
		end

	connect
			-- Connect using `login_strategy'
		require
			is_valid: is_valid
			not_connected: not is_connected
			ready_to_connect: is_ready_to_connect
		do
			login_strategy.connect (Current)
			if is_ok and then status /= Sql_no_data then
				set_connected
			end
		ensure
			connected: is_connected implies is_ok
		end

	connect_with_strategy (new_strategy: ECLI_LOGIN_STRATEGY)
			-- Connect using `new_strategy'.
		require
			is_valid: is_valid
			not_connected: not is_connected
		do
			login_strategy := new_strategy
			connect
		ensure
			login_set: login_strategy = new_strategy
			connected: is_connected implies is_ok
		end

	disconnect
			-- Disconnect the session and close any remaining statement
		require
			is_valid: is_valid
			connected: is_connected
		local
			statements_cursor: like statements.new_cursor
		do
			-- First close all statements, if any
			if statements_count > 0 then
					from
						statements_cursor := statements.new_cursor
						check attached statements_cursor end
						statements_cursor.start
					until
						statements_cursor.off
					loop
						statements_cursor.item.do_close
						statements_cursor.forth
					end
				end
				statements.wipe_out
				statements_count := 0
			do_disconnect
		ensure
			not_connected: not is_connected implies is_ok
			no_opened_statements: statements_count = 0
		end

	close
			-- Close the session
		require
			valid: is_valid
			not_connected: not is_connected
			not_closed: not is_closed
		do
			if not is_closed then
				environment.unregister_session (Current)
			end
			release_handle
			environment := Void
		ensure
			closed:     	is_closed
			unregistered:	not (old environment).is_registered_session (Current)
			not_valid:  	not is_valid
		end

feature {ECLI_ENVIRONMENT} --

	environment_release (env : like environment)
			-- Environment is being released
		do
			if is_connected then
				disconnect
			end
			release_handle
			environment := Void
		ensure then
			released_environment: is_closed = True
		end

feature {NONE} -- Implementation

	simple_login : detachable ECLI_SIMPLE_LOGIN is
		do
			if attached {ECLI_SIMPLE_LOGIN} login_strategy as l then
				Result := l
			end
		end

	reset_implementation
			-- Reset all implementation values to default ones
		do
			ext_transaction_capability.put (sql_tc_none - 1)
			ext_describe_parameters_capability.put (sql_false - 1)
			impl_is_bind_arrayed_parameters_capability := -1
			impl_is_bind_arrayed_results_capability := -1
		end

	release_handle
		do
			if is_connected then
				do_disconnect
			end
			if handle /= default_pointer then
				set_status_without_report ("ecli_c_free_connection", ecli_c_free_connection (handle))
			end
			set_handle ( default_pointer)
		end

	impl_has_pending_transaction : BOOLEAN

	set_connected
		do
			impl_is_connected := True
		end

	set_disconnected
		do
			impl_is_connected := False
		end

	impl_is_connected : BOOLEAN

	impl_info : detachable like info

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER
			-- To be redefined in descendant classes
		do
			Result := ecli_c_session_error (handle, record_index, state, native_error, message, buffer_length, length_indicator)

		end

	impl_is_manual_commit : BOOLEAN
		do
			Result := ext_is_manual_commit.item
		end

	impl_transaction_capability : INTEGER
		do
			Result := ext_transaction_capability.item
		end

	ext_is_manual_commit : XS_C_BOOLEAN
	ext_transaction_capability : XS_C_INT32
	ext_describe_parameters_capability : XS_C_INT32

	impl_describe_parameters_capability : INTEGER do Result := ext_describe_parameters_capability.item end

	impl_is_bind_arrayed_parameters_capability : INTEGER
	impl_is_bind_arrayed_results_capability	: INTEGER

	allocate
			-- Allocate HANDLE
		require
			is_closed: is_closed
		local
			henv : pointer
			ext_handle : XS_C_POINTER
		do
			create ext_handle.make
			create ext_is_manual_commit.make
			create ext_transaction_capability.make
			create ext_describe_parameters_capability.make

			-- | Allocate session handle
			environment := shared_environment
			henv := environment.handle
			set_status ("ecli_c_allocate_connection", ecli_c_allocate_connection(henv, ext_handle.handle))
			handle := ext_handle.item
			--| register with environment
			environment.register_session (Current)
		ensure
			registered: environment.is_registered_session (Current)
			valid: is_valid
		end

	is_ready_for_disposal : BOOLEAN
			-- Is this object ready for disposal ?
		do
			Result := statements_count = 0
		end

	disposal_failure_reason : STRING
		once
			Result := "ECLI_STATEMENT still opened on Current; Close them before closing this session."
		end

	environment : detachable ECLI_ENVIRONMENT

	do_disconnect
			-- Do disconnect
		do
			--| actual disconnect
			set_status ("ecli_c_disconnect", ecli_c_disconnect (handle))
			if is_ok then
				set_disconnected
			end
		end

	att : ECLI_CONNECTION_ATTRIBUTE_CONSTANTS
		once
			create Result
		end

invariant
	valid_session: (attached environment) implies environment = shared_environment
	info_not_void: info /= Void --FIXME: VS-DEL
end
