indexing
	description: "Interactive SQL";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
class
	ISQL

inherit

	KL_SHARED_ARGUMENTS

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all
		end
		
creation

	make

feature -- Initialization

	make is
			-- isql
		do
			test_ar_integer
			test_ar_longvarchar
			test_ar_varchar
			test_ar_char
			
			-- session opening
			parse_arguments
			if error_message /= Void then
				print_usage
			else
				-- check for mandatory parameters
				if user = Void then
					set_error ("Missing user.  Specify parameter","-user")
					print_usage
				elseif password = Void then
					set_error ("Missing password. Specify parameter","-pwd")
					print_usage
				elseif dsn = Void then
					set_error ("Missign data source name. Specify parameter", "-dsn")
					print_usage
				else
					if sql /= Void then
						create_input_file (sql)
					end
					--	
					!! session.make (dsn, user, password)
					session.connect
					if session.has_information_message then
						io.put_string (session.cli_state) 
						io.put_string (session.diagnostic_message)
					end
					if session.is_connected then
						io.put_string ("+ Connected %N")
						print_help
						-- definition of statement on session
						!! statement.make (session)
						--
						-- interactive session
						--
						do_session
	
						-- closing statement
						statement.close
						-- disconnecting and closing session
						session.disconnect
					else
						print_error (session)
					end
					session.close
				end
			end;
		end


feature -- Access

	dsn : STRING
	user: STRING
	password : STRING
	sql : STRING

	vars: DS_HASH_TABLE[STRING, STRING]
	
	error_message : STRING

	last_command : STRING is
		once
			 Result := STRING_.make (1000)
		end
	
	session : ECLI_SESSION
	
	statement : ECLI_STATEMENT
		
	input_file : PLAIN_TEXT_FILE

	last_string : STRING
	
feature -- Status Report

	is_session_done : BOOLEAN is
			-- 
		do
			if end_of_input then
				Result := True
			else
				if last_command.count > 0 then
					Result :=  last_command.item (1) = 'q'
						or else last_command.item (1) = 'Q'
				end
			end
		end

	echo_output : BOOLEAN

	is_session_interactive : BOOLEAN is
		do
			Result := input_file = Void
		end

	is_begin (s : STRING) : BOOLEAN is
			-- is 's' a BEGIN TRANSACTION ?
			-- checking only first 3 characters...
		do
			if s.count >= 3 then
				if      (s.item (1) = 'b' or else s.item  (1) = 'B')
					and (s.item (2) = 'e' or else s.item (2) = 'E')
					and (s.item (3) = 'g' or else s.item (3) = 'G')
				then
					Result := True	
				end				
			end
		end
		
	is_commit (s : STRING) : BOOLEAN is
			-- is 's' a COMMIT TRANSACTION ?
			-- checking only first 3 characters...
		do
			if s.count >= 3 then
				if      (s.item (1) = 'c' or else s.item  (1) = 'C')
					and (s.item (2) = 'o' or else s.item (2) = 'O')
					and (s.item (3) = 'm' or else s.item (3) = 'M')
				then
					Result := True	
				end				
			end
		end
		
	is_rollback (s : STRING) : BOOLEAN is
			-- is 's' a ROLLBACK TRANSACTION ?
			-- checking only first 3 characters...
		do
			if s.count >= 3 then
				if (s.item (1) = 'r' or s.item  (1) = 'R')
					and (s.item (2) = 'o' or s.item (2) = 'O')
					and (s.item (3) = 'l' or s.item (3) = 'L')
				then
					Result := True	
				end				
			end
		end
		
	is_query (s : STRING) : BOOLEAN is
			-- is `s' a SELECT ?
			-- checking only first 3 characters
		do
			if s.count >= 3 then
				if (s.item (1) = 's' or s.item  (1) = 'S')
					and (s.item (2) = 'e' or s.item (2) = 'E')
					and (s.item (3) = 'l' or s.item (3) = 'L')
				then
					Result := True	
				end				
			end
		end
		
	is_set (s : STRING) : BOOLEAN is
			-- is 's' a SET ?
		do
			if s.count >= 3 then
				if (s.item (1) = 's' or s.item  (1) = 'S')
					and (s.item (2) = 'e' or s.item (2) = 'E')
					and (s.item (3) = 't' or s.item (3) = 'T')
				then
					Result := True	
				end				
			end
		end
	
	end_of_input : BOOLEAN is
		do
			if not is_session_interactive then
				Result := input_file.end_of_file
			end
		end

feature -- Status setting

feature -- Element change

	set_var (name, value : STRING) is
		do
			if vars = Void then
				!!vars.make (2)
			end
			vars.force (value, name)
		end
		
	set_parameters (stmt : ECLI_STATEMENT) is
		local
			value : ECLI_VARCHAR
			cursor : DS_HASH_TABLE_CURSOR[STRING,STRING]
		do
			from
				cursor := vars.new_cursor
				cursor.start
			until
				cursor.off
			loop
				if stmt.has_parameter (cursor.key) then
					!!value.make (cursor.item.count)
					value.set_item (cursor.item)
					stmt.put_parameter (value, cursor.key)
				end
				cursor.forth
			end					
		end

feature -- Basic Operations

	do_session is
		do
			test_rowset
			from
				read_command
			until
				is_session_done
			loop
				if not is_session_interactive and echo_output then
					io.put_string (last_command)
					io.put_string ("%N")
				end
				if last_command.is_equal ("h") then
					print_help
				elseif is_begin (last_command) then
					session.begin_transaction
				elseif is_commit (last_command) then
					session.commit
				elseif is_rollback (last_command) then
					session.rollback
				elseif is_set (last_command) then
					do_set (last_command)
				elseif is_query (last_command) then
					do_execute_query (last_command)
				else
					do_execute_sql (last_command)
				end
				read_command
			end
		end

	read_command is
		-- prompt user
		local
			done : BOOLEAN
			separator_index : INTEGER
		do
			last_command.copy("")
			

			-- prompt user
			if is_session_interactive then
				io.put_string ("iSQL>")
			end
			
			from
				read_line
			until
				end_of_input or else done
			loop
				-- Trim trailing blanks
				from
					separator_index := last_string.count
				until
					separator_index < 1 or else
					(last_string.item(separator_index) /= ' ' and then
					last_string.item(separator_index) /= '%T')
				loop
					separator_index := separator_index - 1
				end
				-- End of command ?
				if separator_index >= 1 then
					if last_string.item (separator_index) = ';' then
						done := True
						separator_index := separator_index - 1
					end
				end
				-- Append if not empty string
				if separator_index >= 1 then
					-- Add a blank if necessary to avoid concatenating command statements...
					if last_command.count > 0 and then (last_command.item (last_command.count) /= ' ' or else
					   last_string.item (1) /= ' ') then
					   last_command.append_character (' ')
					end
					-- Append next command segment
					last_command.append (last_string.substring (1, separator_index))					
				end
				if not done then
					read_line
				end
			end
		ensure
			command_set: last_command /= Void
		end

	create_input_file (file_name : STRING) is
			-- create and open file `file_name' for reading
		require
			file_name_exists : file_name /= Void
		local
			rescued : BOOLEAN
		do
			if not rescued then
				!!input_file.make_open_read (file_name)
				if not input_file.is_open_read then
					io.put_string ("Error : cannot open '")
					io.put_string (file_name)
					io.put_string ("' for reading.%N")
					input_file := Void
				end
			end
		ensure
			input_file /= Void implies input_file.is_open_read
		rescue
			rescued := True
			input_file := Void
			retry
		end
	
	read_line is
		do
			if is_session_interactive then
				io.read_line
				last_string := io.last_string
			else
				input_file.read_line
				last_string := input_file.last_string
			end
		end

	do_execute_sql (s : STRING) is
			-- 
		do
			statement.set_sql (last_command)
			if statement.has_parameters then
				if vars /= Void then
					set_parameters (statement)
					statement.bind_parameters
				end
			end
			statement.execute
			if not statement.is_ok or else statement.has_information_message then
				print_error (statement)
			else
				io.put_string ("OK%N")
			end
		end

	do_execute_query (s : STRING) is
			-- 
		local
			cursor : ECLI_ROWset_CURSOR
			after_first : BOOLEAN
		do
			!!cursor.make (session, last_command, 20)
			if cursor.is_ok then
				if cursor.has_parameters then
					if vars /= Void then
						set_parameters (statement)
						cursor.bind_parameters
					end
				end
				from 
					cursor.start
					if cursor.has_information_message then
						print_error (cursor)                                            
					end
				until 
					not cursor.is_ok or else cursor.off
				loop
					if not after_first then
						show_column_names (cursor)
						after_first := True
					end	
					show_one_row (cursor)
					cursor.forth
				end
				if not cursor.is_ok then
					print_error (cursor)
				else
					io.put_string ("OK%N")				
				end				
			else
				print_error (cursor)                                          
			end
			cursor.close
		end
		
	do_set (s : STRING) is
			-- handle a 'set <var-name>=<value>'
		local
			cursor : DS_HASH_TABLE_CURSOR[STRING,STRING]
		do
			if s.count > 3 then
				--do assign
				do_assign (s.substring (4, s.count))
				if error_message /= Void then
					io.put_string (error_message)
					io.put_string ("%N")
				end				
			else
				-- show variable names
				from
					cursor := vars.new_cursor
					cursor.start
				until
					cursor.off
				loop
					io.put_string (cursor.key)
					io.put_string ("=")
					io.put_string (cursor.item)
					io.put_new_line
					cursor.forth
				end					
			end
		end

	do_assign (s : STRING) is
			-- assigns <var-name>=<value>
		local
			setting : STRING
			assign_index : INTEGER		
			var_name, var_value : STRING
			string_routines : ECLI_STRING_ROUTINES
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
					set_var (var_name, var_value)
				else
					set_error ("Missing value for variable", var_name)
				end
			else
					set_error("Not a variable assignment", setting)
			end			
		end
		
feature {NONE} -- Implementation

	parse_arguments is
		local
			index : INTEGER
			current_argument : STRING
		do
			from
				index := 1
				error_message := Void
			until
				error_message /= Void or else index > Arguments.argument_count
			loop
				current_argument := Arguments.argument (index)
				if current_argument.item (1) = '-' then
					if (index + 1) <= Arguments.argument_count then
						if current_argument.is_equal ("-dsn") then
							dsn := Arguments.argument (index + 1)
						elseif current_argument.is_equal ("-user") then
							user := Arguments.argument (index + 1)
						elseif current_argument.is_equal ("-pwd") then
							password := Arguments.argument (index + 1)
						elseif current_argument.is_equal ("-sql") then
							sql := Arguments.argument (index + 1)
						elseif current_argument.is_equal ("-set") then
							do_assign (Arguments.argument (index + 1))
						end
						index := index + 2
					else
						set_error ("Missing value for parameter",current_argument)
					end
				else
					current_argument.to_lower
					if current_argument.is_equal ("echo") then
						echo_output := True
					end
					index := index + 1
				end
			end
		end		
	
	set_error (message, value : STRING) is
		do
						!!error_message.make (0)
						error_message.append (message)
						error_message.append (" '")
						error_message.append (value)
						error_message.append ("'")		
		ensure
			error_message /= Void
		end
		
	print_help is
		do
			if is_session_interactive then
				io.put_string ("Enter a SQL or a command terminated by a ';'%N")
				io.put_string (" ;%Texecutes last SQL or command%N")
				io.put_string ("Commands%N")
				io.put_string (" h%Tprint this message%N")
				io.put_string (" q%Tquit%N")
				io.put_string (" BEGIN TRANSACTION%T Begins a new transaction%N")
				io.put_string (" COMMIT TRANSACTION%T Commits current transaction%N")
				io.put_string (" ROLLBACK TRANSACTION%T Rollbacks current transaction%N")
			end
		end
	
	print_usage is
		do
			if error_message /= Void then
				io.put_string (error_message)
			io.put_new_line
			end
			io.put_string ("Usage: isql -dsn <data_source> -user <user_name> -pwd <password> [-sql <file_name>] [echo] [[-set <name>=<value> ]...]%N%
						%%T-dsn data_source%T%TODBC data source name%N%
						%%T-user user_name%T%Tuser name for database login%N%
						%%T-pwd password%T%Tpassword for database login%N%
						%%T-sql file_name%T%Toptional file_name for batch SQL execution%N%
						%%Techo %T%T%T%Techo batch commands%N%
						%%T-set <name>=<value>%Tset variable 'name' to 'value', for parametered statements.%N")
		end

		
	print_error (stmt : ECLI_STATUS) is
		do
			io.put_string ("** ERROR **%N")
			io.put_string (stmt.diagnostic_message)
			io.put_character ('%N')
		end

	show_column_names (cursor : ECLI_ROW_CURSOR) is
		local
			i, width, npad : INTEGER
			s : STRING
		do
			from
				i := 1
			until
				i > cursor.upper
			loop
				width := (cursor @i i).column_precision
				!! s.make (width)
				s.append (cursor.column_name (i))
				-- pad with blanks
				npad := width - s.count
				pad (s, npad)
				io.put_string (s)
				if i <= cursor.upper then
					io.put_character ('|')
				end
				i := i + 1
			end
			io.put_character ('%N')
		end


	show_one_row (cursor : ECLI_ROW_CURSOR) is
		require
			cursor /= Void and then not cursor.off
		local
			index, npad : INTEGER
		do
			from
				index := cursor.lower
			until
				index > cursor.upper
			loop
				formatting_buffer.clear_content
				if (cursor @i index).is_null then
					formatting_buffer.append ("NULL")
				else
					formatting_buffer.append ((cursor @i index).to_string)
				end
				npad := (cursor @i (index)).column_precision - formatting_buffer.count
				if npad > 0 then
					pad (formatting_buffer, npad)
				end
				io.put_string (formatting_buffer)
				io.put_character ('|')
				index := index + 1
			end
			--
			io.put_character ('%N')
		end
		
	pad (s : STRING; n : INTEGER) is
			-- pad 's' with 'n' blanks
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > n
			loop
				s.append_character (' ')
				i := i + 1
			end
		end			
			
	formatting_buffer : MESSAGE_BUFFER is
		once
			!!Result.make (1000)
		end

	create_compatible_cursor is
		local
			i, cols : INTEGER
			v : ECLI_VARCHAR
			cursor : ARRAY[ECLI_VALUE]
		do
			from
				i := 1
				cols := statement.result_column_count
				!! cursor.make (1, cols)
			until
				i > cols
			loop
				!! v.make (statement.cursor_description.item (i).column_precision)
				cursor.put (v, i)
				i := i + 1
			end
			statement.set_cursor (cursor)
		end

	ar : ECLI_ARRAYED_INTEGER
	
	arl : ECLI_ARRAYED_LONGVARCHAR
	
	arv : ECLI_ARRAYED_VARCHAR
	
	arc : ECLI_ARRAYED_CHAR
	
	test_ar_integer is
			-- 
		do
			!! ar.make (5)
			ar.set_item_at (23, 1)
			ar.set_item_at (-1, 2)
			ar.set_item_at (1_000_000_000, 3)
			ar.set_null_at (4)
			ar.set_item_at (-1_000_000_000, 5)
			print (ar.out)
			print ("%N")
		end

	test_ar_longvarchar is
			-- 
		do
			!! arl.make (30, 5)
			arl.set_item_at ("Essai", 1)
			arl.set_item_at ("", 2)
			arl.set_item_at ("Très longue chaîne", 3)
			arl.set_null_at (4)
			arl.set_item_at ("Rien du tout", 5)
			print (arl.out)
			print ("%N")
		end

	test_ar_varchar is
			-- 
		do
			!! arv.make (30, 5)
			arv.set_item_at ("Essai", 1)
			arv.set_item_at ("", 2)
			arv.set_item_at ("Très longue chaîne", 3)
			arv.set_null_at (4)
			arv.set_item_at ("Rien du tout", 5)
			print (arv.out)
			print ("%N")
		end

	test_ar_char is
			-- 
		do
			!! arc.make (30, 5)
			arc.set_item_at ("Essai", 1)
			arc.set_item_at ("", 2)
			arc.set_item_at ("Très longue chaîne", 3)
			arc.set_null_at (4)
			arc.set_item_at ("Rien du tout", 5)
			print (arc.out)
			print ("%N")
		end
		
	rs : ECLI_ROWSET_CURSOR
	
	avf : ECLI_ARRAYED_VALUE_FACTORY
	
	test_rowset is
			-- 
		local
			index : INTEGER
			loops : INTEGER
		do
			!!rs.make (session, "select * from toto", 3)
			from
				rs.start
				loops := 1
			until
				not rs.is_ok or else rs.off
			loop
				from index := rs.lower
				until (loops \\ rs.row_count /= 1) or else index > rs.upper
				loop
					print (rs.item_by_index (index))
					print ("%N")
					index := index + 1
				end
				rs.forth
				loops := loops + 1
			end
			rs.close
		end


	test_cursors is
		do
				print ("Testing row cursor...%N")
				test_row_cursor
				print ("Testing rowset cursor...%N")
				test_rowset_cursor
		end
		
	test_row_cursor is
		local
			row_cursor : ECLI_ROW_CURSOR
		do
			!! row_cursor.make (session, "select * from sysobjects")
			test_cursor (row_cursor)
			row_cursor.close
		end

	test_rowset_cursor is
		local
			rowset_cursor : ECLI_ROWSET_CURSOR
		do
			!! rowset_cursor.make (session, "select * from sysobjects", 100)
			test_cursor (rowset_cursor)
			rowset_cursor.close
		end
		
	test_cursor (cursor : ECLI_ROW_CURSOR) is
			-- 
		local
			time_begin, time_end : DT_TIME
			clock : DT_SYSTEM_CLOCK
			index : INTEGER
			count : INTEGER
		do
			from
				index := 1; count := 0
				!! clock.make
				time_begin := clock.time_now
			until
				index > 400
			loop
				from
					cursor.start
				until
					cursor.off
				loop
					count := count + 1
					cursor.forth
				end
				index := index + 1
			end
			time_end := clock.time_now
			print ("Begin : ")
			print (time_begin.out)
			print ("; End : ")
			print (time_end.out)
			print (" Count : ")
			print (count.out)
			print ("%N")
		end
		
end -- class ISQL
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
