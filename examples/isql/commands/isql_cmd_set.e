indexing
	description: "Commands that set a value to a variable name."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_SET

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("set [<variable_name>=<value>]", command_width)
			Result.append_string ("Set/[show] variables.")
		end

	match_string : STRING is "set"
	
feature -- Status report
	
	needs_session : BOOLEAN is False
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- execute command SET [<VAR>=<VALUE>]
		do
			error_message := Void
			do_set (text, context)
		end

feature {ISQL} -- Inapplicable

	do_assign (s : STRING; context: ISQL_CONTEXT) is
			-- assigns <var-name>=<value>
		local
			setting : STRING
			assign_index : INTEGER		
			var_name, var_value : STRING
			string_routines : ECLI_STRING_ROUTINES
			msg : STRING
		do
			!!string_routines
			setting := s
			assign_index := setting.index_of ('=',1)
			if assign_index > 1 then
				var_name := string_routines.trimmed (setting.substring (1, assign_index-1))
				--TODO: remove any blank before or after
				if assign_index < setting.count then
					var_value := string_routines.trimmed (setting.substring (assign_index+1,setting.count))
					--TODO: remove any blank before or after
					set_var (var_name, var_value, context)
				else
					--create msg.make (0)
					--msg.append_string ("Missing value for variable ")
					--msg.append_string (var_name)
					--set_error (msg)
					set_var (var_name, "", context)
				end
			else
					create msg.make (0)
					msg.append_string ("Not a variable assignment ")
					msg.append_string (setting)
					set_error (msg)
			end			
		end


feature {NONE} -- Implementation

	do_set (s : STRING; context : ISQL_CONTEXT) is
			-- handle a 'set <var-name>=<value>'
		local
			cursor : DS_HASH_TABLE_CURSOR[STRING,STRING]
		do
			if s.count > Match_string.count then
				--do assign
				do_assign (s.substring ( Match_string.count+1, s.count), context)
				if error_message /= Void then
					io.put_string (error_message)
					io.put_string ("%N")
				end				
			else
				-- show variable names
				from
					cursor := context.variables.new_cursor
					cursor.start
				until
					cursor.off
				loop
					context.output_file.put_string (cursor.key)
					context.output_file.put_string ("=%"")
					context.output_file.put_string (escaped_value (cursor.item))
					context.output_file.put_string ("%"")
					context.output_file.put_new_line
					cursor.forth
				end					
			end
		end

	set_var (name, value : STRING; context : ISQL_CONTEXT) is
		local
			l_value : STRING
		do
			--| suppress leading and trailing '"', if present
			if value.item (1) = '"' and then value.item (value.count) = '"' then
				l_value := value.substring (2, value.count - 1)
			else
				l_value := value
			end
			context.variables.force (substituted_escapes (l_value), name)
		end
	
	substituted_escapes (s : STRING) : STRING is
			-- substitute 'C' escape sequences : \n, \r, \0, \t, \\
		local
			index : INTEGER
			c, r : CHARACTER
			s_begin, s_end : INTEGER
		do
			create Result.make (0)
			from
				s_begin := 1
				s_end := s.count
				index := s_begin
			until
				index > s_end
			loop
				c := s.item (index)
				inspect c
				when '\' then
					if index + 1 <= s_end then
						inspect s.item (index + 1)
						when 'n','N' then
							r := '%N'
						when 'r', 'R' then
							r := '%R'
						when '0' then
							r := '%U'
						when 't', 'T' then
							r := '%T'
						when '\' then
							r := '\'
						else
							--| put character at index + 1
							r := s.item (index + 1)
						end
						Result.append_character (r)
						index := index + 2
					else
						Result.append_character (c)
						index := index + 1
					end
				else
					Result.append_character (c)
					index := index + 1				
				end
			end
		end

	escaped_value (v : STRING) : STRING is
		local
			index : INTEGER
		do
			from
				create Result.make (0)
				index := 1
			until
				index > v.count
			loop
				inspect v.item (index)
				when '%T' then
					Result.append_string ("\t")
				when '%N' then
					Result.append_string ("\n")
				when '%U' then
					Result.append_string ("\0")
				when '%R' then
					Result.append_string ("\r")
				when '\' then
					Result.append_string ("\\")
				else
					Result.append_character (v.item (index))
				end
				index := index + 1
			end
		end

end -- class ISQL_CMD_SET
