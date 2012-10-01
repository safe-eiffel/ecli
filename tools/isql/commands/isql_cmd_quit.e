note
	description: "Objects that quit CLISQL."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_QUIT

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING
		do
			Result := padded ("q[uit]", command_width)
			Result.append_string ("Quit the application.") -- and closes current connection
		end

	match_string : STRING = "q"
	
feature -- Status report
	
	needs_session : BOOLEAN = False
	
	matches (text: STRING) : BOOLEAN
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT)
			-- execute a commit
		do
			context.set_must_quit
		end

end -- class ISQL_CMD_QUIT
