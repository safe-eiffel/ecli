indexing
	description: "Objects that CONNECT to a database."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_CONNECT

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("con[nect] <dsn> <user> <pwd>", Command_width)
			Result.append_string ("Connect to <dsn> datasource as <user> with password <pwd>.")
		end

	match_string : STRING is "con"
	
feature -- Status report
	
	needs_session : BOOLEAN is False
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- connect to a datasource
		local
			worder : KL_WORD_INPUT_STREAM
			source, user, password : STRING
			session : ECLI_SESSION
		do
			create worder.make (text, " %T")
			user := ""
			password := ""
			--| consume command
			worder.read_word
			worder.read_word
			if not worder.end_of_input then
				source := clone (worder.last_string)
				worder.read_word
				if not worder.end_of_input then
					user := clone (worder.last_string)
					worder.read_word
					if not worder.end_of_input then
						password := clone (worder.last_string)
					end
				end
				if context.session /= Void and then context.session.is_connected then
					context.session.disconnect
					context.session.close
				end
				create session.make (source, user, password)
				session.connect
				if session.is_connected then
					context.set_session (session)	
				else
					context.filter.begin_error
					context.filter.put_error ("NOT Connected : ")
					context.filter.put_error (session.diagnostic_message)
					context.filter.end_error
				end
			else
				context.filter.begin_error
				context.filter.put_error ("CONNECT : expecting a datasource name")
				context.filter.end_error			
			end
		end

end -- class ISQL_CMD_CONNECT
