indexing
	description: "Objects that rollback a current transaction."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_ROLLBACK

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("rol[lback transaction]", command_width)
			Result.append_string ("Rollback current transaction.")
		end

	match_string : STRING is "rol"
	
feature -- Status report
	
	needs_session : BOOLEAN is True
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end

feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- rollback current transaction
		do
			context.session.rollback
		end

end -- class ISQL_CMD_ROLLBACK
