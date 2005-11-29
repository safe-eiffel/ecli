indexing
	description: "TEST1 sample application.";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"


class
	TEST1

inherit
	
	ECLI_TYPE_CONSTANTS
	
creation

	make

feature -- Initialization

	make is
			-- ecli test application
		do
			io.put_string ("'test1' ECLI tutorial application%N%N")
			-- session opening
			parse_arguments
			if not arguments_ok then
			 	print_usage
			else
				create_and_connect_session
				if session.is_connected then
					trace_if_necessary
					create_statement
					create_sample_table
					put_empty_string
					
--					put_photo
--					get_photo
--					simple_insert_sample_tuples
--					query_database
--					parameterized_insert
--					query_database
--					parameterized_prepared_insert_sample_tuples
--					query_database
--					drop_table
					disconnect_session
				end
				close_session
				io.put_string ("Test1 finished.%N")
			end
		end

	put_empty_string is
		local
			name, first_name : ECLI_VARCHAR
		do
			create name.make (10)
			create first_name.make (10)
			name.set_item ("Paulisson")
			first_name.set_item ("")
			create stmt.make (session)
			stmt.set_sql ("INSERT INTO ECLITRIAL VALUES (?name,?first_name, 10, {ts '2000-05-24 08:20:15.00'}, 33.3, NULL)")
			stmt.put_parameter (name, "name")
			stmt.put_parameter (first_name, "first_name")
			stmt.bind_parameters
			stmt.execute
		end
		
	put_photo is
		local
			photo : ECLI_FILE_LONGVARBINARY
			photo_file : KL_BINARY_INPUT_FILE
		do
			create photo_file.make ("architecture.bmp")	
			create photo.make_input (photo_file)
			create stmt.make (session)
			stmt.set_sql ("INSERT INTO ECLITRIAL VALUES ('Smith', 'Henry', 10, {ts '2000-05-24 08:20:15.00'}, 33.3, ?photo)")
			stmt.put_parameter (photo, "photo")
			stmt.bind_parameters
			stmt.execute
			if stmt.is_ok then
				print ("OK%N")
			else
				print ("KO%N")
			end
			stmt.close
		end

	get_photo is
		local
			photo : ECLI_FILE_LONGVARBINARY
			photo_file : KL_BINARY_OUTPUT_FILE
		do
			create photo_file.make ("myphoto.bmp")	
			create photo.make_output (photo_file)
			create stmt.make (session)
			stmt.set_sql ("select document from eclitrial")
			stmt.execute
			stmt.set_results (<<photo>>)
			if stmt.is_ok then
				print ("OK%N")
				from
					stmt.start
				until
					stmt.off
				loop
					stmt.forth
				end
			else
				print ("KO%N")
			end
			stmt.close
		end
		
feature -- Access

	session : ECLI_SESSION
			-- Database session on datasource
			
	stmt : ECLI_STATEMENT
			-- Statement used for executing SQL

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
				io.put_string ("Usage: test1 <data_source> <user_name> <password> [<trace_file_name>]%N")
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

	create_statement is
			-- creation of 'stmt'
		require
			session_connected: session /= VOid and then session.is_connected
		do
			io.put_string ("%N STATEMENT - Creation%N")
			io.put_string ("---------------------------------%N")
			-- definition of statement on session
			create  stmt.make (session)
		ensure
			stmt_not_void: stmt /= Void
		end

	create_sample_table is
				-- create sample table named ECLITRIAL
			require
				stmt_not_void: stmt /= Void
			do
				io.put_string ("%N DDL - Create sample table%N")
				io.put_string ("---------------------------------%N")
				-- DDL statement
				-- | Uncomment next line for using MS Access driver or PostgreSQL or SQL Server
				stmt.set_sql ("CREATE TABLE ECLITRIAL (name CHAR(20), fname VARCHAR (20), nbr INTEGER, bdate DATETIME, price FLOAT, document LONGBINARY)")
				--
				-- | Uncomment next line for using Oracle 8 driver, and comment previous one
				--stmt.set_sql ("CREATE TABLE ECLITRIAL (lname CHAR(20), fname VARCHAR2 (20), nbr NUMBER(10), bdate DATE, price FLOAT)")

				-- | Uncomment next line for using Interbase driver, and comment previous one
				--stmt.set_sql ("CREATE TABLE ECLITRIAL (name CHAR(20), fname VARCHAR (20), nbr INTEGER, bdate TIMESTAMP, price FLOAT)")
				show_query ("Table creation : ",stmt)

				stmt.execute
				if stmt.is_ok then
					io.put_string ("Table ECLITRIAL created%N")
				else
					print_status (stmt)
				end
			end

	simple_insert_sample_tuples is
			-- insert sample tuples with simple direct SQL
		do
			io.put_string ("%N DML - Insert tuples - Direct SQL%N")
			io.put_string ("---------------------------------%N")
			-- DML statements

			stmt.set_sql ("INSERT INTO ECLITRIAL VALUES ('Smith', 'Henry', 10, {ts '2000-05-24 08:20:15.00'}, 33.3)")
			show_query ("Insertion of hard-coded values%N", stmt)

			stmt.execute
			--
			stmt.set_sql ("INSERT INTO ECLITRIAL VALUES ('Lulu', 'O''Connor', 20, {ts '2000-06-25 09:34:00.00'}, 12.2)")
			show_query ("",stmt)

			stmt.execute
			--
			stmt.set_sql ("INSERT INTO ECLITRIAL VALUES ('Didi', 'Lemmings', 30, {ts '2000-07-26 23:59:59.00'}, 42.4)")
			show_query ("", stmt)

			stmt.execute
		end

	parameterized_insert is
		local
			p_birthdate : 	ECLI_TIMESTAMP
			first_name_parameter : ECLI_CHAR
			last_name_parameter : 	ECLI_VARCHAR
			p_nbr : ECLI_INTEGER
			price : DOUBLE
			p_price : ECLI_DOUBLE
			l_parameters : ARRAY[ECLI_VALUE]
		do
			io.put_string ("%N DML - Insert tuples - Parameterized SQL%N")
			io.put_string ("------------------------------------------%N")
			-- set parameterized statement
			stmt.set_sql ("INSERT INTO ECLITRIAL VALUES ( ?last_name, ?first_name, ?nbr, ?year, ?price)")
			show_query ("Insertion of parameterized values%N", stmt)

			-- create and setup parameters and values

			create  first_name_parameter.make (20)
			create last_name_parameter.make (20)
			create p_nbr.make
			create p_price.make
			create  p_birthdate.make (1957, 9, 22, 14, 30, 02, 0)
			first_name_parameter.set_item ("Portail")
			last_name_parameter.set_item ("Guillaume")
			p_nbr.set_item (10)
			price := 89.107896
			p_price.set_item (price)

			-- setup parameters array
			create l_parameters.make (1, 5)
			l_parameters.put (last_name_parameter, 1)
			l_parameters.put (first_name_parameter,2)
			l_parameters.put (p_nbr,3)
			l_parameters.put (p_birthdate,4)
			l_parameters.put (p_price,5)

			-- set parameters
			stmt.set_parameters (l_parameters)
			-- SmartEiffel fooled by manifest arrays <<last_name_parameter, first_name_parameter,  p_nbr, p_birthdate, p_price>>)

			show_parameter_names (stmt)
			stmt.bind_parameters
			if not stmt.is_ok then
				print_status (stmt)
			end
			stmt.execute
			if not stmt.is_ok or stmt.has_information_message then
				print_status (stmt)
			end
		end

	parameterized_prepared_insert_sample_tuples is
			-- insert sample tuples with parameterized and prepared SQL
		local
			p_birthdate : 	ECLI_TIMESTAMP
			first_name_parameter, last_name_parameter : 	ECLI_CHAR
			l_parameters: ARRAY[ECLI_VALUE]
		do
			io.put_string ("%N Parameterized insert sample %N")
			io.put_string ("---------------------------------%N")
			-- parameterized statement
			stmt.set_sql ("INSERT INTO ECLITRIAL VALUES (?first_name, ?last_name, 40, ?some_date, 89.02)")
			show_query ("Insertion of parameterized values%N", stmt)

			-- create and setup parameters and values

			create  first_name_parameter.make (20)
			create last_name_parameter.make (20)
			create  p_birthdate.make (1957, 9, 22, 14, 30, 02, 500_000_000)
			
			first_name_parameter.set_item ("Stoney")
			last_name_parameter.set_item ("Archibald")

			-- set parameters by "tuple" i.e. ARRAY[ECLI_VALUE]
			-- order *matters* 
			create l_parameters.make (1,3)
			l_parameters.put (first_name_parameter,1)
			l_parameters.put (last_name_parameter, 2)
			l_parameters.put (p_birthdate, 3)

			stmt.set_parameters (l_parameters)
			-- Do not use Manifest Arrays : SmartEiffel 1.0 and greater generate wrong code !

			-- using 'prepare' sets prepared_execution_mode
			stmt.prepare
			if not stmt.is_ok then
				io.put_string (stmt.diagnostic_message)
				io.put_character ('%N')
			else
				io.put_string ("Prepared%N")
			end
			show_parameter_names (stmt)
			-- describe_parameters is not supported by all drivers

			if stmt.is_describe_parameters_capable then
				stmt.describe_parameters
			else
				io.put_string ("* Parameter description not possible *%N")
			end

			io.put_string ("Executing with parameters : '")
			io.put_string (first_name_parameter.out); io.put_string ("', '")
			io.put_string (last_name_parameter.out); io.put_string ("', '")
			io.put_string (p_birthdate.out); io.put_string ("'%N")
			stmt.bind_parameters
			if stmt.bound_parameters then
				stmt.execute
				if not stmt.is_ok or stmt.has_information_message then
					io.put_string (stmt.diagnostic_message)
					io.put_character ('%N')
				end
			else
				io.put_string ("Problem with parameter ")
				io.put_integer (stmt.last_bound_parameter_index + 1)
				io.put_new_line
				io.put_string (stmt.diagnostic_message)
				io.put_character ('%N')
			end

			-- Change parameter value
			first_name_parameter.set_null

			-- show how it is possible to bind a parameter 'by name'
			stmt.put_parameter (first_name_parameter, "first_name")

			-- put_parameter 'unbind' previously bound parameters; they have to be bound again before execution
			stmt.bind_parameters

			io.put_string ("Executing with parameters : '")
			io.put_string (first_name_parameter.out); io.put_string ("', '")
			io.put_string (last_name_parameter.out); io.put_string ("', '")
			io.put_string (p_birthdate.out); io.put_string ("'%N")

			if stmt.bound_parameters then
				stmt.execute
				if not stmt.is_ok or stmt.has_information_message then
					io.put_string (stmt.diagnostic_message)
					io.put_character ('%N')
				end
			else
				io.put_string ("Problem with parameter ")
				io.put_integer (stmt.last_bound_parameter_index + 1)
				io.put_new_line
				io.put_string (stmt.diagnostic_message)
				io.put_character ('%N')
			end
		end

	query_database is
			-- query database to see what's in the ECLITRIAL table
		local
			name_result_value : 	ECLI_CHAR
			price_result_value : 	ECLI_DOUBLE
			birthdate_result_value : 	ECLI_TIMESTAMP
			firstname_result_value : 	ECLI_VARCHAR
			number_result_value : 		ECLI_INTEGER
			l_cursor : ARRAY[ECLI_VALUE]
		do
			-- set execution mode to immediate (no need to prepare)
			stmt.set_immediate_execution_mode
			stmt.set_sql ("SELECT name, fname, nbr, bdate, price FROM ECLITRIAL")

			show_query("Selection of all inserted data%N", stmt)

			stmt.execute
			if stmt.is_ok then
				show_column_names (stmt)
				
				-- create result set 'value holders'
				create  name_result_value.make (20)
				create  firstname_result_value.make (20)
				create  number_result_value.make
				create  birthdate_result_value.make_default
				create  price_result_value.make
				-- define the container of value holders
				-- name CHAR(20), fname VARCHAR (20), nbr INTEGER, bdate DATETIME, price FLOAT
				create l_cursor.make (1, 5)
				l_cursor.put (name_result_value, 1)
				l_cursor.put (firstname_result_value, 2)
				l_cursor.put (number_result_value,3)
				l_cursor.put (birthdate_result_value, 4)
				l_cursor.put (price_result_value, 5)
				
				stmt.set_results (l_cursor)
				-- iterate on result-set
				from
					stmt.start
				until
					stmt.off
				loop
					show_result_row (stmt)
					stmt.forth
				end
			else
				io.put_string (stmt.diagnostic_message)
				io.put_character ('%N')
			end

		end

	drop_table is
			-- drop ECLITRIAL
		do
			-- DDL statement
			stmt.set_sql  ("DROP TABLE ECLITRIAL")
			show_query ("%N Dropping table%N", stmt)
			io.put_string ("---------------------------------%N")
			stmt.execute
			if not stmt.is_ok then
				print_status (stmt)
			end
		end

	disconnect_session is
			-- disconnect session before closing
		do
			-- session disconnection
			session.disconnect
			if not session.is_connected then
				io.put_string ("%NSession disconnected %N")
			else
				print_status (stmt)
			end
		end

	close_statement is
			-- close `stmt'
		do
			stmt.close
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

	show_column_names (a_statement : ECLI_STATEMENT) is
			-- show column names of `a_statement'.cursor_description
		require
			statement_not_void: a_statement /= Void
			statement_executed: a_statement.is_executed
			statement_has_results: a_statement.has_result_set
		local
			i : INTEGER
		do
			from
				i := 1
				a_statement.describe_results
			until
				i > a_statement.results_description.count
			loop
				io.put_string (formatted_column (a_statement.results_description.item (i).name,
							a_statement.results_description.item (i)))
				if i <= a_statement.results_description.count then
					io.put_character ('|')
				end
				i := i + 1
			end
			io.put_character ('%N')
		end

	formatted_column (s : STRING; d : ECLI_COLUMN_DESCRIPTION) : STRING is
			-- `s' formatted with respect to `d'.size
		local
			width : INTEGER
		do
			width := d.size
			if d.sql_type_code = sql_integer 
			   or else d.sql_type_code = sql_double 
			   or else d.sql_type_code = Sql_float then
				width := width.min (15)
			end
			create  Result.make (width)
			Result.append (s)
			-- pad with blanks
			from
				width := width - s.count
			until
				width <= 0
			loop
				Result.append_character (' ')
				width := width - 1
			end
		end
		
	show_result_row (a_statement : ECLI_STATEMENT) is
			-- show values at current cursor position for `a_statement'
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > a_statement.results.count
			loop
				io.put_string (formatted_column (
							a_statement.results.item (i).out,
							a_statement.results_description.item (i)))
				io.put_character ('|')
				i := i + 1
			end
			io.put_character ('%N')
		end


	show_query (comment : STRING; statement : ECLI_STATEMENT) is
			-- show query on `statement', preceded by `comment'
		do
			io.put_string (comment)
			io.put_string (statement.sql)
			io.put_character ('%N')
			if statement.has_information_message or not statement.is_ok then
				print_status (statement)
			end
		end

	print_status (status : ECLI_STATUS) is
			-- print `status' information
		do
			if status.has_information_message then
				print ("Information *%N")
			elseif status.is_error then
				print ("Error       *%N")
			end
			print ("%TStatus     : ")
			print (status.cli_state)
			print ("%N%TNative code: ")
			print (status.native_code)
			print ("%N%TDiagnostic : ")
			print (status.diagnostic_message)
			print ("%N")
		end

end -- class TEST1
--
-- Copyright: 2000-2005, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
