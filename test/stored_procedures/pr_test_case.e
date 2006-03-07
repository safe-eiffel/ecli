indexing

	description: 
	
		"Test utilities for Stored procedures.";

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class PR_TEST_CASE

inherit

	TS_TEST_CASE
		redefine
			set_up, tear_down
		end
	

feature -- Basic operations

	set_up is
			-- setup test
		local
			exception : EXCEPTIONS
		do
			create_and_connect_session
			if session.is_connected then
				trace_if_necessary
				create_procedures
			else
				create exception
				exception.die (1)		
			end
		end
	
	tear_down is
			-- tear down test
		do
			if session.is_connected then
				drop_procedures
				disconnect_session
			end
			close_session
		end
		
feature -- Access

	session : ECLI_SESSION
			-- Database session on datasource

	trace_file_name : STRING is "trace_stored_procedures.log"
			-- Name of trace file, if any
	
feature -- Status setting

	arguments_ok : BOOLEAN
			-- are program arguments OK ?

feature --  Basic operations

	create_procedures is
		local
			stmt : ECLI_STATEMENT
		do
			create stmt.make (session)
			stmt.set_sql ("CREATE Procedure test_proc_in ( @InputParam INTEGER) As%
						  % select @InputParam%
						  % return")
			stmt.execute
			
			stmt.set_sql ("CREATE Procedure test_proc_out ( @InputParam INTEGER, @OutputParam INTEGER output) As%
						  % select @OutputParam = @InputParam%
						  % return")
						  
			stmt.execute

			stmt.set_sql ("CREATE Procedure test_proc_in_out ( @ParamA INTEGER output, @ParamB INTEGER output) As%
						  %	declare @tmp INTEGER%
						  %	select @tmp = @ParamB%
						  %	select @ParamB = @ParamA%
						  %	select @ParamA = @tmp%
						  %	return")
						  
			stmt.execute

			stmt.set_sql ("CREATE Procedure test_fun ( @InputParam INTEGER) As%
						  %	return (@InputParam)")

			stmt.execute
			
			stmt.set_sql ("create table toto (nom varchar(20), age integer)")
			stmt.execute
			
			stmt.set_sql ("insert into toto values ('Henri', 3)")
			stmt.execute
			stmt.set_sql ("Insert into toto values ('Isa',NULL)")
			stmt.execute
			
			stmt.set_sql ("CREATE Procedure test_multiple_results As%
							% select 1 as a, 2 as b, 3 as c %
							% select * from toto %
							% return")
							
			stmt.execute
			stmt.close
		end
				
	drop_procedures is
		local
			stmt : ECLI_STATEMENT
		do
			create stmt.make (session)
			stmt.set_sql ("drop Procedure test_proc_in")
			stmt.execute
			
			stmt.set_sql ("drop Procedure test_proc_out")
						  
			stmt.execute

			stmt.set_sql ("drop Procedure test_proc_in_out")
						  
			stmt.execute

			stmt.set_sql ("drop Procedure test_fun ")
			stmt.execute
			
			stmt.set_sql ("drop Procedure test_multres")
			stmt.execute
			
			stmt.set_sql ("drop table toto")
			stmt.execute
			
			stmt.close
		end
		

	trace_if_necessary is
			-- activate trace if trace_file_name exists
		local
			f : KL_TEXT_OUTPUT_FILE
			tracer : ECLI_TRACER
		do
			create f.make (trace_file_name)
			f.open_write
			if f.is_open_write then
				create tracer.make (f)
				session.set_tracer (tracer)
			end
			assert ("tracing", session.is_tracing)
		end
		
	create_and_connect_session is
			-- create session and connect user `data_source_name', `user_name' and `password'
		local
			strategy : ECLI_DRIVER_LOGIN
		do
			create  session.make_default
			create strategy.make ("DSN=Northwind");
			session.set_login_strategy (strategy)
			session.connect
			assert ("connected", session.is_connected)
		ensure
			session_not_void: session /= Void
		end

	disconnect_session is
			-- disconnect session before closing
		do
			-- session disconnection
			session.disconnect
		end

	close_session is
			-- close `session'
		do
			session.close
		end
		
end -- class TEST1
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
