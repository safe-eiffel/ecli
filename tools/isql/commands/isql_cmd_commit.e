indexing
	description: "Commands that commit a transaction."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_COMMIT

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("com[mit transaction]", command_width)
			Result.append_string ("Commit current transaction.")
		end

	match_string : STRING is "com"
	
feature -- Status report
	
	needs_session : BOOLEAN is True
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- execute a commit
		do
			context.session.commit
		end

end -- class ISQL_CMD_COMMIT
