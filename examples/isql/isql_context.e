indexing
	description: "ISQL command contexts."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CONTEXT

inherit
	KL_STANDARD_FILES
	
creation
	make, make_by_parent
	
feature {NONE} -- Initialization

	make (an_output_file : like output_file; a_commands : like commands; an_sql_command : like sql_command) is
			-- create context
		require
			an_output_file_not_void: an_output_file /= Void
			a_commands_not_void: a_commands /= Void
			an_sql_command_not_void: an_sql_command /= Void
		do
			output_file := an_output_file
			create variables.make (10)
			commands := a_commands
			create_filter
			filter.set_output_file (output_file)
			create history.make
			sql_command := an_sql_command
		ensure
			output_file_affected: output_file = an_output_file
			commands_affected : commands = a_commands
			history_not_void: history /= Void
		end

	make_by_parent (a_parent_context : like Current) is
			-- make using `a_parent' as enclosing context
		require
			a_parent_not_void: a_parent_context /= Void
		do
			parent_context := a_parent_context
			output_file := parent_context.output_file
			input_file := parent_context.input_file
			commands := parent_context.commands
			session := parent_context.session
			create {ISQL_CONFIGURABLE_TEXT_FILTER} filter.make (Current)
			filter.set_output_file (output_file)
			create variables.make (10)
			create history.make
			sql_command := parent_context.sql_command
		ensure
			parent_context_set: parent_context = a_parent_context
			output_file_set: output_file = parent_context.output_file
			input_file_set: input_file = parent_context.input_file
			commands_set: commands = parent_context.commands
			session_set : session = parent_context.session
			filter_exists : filter /= Void
			history_not_void: history /= Void
		end
feature {ISQL, ISQL_CONTEXT, ISQL_CMD_HELP} -- Access

	sql_command: ISQL_CMD_SQL

feature -- Access

	command_stream: ISQL_COMMAND_STREAM

	output_file : KI_TEXT_OUTPUT_STREAM

	input_file : KI_TEXT_INPUT_STREAM
	
	variables : DS_HASH_TABLE[STRING,STRING]
	
	parent_context : like Current
	
	session : ECLI_SESSION
	
	commands : DS_LIST [ISQL_COMMAND]

	no_headings : BOOLEAN is False
	
	filter : ISQL_FILTER

	variable (name : STRING) : STRING is
			-- value of variable `name'
		require
			name_not_void: name /= Void
			has_variable_name: has_variable (name)
		do
			if variables.has (name) then
				Result := variables.item (name)
			else
				if parent_context /= Void then
					Result := parent_context.variable (name)
				end
			end
		end
	
	variables_count : INTEGER is
			-- count of currently set variables
		do
			Result := variables.count
		end

	history : DS_LINKED_LIST [STRING]
	
feature -- Status report

	echo_output : BOOLEAN
	
	has_variable (name : STRING) : BOOLEAN is
		require
			name_not_void: name /= Void
		do
			Result := variables.has (name) or else (parent_context /= Void and then parent_context.has_variable (name))
		end
		
	is_executable : BOOLEAN is
			-- can this context be used for executing a command ?
		do
			Result := session.is_connected and then output_file.is_open_write
		ensure
			definition: Result = (session.is_connected and then output_file.is_open_write)
		end

	must_quit : BOOLEAN

	is_variable_true (name : STRING) : BOOLEAN is
			-- is `name' variable true ?
		require
			name_not_void: name /= Void
		local
			var : STRING
		do
			if has_variable (name) then
				var := variable (name)
				if  not var.is_empty then
					Result := var.item (1) = 'T' or else var.item (1) = 't'					
				end
			end
		ensure
			definition: Result = (has_variable (name) and then (not variable (name).is_empty and then variable (name).item (1) = 't' or else variable (name).item (1)= 'T'))
		end
		
feature -- Status setting

	set_must_quit is
		do
			must_quit := True
		ensure
			must_quit_true: must_quit
		end
	
	enable_echo_output is
		do
			echo_output := True
		ensure
			echo_output: echo_output
		end
		
	disable_echo_output is
		do
			echo_output := False
		ensure
			not_echo_output: not echo_output
		end

feature {ISQL} -- Element change

	set_input_file (a_file : like input_file) is
			-- 
		require
			a_file_not_void: a_file /= Void
		do
			input_file := a_file
		ensure
			input_file_set: input_file = a_file			
		end
		
	set_interactive is
			-- 
		do
			input_file := Input
		ensure
			input_file_set: input_file = Input
		end
		
feature -- Element change

	create_command_stream (stream : KI_TEXT_INPUT_STREAM) is
			-- 
		do
			if not stream.is_open_read then
				filter.begin_error
				filter.put_error ("EXECUTE : Cannot open stream '")
				if stream /= Input then
					filter.put_error (stream.name)
				else
					filter.put_error ("stdin")
				end
				filter.put_error ("'")
				filter.end_error
			else
				if parent_context = Void and then stream = Input then
					create command_stream.make_interactive
				else
					create command_stream.make_file (stream)
				end
			end
		end

	set_command_stream (a_command_stream: ISQL_COMMAND_STREAM) is
			-- Set `command_stream' to `a_command_stream'.
		do
			command_stream := a_command_stream
		ensure
			command_stream_assigned: command_stream = a_command_stream
		end

	set_output_file (a_file: like OUTPUT_FILE) is
			-- set `output_file' to `a_file'
		require
			a_file_not_void: a_file /= Void
		do
			output_file := a_file
			filter.set_output_file (a_file)
		ensure
			output_file_set: output_file = a_file
		end

	set_session (a_session : ECLI_SESSION) is
			-- set `session' to `a_session'
		require
			a_session_not_void: a_session /= Void
		do
			session := a_session
		ensure
			session_set: session = a_session

		end
		
	remove_variable (name : STRING) is
			-- 
		require
			name_not_void: name /= Void
		do
			variables.remove (name)
		ensure
			not_has_variable: not has_variable (name)
		end
		
	set_variable (value, name : STRING) is
			-- add variable `name' with `value'
		require
			name_not_void: name /= Void
			value_not_void: value /= Void
		do
			variables.force (value, name)
		ensure
			has_variable: has_variable (name)
			variable: variable (name) = value
--			maybe_added: not (old has_variable (name)) implies variables_count = old variables_count + 1
		end

feature -- Basic operations

	do_session is
		do
			from
				read_command 
			until
				is_session_done
			loop
				if not command_stream.is_interactive and then echo_output then
					output_file.put_string (command_stream.text)
					output_file.put_string ("%N")
				end
				do_execute_command (command_stream.text)
				if not must_quit then
					read_command
				end
			end
		end

	do_execute_command (a_text : STRING) is
			-- 
		local
			command : ISQL_COMMAND
		do
			from
				commands.start
			until
				commands.off or else commands.item_for_iteration.matches (a_text)
			loop
				commands.forth
			end
			if not commands.off then
				command := commands.item_for_iteration
			else
				command := sql_command
			end
			if command.needs_session then
				if session = Void or else not session.is_connected then
					filter.begin_error
					filter.put_error ("Not Connected : unable to execute command.%NUse CONNECT command to do so.%N")
					filter.end_error
				else
					command.execute (a_text, Current)
				end
			else
				command.execute (a_text, Current)			
			end
			if False then
				filter.begin_error
				filter.put_error ("Unknown command_stream : " + command_stream.text)
				filter.end_error
			end			
		end
		
	read_command is
			-- read command_stream and prompt if necessary
		do
			if command_stream.is_interactive and command_stream.buffer_text = Void then
				print ("ISQL> ")
			end
			command_stream.read
			if not command_stream.end_of_input then
				if history.count > 20 then
					history.remove_first
				end
				history.put_last (clone (command_stream.text))
			end
		end

	is_session_done : BOOLEAN is
			-- 
		do
			Result := must_quit or else command_stream.end_of_input
		end
		
feature -- Constants

	var_heading_begin : STRING is "_heading_begin"
	var_heading_separator : STRING is "_heading_separator"
	var_heading_end : STRING is "_heading_end"
	
	var_row_begin : STRING is "_row_begin"
	var_row_end : STRING is "_row_end"
	var_column_separator : STRING is "_column_separator"
	var_editor : STRING is "_editor"
	var_no_heading : STRING is "_no_heading"

feature {NONE} -- Implementation

	create_filter is
		do
			create {ISQL_CONFIGURABLE_TEXT_FILTER} filter.make (Current)			
		end
		
invariant

	output_file_not_void: output_file /= Void
	variables_not_void: variables /= Void
	commands_not_void: commands /= Void
	history_not_void: history /= Void
		execute_command_not_void: sql_command /= Void

end -- class ISQL_CONTEXT
