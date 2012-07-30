indexing
	description: "[
			TEST1 sample application.
			
			Shows various topics : 
			* create and drop tables (DDL)
			* table insertion (basic, parameterized)
			* selection
			* putting and getting long data (photos in this case).
	]";

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"


class
	TEST1

inherit

	ECLI_TYPE_CONSTANTS

	KL_SHARED_EXECUTION_ENVIRONMENT
	KL_SHARED_FILE_SYSTEM

	KL_SHARED_ARGUMENTS

	KL_IMPORTED_ARRAY_ROUTINES

create

	make

feature -- Initialization

	make is
			-- Application constructor.
		local
			nl : BOOLEAN
			s : STRING
		do
			create error_handler.make_standard
			error_handler.report_info_message ("'test1' ECLI tutorial application%N%N")
			-- session opening
			parse_arguments
			if not arguments_ok then
			 	print_usage
			else
				create_and_connect_session
				if session.is_connected then
--FIXME:
--					create type_catalog.make (session)
					trace_if_necessary
					create_statement
					determine_current_sql_type
					if current_sql_type /= Void then
						 create_sample_table
						if is_tables_created then
							simple_insert_sample_tuples
							parameterized_insert
							parameterized_prepared_insert_sample_tuples
							query_database
							if is_longvarbinary_supported then
								put_photo ("1892005034", photo_filename ("nvc.jpg"))
								put_photo ("0136291554", photo_filename ("oosc2.jpg"))
								get_photo ("0136291554", ".\photo_oosc2.jpg")
								get_photo ("1892005034", ".\photo_nvc.jpg")
							end
						end
						drop_tables
					else
						error_handler.report_info_message ("Could not determine SQL type")
					end
					disconnect_session
				end
				close_session
				error_handler.report_info_message ("Test1 finished.%N")
			end
		end

feature -- Access

	session : ECLI_SESSION
			-- Database session on datasource

	type_catalog : ECLI_TYPE_CATALOG
			-- Catalog of types available for `session'.

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

	current_sql_type : STRING
			-- Current sql type.

	error_handler : UT_ERROR_HANDLER

	valid_sql_types : DS_LIST[STRING] is
			-- Valid sql types
		once
			create {DS_LINKED_LIST[STRING]}Result.make
		 	Result.put_right (sql_92)
			Result.put_right (sql_interbase)
			Result.put_right (sql_mssql)
			Result.put_right (sql_oracle)
			Result.put_right (sql_postgres)
			Result.set_equality_tester (create {KL_EQUALITY_TESTER[STRING]})
		ensure
			valid_sql_types_not_void: Result /= Void
		end

feature -- Status setting

	arguments_ok : BOOLEAN
			-- are program arguments OK ?

	is_tables_created : BOOLEAN

	is_longvarbinary_supported : BOOLEAN

feature --  Basic operations

	create_and_connect_session is
			-- Create session and connect user `data_source_name', `user_name' and `password'.
		require
			data_source_name_not_void: data_source_name /= Void
			user_name_not_void: user_name /= Void
			password_not_void: password /= Void
		local
			login_strategy : ECLI_LOGIN_STRATEGY
		do
			error_handler.report_info_message ("=> SESSION - Creation and Connection")
			error_handler.report_info_message ("Connection can give some information about what happened%NThis is not necessarily an error !%N")
			create  session.make_default
			create {ECLI_SIMPLE_LOGIN}login_strategy.make (data_source_name, user_name, password)
			session.set_login_strategy (login_strategy)
			session.connect
			if session.has_information_message or not session.is_ok then
				handle_status (session)
			end
			if session.is_connected then
				error_handler.report_info_message ("SUCCESS: Connected")
			end
			session.set_error_handler (create {ECLI_ERROR_HANDLER}.make_standard)
		ensure
			session_not_void: session /= Void
		end

	trace_if_necessary is
			-- Activate trace if trace_file_name exists.
		local
			f : KL_TEXT_OUTPUT_FILE
			tracer : ECLI_TRACER
			message : STRING
		do
			create message.make (100)
			if trace_file_name /= Void then
				create f.make (trace_file_name)
				f.open_write
				if f.is_open_write then
					create tracer.make (f)
					session.set_tracer (tracer)
					message.append_string ("+ Trace in file : '")
					message.append_string (trace_file_name)
					message.append_character ('%'')
					error_handler.report_info_message (message)
				else
					message.append_string ("- Trace file cannot be open : '")
					message.append_string (trace_file_name)
					message.append_character ('%'')
					error_handler.report_error_message (message)
				end
			end
		end

	create_statement is
			-- Create 'stmt'.
		require
			session_connected: session /= VOid and then session.is_connected
		do
			error_handler.report_info_message ("=> STATEMENT - Creation")
			-- definition of statement on session
			create  stmt.make (session)
			stmt.set_error_handler (create {ECLI_ERROR_HANDLER}.make_standard)
		ensure
			stmt_not_void: stmt /= Void
		end

	determine_current_sql_type is
		local
			name : STRING
		do
			name := session.info.dbms_name
			if current_sql_type = Void then
				dbms2sqlsyntax.search (name)
				if dbms2sqlsyntax.found then
					current_sql_type := dbms2sqlsyntax.found_item
				end
			end
			if current_sql_type /= Void then
				is_longvarbinary_supported := dbms2longvarbinary.has (name) and then dbms2longvarbinary.item (name)
			end
		end

	create_sample_table is
				-- Create sample tables.
			require
				stmt_not_void: stmt /= Void
				current_sql_type_not_vodi: current_sql_type /= Void
			do
				error_handler.report_info_message ("=> DDL - Create sample tables")
				-- change to sql_oracle or sql_interbase in order to get the appropriate SQL version
				get_ddl_statements
				stmt.set_sql (ddl_book)
				stmt.execute
				if stmt.is_ok then
					stmt.set_sql (ddl_copy)
					stmt.execute
					if stmt.is_ok then
						stmt.set_sql (ddl_borrower)
						stmt.execute
						if stmt.is_ok and is_longvarbinary_supported then
							stmt.set_sql (ddl_bookcover)
							stmt.execute
						end
					end
				end
				if not stmt.is_ok then
					handle_status (stmt)
				end
				is_tables_created := stmt.is_ok
			end

	simple_insert_sample_tuples is
			-- Insert sample tuples with simple direct SQL.
		do
			error_handler.report_info_message ("=> DML - Insert tuples - Direct SQL")
			-- DML statements
			-- BOOK
			stmt.set_sql ("INSERT INTO BOOK VALUES ('1892005034', 'Nonviolent Communication: A Language of Life', 'Rosenberg, Marshall B.')")
			stmt.execute
			show_query (stmt)

--			-- BORROWER
--			stmt.set_sql ("INSERT INTO BORROWER VALUES (1, 'Smith, Paul', 'Avenue Albert Ier, 54, 3000 Leuven')")
--			show_query (

			-- COPY
			stmt.set_sql ("INSERT INTO COPY VALUES ('1892005034', 1, {d '2005-03-27'}, 15.77, 1,1,1, NULL, NULL)")
			stmt.execute
			show_query (stmt)
		end

	parameterized_insert is
			-- Insert tuples through parameterized statements.
		local
			p_isbn : ECLI_VARCHAR
			p_title : ECLI_VARCHAR
			p_author : ECLI_VARCHAR
		do
			error_handler.report_info_message ("=> DML - Insert tuples - Parameterized SQL")
			-- create buffers
			create p_isbn.make (14)
			create p_title.make (100)
			create p_author.make (30)

			-- Insert new BOOK
			-- set SQL
			stmt.set_sql (dml_parameterized_insert_book)

			-- put parameters by array
			stmt.set_parameters (<< p_isbn, p_title, p_author>>)

			-- bind parameters
			stmt.bind_parameters

			-- set parameter values
			p_isbn.set_item ("0136291554")
			p_title.set_item ("Object-Oriented Software Construction (Book/CD-ROM) (2nd Edition)")
			p_author.set_item ("Meyer, Bertrand")

			-- execute
			stmt.execute
			show_query (stmt)

			if not stmt.is_ok or stmt.has_information_message then
				handle_status (stmt)
			end
		end

	parameterized_prepared_insert_sample_tuples is
			-- Insert tuples with parameterized and prepared SQL.
		local
			p_isbn : ECLI_VARCHAR
			p_serial : ECLI_INTEGER
			p_purchased : ECLI_TIMESTAMP
			p_price : ECLI_DOUBLE
			p_store, p_shelf, p_row : ECLI_INTEGER
			p_borrower : ECLI_INTEGER
			p_borrow_date : ECLI_TIMESTAMP
			purchase_date : DT_DATE_TIME
		do
			error_handler.report_info_message ("=> DML - Insert tuples - Prepared + parameterized SQL")
			-- create buffers
			create p_isbn.make (14)
			create p_serial.make
			create p_purchased.make_null
			create p_price.make
			create p_store.make
			create p_shelf.make
			create p_row.make
			create p_borrower.make
			create p_borrow_date.make_null

			-- Insert new BOOK
			-- set SQL
			stmt.set_sql (dml_parameterized_insert_copy)
			-- Prepare
			stmt.prepare
			if stmt.is_ok then
				-- put parameters by name
				stmt.put_parameter (p_isbn, "isbn")
				stmt.put_parameter (p_serial, "serial")
				stmt.put_parameter (p_purchased, "purchased")
				stmt.put_parameter (p_price, "price")
				stmt.put_parameter (p_store, "store")
				stmt.put_parameter (p_shelf, "shelf")
				stmt.put_parameter (p_row, "row")
				stmt.put_parameter (p_borrower, "borrower")
				stmt.put_parameter (p_borrow_date, "borrow_date")


				-- bind parameters
				stmt.bind_parameters

				-- set parameter values
				p_isbn.set_item ("0136291554")
				p_serial.set_item (1)
				create purchase_date.make (1998, 2, 3, 0, 0, 0)
				p_purchased.set_item (purchase_date)
				p_price.set_item (89.90)
				p_store.set_item (1)
				p_shelf.set_item (3)
				p_row.set_item (1)
				p_borrower.set_null
				p_borrow_date.set_null

				-- execute
				stmt.execute
				show_query (stmt)
			end
			if not stmt.is_ok or stmt.has_information_message then
				handle_status (stmt)
			end
		end

	query_database is
			-- Query database to see what's in the BOOK table.
		local
			buffer_factory : ECLI_BUFFER_FACTORY
		do
			error_handler.report_info_message ("=> DML - Selection of data")
			-- set execution mode to immediate (no need to prepare)
			stmt.set_immediate_execution_mode
			stmt.set_sql ("SELECT * from BOOK")

			show_query(stmt)

			stmt.execute
			if stmt.is_ok then
				show_column_names (stmt)

				create buffer_factory

				-- create result set 'value holders'
				stmt.describe_results
				buffer_factory.create_buffers (stmt.results_description)
				stmt.set_results (buffer_factory.last_buffers)
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

	put_photo (an_isbn, a_target_filename : STRING) is
			-- Put long data.
		require
			an_isbn_not_void: an_isbn /= Void
			a_target_filename_not_void: a_target_filename /= Void
			stmt_valid: stmt /= Void and then stmt.is_valid
		local
			photo : ECLI_FILE_LONGVARBINARY
			photo_file : KL_BINARY_INPUT_FILE
			isbn : ECLI_VARCHAR
			l_stmt : ECLI_STATEMENT
		do
			create l_stmt.make (session)
--			l_stmt.raise_exception_on_error
			error_handler.report_info_message ("=> DML - Insert tuple - Long data")
			create photo_file.make (a_target_filename)
			-- Create photo buffer for input.
			create photo.make_input (photo_file)
			create isbn.make (14)
			isbn.set_item (an_isbn)
			l_stmt.set_sql ("INSERT INTO BOOKCOVER VALUES (?isbn, ?photo)")
			l_stmt.put_parameter (photo, "photo")
			l_stmt.put_parameter (isbn, "isbn")
			l_stmt.bind_parameters
			l_stmt.execute
			show_query (l_stmt)
			if stmt.is_ok then
				print ("OK%N")
			else
				print ("KO%N")
			end
			l_stmt.close
		end

	get_photo (an_isbn, a_target_filename : STRING) is
			-- Get long data.
		require
			an_isbn_not_void: an_isbn /= Void
			a_target_filename_not_void: a_target_filename /= Void
			stmt_valid: stmt /= Void and then stmt.is_valid
		local
			photo_file : KL_BINARY_OUTPUT_FILE
			photo : ECLI_FILE_LONGVARBINARY
			isbn : ECLI_VARCHAR
		do
			error_handler.report_info_message ("=> DML - Select tuple - Long data")
			create photo_file.make (a_target_filename)
			-- Create photo buffer for output.
			create photo.make_output (photo_file)
			create isbn.make (14)
			isbn.set_item (an_isbn)
			stmt.set_sql ("SELECT cover FROM BOOKCOVER WHERE isbn=?isbn")
			stmt.put_parameter (isbn, "isbn")
			stmt.bind_parameters
			stmt.execute
			show_query (stmt)
			if stmt.is_ok then
				stmt.set_results (<<photo>>)
				from
					stmt.start
				until
					not stmt.is_ok or else stmt.off
				loop
					stmt.forth
				end
				if not stmt.is_ok then
					handle_status (stmt)
				end
			else
				print ("KO%N")
			end
		end

	drop_tables is
			-- Drop tables.
		do
			error_handler.report_info_message ("=> DDL - Dropping tables")
			-- DDL statement
			stmt.set_sql  ("DROP TABLE BOOK")
			stmt.execute
			show_query (stmt)

			stmt.set_sql  ("DROP TABLE COPY")
			stmt.execute
			show_query (stmt)

			stmt.set_sql  ("DROP TABLE BORROWER")
			stmt.execute
			show_query (stmt)

			if is_longvarbinary_supported then
				stmt.set_sql  ("DROP TABLE BOOKCOVER")
				stmt.execute
				show_query (stmt)
			end
		end

	disconnect_session is
			-- Disconnect session.
		require
			session_not_void: session /= Void
			session_connected: session.is_connected
		do
			-- session disconnection
			session.disconnect
			if not session.is_connected then
				error_handler.report_info_message ("Session disconnected")
			else
				handle_status (stmt)
			end
		ensure
			session_disconnected: not session.is_connected
		end

	close_statement is
			-- Close `stmt'.
		require
			stmt_not_void: stmt /= Void
			stmt_valid: stmt.is_valid
		do
			stmt.close
		ensure
			stmt_not_valid: not stmt.is_valid
		end

	close_session is
			-- Close `session'.
		require
			session_not_void: session /= Void
			session_valid: session.is_valid
		do
			session.close
		ensure
			session_not_valid: not session.is_valid
		end

feature -- Constants

	sql_92 : STRING is "sql92"
	sql_oracle : STRING is "ora"
	sql_interbase : STRING is "ib"
	sql_mssql : STRING is "mssql"
	sql_postgres : STRING is "pg"

	dml_parameterized_insert_book : STRING is "INSERT INTO BOOK VALUES (?isbn, ?title, ?author)"
	dml_parameterized_insert_copy : STRING is "INSERT INTO COPY VALUES (?isbn, ?serial, ?purchased, ?price, ?store, ?shelf, ?row, ?borrower, ?borrow_date)"

feature {NONE} -- Implementation

	parse_arguments is
			-- Parse program arguments.
		local
			i : INTEGER
			key, value : STRING
		do
			arguments_ok := False
			from
				i := 1
			until
				i > arguments.argument_count
			loop
				key := arguments.argument (i)
				if i + 1 <= arguments.argument_count then
					value := arguments.argument (i + 1)
					if key.is_equal ("-dsn") then
						data_source_name := value
					elseif key.is_equal ("-user") then
						user_name := value
					elseif key.is_equal ("-pwd") then
						password := value
					elseif key.is_equal ("-sql") then
						current_sql_type := value
					elseif key.is_equal ("-trace") then
						trace_file_name := value
					end
					i := i + 2
				else
					i := i + 1
				end
			end
			if data_source_name /= Void and then user_name /= Void and then password /= Void then
				arguments_ok := True
				if current_sql_type /= Void then
					if valid_sql_types.has (current_sql_type) then
					else
						arguments_ok := False
						error_handler.report_error_message ("Invalid sql syntax : " + current_sql_type + " is not supported")
					end
				end
			else
				error_handler.report_error_message ("-dsn, -user and -pwd options are mandatory")
			end
		ensure
			ok: arguments_ok implies (data_source_name /= Void and user_name /= Void and password /= Void)
		end

	print_usage is
			-- Print terse usage string.
		local
			usage : UT_USAGE_MESSAGE
			message : STRING
			c : DS_LIST_CURSOR[STRING]
		do
			create message.make_from_string ("-dsn <data_source> -user <user_name> -pwd <password> -sql <sqlsyntax> [-tracefile <trace_file_name>]")
			message.append_string ("%N%TSupported sql syntaxes :%N")
			from
				c := valid_sql_types.new_cursor
				c.start
			until
				c.off
			loop
				message.append_string ("%N%T%T")
				message.append_string (c.item)
				c.forth
			end
			create usage.make (message)
			error_handler.report_warning (usage)
		end

	show_parameter_names (a_statement : ECLI_STATEMENT) is
			-- Show parameter names of SQL in `a_statement'
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
			-- Show column names of `a_statement'.cursor_description
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
			-- Format `s' with respect to `d'.size.
		local
			width : INTEGER
		do
			width := d.size.as_integer_32
			if d.sql_type_code = sql_integer
			   or else d.sql_type_code = sql_double
			   or else d.sql_type_code = Sql_float then
				width := width.min (15)
			end
			create  Result.make (width)
			Result.append_string (s)
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
			-- Show values at current cursor position for `a_statement'.
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


	show_query (statement : ECLI_STATEMENT) is
			-- Show query in `statement'.
		local
			message: STRING
		do
			create message.make (statement.sql.count + 100)
			if statement.is_ok then
				message.append_string ("SUCCESS: ")
			else
				message.append_string ("ERROR  : ")
			end
			message.append_string (statement.sql)
			error_handler.report_info_message (message)
			if statement.has_information_message or not statement.is_ok then
				handle_status (statement)
			end
		end

	handle_status (status : ECLI_STATUS) is
			-- Handle `status' information.
		local
			message: STRING
		do
			create message.make (100)
			if status.is_error or status.has_information_message then
				if status.has_information_message then
					message.append_string ("Information * ")
				elseif status.is_error then
					message.append_string ("Error       * ")
				end
				message.append_string (  " Status = ")
				message.append_string (status.cli_state)
				message.append_string (" * Native Code = ")
				message.append_integer (status.native_code)
				message.append_string (" * Diagnostic '")
				message.append_string (status.diagnostic_message)
				message.append_character ('%'')
				if status.is_error then
					error_handler.report_error_message (message)
				else
					error_handler.report_info_message (message)
				end
			end
		end

	ddl_book : STRING
	ddl_copy : STRING
	ddl_borrower: STRING
	ddl_bookcover: STRING

	get_ddl_statements is
			-- Get DDL SQL statements in configuration files.
		require
			current_sql_type_not_void: current_sql_type /= Void
			valid_sql_type: valid_sql_types.has (current_sql_type)
		do
			ddl_book := string_from_file (ddl_filename_for ("book", current_sql_type))
			ddl_bookcover := string_from_file (ddl_filename_for ("bookcover", current_sql_type))
			ddl_copy := string_from_file (ddl_filename_for ("copy", current_sql_type))
			ddl_borrower := string_from_file (ddl_filename_for ("borrower", current_sql_type))
		ensure
			ddl_book_set: ddl_book /= Void and then not ddl_book.is_empty
			ddl_copy_set: ddl_copy /= Void and then not ddl_copy.is_empty
			ddl_borrower_set: ddl_borrower /= Void and then not ddl_borrower.is_empty
		end

	ddl_file_prefix : STRING is "ddl_"

	ddl_filename_for (table, sql_type : STRING) : STRING is
			-- Ddl file name for `table' and `sql_type'.
		require
			table_not_void: table /= Void
			sql_type_not_void: sql_type /= Void
		local
			directory : STRING
		do
			create Result.make (125)
			directory := file_system.nested_pathname (execution_environment.interpreted_string ("${ECLI}"), << "examples", "books" >>)
			Result.append_string (file_system.pathname (directory, ddl_file_prefix))
			Result.append_string (table)
			Result.append_character ('_')
			Result.append_string (sql_type)
			Result.append_string (".sql")
		end

	photo_filename (name : STRING) : STRING is
			-- Photo filename for `name'.
		require
			name_not_void: name /= Void
		local
			directory : STRING
		do
			create Result.make (125)
			directory := file_system.nested_pathname (execution_environment.interpreted_string ("${ECLI}"), << "examples", "books", "data" >>)
			Result.append_string (file_system.pathname (directory, name))
		ensure
			photo_filename_not_void: Result /= Void
		end

	string_from_file (filename : STRING) : STRING is
			-- String extracted from file `filename'.
		require
			filename_not_void: filename /= Void
			file_exists: file_system.file_exists (filename)
		local
			file : KL_TEXT_INPUT_FILE
		do
			create Result.make (1000)
			create file.make (filename)
			file.open_read
			if file.is_open_read then
				from
				until
					file.end_of_input
				loop
					if Result.count > 0 then
						Result.append_character ('%N')
					end
					file.read_line
					Result.append_string (file.last_string)
				end
			end
		end

	dbms2sqlsyntax : DS_HASH_TABLE[STRING, STRING] is
			-- Map of dbms name to sql syntax.
		once
			create Result.make (10)
			Result.put (sql_interbase, "Firebird 1.5")
			Result.put (sql_mssql, "Microsoft SQL Server")
			Result.put (sql_postgres, "PostgreSQL")
			Result.put (sql_oracle, "Oracle")
			Result.put (sql_mssql, "ACCESS")
		end

	dbms2longvarbinary : DS_HASH_TABLE[BOOLEAN, STRING] is
		once
			create Result.make (10)
			Result.put (True, "Firebird 1.5")
			Result.put (True, "Microsoft SQL Server")
			Result.put (True, "ACCESS")
		end

end -- class TEST1
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
