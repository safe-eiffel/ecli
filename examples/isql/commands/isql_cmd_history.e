indexing
	description: "Objects that list the command history."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_HISTORY

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("hist[ory]", Command_width)
			Result.append_string ("Print the commands history.")
		end

	match_string : STRING is "hist"
	
feature -- Status report
	
	needs_session : BOOLEAN is False
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- show history
		local
			cursor : DS_LINKED_LIST_CURSOR[STRING]	
			count : INTEGER
		do
			--| print heading message
			--| list commands
			from
				cursor := context.history.new_cursor
				cursor.start
				count := 1
			until
				cursor.off
			loop
				context.output_file.put_integer (count)
				context.output_file.put_character (':')
				context.output_file.put_string (cursor.item)
				context.output_file.put_new_line
				cursor.forth
				count := count + 1
			end
		end

end -- class ISQL_CMD_HISTORY
