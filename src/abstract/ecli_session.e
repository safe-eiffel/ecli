indexing

	description:

		"Objects that represent a session to a database"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_SESSION

inherit

	ECLI_STATUS

	ECLI_HANDLE
		export
			{ANY} is_valid
		end

	ECLI_SHARED_ENVIRONMENT

	PAT_PUBLISHER [ECLI_STATEMENT]
		rename
			subscribe as register_statement,
			unsubscribe as unregister_statement,
			has_subscribed as is_registered_statement,
			subscribers as statements,
			impl_subscribers as impl_statements,
			count as statements_count
		export
			{ECLI_STATEMENT}
				register_statement,
				unregister_statement,
				is_registered_statement
		end

	PAT_SUBSCRIBER
		rename
			publisher as environment,
			published as environment_release,
			has_publisher as has_environment,
			unsubscribed as is_closed
		redefine
			environment_release
		end

	ECLI_TRANSACTION_CAPABILITY_CONSTANTS

creation

	make

feature -- Initialization

	make, open (a_data_source, a_user_name, a_password : STRING) is
			-- Make session using `session_string'
		require
			data_source_defined: a_data_source /= Void
			user_name_defined: a_user_name/= Void
			password_defined: a_password /= Void
			closed: is_closed
		do
			-- Set data_source, user_name and password
			set_data_source (a_data_source)
			set_user_name(a_user_name)
			set_password (a_password)
			allocate
			reset_implementation
		ensure
			data_source_set : data_source.is_equal (a_data_source)
			user_name_set : user_name.is_equal (a_user_name)
			password_set : password.is_equal (a_password)
			valid: is_valid
			open:  not is_closed
		end

	attach is
			-- Attach current session object to shared CLI environment
		obsolete "Use open /close instead of attach/release"
		do
		end

	release is
			-- Release current session object from environment.  Ready for disposal
		obsolete "Use open/close instead of attach/release"
		do
		end

feature -- Access

	data_source : STRING is
			-- Data source used for connection
		do
			Result := impl_data_source.as_string
		end

	user_name : STRING is
			-- User name used for connection
		do
			Result := impl_user_name.as_string
		end

	password : STRING is
			-- Password used for connection
		do
			Result := impl_password.as_string
		end

	transaction_capability : INTEGER is
			-- Transaction capability of established session
		require
			connected: is_connected
		do
			--| evaluate capability
			if impl_transaction_capability < sql_tc_none then
				set_status (ecli_c_transaction_capable (handle, ext_transaction_capability.handle))
			end
			Result := impl_transaction_capability
		ensure
			definition: Result = Sql_tc_all or else Result = Sql_tc_ddl_commit or else Result = Sql_tc_ddl_ignore
				or else Result = Sql_tc_dml or else Result = Sql_tc_none
		end

	tracer : ECLI_TRACER
			-- Tracer of all session activity; Void implies no trace

	transaction_isolation : ECLI_TRANSACTION_ISOLATION is
			-- Current active transaction isolation options
		local
			ext_txn_isolation : XS_C_UINT32
			att : ECLI_CONNECTION_ATTRIBUTE_CONSTANTS
		do
			create ext_txn_isolation.make
			create att
			set_status (ecli_c_get_integer_connection_attribute (handle, att.Sql_attr_txn_isolation , ext_txn_isolation.handle))
			create Result.make (ext_txn_isolation.item)
		ensure
			Result_not_void: Result /= Void
		end
		
feature -- Status report

	has_pending_transaction : BOOLEAN is
			-- Has the session a pending transaction ?
		do
			Result := impl_has_pending_transaction
		end

	is_manual_commit : BOOLEAN is
			-- Is this session in 'manual commit mode' ?
		require
			valid: is_valid
			connected: is_connected
		do
			set_status (ecli_c_is_manual_commit (handle, ext_is_manual_commit.handle))
			Result := impl_is_manual_commit
		end

	is_ready_to_connect : BOOLEAN is
			-- Is this session ready to be connected ?
		do
			Result := (data_source /= Void and then user_name/= Void and then password /= Void)
		ensure
			definition: Result = (data_source /= Void and then user_name/= Void and then password /= Void)
		end
		
	is_connected : BOOLEAN is
			-- Is this session connected to a database ?
		do
			Result := impl_is_connected
		ensure
			connected_valid: Result implies is_valid
		end

	is_connection_dead : BOOLEAN is
			-- Is the connection dead ?
		local
			uint_result : XS_C_UINT32
			att : ECLI_CONNECTION_ATTRIBUTE_CONSTANTS
		do
			create uint_result.make
			create att
			set_status (ecli_c_get_integer_connection_attribute (handle, att.Sql_attr_connection_dead,uint_result.handle))
			Result := (uint_result.item = att.Sql_cd_true)
		end
		
	is_transaction_capable : BOOLEAN is
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
	
	is_describe_parameters_capable : BOOLEAN is
			-- Can 'ECLI_STATEMENT.describe_parameters' be called ?
		local
			functions : ECLI_FUNCTIONS_CONSTANTS
		do
			create functions
			if impl_describe_parameters_capability < sql_false then
				set_status (ecli_c_sql_get_functions (handle, functions.Sql_api_sqldescribeparam, ext_describe_parameters_capability.handle))
			end
			Result := impl_describe_parameters_capability = sql_true
		end

	is_bind_arrayed_parameters_capable : BOOLEAN is
			-- Can arrayed parameters be used in rowset operations ?
		local
			dummy_statement : ECLI_STATEMENT
		do
			if impl_is_bind_arrayed_parameters_capability < 0 then
				!!dummy_statement.make (Current)
				if dummy_statement.can_use_arrayed_parameters then
					impl_is_bind_arrayed_parameters_capability := 1
				else
					impl_is_bind_arrayed_parameters_capability := 0
				end
				dummy_statement.close
			end
			Result := impl_is_bind_arrayed_parameters_capability = 1
		end
		
	is_bind_arrayed_results_capable : BOOLEAN is
			-- Can arrayed results be used  ?
		local
			dummy_statement : ECLI_STATEMENT
		do
			if impl_is_bind_arrayed_results_capability < 0 then
				!!dummy_statement.make (Current)
				if dummy_statement.can_use_arrayed_results then
					impl_is_bind_arrayed_results_capability := 1
				else
					impl_is_bind_arrayed_results_capability := 0
				end
				dummy_statement.close
			end
			Result := impl_is_bind_arrayed_results_capability = 1
		end

	is_tracing : BOOLEAN is
			-- Is this session tracing SQL statements ?
		do
			Result := tracer /= Void
		ensure
			tracing_is_tracer_not_void: Result = (tracer /= Void)
		end

feature -- Status setting

	set_manual_commit is
			-- Set commit mode to `manual'
		require
			valid: is_valid
			connected: is_connected
			capable : is_transaction_capable
		do
			--| actual setting of manual commit
			set_status (ecli_c_set_manual_commit (handle, True))
		ensure
			is_manual_commit
		end

	set_automatic_commit is
			-- Set commit mode to `automatic'
		require
			valid: is_valid
			connected: is_connected
		do
			--| actual setting of automatic commit
			set_status (ecli_c_set_manual_commit (handle, False))
		ensure
			automatic_commit: not is_manual_commit
		end

	disable_tracing is
			-- Disable session trace
		require
			tracing: is_tracing
		do
			tracer := Void
		ensure
			not_tracing: not is_tracing
			no_tracer: tracer = Void
		end

feature -- Element change

	set_user_name(a_user_name: STRING) is
			-- Set `user' to `a_user'
		require
			not_connected: not is_connected
			a_user_ok: a_user_name/= Void
		do
			create impl_user_name.make_from_string (a_user_name)
		ensure
			user_name_set: user_name.is_equal (a_user_name)
		end

	set_data_source (a_data_source : STRING) is
			-- Set `data_source' to `a_data_source'
		require
			not_connected: not is_connected
			a_data_source_ok: a_data_source /= Void
		do
			create impl_data_source.make_from_string (a_data_source)
		ensure
			data_source_set: data_source.is_equal (a_data_source)
		end

	set_password (a_password : STRING) is
			-- Set password to 'a_password
		require
			not_connected: not is_connected
			a_password_ok: a_password /= Void
		do
			create impl_password.make_from_string (a_password)
		ensure
			password_set: password.is_equal (a_password)
		end

	set_tracer (a_tracer : ECLI_TRACER) is
			-- Trace SQL with `a_tracer'
		require
			tracer_ok: a_tracer /= Void
		do
			tracer := a_tracer
		ensure
			tracer_set: tracer = a_tracer
			tracing: is_tracing
		end

	set_transaction_isolation (an_isolation : ECLI_TRANSACTION_ISOLATION) is
			-- Change transaction isolation level
		require
			an_isolation_not_void: an_isolation /= Void
			no_pending_transaction: not has_pending_transaction
		local
			att : ECLI_CONNECTION_ATTRIBUTE_CONSTANTS
		do
			create att
			set_status (ecli_c_set_integer_connection_attribute (handle, att.Sql_attr_txn_isolation,  an_isolation.value))
		ensure
			done_when_ok: is_ok implies (transaction_isolation.is_equal (an_isolation))
		end

feature -- Basic Operations

	begin_transaction is
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

	commit is
			-- Commit current transaction
		require
			valid: is_valid
			connected: is_connected
			manual_commit: is_manual_commit
			pending_transaction: has_pending_transaction
		do
			set_status (ecli_c_commit (handle))
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

	rollback is
			-- Rollback current transaction
		require
			valid: is_valid
			connected: is_connected
			manual_commit: is_manual_commit
			pending_transaction: has_pending_transaction
		do
			set_status (ecli_c_rollback (handle))
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

	connect is
			-- Connect to `data_source' using `user_name' and `password'
		require
			is_valid: is_valid
			not_connected: not is_connected
			ready_to_connect: is_ready_to_connect
		do
			set_status (ecli_c_connect (handle,
					impl_data_source.handle,
					impl_user_name.handle,
					impl_password.handle))
			if is_ok then
				set_connected
			end
		ensure
			connected: is_connected implies is_ok
		end

	disconnect is
			-- Disconnect the session and close any remaining statement
		require
			is_valid: is_valid
			connected: is_connected
		local
			statements_cursor : DS_LIST_CURSOR[ECLI_STATEMENT]
		do
			-- First close all statements, if any
			if statements_count > 0 then
				from
					statements_cursor := statements.new_cursor
					statements_cursor.start
				until
					statements_cursor.off
				loop
					statements_cursor.item.do_close
					statements_cursor.forth
				end
				statements.wipe_out
				statements_count := 0
			end
			do_disconnect
		ensure
			not_connected: not is_connected implies is_ok
			no_opened_statements: statements_count = 0
		end

	close is
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

	environment_release (env : like environment) is
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

	reset_implementation is
			-- Reset all implementation values to default ones
		do
			ext_transaction_capability.put (sql_tc_none - 1)
			ext_describe_parameters_capability.put (sql_false - 1)
			impl_is_bind_arrayed_parameters_capability := -1			
			impl_is_bind_arrayed_results_capability := -1			
		end
		
	release_handle is
		do
			if is_connected then
				do_disconnect
			end
			if handle /= default_pointer then
				set_status (ecli_c_free_connection (handle))
			end
			set_handle ( default_pointer)
		end

	impl_data_source : XS_C_STRING

	impl_user_name: XS_C_STRING

	impl_password : XS_C_STRING

	impl_has_pending_transaction : BOOLEAN

	set_connected is
		do
			impl_is_connected := True
		end

	set_disconnected is
		do
			impl_is_connected := False
		end

	impl_is_connected : BOOLEAN

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER  is
			-- To be redefined in descendant classes
		do
			Result := ecli_c_session_error (handle, record_index, state, native_error, message, buffer_length, length_indicator)

		end

	impl_is_manual_commit : BOOLEAN is
		do
			Result := ext_is_manual_commit.item
		end

	impl_transaction_capability : INTEGER is
		do
			Result := ext_transaction_capability.item
		end
		
	ext_is_manual_commit : XS_C_BOOLEAN
	ext_transaction_capability : XS_C_INT32
	ext_describe_parameters_capability : XS_C_INT32
	
	impl_describe_parameters_capability : INTEGER is do Result := ext_describe_parameters_capability.item end

	impl_is_bind_arrayed_parameters_capability : INTEGER
	impl_is_bind_arrayed_results_capability	: INTEGER
	
	allocate is
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
			set_status (ecli_c_allocate_connection(henv, ext_handle.handle))
			handle := ext_handle.item
			--| register with environment
			environment.register_session (Current)
		ensure
			registered: environment.is_registered_session (Current)
			valid: is_valid
		end

	is_ready_for_disposal : BOOLEAN is
			-- Is this object ready for disposal ?
		do
			Result := statements_count = 0
		end

	disposal_failure_reason : STRING is
		once
			Result := "ECLI_STATEMENT still opened on Current; Close them before closing this session."
		end

	environment : ECLI_ENVIRONMENT

	do_disconnect is
			-- Do disconnect
		do
			--| actual disconnect
			set_status (ecli_c_disconnect (handle))
			if is_ok then
				set_disconnected
			end			
		end
		
invariant
	valid_session: environment /= Void implies environment = shared_environment

end
