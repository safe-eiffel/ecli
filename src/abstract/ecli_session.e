indexing
	description:

		"Objects that represent a session to a database"

	author: 	"Paul G. Crismer"
	date: 		"$Date$"
	revision: 	"$Revision$"
	licensing: 	"See notice at end of class"

class
	ECLI_SESSION

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
			-- Make session using 'session_string'
		require
			data_source_defined: a_data_source /= Void
			user__name_defined: a_user_name/= Void
			password_defined: a_password /= Void
			closed: is_closed
		do
			-- set data_source, user_name and password
			set_data_source (a_data_source)
			set_user_name(a_user_name)
			set_password (a_password)
			allocate
			reset_implementation
		ensure
			data_source_shared : data_source = a_data_source
			user_name_shared : user_name= a_user_name
			password_shared : password = a_password
			valid: is_valid
			open:  not is_closed
		end

feature -- Initialization

	attach is
			-- attach current session object to shared CLI environment
		obsolete "Use open /close instead of attach/release"
		do
		end

	release is
			-- releases current session object from environment.  Ready for disposal
		obsolete "Use open/close instead of attach/release"
		do
		end

	close is
			-- closes the the session
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


feature -- Access

	has_pending_transaction : BOOLEAN is
			-- has the session a pending transaction ?
		do
			Result := impl_has_pending_transaction
		end

	data_source : STRING is
		do
			Result := impl_data_source
		end

	user_name : STRING is
		do
			Result := impl_user_name
		end

	password : STRING is
		do
			Result := impl_password
		end

	transaction_capability : INTEGER is
		do
			--| evaluate capability
			if impl_transaction_capability < sql_tc_none then
				set_status (ecli_c_transaction_capable (handle, $impl_transaction_capability))
			end
			Result := impl_transaction_capability
		end

	tracer : ECLI_TRACER

feature -- Status report

	is_manual_commit : BOOLEAN is
			-- Is this session in 'manual commit mode' ?
		require
			valid: is_valid
			connected: is_connected
		do
			set_status (ecli_c_is_manual_commit (handle, $impl_is_manual_commit))
			Result := impl_is_manual_commit
		end

	is_connected : BOOLEAN is
			-- Is this session connected to a database ?
		do
			Result := impl_is_connected
		ensure
			connected_valid: Result implies is_valid
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
			-- can 'ECLI_STATEMENT.describe_parameters' be called ?
		local
			functions : expanded ECLI_FUNCTIONS_CONSTANTS
		do
			if impl_describe_parameters_capability < sql_false then
				set_status (ecli_c_sql_get_functions (handle, functions.Sql_api_sqldescribeparam, $ impl_describe_parameters_capability))
			end
			Result := impl_describe_parameters_capability = sql_true
		end

	is_bind_arrayed_parameters_capable : BOOLEAN is
			-- can arrayed parameters be used in rowset operations ?
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
		
	is_tracing : BOOLEAN is
			-- is this session tracing SQL statements ?
		do
			Result := tracer /= Void
		ensure
			has_tracer: Result implies tracer /= Void
		end

feature -- Status setting

	set_manual_commit is
			-- Set commit mode to 'manual'
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
			-- Set commit mode to 'automatic'
		require
			valid: is_valid
			connected: is_connected
		do
			--| actual setting of automatic commit
			set_status (ecli_c_set_manual_commit (handle, False))
		ensure
			not is_manual_commit
		end

	set_user_name(a_user_name: STRING) is
			-- set 'user' to 'a_user'
		require
			not_connected: not is_connected
			a_user_ok: a_user_name/= Void
		do
			impl_user_name:= a_user_name
		ensure
			user_name= a_user_name
		end

	set_data_source (a_data_source : STRING) is
			-- set 'data_source' to 'a_data_source'
		require
			not_connected: not is_connected
			a_data_source_ok: a_data_source /= Void
		do
			impl_data_source := a_data_source
		ensure
			data_source = a_data_source
		end

	set_password (a_password : STRING) is
			-- set password to 'a_password
		require
			not_connected: not is_connected
			a_password_ok: a_password /= Void
		do
			impl_password := a_password
		ensure
			password = a_password
		end

	set_tracer (a_tracer : ECLI_TRACER) is
			-- trace SQL with 'a_tracer'
		require
			tracer_ok: a_tracer /= Void
		do
			tracer := a_tracer
		ensure
			tracer_set: tracer = a_tracer
			tracing: is_tracing
		end

	disable_tracing is
			-- disable session trace
		require
			tracing: is_tracing
		do
			tracer := Void
		ensure
			not_tracing: not is_tracing
			no_tracer: tracer = Void
		end

feature -- Basic Operations

	begin_transaction is
			-- begin a new transaction
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
			-- commit current transaction
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
			commit_mode_reset : not is_manual_commit
		end

	rollback is
			-- rollback current transaction
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
			commit_mode_reset : not is_manual_commit
		end

	connect is
			-- establish a session using the session_string
		require
			is_valid: is_valid
			not_connected: not is_connected
			data_source_set: data_source /= Void
			user_set : user_name/= Void
			password_set : password /= Void
		local
			tools : ECLI_EXTERNAL_TOOLS
		do
			set_status (ecli_c_connect (handle,
					tools.string_to_pointer (data_source),
					tools.string_to_pointer (user_name),
					tools.string_to_pointer (password)))
			if is_ok then
				set_connected
			end
		ensure
			connected: is_connected implies is_ok
		end

	disconnect is
			-- disconnect the session
		require
			is_valid: is_valid
			connected: is_connected
			no_opened_statements: statements_count = 0
		do
			statements.wipe_out
			--| actual disconnect
			set_status (ecli_c_disconnect (handle))
			if is_ok then
				set_disconnected
			end
		ensure
			not_connected: not is_connected implies is_ok
		end

feature {ECLI_ENVIRONMENT} --

	environment_release (env : like environment) is
			-- environment is being released
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
			-- reset all implementation values to default ones
		do
			impl_transaction_capability := sql_tc_none - 1
			impl_describe_parameters_capability := sql_false - 1
			impl_is_bind_arrayed_parameters_capability := -1			
		end
		
	release_handle is
		do
			set_status (ecli_c_free_connection (handle))
			set_handle ( default_pointer)
		end

	impl_data_source : STRING

	impl_user_name: STRING

	impl_password : STRING

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
			-- to be redefined in descendant classes
		do
			Result := ecli_c_session_error (handle, record_index, state, native_error, message, buffer_length, length_indicator)

		end

	impl_is_manual_commit : BOOLEAN

	impl_transaction_capability : INTEGER

	impl_describe_parameters_capability : INTEGER
	
	impl_is_bind_arrayed_parameters_capability : INTEGER
	
	allocate is
			-- allocate HANDLE
		require
			is_closed: is_closed
		local
			henv : pointer
		do
			-- | Allocate session handle
			environment := shared_environment
			henv := environment.handle
			set_status (ecli_c_allocate_connection(henv, $handle))
			--| register with environment
			environment.register_session (Current)
		ensure
			registered: environment.is_registered_session (Current)
			valid: is_valid
		end

	is_ready_for_disposal : BOOLEAN is
			-- is this object ready for disposal ?
		do
			Result := statements_count = 0
		end

	disposal_failure_reason : STRING is
		once
			Result := "ECLI_STATEMENT still opened on Current; Close them before closing this session."
		end

	environment : ECLI_ENVIRONMENT

invariant
	valid_session: environment /= Void implies environment = shared_environment

end -- class ECLI_SESSION
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
