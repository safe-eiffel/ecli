indexing
	description: "Abstraction of a cursor.  Used by 'query_assistant'-generated classes."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

deferred class
	ECLI_CURSOR

inherit
	ECLI_STATEMENT
		rename
			close as statement_close,
			close_cursor as close, 
			start as statement_start
		export
			{NONE} all
			{ANY} 
				forth, close, is_closed, make, is_ok, is_prepared, is_executed, off, 
				before, after, has_information_message, diagnostic_message, sql, cursor,
				array_routines, has_results, cursor_status, Cursor_after, Cursor_before, Cursor_in
		redefine
			make
		end

feature {NONE} -- Initialization

	make (a_session : ECLI_SESSION) is
		do
			Precursor (a_session)
			set_sql (definition)
			prepare
		ensure then
			prepared: is_ok implies is_prepared
		end
		
	create_buffers is
			-- create all ECLI_VALUE objects
		deferred
		end

feature -- Access

	definition : STRING is
		deferred
		end

feature {NONE} -- Implementation

	implementation_start is
		do
			bind_parameters
			execute
			if is_ok then
				if has_results then
					create_buffers
					statement_start
				end
			end
		end
	
invariant
	inv_definition: definition /= Void

end -- class ECLI_CURSOR
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--

