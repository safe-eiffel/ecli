indexing
	description: "Objects that RECALL commands from the history."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_RECALL

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("re[call] <i>", Command_width)
			Result.append ("Recall the <i>th command in the history.")
		end

	match_string : STRING is "re"
	
feature -- Status report
	
	needs_session : BOOLEAN is False
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- recall a command in history
		local
			worder : KL_WORD_INPUT_STREAM
			history_index : INTEGER
		do
			create worder.make (text, " %T")
			--| consume command
			worder.read_word
			worder.read_word
			if not worder.end_of_input then
				if worder.last_string.is_integer then
					history_index := worder.last_string.to_integer
					context.output_file.put_string (context.history.item (history_index))
					context.command_stream.set_buffer_text (context.history.item (history_index))
				else
					context.filter.begin_error
					context.filter.put_error ("RECALL : invalid number '" + worder.last_string +"'")
					context.filter.end_error
				end
			else
				context.filter.begin_error
				context.filter.put_error ("RECALL : expecting a number")
				context.filter.end_error			
			end
		end

end -- class ISQL_CMD_RECALL
