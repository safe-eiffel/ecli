note
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

	make
			-- isql
		local
			env : ECLI_SHARED_ENVIRONMENT
		do
			create env
			env.enable_connection_pooling

			create_commands
			create_initial_context
			create_default_system_variables (current_context)
			print_banner
			-- session opening
			parse_arguments
			if not error_message.is_empty then
				print_usage
			else
				do_initial_connection
				if session = Void or else attached session as l_session and then not l_session.is_connected then
					current_context.filter.begin_error
					current_context.filter.put_error ("WARNING : NO session connected !%N%
						%Commands usage is restricted. Type HELP more information.%N%
						%Please connect first using 'CONNECT' command.%N")
					current_context.filter.end_error
				end
				do_session
				do_final_disconnection
			end;
		end

feature -- Access

	dsn : detachable STRING
				-- Data source name

	user: detachable STRING
				-- User name

	password : detachable STRING
				-- Password

	sql_file_name : STRING
				-- clisql script filename

	error_message : STRING
				-- current error message

	session : detachable ECLI_SESSION
				-- database session

	output_file : KI_TEXT_OUTPUT_STREAM
				-- output file of the application

	current_context : ISQL_CONTEXT
				-- current execution context

feature -- Status Report

	echo_output : BOOLEAN

feature -- Element change

	create_default_system_variables (a_context : ISQL_CONTEXT)
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

	parse_arguments
		local
			index : INTEGER
			current_argument : STRING
		do
			from
				index := 1
				create error_message.make_empty
				create sql_file_name.make_empty
			until
				not error_message.is_empty or else index > Arguments.argument_count
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

	set_error (message, value : STRING)
			-- set error_message to "<message> '<value>' "
		do
			create error_message.make (0)
			error_message.append_string (message)
			error_message.append_string (" '")
			error_message.append_string (value)
			error_message.append_string ("'")
		ensure
			not_error_message_empty: not error_message.is_empty
		end

	print_banner
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

	print_usage
			-- print command usage
		do
			if error_message /= Void then
				current_context.filter.begin_error
				current_context.filter.put_error (error_message)
				current_context.filter.end_error
			end
			commands.execute ("usage", current_context)
		end


	print_error (status : ECLI_STATUS)
			-- print error message relative to `status'
		do
			current_context.filter.begin_error
			current_context.filter.put_error (status.diagnostic_message)
			current_context.filter.end_error
		end

	create_commands
			-- create command_stream set
		do
			create commands.make
		end

	commands : ISQL_COMMANDS
				-- list of supported commands

	create_current_context  (a_output_file : KI_TEXT_OUTPUT_STREAM; a_commands : ISQL_COMMANDS)
		do
			create current_context.make (a_output_file, a_commands)
		end

	create_initial_context
		local
			std : KL_STANDARD_FILES
		do
			create std
			check attached std.output as o then
				output_file := o
				create_current_context (output_file, commands)
			end
		ensure
			current_context_created: current_context /= Void
		end

	do_initial_connection
		local
			simple_login : ECLI_SIMPLE_LOGIN
			l_session : attached like session
		do
			if echo_output then
				current_context.enable_echo_output
			end
			if attached dsn as l_dsn and then attached user as l_user and then attached password as l_password then
				create l_session.make_default
				session := l_session
				create simple_login.make (l_dsn, l_user, l_password)
				l_session.set_login_strategy (simple_login)
				l_session.connect
				current_context.set_session (l_session)
				if l_session.is_connected then
					--| create default values for system variables
					current_context.filter.begin_error
					current_context.filter.put_error ("Connected %N")
					current_context.filter.end_error
				else
					print_error (l_session)
				end
			end
		end

	do_session
		do
			commands.do_session (current_context, sql_file_name)
		end

	do_final_disconnection
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
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
