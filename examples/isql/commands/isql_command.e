indexing
	description: "Objects that abstract ISQL commands."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ISQL_COMMAND

inherit
	ANY
	
	ECLI_STRING_ROUTINES
		export {NONE} all
		end
		
feature -- Access

	help_message : STRING is
			-- help message for current command
		deferred
		end
		
	error_message : STRING
	
feature -- Status report

	matches (text : STRING) : BOOLEAN is
			-- does `text' match current command
		deferred
		end

	is_error : BOOLEAN is
		do
			Result := error_message /= Void
		ensure
			definition: Result = (error_message /= Void)
		end

	needs_session : BOOLEAN is
			-- does this command need a connected session ?
		deferred
		end
		
feature -- Element change

	set_error (a_message : STRING) is
			-- set error_message to `a_message'
		require
			a_message_not_void: a_message /= Void
		do
			error_message := a_message
		ensure
			is_error: is_error
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- execute `text' within `context'
		require
			text_not_void: text /= Void
			text_matches_command: matches (text)
			context_not_void: context /= Void
--			context_executable: context.is_executable
		deferred
		end
		
feature {NONE} -- Implementation

	matches_single_string (text : STRING; matcher : STRING) : BOOLEAN is
		local
			stream : KL_WORD_INPUT_STREAM
			temp : STRING
		do
			create stream.make (text," %T%N%R")
			stream.read_word
			if not stream.end_of_input then
				temp := stream.last_string
				temp.to_lower
				Result := temp.substring_index (matcher,1)=1
			end
		end

	print_string (output : KI_TEXT_OUTPUT_STREAM; s : STRING) is
		do
			if s /= Void then
				output.put_string (s)
			else
				output.put_string ("NULL")
			end
		end

	nullable_string (s : STRING) : STRING is
		do
			if s/= Void then
				Result := s
			else
				Result := "NULL"
			end
		end
		
	command_width : INTEGER is 30
	sql_error (stmt : ECLI_STATUS) : STRING is
			-- 
		do
			Result := sql_error_msg (stmt, Void)
		end
		
	sql_error_msg (stmt : ECLI_STATUS; msg : STRING) : STRING is
		do
			create Result.make (0)
			Result.append_string ("* ERROR")
			if msg /= Void then
				Result.append_string (" : ")
				Result.append_string (msg)
			end
			Result.append_string (" * ")
			Result.append_string ("STATE:")
			Result.append_string (stmt.cli_state)
			Result.append_string (";CODE:")
			Result.append_string (stmt.native_code.out)
			Result.append_string (";MESSAGE:")
			Result.append_string (stmt.diagnostic_message)
		end
	
end -- class ISQL_COMMAND
