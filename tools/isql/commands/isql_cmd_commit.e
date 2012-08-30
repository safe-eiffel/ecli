note
	description: "Commands that commit a transaction."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_COMMIT

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING
		do
			Result := padded ("com[mit transaction]", command_width)
			Result.append_string ("Commit current transaction.")
		end

	match_string : STRING = "com"
	
feature -- Status report
	
	needs_session : BOOLEAN = True
	
	matches (text: STRING) : BOOLEAN
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT)
			-- execute a commit
		do
			context.session.commit
		end

end -- class ISQL_CMD_COMMIT
