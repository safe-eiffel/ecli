indexing
	description: "Encapsulation of CLI environment.  %
				% There should be a single object of this type in a system.%
				% This object is a handle to the CLI facilities : it is the first%
				% CLI object to be created, and the last to be deleted."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ENVIRONMENT

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

creation
	make


feature -- Initialization

	make is
			-- initialize CLI environment
		do
			-- | Actual allocation of CLI handle
			set_status (ecli_c_allocate_environment ($handle))
		end


feature {NONE} -- Implementation

	is_ready_for_disposal : BOOLEAN is
		do
			Result := sessions_count = 0
		end
	
	disposal_failure_reason : STRING is
		once
			Result := "ECLI_SESSIONS still open; check your code and close them before exiting."
		end
			
	release_handle is
			-- release environment handle
		do
			-- | actual release of the handle.
			set_status (ecli_c_free_environment (handle))
			set_handle (default_pointer)
		end

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER  is
			-- to be redefined in descendant classes
		do
			Result := ecli_c_environment_error (handle, record_index, state, native_error, message, buffer_length, length_indicator)
		end

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_ENVIRONMENT
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
