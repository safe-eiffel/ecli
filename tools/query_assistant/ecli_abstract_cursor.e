indexing
	description: "Operations common to all cursors"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

deferred class

	ECLI_ABSTRACT_CURSOR

feature -- Initialization

	make (a_session : ECLI_SESSION; a_sql : STRING)
			-- create a cursor on 'a_session' whose "definition" is 'a_sql'
		require
			a_session /= Void and then a_session.is_connected
		do
			-- create statement
			create statement.make (a_session)
			statement.set_sql (a_sql)
			statement.prepare
			setup
		ensure
			is_ok implies statement.is_prepared
			-- each parameter or buffer type has been created
		end

	setup is
		deferred
		end

feature -- cursor operations

	start is
			-- position to first cursor position
		require 
			before: before
			executed: statement.is_executed
		do
			statement.start
			if off then
				readable := False
			end
		ensure
		end

	forth
			-- advance cursor forth
		require
			not_off: not off
		do
			statement.forth
		ensure
		end

	is_ok : BOOLEAN is
			-- has last operations succeeded ?
		do
			Result := statement.is_ok
		end

feature -- Status Report

	before : BOOLEAN is
			-- is the cursor before any active row ?
		do
			Result := statement.before
		end
		
	off : BOOLEAN is
			-- is the cursor off (after) any active row ?
		do
			Result := statement.off
		end
	
	readable : BOOLEAN
			-- are the cursor values 'readable', i.e., representing
			-- a current valid cursor position ?

feature {NONE} -- associated statement 

	statement : ECLI_STATEMENT


end -- class ECLI_ABSTRACT_CURSOR
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
