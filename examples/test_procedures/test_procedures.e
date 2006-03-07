indexing
	description: "test procedures application.";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"


class
	TEST_PROCEDURES
	
creation

	make

feature -- Initialization

	make is
			-- ecli test application
		do
			io.put_string ("ECLI 'test_procedures' application%N%N")
			-- session opening
			parse_arguments
			if not arguments_ok then
			 	print_usage
			else
				create_and_connect_session
				if session.is_connected then
					trace_if_necessary
					create_procedures
					test_procedures
					drop_procedures
					disconnect_session
				end
				close_session
				io.put_string ("Finished.%N")
			end
		end
		
feature -- Access

	session : ECLI_SESSION
			-- Database session on datasource

	data_source_name : STRING
			-- Name of datasource
			
	user_name : STRING
			-- User name
	
	password : STRING
			-- Password

	trace_file_name : STRING
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
		
	test_procedures is
		local
			pin, pout, pinout, fun, mulres : ECLI_STORED_PROCEDURE
			input : ECLI_INTEGER
			res : ECLI_INTEGER
			output : ECLI_INTEGER
			res_count : INTEGER
			factory : ECLI_BUFFER_FACTORY
			row_count : INTEGER
		do
			-- input parameter
			create pin.make (session)
			pin.set_sql ("{call test_proc_in (?in)}")
			create input.make
			create res.make
			input.set_item (33)
			pin.put_input_parameter (input, "in")
			pin.bind_parameters
			pin.execute
			print ("Testing input parameter : %N")
			if pin.is_ok then
				pin.set_results (<<res>>)
				pin.start
				print ("Passed   : "+input.as_integer.out + "%N")
				print ("Received : "+res.as_integer.out + "%N")
			end
			pin.close
			-- output parameter
			create pout.make (session)
			pout.set_sql ("{call test_proc_out (?in, ?out)}")
			create input.make
			create output.make
			input.set_item (27)
			pout.put_input_parameter (input, "in")
			pout.put_output_parameter (output, "out")
			pout.bind_parameters
			pout.execute
			print ("Testing output parameter : %N")
			if pout.is_ok then
				print ("Passed   : "+input.as_integer.out + "%N")
				print ("Received : "+output.as_integer.out + "%N")
			else
				print (pout.diagnostic_message)
			end
			pout.close
			-- input output
			create pinout.make (session)
			pinout.set_sql ("{call test_proc_in_out (?in, ?out)}")
			create input.make
			create output.make
			input.set_item (27)
			output.set_item (33)
			pinout.put_input_output_parameter (input, "in")
			pinout.put_input_output_parameter (output, "out")
			print ("Testing input/output parameter : %N")
			print ("Passed   : "+input.as_integer.out + ", "+output.as_integer.out+"%N")
			pinout.bind_parameters
			pinout.execute
			if pinout.is_ok then
				print ("Received : "+input.as_integer.out + ", "+output.as_integer.out+"%N")
			else
				print (pinout.diagnostic_message)
			end
			pinout.close
			-- function
			create fun.make (session)
			create input.make
			input.set_item (-23)
			create res.make
			fun.set_sql ("{?res=call test_fun (?in)}")
			fun.put_output_parameter (res, "res")
			fun.put_input_parameter (input, "in")
			fun.bind_parameters
			fun.execute
			print ("Testing function call : %N")
			print ("Passed   : "+input.as_integer.out +"%N")
			if fun.is_ok then
				print ("Received : "+res.as_integer.out +"%N")
			end
			fun.close
			-- multiple result sets
			
			create mulres.make (session)
			mulres.set_sql ("{call test_multiple_results}")
			mulres.execute
			mulres.raise_exception_on_error
			if mulres.is_ok then
				from
					mulres.describe_results
					create factory
					factory.create_buffers (mulres.results_description)
					mulres.set_results (factory.last_buffers)
					mulres.start
				until
					not mulres.has_another_result_set and mulres.off
				loop
					from
						if mulres.has_another_result_set then
							mulres.forth_result_set
							mulres.describe_results
							create factory
							factory.create_buffers (mulres.results_description)
							mulres.set_results (factory.last_buffers)
							mulres.start
						end
						res_count := res_count + 1
						print ("Result set : " + res_count.out+"%N")
						print ("Width : " + mulres.result_columns_count.out+"%N")
						row_count := 0
					until
						mulres.off
					loop
						row_count := row_count + 1
						mulres.forth
					end
					print ("Got "+row_count.out+" rows %N")
				end
				mulres.close
			end
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
		
		
	parse_arguments is
			-- parse program arguments
		local
			args : ARGUMENTS
		do
			create args
			if args.argument_count >= 3 then
				data_source_name := clone (args.argument (1))
				user_name := clone (args.argument (2))
				password := clone (args.argument (3))
				arguments_ok := True
				if args.argument_count > 3 then
					trace_file_name := clone (args.argument (4))
				end
			end
		ensure
			ok: arguments_ok implies (data_source_name /= Void and user_name /= Void and password /= Void)
		end

	print_usage is
			-- print terse usage string
		do
				io.put_string ("Usage: test_procedures <data_source> <user_name> <password> [<trace_file_name>]%N")
		end

	trace_if_necessary is
			-- activate trace if trace_file_name exists
		local
			f : KL_TEXT_OUTPUT_FILE
			tracer : ECLI_TRACER
		do
			if trace_file_name /= Void then
				create f.make (trace_file_name)
				f.open_write
				if f.is_open_write then
					create tracer.make (f)
					session.set_tracer (tracer)
					io.put_string ("Trace in file : ")
					io.put_string (trace_file_name)
					io.put_string ("%N")
				else
					io.put_string ("Trace file <")
					io.put_string (trace_file_name)
					io.put_string ("> cannot be open. No trace%N")
				end
			end		
		end
		
	create_and_connect_session is
			-- create session and connect user `data_source_name', `user_name' and `password'
		do
			io.put_string ("%N SESSION - Creation and Connection%N")
			io.put_string ("---------------------------------%N")
			io.put_string ("Connection can give some information about what happened%N")
			io.put_string ("This is not necessarily an error !%N")
			create  session.make (data_source_name, user_name, password)
			session.connect
			if session.has_information_message or not session.is_ok then
				print_status (session)
			end
			if session.is_connected then
				io.put_string ("%NSUCCESS : Connected %N")
			end
		ensure
			session_not_void: session /= Void
		end

	disconnect_session is
			-- disconnect session before closing
		do
			-- session disconnection
			session.disconnect
			if not session.is_connected then
				io.put_string ("%NSession disconnected %N")
			else
				print_status (session)
			end
		end

	close_session is
			-- close `session'
		do
			session.close
		end

feature -- Miscellaneous

	show_parameter_names (a_statement : ECLI_STATEMENT) is
			-- show parameter names of SQL in `a_statement'
		local
			list_cursor: DS_LIST_CURSOR[STRING]
		do
			list_cursor := a_statement.parameter_names.new_cursor
			from
				list_cursor.start
				io.put_string ("Parameter names of Query :%N")
			until
				list_cursor.off
			loop
				io.put_string ("%T%"")
				io.put_string (list_cursor.item)
				io.put_string ("%"%N")
				list_cursor.forth
			end
		end



	print_status (status : ECLI_STATUS) is
		require
			status_not_void: status /= Void
		do
			print (status.diagnostic_message)
		end
		
end
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License version 2 <http://www.opensource.org/licenses/ver2_eiffel.php>
-- See file <forum.txt>
--
