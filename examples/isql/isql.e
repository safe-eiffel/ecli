indexing
	description: "Interactive SQL";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
class
	ISQL

creation

	make

feature -- Initialization

	make is
			-- isql
		local
			args :          expanded ARGUMENTS
		do
			-- session opening
			if args.argument_count < 3 then
				io.put_string ("Usage: isql <data_source> <user_name> <password> [<input_file_name> [echo]]%N")
			else
				-- determine_input
				if args.argument_count > 3 then
					create_input_file (args.argument (4))
					if args.argument_count > 4 then
						echo_output := (args.argument (4).item (1) ='e' or else args.argument (4).item (1)='E')
					end
				end
				
				!! session.make (args.argument (1), args.argument (2), args.argument (3))
				session.connect
				if session.has_information_message then
					io.put_string (session.cli_state) 
					io.put_string (session.diagnostic_message)
				end
				if session.is_connected then
					io.put_string ("+ Connected %N")
					print_help
				end
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
				session.close
			end;
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
		
	do_session is
		do
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
				else
					statement.set_sql (last_command)
					statement.execute
					if not statement.is_ok then
						print_error
					else
						if statement.has_information_message then
							print_error                                             
						end
						if statement.has_results then
							statement.describe_cursor
							show_column_names (statement)
							show_result_rows (statement)
						else
							io.put_string ("OK%N")
						end
					end
				end
				read_command
			end
		end
		
	print_error is
		do
			io.put_string ("** ERROR **%N")
			io.put_string (statement.diagnostic_message)
			io.put_character ('%N')
		end

	show_column_names (stmt : ECLI_STATEMENT) is
		local
			i, width, npad : INTEGER
			s : STRING
		do
			from
				i := 1
			until
				i > stmt.cursor_description.count
			loop
				width := stmt.cursor_description.item (i).column_precision
				!! s.make (width)
				s.append (stmt.cursor_description.item (i).name)
				-- pad with blanks
				npad := width - s.count
				pad (s, npad)
				io.put_string (s)
				if i <= stmt.cursor_description.count then
					io.put_character ('|')
				end
				i := i + 1
			end
			io.put_character ('%N')
		end

	show_result_rows (stmt : ECLI_STATEMENT) is
		do
			--
			create_compatible_cursor
			from stmt.start
			until stmt.off
			loop
				show_one_row (stmt)
				stmt.forth
			end
		end

	show_one_row (stmt : ECLI_STATEMENT) is
		require
			stmt /= Void and then stmt.is_executed and then stmt.cursor_description /= Void
		local
			i, npad : INTEGER
		do
			from
				i := 1
			until
				i > stmt.cursor.count
			loop
				formatting_buffer.clear_content
				formatting_buffer.append (stmt.cursor.item (i).out)
				npad := stmt.cursor_description.item (i).column_precision - formatting_buffer.count
				if npad > 0 then
					pad (formatting_buffer, npad)
				end
				io.put_string (formatting_buffer)
				io.put_character ('|')
				i := i + 1
			end
			--
			io.put_character ('%N')
		end


feature -- Basic Operations

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
					separator_index < 1 or
					last_string.item(separator_index) /= ' ' or
					last_string.item(separator_index) /= '%T'
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
					last_command.append (last_string.substring (1, separator_index))					
				end
				if not done then
					read_line
				end
			end
		end

	last_command : STRING is
		local
			string_routines : expanded KL_STRING_ROUTINES
		once
			 Result := string_routines.make (1000)

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
			!! Result.make (1000)
		end
	
	session : ECLI_SESSION
	
	statement : ECLI_STATEMENT
	
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

	is_session_interactive : BOOLEAN is
		do
			Result := input_file = Void
		end
		
	input_file : PLAIN_TEXT_FILE

	create_input_file (file_name : STRING) is
			-- create and open file `file_name' for reading
		require
			file_name_exists : file_name /= Void
		local
			rescued : BOOLEAN
		do
			if not rescued then
				!!input_file.make_open_read (file_name)
			end
		ensure
			input_file /= Void implies input_file.is_open_read
		rescue
			rescued := True
			input_file := Void
			retry
		end

	last_string : STRING
	
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
	
	end_of_input : BOOLEAN is
		do
			if not is_session_interactive then
				Result := input_file.end_of_file
			end
		end

	echo_output : BOOLEAN
	
end -- class ISQL
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
