indexing
	description: "Commands that begin a transaction."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_USAGE

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("usage", command_width)
			Result.append ("Print command usage.")
		end

	match_string : STRING is "usage"
	
feature -- Status report
	
	needs_session : BOOLEAN is False
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- show usage
		do
			context.output_file.put_string (Usage_string)
		end

	Usage_string : STRING is "Usage: isql [-dsn <data_source> -user <user_name> -pwd <password>] [-sql <file_name>] [echo] [[-set <name>=<value> ]...]%N%
						%%T-dsn data_source%T%TODBC data source name%N%
						%%T-user user_name%T%Tuser name for database login%N%
						%%T-pwd password%T%Tpassword for database login%N%
						%%T-sql file_name%T%Toptional file_name for batch SQL execution%N%
						%%Techo %T%T%T%Techo batch commands%N%
						%%T-set <name>=<value>%Tset variable 'name' to 'value', for parametered statements.%N"
						
end -- class ISQL_CMD_USAGE