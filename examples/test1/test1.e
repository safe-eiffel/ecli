indexing
	description: "TEST1 sample application";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"


class
	TEST1

creation

	make

feature -- Initialization

	make is
			-- ecli test application
		do
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
					simple_insert_sample_tuples
					query_database
					parameterized_insert
					query_database
					parameterized_prepared_insert_sample_tuples
					query_database
					drop_table
					close_statement
					disconnect_session
				end
				close_session
			end
			io.put_string ("Press ENTER to continue")
			io.read_line
		end


feature -- Access

	session : 	ECLI_SESSION
	stmt : 		ECLI_STATEMENT

	data_source_name, user_name, password : STRING

	trace_file_name : STRING
	
feature -- Status setting

	arguments_ok : BOOLEAN

feature --  Basic operations

	parse_arguments is
		local
			args :		expanded ARGUMENTS
		do
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
		do
				io.put_string ("Usage: test1 <data_source> <user_name> <password> [<trace_file_name>]%N")
		end

	trace_if_necessary is
		local
			f : KL_TEXT_OUTPUT_FILE
			tracer : ECLI_TRACER
		do
			if trace_file_name /= Void then
				!!f.make (trace_file_name)
				f.open_write
				if f.is_open_write then
					!!tracer.make (f)
					session.set_tracer (tracer)
					io.put_string ("Trace in file : ")
					io.put_string (trace_file_name)
					io.put_string ("%N")
				else
					io.put_string ("Trace file <")
					io.put_string (trace_file_name)
					io.put_string ("> cannot be open.  No trace%N")
				end
			end		
		end
		
	create_and_connect_session is
		do
			io.put_string ("SESSION - Creation and Connection%N")
			!! session.make (data_source_name, user_name, password)
			session.connect
			if session.has_information_message or not session.is_ok then
				print_status (session)
			end
			if session.is_connected then
				io.put_string ("Connected !!!%N")
			end
		ensure
			session_exists: session /= Void
		end

	create_statement is
			-- creation of 'stmt'
		require
			session_connected: session /= VOid and then session.is_connected
		do
			io.put_string ("STATEMENT - Creation%N")
			-- definition of statement on session
			!! stmt.make (session)
		ensure
			stmt_exists: stmt /= Void
		end

	create_sample_table is
			require
				stmt_exists: stmt /= Void
			do
				io.put_string (" - DDL - Create sample table%N")
				-- DDL statement
				-- | Uncomment next line for using MS Access driver or PostgreSQL
				stmt.set_sql ("CREATE TABLE ECLIESSAI (name CHAR(20), fname VARCHAR (20), nbr INTEGER, bdate DATETIME, price FLOAT)")
				--
				-- | Uncomment next line for using Oracle 8 driver, and comment previous one
				--stmt.set_sql ("CREATE TABLE ECLIESSAI (lname CHAR(20), fname VARCHAR2 (20), nbr NUMBER(10), bdate DATE, price FLOAT)")
				-- | Uncomment next line for using Interbase driver, and comment previous one
				--stmt.set_sql ("CREATE TABLE ECLIESSAI (name CHAR(20), fname VARCHAR (20), nbr INTEGER, bdate TIMESTAMP, price FLOAT)")
				show_query ("Table creation : ",stmt)

				stmt.execute
				if stmt.is_ok then
					io.put_string ("Table ECLIESSAI created%N")
				else
					print_status (stmt)
				end
			end

	simple_insert_sample_tuples is
			-- insert sample tuples with simple direct SQL
		do
				io.put_string (" - DML - Insert tuples - Direct SQL%N")
				-- DML statements

				stmt.set_sql ("INSERT INTO ECLIESSAI VALUES ('Toto', 'Henri', 10, {ts '2000-05-24 08:20:15.00'}, 33.3)")
				show_query ("Insertion of hard-coded values%N", stmt)

				stmt.execute
				--
				stmt.set_sql ("INSERT INTO ECLIESSAI VALUES ('Lulu', 'O''Connor', 20, {ts '2000-06-25 09:34:00.00'}, 12.2)")
				show_query ("",stmt)

				stmt.execute
				--
				stmt.set_sql ("INSERT INTO ECLIESSAI VALUES ('Didi', 'Lemmings', 30, {ts '2000-07-26 23:59:59.00'}, 42.4)")
				show_query ("", stmt)

				stmt.execute
		end

	parameterized_insert is
		local
			p_birthdate : 	ECLI_DATE_TIME
			first_name_parameter, last_name_parameter : 	ECLI_CHAR
			p_nbr : ECLI_INTEGER
			price : DOUBLE
			p_price : ECLI_DOUBLE
		do
			io.put_string (" - DML - Insert tuples - Parameterized SQL%N")
			-- parameterized statement
			stmt.set_sql ("INSERT INTO ECLIESSAI VALUES (?first_name, ?last_name, ?nbr, ?year, ?price)")
			show_query ("Insertion of parameterized values%N", stmt)
			-- create and setup parameters and values
			!! first_name_parameter.make (20)
			first_name_parameter.set_item ("Portail")
			!!last_name_parameter.make (20)
			last_name_parameter.set_item ("Guillaume")
			!!p_nbr.make
			p_nbr.set_item (10)
			price := 89.107896
			!!p_price.make
			p_price.set_item (price)
			!! p_birthdate.make (1957, 9, 22, 14, 30, 02, 0)
			stmt.set_parameters (<<first_name_parameter, last_name_parameter, p_nbr, p_birthdate, p_price>>)
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
		do
			-- parameterized statement
			stmt.set_sql ("INSERT INTO ECLIESSAI VALUES (?first_name, ?last_name, 40, ?some_date, 89.02)")
			show_query ("Insertion of parameterized values%N", stmt)
			-- create and setup parameters and values
			!! first_name_parameter.make (20)
			first_name_parameter.set_item ("Stoney")
			!!last_name_parameter.make (20)
			last_name_parameter.set_item ("Archibald")
			!! p_birthdate.make (1957, 9, 22, 14, 30, 02, 0)

			-- set parameters by "tuple" i.e. ARRAY[ECLI_VALUE]
			-- order *matters* !!!

			stmt.set_parameters (<<first_name_parameter, last_name_parameter, p_birthdate>>)

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

			stmt.describe_parameters

			-- verify if `describe_parameters' is supported or not

			if not stmt.is_ok then
				io.put_string ("* Parameter description not possible !!! *%N")
			end

			io.put_string ("Executing with parameters : '")
			io.put_string (first_name_parameter.out); io.put_string ("', '")
			io.put_string (last_name_parameter.out); io.put_string ("', '")
			io.put_string (p_birthdate.out); io.put_string ("'%N")
			stmt.bind_parameters
			stmt.execute

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

			stmt.execute
			if not stmt.is_ok then
				io.put_string (stmt.diagnostic_message)
				io.put_character ('%N')
			end
		end

	query_database is
		local
			name_result_value : 	ECLI_CHAR
			price_result_value : 	ECLI_DOUBLE
			birthdate_result_value : 	ECLI_DATE_TIME
			firstname_result_value : 	ECLI_VARCHAR
			number_result_value : 		ECLI_INTEGER
		do
			-- set execution mode to immediate (no need to prepare)
			stmt.set_immediate_execution_mode
			stmt.set_sql ("SELECT * FROM ECLIESSAI")

			show_query("Selection of all inserted data%N", stmt)

			stmt.execute
			if stmt.is_ok then
				stmt.describe_cursor
				-- create result set 'value holders'
				!! name_result_value.make (20)
				!! firstname_result_value.make (20)
				!! number_result_value.make
				!! birthdate_result_value.make_default
				!! price_result_value.make
				-- define the container of value holders
				stmt.set_cursor (<<name_result_value, firstname_result_value, number_result_value, birthdate_result_value, price_result_value>>)
				-- iterate on result-set
				from
					stmt.start
					show_column_names (stmt)
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
		do
			-- DDL statement
			stmt.set_sql  ("DROP TABLE ECLIESSAI")
			show_query ("Dropping table%N", stmt)
			stmt.execute
			if not stmt.is_ok then
				print_status (stmt)
			end
		end

	disconnect_session is
		do
			-- session disconnection
			session.disconnect
			if not session.is_connected then
				io.put_string ("Disconnected!!!%N")
			end
		end

	close_statement is
		do
			stmt.close
		end

	close_session is
		do
			session.close
		end

feature -- Miscellaneous

	show_parameter_names (astmt : ECLI_STATEMENT) is
		local
			list_cursor: DS_LIST_CURSOR[STRING]
		do
			list_cursor := astmt.parameter_names.new_cursor
			from
				list_cursor.start
				io.put_string ("** Parameter names **%N")
			until
				list_cursor.off
			loop
				io.put_string (list_cursor.item)
				io.put_string ("%N")
				list_cursor.forth
			end
		end

	show_column_names (astmt : ECLI_STATEMENT) is
		require
			statement_exists: astmt /= Void
			statement_executed: astmt.is_executed
			statement_has_results: astmt.has_results
		local
			i, width : INTEGER
			s : STRING
		do
			from
				i := 1
			until
				i > astmt.cursor_description.count
			loop
				width := astmt.cursor_description.item (i).size
				!! s.make (width)
				s.append (astmt.cursor_description.item (i).name)
				-- pad with blanks
				from
					width := width - s.count
				until
					width <= 0
				loop
					s.append_character (' ')
					width := width - 1
				end
				io.put_string (s)
				if i <= astmt.cursor_description.count then
					io.put_character ('|')
				end
				i := i + 1
			end
			io.put_character ('%N')
		end

	show_result_row (astmt : ECLI_STATEMENT) is
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > astmt.cursor.count
			loop
				io.put_string (astmt.cursor.item (i).out)
				io.put_character ('|')
				i := i + 1
			end
			io.put_character ('%N')
		end


	show_query (comment : STRING; statement : ECLI_STATEMENT) is
		do
			io.put_string (comment)
			io.put_string (statement.sql)
			io.put_character ('%N')
			if statement.has_information_message or not statement.is_ok then
				print_status (statement)
			end
		end

	print_status (status : ECLI_STATUS) is
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

invariant
end -- class TEST1
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
