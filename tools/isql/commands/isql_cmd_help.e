indexing
	description: "Objects that show HELP about CLISQL commands."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_HELP

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("he[lp]", Command_width)
			Result.append_string ("Print the list of available commands.")
		end

	match_string : STRING is "he"

feature -- Status report

	needs_session : BOOLEAN is False

	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end

feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- show help
		do
			--| print heading message
			context.filter.begin_message
			context.filter.put_message ("Enter any command followed by a semicolon.%N%
				%This semicolon launches command execution.%N%
				%Command names can be abbreviated; characters between [ ] can be avoided.%N%NAvailable commands ('*' = needs a connected session) :%N")

			--| list commands
			if attached context.commands.new_cursor as cursor then
				from
					cursor := context.commands.new_cursor
					cursor.start
				until
					cursor.off
				loop
					if cursor.item.needs_session then
						context.filter.put_message ("* ")
					else
						context.filter.put_message ("  ")
					end
					context.filter.put_message (cursor.item.help_message)
					context.filter.put_message ("%N")
					cursor.forth
				end
			end
--			context.filter.put_message ("* ")
--			context.filter.put_message (context.sql_command.help_message)
			context.filter.end_message
		end

end -- class ISQL_CMD_HELP
