indexing
	description: "Abstraction of a SQL query."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

deferred class
	ECLI_QUERY

inherit
	ECLI_STATEMENT
		rename
			start as statement_start
		export
			{NONE} all;
			{ANY} 
				make, forth, close, 
				is_closed,is_ok, is_prepared, is_prepared_execution_mode, is_executed, is_valid, 
				off, before, after, has_information_message, diagnostic_message, sql, cursor,
				go_after, array_routines, has_results, cursor_status, Cursor_after, Cursor_before, Cursor_in,
				has_parameters,execute, bind_parameters, put_parameter, prepare
		redefine
			make
		end

	ANY
	
feature {NONE} -- Initialization

	make (a_session : ECLI_SESSION) is
		do
			Precursor (a_session)
			set_sql (definition)
		end

	make_prepared (a_session : ECLI_SESSION) is
		require -- from ECLI_STATEMENT
			a_session_exists: a_session /= void
			a_session_connected: a_session.is_connected
			not_valid: not is_valid
		do
			make (a_session)
			prepare
		ensure
			session_ok: session = a_session and not is_closed
			registered: session.is_registered_statement (Current)
			same_exception_on_error: exception_on_error = session.exception_on_error
			valid: is_valid
			prepared: is_ok implies is_prepared
		end
		
feature -- Access

	definition : STRING	is
			-- cursor definition (i.e. SQL text)
		deferred
		end
			
invariant
	inv_definition: definition /= Void

end -- class ECLI_QUERY
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--

