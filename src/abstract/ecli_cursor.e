indexing
	description: "Abstraction of a cursor.  Used by 'query_assistant'-generated classes."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

deferred class
	ECLI_CURSOR

inherit
	ANY

	ECLI_STATEMENT
		rename
			close_cursor as close, start as statement_start
		export
			{NONE} all
			{ANY} 
				forth, close, make, is_ok, is_prepared, is_executed, off, 
				before, after, has_information_message, diagnostic_message,
				has_results, cursor_status, Cursor_after, Cursor_before, Cursor_in
		redefine
			make
		end

feature {NONE} -- Initialization

	make (a_session : ECLI_SESSION) is
		do
			Precursor (a_session)
			set_sql (definition)
			setup
			prepare
		ensure then
			prepared: is_ok implies is_prepared
		end
		
	setup is
			-- create all ECLI_VALUE objects
		deferred
		end

feature -- Access

	definition : STRING is
		deferred
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

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

feature {NONE} -- Implementation

	implementation_start is
		do
			bind_parameters
			execute
			statement_start
		end
	
invariant
	inv_definition: definition /= Void

end -- class ECLI_CURSOR
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
