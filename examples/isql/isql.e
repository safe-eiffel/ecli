indexing
	description: "Interactive SQL";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
class
	ISQL

inherit

	KL_SHARED_ARGUMENTS

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all
		end

	ECLI_STRING_ROUTINES
		export {NONE} all
		end
		
creation

	make

feature -- Initialization

	make is
			-- isql
		do			
			-- session opening
			parse_arguments
			if error_message /= Void then
				print_usage
			else
				-- check for mandatory parameters
				if user = Void then
					set_error ("Missing user.  Specify parameter","-user")
					print_usage
				elseif password = Void then
					set_error ("Missing password. Specify parameter","-pwd")
					print_usage
				elseif dsn = Void then
					set_error ("Missign data source name. Specify parameter", "-dsn")
					print_usage
				else
					if sql /= Void then
						create_input_file (sql)
						!!command.make_file (input_file)
					else
						!!command.make_interactive
					end
					--	
					!! session.make (dsn, user, password)
					session.connect
					if session.has_information_message then
						io.put_string (session.cli_state) 
						io.put_string (session.diagnostic_message)
					end
					if session.is_connected then
						io.put_string ("+ Connected %N")
						print_help
						-- definition of statement on session
						!! statement.make (session)
						do_session	
						-- closing statement
						statement.close
						-- disconnecting and closing session
						session.disconnect
					else
						print_error (session)
					end
					session.close
				end
			end;
		end


feature -- Access

	dsn : STRING
	user: STRING
	password : STRING
	sql : STRING

	vars: DS_HASH_TABLE[STRING, STRING]
	
	error_message : STRING
	
	session : ECLI_SESSION
	
	statement : ECLI_STATEMENT
		
	input_file : PLAIN_TEXT_FILE
	
feature -- Status Report

	is_session_done : BOOLEAN is
			-- 
		do
			Result := command.is_quit or else command.end_of_input
		end

	echo_output : BOOLEAN

		
	command : 	ISQL_COMMAND

feature -- Status setting

feature -- Element change

	set_var (name, value : STRING) is
		do
			if vars = Void then
				!!vars.make (2)
			end
			vars.force (value, name)
		end
		
	set_parameters (stmt : ECLI_STATEMENT) is
		local
			value : ECLI_VARCHAR
			cursor : DS_HASH_TABLE_CURSOR[STRING,STRING]
		do
			from
				cursor := vars.new_cursor
				cursor.start
			until
				cursor.off
			loop
				if stmt.has_parameter (cursor.key) then
					!!value.make (cursor.item.count)
					value.set_item (cursor.item)
					stmt.put_parameter (value, cursor.key)
				end
				cursor.forth
			end					
		end

feature -- Basic Operations

	do_session is
		do
			from
				read_command
			until
				is_session_done
			loop
				if not command.is_interactive and echo_output then
					io.put_string (command.text)
					io.put_string ("%N")
				end
				if command.is_help then
					print_help
				elseif command.is_begin then
					session.begin_transaction
				elseif command.is_commit then
					session.commit
				elseif command.is_rollback then
					session.rollback
				elseif command.is_set then
					do_set (command.text)
				elseif command.is_query  then
					do_execute_query (command.text)
				elseif command.is_tables then
					do_tables
				elseif command.is_types then
					do_types
				elseif command.is_sources then
					do_sources
				elseif command.is_columns then
					do_columns (command.text)
				elseif command.is_procedures then
					do_procedures
				else
					do_execute_sql (command.text)
				end
				read_command
			end
		end

	read_command is
			-- read command and prompt if necessary
		do
			if command.is_interactive then
				print ("ISQL> ")
			end
			command.read
		end
		
	create_input_file (file_name : STRING) is
			-- create and open file `file_name' for reading
		require
			file_name_exists : file_name /= Void
		local
			rescued : BOOLEAN
		do
			if not rescued then
				!!input_file.make_open_read (file_name)
				if not input_file.is_open_read then
					io.put_string ("Error : cannot open '")
					io.put_string (file_name)
					io.put_string ("' for reading.%N")
					input_file := Void
				end
			end
		ensure
			input_file /= Void implies input_file.is_open_read
		rescue
			rescued := True
			input_file := Void
			retry
		end
	
	do_execute_sql (s : STRING) is
			-- 
		do
			statement.set_sql (s)
			if statement.has_parameters then
				if vars /= Void then
					set_parameters (statement)
					statement.bind_parameters
				end
			end
			statement.execute
			if not statement.is_ok or else statement.has_information_message then
				print_error (statement)
			else
				io.put_string ("OK%N")
			end
		end

	do_execute_query (s : STRING) is
			-- execute query 's' -- must be a SELECT or a procedure call that returns a result-set
		local
			cursor : ECLI_ROWSET_CURSOR
			after_first : BOOLEAN
		do
			!!cursor.make (session, s, 20)
			if cursor.is_ok then
				if cursor.has_parameters then
					if vars /= Void then
						set_parameters (cursor)
						cursor.bind_parameters
					end
				end
				from 
					cursor.start
					if cursor.has_information_message then
						print_error (cursor)                                            
					end
				until 
					not cursor.is_ok or else cursor.off
				loop
					if not after_first then
						show_column_names (cursor)
						after_first := True
					end	
					show_one_row (cursor)
					cursor.forth
				end
				if not cursor.is_ok then
					print_error (cursor)
				else
					io.put_string ("OK%N")				
				end				
			else
				print_error (cursor)                                          
			end
			cursor.close
		end
		

	do_tables is
			-- show tables of current datasource
		local
			index : INTEGER
			table : ECLI_TABLE
			cursor : ECLI_TABLES_CURSOR
			search_criteria : ECLI_NAMED_METADATA
		do
			from 
				!!search_criteria.make (Void, Void, Void)
				!!cursor.make (search_criteria, session)
				cursor.start
				print ("CATALOG%T SCHEMA%T TABLE_NAME%T TYPE%T DESCRIPTION%N")
			until
				not cursor.is_ok or else cursor.off
			loop
				table := cursor.item
				print (table.catalog) print ("%T")
				print (table.schema) print ("%T")
				print (table.name) print ("%T")
				print (table.type) print ("%T")
				print (table.description) print ("%N")
				cursor.forth
			end
			cursor.close
			if not cursor.is_ok then
				print ("Error getting tables metadata : '")
				print (cursor.diagnostic_message)
				print ("'%N")
			end
		end
		
	do_types is
			-- show types supported by current datasource
		local
			cursor : ECLI_SQL_TYPES_CURSOR
			type : ECLI_SQL_TYPE			
		do
			from 
				!!cursor.make_all_types (session)
				cursor.start
				print ("TYPE_NAME%T CODE%T SIZE%T CREATE_PARAMETERS%N")
			until not cursor.is_ok or else cursor.off
			loop
				type := cursor.item
				print (type.name) print ("%T")
				print (type.sql_type_code.out) print ("%T")
				print (type.size.out) print ("%T") 
				print (type.create_params) print ("%N")
				cursor.forth
			end
			if not cursor.is_ok then
				print ("Error getting types metadata : '")
				print (cursor.diagnostic_message)
				print ("'%N")
			end
			cursor.close
		end
		
	do_sources is
			-- show data sources on this computer
		local
			cursor : ECLI_DATA_SOURCES_CURSOR
		do
			from
				!!cursor.make_all
				cursor.start
				print ("SOURCE_NAME%T DESCRIPTION%N")
			until
				not cursor.is_ok or else cursor.off
			loop
				print (cursor.item.name) print ("%T")
				print (cursor.item.description) print ("%N")
				cursor.forth
			end
			if not cursor.is_ok then
				print ("Error getting data sources metadata : '")
				print (cursor.diagnostic_message)
				print ("'%N")
			end
			cursor.close
		end
		
	do_procedures is
			-- show procedures
		local
			i : INTEGER
			cursor : ECLI_PROCEDURES_CURSOR
		do
			from
				!! cursor.make_all_procedures (session)
				cursor.start
			until
				not cursor.is_ok or else cursor.off
				
			loop
				print (cursor.item)
				print ("%N")
				cursor.forth	
			end
			if not cursor.is_ok then
				print ("Error getting procedures metadata : '")
				print (cursor.diagnostic_message)
				print ("'%N")
			end
			cursor.close
		end
		
	do_columns (s : STRING) is
			-- show columns of a table
		local
			word_index : INTEGER
			table_name : STRING
			string_routines : ECLI_STRING_ROUTINES
			cursor : ECLI_COLUMNS_CURSOR
			index : INTEGER
			the_column : ECLI_COLUMN
			search_criteria : ECLI_NAMED_METADATA
		do
			!!string_routines
			word_index := s.index_of (' ',1)
			if word_index > 0 then
				table_name := string_routines.trimmed (s.substring (word_index + 1, s.count))
				from
					!!search_criteria.make (Void, Void, table_name)
					!!cursor.make (search_criteria, session)
					cursor.start
					print ("COLUMN_NAME%T TYPE%T SIZE %T DESCRIPTION%N")
				until
					not cursor.is_ok or else cursor.off
				loop
					the_column := cursor.item
					print (the_column.name) print ("%T")
					print (the_column.type_name) print ("%T")
					print (the_column.size) print ("%T")
					print (the_column.description) print ("%N")
					cursor.forth
				end
				if not cursor.is_ok then
					print ("Error getting columns metadata : '")
					print (cursor.diagnostic_message)
					print ("'%N")
				end
				cursor.close
			else
				io.put_string ("Usage: COLUMNS <TABLE_NAME>; please provide a <TABLE_NAME>%N")
			end
		end
		

	do_set (s : STRING) is
			-- handle a 'set <var-name>=<value>'
		local
			cursor : DS_HASH_TABLE_CURSOR[STRING,STRING]
		do
			if s.count > 3 then
				--do assign
				do_assign (s.substring (4, s.count))
				if error_message /= Void then
					io.put_string (error_message)
					io.put_string ("%N")
				end				
			else
				-- show variable names
				from
					cursor := vars.new_cursor
					cursor.start
				until
					cursor.off
				loop
					io.put_string (cursor.key)
					io.put_string ("=")
					io.put_string (cursor.item)
					io.put_new_line
					cursor.forth
				end					
			end
		end

	do_assign (s : STRING) is
			-- assigns <var-name>=<value>
		local
			setting : STRING
			assign_index : INTEGER		
			var_name, var_value : STRING
			string_routines : ECLI_STRING_ROUTINES
		do
			!!string_routines
			setting := s
			assign_index := setting.index_of ('=',1)
			if assign_index > 1 then
				var_name := string_routines.trimmed (setting.substring (1, assign_index-1))
				--TODO: remove any blank before or after
				if assign_index < setting.count then
					var_value := string_routines.trimmed (setting.substring (assign_index+1,setting.count))
					--TODO: remove any blank before or after
					set_var (var_name, var_value)
				else
					set_error ("Missing value for variable", var_name)
				end
			else
					set_error("Not a variable assignment", setting)
			end			
		end
		
feature {NONE} -- Implementation

	parse_arguments is
		local
			index : INTEGER
			current_argument : STRING
		do
			from
				index := 1
				error_message := Void
			until
				error_message /= Void or else index > Arguments.argument_count
			loop
				current_argument := Arguments.argument (index)
				if current_argument.item (1) = '-' then
					if (index + 1) <= Arguments.argument_count then
						if current_argument.is_equal ("-dsn") then
							dsn := Arguments.argument (index + 1)
						elseif current_argument.is_equal ("-user") then
							user := Arguments.argument (index + 1)
						elseif current_argument.is_equal ("-pwd") then
							password := Arguments.argument (index + 1)
						elseif current_argument.is_equal ("-sql") then
							sql := Arguments.argument (index + 1)
						elseif current_argument.is_equal ("-set") then
							do_assign (Arguments.argument (index + 1))
						end
						index := index + 2
					else
						set_error ("Missing value for parameter",current_argument)
					end
				else
					current_argument.to_lower
					if current_argument.is_equal ("echo") then
						echo_output := True
					end
					index := index + 1
				end
			end
		end		
	
	set_error (message, value : STRING) is
		do
						!!error_message.make (0)
						error_message.append (message)
						error_message.append (" '")
						error_message.append (value)
						error_message.append ("'")		
		ensure
			error_message /= Void
		end
		
	print_help is
		do
			if command.is_interactive then
				io.put_string ("Enter a SQL or a command terminated by a ';'%N")
				io.put_string (" ;%Texecutes last SQL or command%N")
				io.put_string ("Commands%N")
				io.put_string (" h%Tprint this message%N")
				io.put_string (" q%Tquit%N")
				io.put_string (" BEGIN TRANSACTION%T Begins a new transaction%N")
				io.put_string (" COMMIT TRANSACTION%T Commits current transaction%N")
				io.put_string (" ROLLBACK TRANSACTION%T Rollbacks current transaction%N")
			end
		end
	
	print_usage is
		do
			if error_message /= Void then
				io.put_string (error_message)
			io.put_new_line
			end
			io.put_string ("Usage: isql -dsn <data_source> -user <user_name> -pwd <password> [-sql <file_name>] [echo] [[-set <name>=<value> ]...]%N%
						%%T-dsn data_source%T%TODBC data source name%N%
						%%T-user user_name%T%Tuser name for database login%N%
						%%T-pwd password%T%Tpassword for database login%N%
						%%T-sql file_name%T%Toptional file_name for batch SQL execution%N%
						%%Techo %T%T%T%Techo batch commands%N%
						%%T-set <name>=<value>%Tset variable 'name' to 'value', for parametered statements.%N")
		end

		
	print_error (stmt : ECLI_STATUS) is
		do
			io.put_string ("** ERROR **%N")
			io.put_string (stmt.diagnostic_message)
			io.put_character ('%N')
		end

	show_column_names (cursor : ECLI_ROW_CURSOR) is
		local
			i, width : INTEGER
			s : STRING
		do
			from
				i := 1
			until
				i > cursor.upper
			loop
				width := (cursor @i i).column_precision
				!! s.make (width)
				s.append (cursor.column_name (i))
				-- pad with blanks
				if width > s.count then
					pad (s, width)
				else
					s.keep_head (width)
				end
				io.put_string (s)
				if i <= cursor.upper then
					io.put_character ('|')
				end
				i := i + 1
			end
			io.put_character ('%N')
		end


	show_one_row (cursor : ECLI_ROW_CURSOR) is
		require
			cursor /= Void and then not cursor.off
		local
			index, precision : INTEGER
		do
			from
				index := cursor.lower
			until
				index > cursor.upper
			loop
				formatting_buffer.clear_content
				if (cursor @i index).is_null then
					formatting_buffer.append ("NULL")
				else
					formatting_buffer.append ((cursor @i index).to_string)
				end
				precision := (cursor @i (index)).column_precision				
				if precision > formatting_buffer.count then
					pad (formatting_buffer, precision)
				else
					formatting_buffer.keep_head (precision)
				end
				io.put_string (formatting_buffer)
				io.put_character ('|')
				index := index + 1
			end
			--
			io.put_character ('%N')
		end
					
	formatting_buffer : MESSAGE_BUFFER is
		once
			!!Result.make (1000)
		end

--	repository : ECLI_REPOSITORY is
--			-- current repository
--		once 
--			!!Result.make(session)
--		end
		
end -- class ISQL
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
