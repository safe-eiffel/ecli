note
	description: "Commands that edit the query buffer in an editor."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_EDIT

inherit
	ISQL_COMMAND

	KL_EXECUTION_ENVIRONMENT

	KL_SHARED_OPERATING_SYSTEM

	KL_SHARED_FILE_SYSTEM

feature -- Access

	help_message : STRING
		do
			Result := padded ("edit", command_width)
			Result.append_string ("Edit query buffer with current editor.")
		end

	match_string : STRING = "edit"

feature -- Status report

	needs_session : BOOLEAN = False

	matches (text: STRING) : BOOLEAN
		do
			Result := matches_single_string (text, match_string)
		end

feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT)
			-- launch an editor on 'clibuferr.sql'
		local
			editor_program : STRING
			temp_file : KL_TEXT_OUTPUT_FILE
			shell_command : KL_SHELL_COMMAND
		do
			--| verify that _editor variable exists : either system variable or local variable
			if context.has_variable (context.Var_editor) then
				editor_program := context.variable (context.Var_editor)
			else
				editor_program := variable_value ("CLISQL_EDITOR")
			end
			if editor_program /= Void then
				--| create temporary file
				create temp_file.make ("clibuffer.sql")
				temp_file.open_write
				temp_file.close
				--| edit empty file
				--Environment_impl.launch (editor_program + " clibuffer.sql")
				create shell_command.make (editor_program + " clibuffer.sql")
				shell_command.execute
				--| let the system execute the command
				context.filter.begin_message
				context.filter.put_message ("Commands have been saved in file 'clibuffer.sql'%NType 'EXECUTE clibuffer.sql' to execute them.")
				context.filter.end_message
			end
		end

end -- class ISQL_CMD_EDIT
