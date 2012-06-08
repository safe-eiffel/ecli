indexing
	description: "Commands that execute SQL scripts in a file."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_EXECUTE

inherit
	ISQL_COMMAND

	KL_STANDARD_FILES
		undefine
			default_create
		end

feature -- Access

	help_message : STRING is
		do
			Result := padded ("exec[ute] <filename>", command_width)
			Result.append_string ("Execute clisql command_stream from <filename>.")
		end

	match_string : STRING is "exec"

feature -- Status report

	needs_session : BOOLEAN is True

	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end

feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- execute a commands script
		local
			worder : KL_WORD_INPUT_STREAM
			filename : STRING
			stream : KI_TEXT_INPUT_STREAM
			file : KL_TEXT_INPUT_FILE
			current_context : ISQL_CONTEXT
		do
			current_context := context
			create worder.make (text, " %T")
			--| read command
			worder.read_word
			if not worder.end_of_input then
				--| read filename
				worder.read_quoted_word
				if not worder.end_of_input then
					filename := worder.last_string.twin
					--| suppress eventual quotes
					if filename.item (1) = '%"' and then filename.item (filename.count) = '%"'
						or else filename.item (1) = '%'' and then filename.item (filename.count) = '%'' then
						filename := filename.substring (2, filename.count - 1)
					end
					--| verify that file exists
					create file.make (filename)
					if file.exists and file.is_readable then
						file.open_read
					end
					stream := file
					create current_context.make_by_parent (context)
				else
					check
						context.parent_context = Void
					end
					stream := attached_input
					current_context := context
				end
				current_context.create_command_stream (stream)
				--| let the system execute the commands in the script
				if current_context.command_stream /= Void then
					current_context.do_session
				end
			end
		end

feature -- Implementation

	attached_input : attached like Input
		do
			check attached Input as i then
				Result := i
			end
		end
end -- class ISQL_CMD_EXECUTE
