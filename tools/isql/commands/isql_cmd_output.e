indexing
	description: "Objects that direct further output to a specific file."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_OUTPUT

inherit
	ISQL_COMMAND

	KL_STANDARD_FILES

feature -- Access

	help_message : STRING is
		do
			Result := padded ("out[put] <filename>|stdout", Command_width)
			Result.append_string ("Direct output to <filename> | stdout.")
		end

	match_string : STRING is "out"

feature -- Status report

	needs_session : BOOLEAN is False

	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end

feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- execute an output redirection
		local
			worder : KL_WORD_INPUT_STREAM
			name : STRING
			string_routines : KL_STRING_ROUTINES
			file : KL_TEXT_OUTPUT_FILE
			msg : STRING
		do
			create worder.make (text, " %T%N")
			--| skip command name
			worder.read_word
			--| read filename
			if not worder.end_of_input then
				worder.read_quoted_word
				if not worder.end_of_input then
					name := worder.last_string.twin
					if worder.is_last_string_quoted then
						name := name.substring (2, name.count-1)
					end
					create string_routines
					if name.as_lower.is_equal ("stdout") then
						context.set_output_file (Output)
					else
						create file.make (name)
						file.open_write
						if file.is_open_write then
							context.set_output_file (file)
						else
							create msg.make (0)
							msg.append_string ("Cannot set file %"")
							msg.append_string (name)
							msg.append_string ("%" as output")
							context.filter.begin_error
							context.filter.put_error (msg)
							context.filter.end_error
						end
					end
				end
			end
		end

end -- class ISQL_CMD_OUTPUT
