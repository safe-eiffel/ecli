note
	description: "ISQL command contexts."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CONTEXT

inherit
	KL_STANDARD_FILES
		redefine
			default_create
		end

create
	make, make_by_parent

feature {NONE} -- Initialization

	default_create
		do

		end

	make (an_output_file : like output_file; a_commands : like commands)
			-- create context
		require
			an_output_file_not_void: an_output_file /= Void
			a_commands_not_void: a_commands /= Void
		do
			default_create
			output_file := an_output_file
			commands := a_commands
			create variables.make_default
			create history.make
			filter.set_output_file (output_file)
		ensure
			output_file_affected: output_file = an_output_file
			commands_affected : commands = a_commands
			history_not_void: history /= Void
		end

	make_by_parent (a_parent_context : like Current)
			-- make using `a_parent' as enclosing context
		require
			a_parent_not_void: a_parent_context /= Void
		do
			parent_context := a_parent_context
			output_file := parent_context.output_file
			input_file := parent_context.input_file
			commands := parent_context.commands
			session := parent_context.session
			create variables.make (10)
			create history.make
			filter.set_output_file (output_file)
		ensure
			parent_context_set: parent_context = a_parent_context
			output_file_set: output_file = parent_context.output_file
			input_file_set: input_file = parent_context.input_file
			commands_set: commands = parent_context.commands
			session_set : session = parent_context.session
			filter_exists : filter /= Void
			history_not_void: history /= Void
		end

feature -- Access

	command_stream: detachable ISQL_COMMAND_STREAM

	input_file : detachable KI_TEXT_INPUT_STREAM

	variables : DS_HASH_TABLE[STRING,STRING]

	parent_context : detachable like Current

	session : detachable ECLI_SESSION

	commands : ISQL_COMMANDS

	no_headings : BOOLEAN = False

	filter : ISQL_FILTER
		do
			if attached impl_filter as f then
				Result := f
			else
				Result := new_filter
				impl_filter := Result
			end
		end

	variable (name : STRING) : STRING
			-- value of variable `name'
		require
			name_not_void: name /= Void
			has_variable_name: has_variable (name)
		do
			Result := ""
			if variables.has (name) then
				Result := variables.item (name)
			else
				if parent_context /= Void then
					Result := parent_context.variable (name)
				end
			end
		end

	variables_count : INTEGER
			-- count of currently set variables
		do
			Result := variables.count
		end

	history : DS_LINKED_LIST [STRING]

feature -- Status report

	echo_output : BOOLEAN

	has_variable (name : STRING) : BOOLEAN
		require
			name_not_void: name /= Void
		do
			Result := variables.has (name) or else (parent_context /= Void and then parent_context.has_variable (name))
		end

	is_executable : BOOLEAN
			-- can this context be used for executing a command ?
		do
			Result := session.is_connected and then output_file.is_open_write
		ensure
			definition: Result = (session.is_connected and then output_file.is_open_write)
		end

	must_quit : BOOLEAN

	is_variable_true (name : STRING) : BOOLEAN
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

	set_must_quit
		do
			must_quit := True
		ensure
			must_quit_true: must_quit
		end

	enable_echo_output
		do
			echo_output := True
		ensure
			echo_output: echo_output
		end

	disable_echo_output
		do
			echo_output := False
		ensure
			not_echo_output: not echo_output
		end

feature {ISQL} -- Element change

	set_input_file (a_file : like input_file)
			--
		require
			a_file_not_void: a_file /= Void
		do
			input_file := a_file
		ensure
			input_file_set: input_file = a_file
		end

	set_interactive
			--
		do
			if attached Input as in then
				input_file := in
			end
		ensure
			input_file_set: input_file = Input
		end

feature -- Element change

	create_command_stream (stream : KI_TEXT_INPUT_STREAM)
			--
		do
			if not stream.is_open_read then
				filter.begin_error
				filter.put_error ("EXECUTE : Cannot open stream '")
				if stream /= Input and attached stream.name as n then
					filter.put_error (n)
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

--	set_command_stream (a_command_stream: ISQL_COMMAND_STREAM) is
--			-- Set `command_stream' to `a_command_stream'.
--		do
--			command_stream := a_command_stream
--		ensure
--			command_stream_assigned: command_stream = a_command_stream
--		end

	set_output_file (a_file: like OUTPUT_FILE)
			-- set `output_file' to `a_file'
		require
			a_file_not_void: a_file /= Void
			a_file_is_open_write: a_file.is_open_write
		do
			if output_file /= a_file then
				if output_file /= output then
					output_file.close
				end
			end
			output_file := a_file
			filter.set_output_file (a_file)
		ensure
			output_file_set: output_file = a_file
		end

	set_session (a_session : ECLI_SESSION)
			-- set `session' to `a_session'
		require
			a_session_not_void: a_session /= Void
		do
			session := a_session
		ensure
			session_set: session = a_session

		end

	remove_variable (name : STRING)
			--
		require
			name_not_void: name /= Void
		do
			variables.remove (name)
		ensure
			not_has_variable: not has_variable (name)
		end

	set_variable (value, name : STRING)
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

	do_session
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

	do_execute_command (a_text : STRING)
			--
		do
			commands.execute (a_text, Current)
		end

	read_command
			-- read command_stream and prompt if necessary
		do
			if command_stream.is_interactive and command_stream.buffer_text.is_empty then
				show_prompt
			end
			command_stream.read
			if not command_stream.end_of_input then
				if history.count > 20 then
					history.remove_first
				end
				history.put_last (command_stream.text.twin)
			end
		end

	is_session_done : BOOLEAN
			--
		do
			Result := must_quit or else command_stream.end_of_input
		end

feature -- Constants

	var_heading_begin : STRING = "_heading_begin"
	var_heading_separator : STRING = "_heading_separator"
	var_heading_end : STRING = "_heading_end"

	var_row_begin : STRING = "_row_begin"
	var_row_end : STRING = "_row_end"
	var_column_separator : STRING = "_column_separator"
	var_editor : STRING = "_editor"
	var_no_heading : STRING = "_no_heading"

feature {ISQL_CONTEXT} -- Access

	output_file : KI_TEXT_OUTPUT_STREAM

feature -- Constants

	c_prompt : STRING = "ISQL> "

feature {NONE} -- Implementation

	new_filter : like filter
		do
			create {ISQL_CONFIGURABLE_TEXT_FILTER} Result.make (Current)
		end

	impl_filter : detachable like filter

	show_prompt
		do
			output.put_string (c_prompt)
		end

invariant

	output_file_not_void: output_file /= Void
	variables_not_void: variables /= Void
	commands_not_void: commands /= Void
	history_not_void: history /= Void

end -- class ISQL_CONTEXT
