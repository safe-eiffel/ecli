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

	ECLI_SHARED_ENVIRONMENT

	PAT_PUBLISHER [ECLI_STATEMENT]
		rename
			subscribe as register_statement,
			unsubscribe as unregister_statement,
			has_subscribed as is_registered_statement,
			subscribers as statements,
			impl_subscribers as impl_statements
		export
			{ECLI_STATEMENT}
				register_statement,
				unregister_statement,
				is_registered_statement
		end

	PAT_SUBSCRIBER
		rename
			publisher as environment,
			published as environment_release
		redefine	
			environment_release
		end

creation
	make

feature -- Initialization

	make (a_data_source, a_user_name, a_password : STRING) is
			-- Make session using 'session_string'
		require
			data_source_defined: a_data_source /= Void
			user__name_defined: a_user_name/= Void
			password_defined: a_password /= Void
		local
			henv : pointer
		do
			-- | Allocate session handle
			henv := environment.handle
			set_status (ecli_c_allocate_connection(henv, $handle))
			-- set data_source, user_name and password
			set_data_source (a_data_source)
			set_user_name(a_user_name)
			set_password (a_password)
			--| register with environment
			environment.register_session (Current)
		ensure
			data_source_shared : data_source = a_data_source
			user_name_shared : user_name= a_user_name
			password_shared : password = a_password
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

feature -- Measurement

feature -- Status report

	is_manual_commit : BOOLEAN is
			-- Is this session in 'manual commit mode' ?
		require
			connected: is_connected
		local
			v : BOOLEAN
		do
			set_status (ecli_c_is_manual_commit (handle, $v))
			Result := v
		end

	is_connected : BOOLEAN is
			-- Is this session connected to a database ?
		do
			Result := impl_is_connected
		ensure
			connected_valid: Result implies is_valid
		end

feature -- Status setting

	set_manual_commit is
			-- Set commit mode to 'manual'
		require
			connected: is_connected
		do
			--| actual setting of manual commit
			set_status (ecli_c_set_manual_commit (handle, True))
		ensure
			is_manual_commit
		end

	set_automatic_commit is
			-- Set commit mode to 'automatic'
		require
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

feature -- Basic Operations

	begin_transaction is
			-- begin a new transaction
		require
			connected: is_connected
		do
			set_manual_commit
			if is_ok then
				impl_has_pending_transaction := True
			end
		ensure
			manual_commit:	is_manual_commit implies is_ok
			has_pending_transaction: has_pending_transaction implies is_ok
		end

	commit is
			-- commit current transaction
		require
			connected: is_connected
			manual_commit: is_manual_commit
			pending_transaction: has_pending_transaction
		do
			set_status (ecli_c_commit (handle))
			if is_ok then
				impl_has_pending_transaction := False
			end
			set_automatic_commit
		ensure
			no_pending_transaction: not has_pending_transaction implies is_ok
			commit_mode_reset : not is_manual_commit 
		end

	rollback is
			-- rollback current transaction
		require
			connected: is_connected
			manual_commit: is_manual_commit
			pending_transaction: has_pending_transaction
		do
			set_status (ecli_c_rollback (handle))
			if is_ok then
				impl_has_pending_transaction := False
			end
			set_automatic_commit
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
			connected: is_connected
		local
			cursor : DS_LIST_CURSOR[ECLI_STATEMENT]
		do
			from
				cursor := statements.new_cursor
				cursor.start
			until
				cursor.off
			loop
				cursor.item.session_disconnect (Current)
				cursor.forth
			end
			statements.wipe_out
			--| actual disconnect
			set_status (ecli_c_disconnect (handle))
			if is_ok then
				set_disconnected
			end				
		ensure
			not_connected: not is_connected implies is_ok
			-- foreach s in old statements it_holds not s.is_valid
			-- statements.empty
		end

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {ECLI_ENVIRONMENT} --

	environment_release (env : ECLI_ENVIRONMENT) is
			-- environment is being released
		do
			disconnect
			release_handle
		end 

feature {NONE} -- Implementation

	release_handle is
		do
			if is_connected then
				disconnect
			end
			environment.unregister_session (Current)
			set_status (ecli_c_free_connection (handle))
			handle := default_pointer
		ensure then
			not_connected: not is_connected
			not_referenced_by_environment: not environment.is_registered_session (Current)
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

invariant
	valid_session: --

end -- class ECLI_SESSION
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
