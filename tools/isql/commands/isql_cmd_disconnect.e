note
	description: "Objects that CONNECT to a database."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_DISCONNECT

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING
		do
			Result := padded ("dis[connect]", Command_width)
			Result.append_string ("Disconnect current session.")
		end

	match_string : STRING = "dis"
	
feature -- Status report
	
	needs_session : BOOLEAN = True
	
	matches (text: STRING) : BOOLEAN
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT)
			-- execute a disconnect
		do
			context.session.disconnect
			context.session.close
		end

end -- class ISQL_CMD_DISCONNECT
