note

	description:

		"Encapsulation of CLI environment.%
				% There should be a single object of this type in a system.%
				% This object is a handle to the CLI facilities : it is the first%
				% CLI object to be created, and the last to be deleted."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ENVIRONMENT

inherit

	ECLI_HANDLE

	ECLI_EXTERNAL_API

	ECLI_STATUS

	PAT_PUBLISHER [ECLI_SESSION]
		rename
			subscribe as register_session,
			unsubscribe as unregister_session,
			has_subscribed as is_registered_session,
			subscribers as sessions,
			impl_subscribers as impl_sessions,
			count as sessions_count
		export
			{ECLI_SESSION}
				register_session,
				unregister_session,
				is_registered_session
			end

create

	{ECLI_SHARED_ENVIRONMENT} make

feature {NONE} -- Initialization

	make
			-- Initialize CLI environment
		local
			ext_handle : XS_C_POINTER
		do
			create error_handler.make_null
			-- | Actual allocation of CLI handle
			create ext_handle.make
			set_status ("ecli_c_allocate_environment", ecli_c_allocate_environment (ext_handle.handle))
			handle := ext_handle.item
		end

feature -- Basic operations


feature {NONE} -- Implementation

	is_ready_for_disposal : BOOLEAN
		do
			Result := sessions_count = 0
		end

	disposal_failure_reason : STRING
		once
			Result := "ECLI_SESSIONS still open; check your code and close them before exiting."
		end

	release_handle
			-- Release environment handle
		do
			-- | actual release of the handle.
			set_status_without_report ("ecli_c_free_environment", ecli_c_free_environment (handle))
			set_handle (default_pointer)
		end

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER
			-- To be redefined in descendant classes
		do
			Result := ecli_c_environment_error (handle, record_index, state, native_error, message, buffer_length, length_indicator)
		end

invariant
	is_valid: is_valid

end
