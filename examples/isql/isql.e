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
				io.put_string ("Usage: isql <data_source> <user_name> <password>%N")
			else
				create session.make (args.argument (1), args.argument (2), args.argument (3))
				session.connect
				if session.has_information_message then
					io.put_string (session.cli_state) 
					io.put_string (session.diagnostic_message)
				end
				if session.is_connected then
					io.put_string ("Connected !!!%N")
				end
				-- definition of statement on session
				create statement.make (session)
				do_session
			end;
		end
				
	do_session is
		do
			from
				read_command
			until
				last_command.is_equal ("q")
			loop
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
				create s.make (width)
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
		do
			last_command.copy("")

			io.put_string ("iSQL>")
			from
				io.read_line
			until
				io.last_string.item(1) = ';'
			loop
				last_command.append (io.last_string)
				io.read_line
			end
		end

	last_command : STRING is
		once
			create Result.make (1000)

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
			create Result.make (1000)
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
				create cursor.make (1, cols)
			until
				i > cols
			loop
				create v.make (statement.cursor_description.item (i).column_precision)
				cursor.put (v, i)
				i := i + 1
			end
			statement.set_cursor (cursor)
		end

end -- class ISQL
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
