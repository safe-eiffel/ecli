indexing
	description: "Command Line Interactive SQL for ODBC datasources";
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
		
creation

	make

feature -- Initialization

	make is
			-- isql
		local
			std : KL_STANDARD_FILES
		do			
			create_commands
			create std
			output_file := std.output
			create vars.make (10)
			create current_context.make (output_file, vars, commands) 
			create_default_system_variables
			print_banner
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
					current_context.set_session (session)
					if session.is_connected then
						-- definition of statement on session
						!! statement.make (session)
						--| create default values for system variables
						current_context.filter.begin_error
						current_context.filter.put_error ("Connected %N")
						current_context.filter.end_error
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

	create_default_system_variables is
			-- create default system variables and their value
		do
			vars.put ("", current_context.var_heading_begin)
			vars.put ("%N", current_context.var_heading_end)
			vars.put (",", current_context.var_heading_separator)
			vars.put ("", current_context.var_row_begin)
			vars.put (",", current_context.var_column_separator)
			vars.put ("%N", current_context.var_row_end)
		end		
	test_match is
			-- 
		local
			t : KL_WORD_INPUT_STREAM
		do
			create t.make ("   %"tabulations%"  ", " %T%N%R")
			t.read_quoted_word
			create t.make ("%T%R'tabulations'", " %T%N%R")
			t.read_quoted_word
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
		
	input_file : KI_TEXT_INPUT_STREAM -- PLAIN_TEXT_FILE

	output_file : KI_TEXT_OUTPUT_STREAM
	
	current_context : ISQL_CONTEXT
	
feature -- Status Report

	is_session_done : BOOLEAN is
			-- 
		do
			Result := current_context.must_quit or else command.end_of_input
		end

	echo_output : BOOLEAN

		
	command : 	ISQL_COMMAND_STREAM

feature -- Status setting

feature -- Element change

feature -- Basic Operations

	do_session is
		do
			from
				read_command
			until
				is_session_done
			loop
				if not command.is_interactive and echo_output then
					current_context.output_file.put_string (command.text)
					current_context.output_file.put_string ("%N")
				end
				execute_command (command.text)
				if not current_context.must_quit then
					read_command
				end
			end
		end

	execute_command (a_text : STRING) is
			-- 
		do
			from
				commands.start
			until
				commands.off or else commands.item_for_iteration.matches (a_text)
			loop
				commands.forth
			end
			if not commands.off then
				commands.item_for_iteration.execute (a_text, current_context)
			else
				current_context.filter.begin_error
				current_context.filter.put_error ("Unknown command : " + command.text)
				current_context.filter.end_error
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
			file : KL_TEXT_INPUT_FILE
		do
			if not rescued then
				--!!input_file.make_open_read (file_name)
				create file.make (file_name)
				file.open_read
				input_file := file
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
	
--	do_execute_sql (s : STRING) is
--			-- 
--		do
--			statement.set_sql (s)
--			if statement.has_parameters then
--				if vars /= Void then
--					set_parameters (statement)
--					statement.bind_parameters
--				end
--			end
--			statement.execute
--			if not statement.is_ok or else statement.has_information_message then
--				print_error (statement)
--			else
--				io.put_string ("OK%N")
--			end
--		end
--
--	do_execute_query (s : STRING) is
--			-- execute query 's' -- must be a SELECT or a procedure call that returns a result-set
--		local
--			cursor : ECLI_ROWSET_CURSOR
--			after_first : BOOLEAN
--		do
--			!!cursor.make (session, s, 20)
--			if cursor.is_ok then
--				if cursor.has_parameters then
--					if vars /= Void then
--						set_parameters (cursor)
--						cursor.bind_parameters
--					end
--				end
--				from 
--					cursor.start
--					if cursor.has_information_message then
--						print_error (cursor)                                            
--					end
--				until 
--					not cursor.is_ok or else cursor.off
--				loop
--					if not after_first then
--						show_column_names (cursor)
--						after_first := True
--					end	
--					show_one_row (cursor)
--					cursor.forth
--				end
--				if not cursor.is_ok then
--					print_error (cursor)
--				else
--					io.put_string ("OK%N")				
--				end				
--			else
--				print_error (cursor)                                          
--			end
--			cursor.close
--		end
--		

--	do_tables is
--			-- show tables of current datasource
--		local
--			index : INTEGER
--			table : ECLI_TABLE
--		do
--			from index := 1
--				print ("CATALOG%T SCHEMA%T TABLE_NAME%T TYPE%T DESCRIPTION%N")
--			until
--				not repository.is_ok or else index > repository.tables.upper
--			loop
--				table := repository.tables.item (index)
--				print (table.catalog) print ("%T")
--				print (table.schema) print ("%T")
--				print (table.name) print ("%T")
--				print (table.type) print ("%T")
--				print (table.description) print ("%N")
--				index := index + 1
--			end
--			if not repository.is_ok then
--				print ("Error getting tables metadata : '")
--				print (repository.diagnostic_message)
--				print ("'%N")
--			end
--		end
--		
--	do_sources is
--			-- show data sources on this computer
--		local
--			cursor : ECLI_DATA_SOURCES_CURSOR
--		do
--			debug
--				!!cursor.make_all
--			end
--			from
--				cursor.start
--				print ("SOURCE_NAME%T DESCRIPTION%N")
--			until
--				cursor.off
--			loop
--				print (cursor.item.name) print ("%T")
--				print (cursor.item.description) print ("%N")
--				cursor.forth
--			end
--		end		
		
		
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
		

	print_banner is
		do
			current_context.output_file.put_string (
				"CLISQL - Command Line Interactive SQL for ODBC datasources.%N%N%
				%This application has been developed using the Eiffel language.%N%
				%Copyright (C) Paul G. Crismer 2000-2003. %N%
				%SAFE project (http://safe.sourceforge.net).%N%
				%Released under the Eiffel Forum License version 1.%N%N%
				%Type%N%
				%    help; or he; to get help,%N%
				%    quit; or q;  to quit.%N%N")
		end
		
	print_usage is
		do
			if error_message /= Void then
				current_context.output_file.put_string (error_message)
				current_context.output_file.put_new_line
			end
			execute_command ("usage")
		end

		
	print_error (stmt : ECLI_STATUS) is
		do
			current_context.filter.begin_error
			current_context.filter.put_error (stmt.diagnostic_message)
			current_context.filter.end_error
		end
--
--	show_column_names (cursor : ECLI_ROW_CURSOR) is
--		local
--			i, width : INTEGER
--			s : STRING
--		do
--			from
--				i := 1
--			until
--				i > cursor.upper
--			loop
--				width := (cursor @i i).column_precision
--				!! s.make (width)
--				s.append (cursor.column_name (i))
--				-- pad with blanks
--				if width > s.count then
--					pad (s, width)
--				else
--					s.head (width)
--				end
--				io.put_string (s)
--				if i <= cursor.upper then
--					io.put_character ('|')
--				end
--				i := i + 1
--			end
--			io.put_character ('%N')
--		end
--
--
--	show_one_row (cursor : ECLI_ROW_CURSOR) is
--		require
--			cursor /= Void and then not cursor.off
--		local
--			index, precision : INTEGER
--		do
--			from
--				index := cursor.lower
--			until
--				index > cursor.upper
--			loop
--				formatting_buffer.clear_content
--				if (cursor @i index).is_null then
--					formatting_buffer.append ("NULL")
--				else
--					formatting_buffer.append ((cursor @i index).to_string)
--				end
--				precision := (cursor @i (index)).column_precision				
--				if precision > formatting_buffer.count then
--					pad (formatting_buffer, precision)
--				else
--					formatting_buffer.head (precision)
--				end
--				io.put_string (formatting_buffer)
--				io.put_character ('|')
--				index := index + 1
--			end
--			--
--			io.put_character ('%N')
--		end
--					
--	formatting_buffer : MESSAGE_BUFFER is
--		once
--			!!Result.make (1000)
--		end

--	repository : ECLI_REPOSITORY is
--			-- current repository
--		once 
--			!!Result.make(session)
--		end

	create_commands is
			-- create command set
		local
			l_command : ISQL_COMMAND
		do
			create commands.make
			create {ISQL_CMD_COMMENT}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_COLUMNS}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_PRIMARY_KEYS}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_FOREIGN_KEYS}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_EDIT}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_EXECUTE}l_command
			commands.put_last (l_command)
			create set_command
			commands.put_last (set_command)
			create {ISQL_CMD_COMMIT}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_OUTPUT} l_command
			commands.put_last (l_command)
			create {ISQL_CMD_PROCEDURES}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_SOURCES}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_TABLES}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_TYPES}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_ROLLBACK}l_command
			commands.put_last (l_command)
			create {ISQL_CMD_BEGIN}l_command
			commands.put_last (l_command)			
			create {ISQL_CMD_QUIT}l_command
			commands.put_last (l_command)			
			create {ISQL_CMD_HELP} help_command
			commands.put_last (help_command)			
			create {ISQL_CMD_USAGE} l_command
			commands.put_last (l_command) 
			create {ISQL_CMD_SQL}l_command
			commands.put_last (l_command)
		end
		
	commands : DS_LINKED_LIST [ISQL_COMMAND]

	help_command : ISQL_CMD_HELP
	
	do_assign (text : STRING) is
		require
			set_command_not_void: set_command /= Void
		do
			set_command.do_assign (text, current_context)
		end
		
	set_command : ISQL_CMD_SET
	
end -- class ISQL
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
