note
	description: "Objects that list the command history."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_HISTORY

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING
		do
			Result := padded ("hist[ory]", Command_width)
			Result.append_string ("Print the commands history.")
		end

	match_string : STRING = "hist"

feature -- Status report

	needs_session : BOOLEAN = False

	matches (text: STRING) : BOOLEAN
		do
			Result := matches_single_string (text, match_string)
		end

feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT)
			-- show history
		local
			count : INTEGER
			l_message : STRING
		do
			--| print heading message
			--| list commands
			if attached context.history.new_cursor as cursor then
				from
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
		end

end -- class ISQL_CMD_HISTORY
