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
			l_message : STRING
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
				create l_message.make (30)
				l_message.append_integer (count)
				l_message.append_character (':')
				l_message.append_string (cursor.item)
				context.filter.begin_message
				context.filter.put_message (l_message)
				context.filter.end_message
				cursor.forth
				count := count + 1
			end
		end

end -- class ISQL_CMD_HISTORY
