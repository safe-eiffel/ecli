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
			end
		ensure
			ok: arguments_ok implies (data_source_name /= Void and user_name /= Void and password /= Void)
		end

	print_usage is
		do
				io.put_string ("Usage: test1 <data_source> <user_name> <password>%N")
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
				stmt.set_sql ("INSERT INTO ECLIESSAI VALUES ('Lulu', 'Jimmy', 20, {ts '2000-06-25 09:34:00.00'}, 12.2)")
				show_query ("",stmt)

				stmt.execute
				--
				stmt.set_sql ("INSERT INTO ECLIESSAI VALUES ('Didi', 'Anticonstitutionnellement', 30, {ts '2000-07-26 23:59:59.99'}, 42.4)")
				show_query ("", stmt)

				stmt.execute
		end

	parameterized_insert is
		local
			p_birthdate : 	ECLI_TIMESTAMP
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
         !! p_birthdate.make (1957, 9, 22, 14, 30, 02, 5453528)
         stmt.set_parameters (<<first_name_parameter, last_name_parameter, p_nbr, p_birthdate, p_price>>)
			show_parameter_names (stmt)
			stmt.bind_parameters
			if not stmt.is_ok then
         	print_status (stmt)
         end
         stmt.execute
			if not stmt.is_ok then
				print_status (stmt)
			end
      end

	parameterized_prepared_insert_sample_tuples is
			-- insert sample tuples with parameterized and prepared SQL
		local
			p_birthdate : 	ECLI_TIMESTAMP
			name_parameter, other_name_parameter : 	ECLI_CHAR
		do
			-- parameterized statement
			stmt.set_sql ("INSERT INTO ECLIESSAI VALUES (?some_name, ?some_other_name, 40, ?some_date, 89.02)")
			show_query ("Insertion of parameterized values%N", stmt)
			-- create and setup parameters and values
			!! name_parameter.make (20)
			name_parameter.set_item ("Stoney")
			!!other_name_parameter.make (20)
         other_name_parameter.set_item ("Archibald")
         !! p_birthdate.make (1957, 9, 22, 14, 30, 02, 5453528)
			stmt.set_parameters (<<name_parameter, other_name_parameter, p_birthdate>>)
			-- using 'prepare' sets prepared_execution_mode
			stmt.prepare
			if not stmt.is_ok then
				io.put_string (stmt.diagnostic_message)
				io.put_character ('%N')
			else
         	io.put_string ("Prepared%N")
         end
			show_parameter_names (stmt)
			stmt.describe_parameters
			if not stmt.is_ok then
				io.put_string ("* Parameter description not possible !!! *%N")
			end
			io.put_string ("Executing with parameters : '")
			io.put_string (name_parameter.out); io.put_string ("', '")
			io.put_string (name_parameter.out); io.put_string ("', '")
			io.put_string (p_birthdate.out); io.put_string ("'%N")
			stmt.bind_parameters
			stmt.execute
			-- Change parameter value
			name_parameter.set_null
			-- show how it is possible to bind a parameter 'by name'
			stmt.put_parameter (name_parameter, "some_name")
			-- put_parameter 'unbind' previously bound parameters; they have to be bound again before execution
			stmt.bind_parameters
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
			birthdate_result_value : 	ECLI_TIMESTAMP
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
				!! birthdate_result_value.make_first
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
		local
			i, width : INTEGER
			s : STRING
		do
			from
				i := 1
			until
				i > astmt.cursor_description.count
			loop
				width := astmt.cursor_description.item (i).column_precision
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
		end

	print_status (status : ECLI_STATUS) is
   	do
           --if status.has_information_message or status.is_error then
                   print (status.cli_state)
                   print (status.native_code)
                   print (status.diagnostic_message)
           --end
      end

invariant
end -- class TEST1
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
