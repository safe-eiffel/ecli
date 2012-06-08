indexing

	description:

			"Simple Login Strategies that use a connection string."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_DRIVER_LOGIN

inherit
	ECLI_LOGIN_STRATEGY
		export
			{ANY} Sql_driver_noprompt, Sql_driver_complete, Sql_driver_complete_required, Sql_driver_prompt
		end

create
	make, make_interactive, make_complete_strict, make_complete_lazy

feature {NONE} -- Initialization

	make (new_connection_string : STRING) is
			-- Make with `new_connection_string'.
		require
			new_connection_string_not_void: new_connection_string /= Void --FIXME: VS-DEL
		do
			connection_string := new_connection_string
			mode := Sql_driver_noprompt
			parent_window_handle := default_pointer
			completed_connection_string := connection_string
		ensure
			connection_string_set: connection_string = new_connection_string
			completed_connection_string_set: completed_connection_string = connection_string
			mode_no_prompt: mode = Sql_driver_noprompt
		end

	make_interactive (new_connection_string : STRING; new_parent_window_handle : POINTER) is
			-- Make using `new_connection_string'. Connection dialog shall use `new_parent_window_handle' as parent window.
		require
			new_connection_string_not_void: new_connection_string /= Void --FIXME: VS-DEL
		do
			connection_string := new_connection_string
			mode := Sql_driver_prompt
			parent_window_handle := new_parent_window_handle
			completed_connection_string := connection_string
		ensure
			connection_string_set: connection_string = new_connection_string
			mode_no_prompt: mode = Sql_driver_prompt
			parent_window_handle_set: parent_window_handle = new_parent_window_handle
			completed_connection_string_set: completed_connection_string = connection_string
		end

	make_complete_strict (new_connection_string : STRING; new_parent_window_handle : POINTER) is
			-- Make using `new_connection_string'. Complete connection string with a dialog if necessary.
			-- Possible connection dialog shall use `new_parent_window_handle'.
			-- All attributes in `new_connection_string' will be checked.
		require
			new_connection_string_not_void: new_connection_string /= Void --FIXME: VS-DEL
		do
			connection_string := new_connection_string
			mode := Sql_driver_complete
			parent_window_handle := new_parent_window_handle
			completed_connection_string := connection_string
		ensure
			connection_string_set: connection_string = new_connection_string
			mode_complete: mode = Sql_driver_complete
			parent_window_handle_set: parent_window_handle = new_parent_window_handle
			completed_connection_string_set: completed_connection_string = connection_string
		end

	make_complete_lazy (new_connection_string : STRING; new_parent_window_handle : POINTER) is
			-- Make using `new_connection_string'. Complete connection string with a dialog if necessary.
			-- Possible connection dialog shall use `new_parent_window_handle'.
			-- Only necessary attributes in `new_connection_string' whill be checked.
		require
			new_connection_string_not_void: new_connection_string /= Void --FIXME: VS-DEL
		do
			connection_string := new_connection_string
			mode := Sql_driver_complete_required
			parent_window_handle := new_parent_window_handle
			completed_connection_string := connection_string
		ensure
			connection_string_set: connection_string = new_connection_string
			mode_complete_required: mode = Sql_driver_complete_required
			parent_window_handle_set: parent_window_handle = new_parent_window_handle
			completed_connection_string_set: completed_connection_string = connection_string
		end

feature -- Access

	connection_string : STRING
		-- Connection string as given

	completed_connection_string : STRING
		-- Connection string as completed by driver

	mode : INTEGER
		-- Login mode (see valid_modes)

	parent_window_handle : POINTER
		-- Window handle used by the underlying windowing system as parent for the connection dialog.

feature -- Status report

	valid_modes : DS_SET[INTEGER]
			-- Valid values for `modes'
		once
			create {DS_HASH_SET[INTEGER]}Result.make (3)
			Result.force (Sql_driver_noprompt)
			Result.force (Sql_driver_prompt)
			Result.force (Sql_driver_complete)
		end

feature -- Basic operations

	connect (the_session : ECLI_SESSION) is
			-- Connect `the_session'
		local
			actual_length : XS_C_INT16
			impl_connection_string : XS_C_STRING
			impl_completed_connection_string : XS_C_STRING
		do
			create actual_length.make
			create impl_connection_string.make_from_string (connection_string)
			create impl_completed_connection_string.make (completed_connection_string_default_length)
			the_session.set_status ("ecli_c_driver_connect", ecli_c_driver_connect (
				the_session.handle,
				parent_window_handle,
				impl_connection_string.handle,
				impl_connection_string.capacity,
				impl_completed_connection_string.handle,
				impl_completed_connection_string.capacity,
				actual_length.handle,
				mode))
			if actual_length.item > 0 then
				completed_connection_string := impl_completed_connection_string.substring (1, actual_length.item)
			else
				completed_connection_string := ""
			end
		ensure then
			completed_connection_string_not_void: completed_connection_string /= Void --FIXME: VS-DEL
		end

feature -- Constants

	completed_connection_string_default_length : INTEGER is 4096

feature -- Inapplicable

feature {NONE} -- Implementation

invariant

	connection_string_not_void: connection_string /= Void
	modes_within_valid_modes: valid_modes.has (mode)
	
end -- class ECLI_DRIVER_LOGIN
