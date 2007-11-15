indexing
	description: "Command Line Interactive SQL for ODBC datasources.";
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

	KL_SHARED_OPERATING_SYSTEM

	KL_SHARED_FILE_SYSTEM

create

	make

feature {NONE} -- Initialization

	make is
			-- isql
		local
			simple_login : ECLI_SIMPLE_LOGIN
		do
			create_commands
			create_initial_context
			create_default_system_variables (current_context)
			print_banner
			-- session opening
			parse_arguments
			if error_message /= Void then
				print_usage
			else
				do_initial_connection
				if session = Void or else session /= Void and then not session.is_connected then
					current_context.filter.begin_error
					current_context.filter.put_error ("WARNING : NO session connected !%N%
						%Commands usage is restricted. Type HELP more information.%N%
						%Please connect first using 'CONNECT' command.%N")
					current_context.filter.end_error
				end
--				if sql_file_name /= Void then
--					commands.execute ("execute "+sql_file_name, current_context)
--				else
--					commands.execute ("execute", current_context)
--				end
--				-- disconnecting and closing session
				do_session
				do_final_disconnection
			end;
		end

feature -- Access

	dsn : STRING
				-- Data source name

	user: STRING
				-- User name

	password : STRING
				-- Password

	sql_file_name : STRING
				-- clisql script filename

	error_message : STRING
				-- current error message

	session : ECLI_SESSION
				-- database session

	output_file : KI_TEXT_OUTPUT_STREAM
				-- output file of the application

	current_context : ISQL_CONTEXT
				-- current execution context

feature -- Status Report

	echo_output : BOOLEAN

feature -- Element change

	create_default_system_variables (a_context : ISQL_CONTEXT) is
			-- create default system variables and their value
		do
			a_context.set_variable ("", a_context.var_heading_begin)
			a_context.set_variable ("%N", a_context.var_heading_end)
			a_context.set_variable (",", a_context.var_heading_separator)
			a_context.set_variable ("", a_context.var_row_begin)
			a_context.set_variable (",", a_context.var_column_separator)
			a_context.set_variable ("%N", a_context.var_row_end)
			if Operating_system.is_windows or else Operating_system.Is_dotnet then
				a_context.set_variable ("notepad", a_context.Var_editor)
			else
				a_context.set_variable ("vi", a_context.Var_editor)
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
						elseif current_argument.is_equal ("-sql_file_name") or else current_argument.is_equal ("-sql") then
							sql_file_name := Arguments.argument (index + 1)
						elseif current_argument.is_equal ("-set") then
							commands.execute ("SET " + Arguments.argument (index + 1), current_context)
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
			-- set error_message to "<message> '<value>' "
		do
			!!error_message.make (0)
			error_message.append_string (message)
			error_message.append_string (" '")
			error_message.append_string (value)
			error_message.append_string ("'")
		ensure
			error_message /= Void
		end

	print_banner is
			-- print banner
		do
			current_context.filter.begin_message
			current_context.filter.put_message (
				"CLISQL - Command Line Interactive SQL for ODBC datasources.%N%N%
				%This application has been developed using the Eiffel language.%N%
				%Copyright (C) Paul G. Crismer 2000-2006. %N%
				%SAFE project (http://safe.sourceforge.net).%N%
				%Released under the Eiffel Forum License version 1.%N%N%
				%Type%N%
				%    help; or he; to get help,%N%
				%    quit; or q;  to quit.%N%N")
			current_context.filter.end_message
		end

	print_usage is
			-- print command usage
		do
			if error_message /= Void then
				current_context.filter.begin_error
				current_context.filter.put_error (error_message)
				current_context.filter.end_error
			end
			commands.execute ("usage", current_context)
		end


	print_error (status : ECLI_STATUS) is
			-- print error message relative to `status'
		do
			current_context.filter.begin_error
			current_context.filter.put_error (status.diagnostic_message)
			current_context.filter.end_error
		end

	create_commands is
			-- create command_stream set
		local
			l_command : ISQL_COMMAND
		do
			create commands.make
		end

	commands : ISQL_COMMANDS
				-- list of supported commands

	create_current_context  (a_output_file : KI_TEXT_OUTPUT_STREAM; a_commands : ISQL_COMMANDS) is
		do
			create current_context.make (a_output_file, a_commands)
		end

	create_initial_context is
		local
			std : KL_STANDARD_FILES
		do
			create std
			output_file := std.output
			create_current_context (output_file, commands)
		ensure
			current_context_created: current_context /= Void
		end

	do_initial_connection is
		local
			simple_login : ECLI_SIMPLE_LOGIN
		do
			if echo_output then
				current_context.enable_echo_output
			end
			if dsn /= Void and then user /= Void and then password /= Void then
				create session.make_default
				create simple_login.make (dsn, user, password)
				session.set_login_strategy (simple_login)
				session.connect
				current_context.set_session (session)
				if session.is_connected then
					--| create default values for system variables
					current_context.filter.begin_error
					current_context.filter.put_error ("Connected %N")
					current_context.filter.end_error
				else
					print_error (session)
				end
			end
		end

	do_session is
		do
			commands.do_session (current_context, sql_file_name)
		end

	do_final_disconnection is
		do
			if current_context.session /= Void then
				if current_context.session.is_connected then
					current_context.session.disconnect
				end
				if current_context.session.is_valid then
					current_context.session.close
				end
			end
		end

end -- class ISQL
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
