indexing
	description: "ECLI test of rowset classes";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
class
	TEST_ROWSET

inherit

	KL_SHARED_ARGUMENTS

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all
		end
		
creation

	make

feature -- Initialization

	make is
		do			
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
					!! session.make (dsn, user, password)
					session.connect
					if session.has_information_message then
						io.put_string (session.cli_state) 
						io.put_string (session.diagnostic_message)
					end
					if session.is_connected then
						io.put_string ("+ Connected %N")
						do_tests
	
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
	
	session : ECLI_SESSION
	
	statement : ECLI_STATEMENT
		
	error_message : STRING
	
feature -- Status Report

feature -- Status setting

feature -- Element change

feature -- Basic Operations

	do_tests is
		local
			test : ROWSET_MODIFIER_TEST
		do
				!!test.make (session)
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
						end
						index := index + 2
					else
						set_error ("Missing value for parameter",current_argument)
					end
				else
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
			
	print_usage is
		do
			if error_message /= Void then
				io.put_string (error_message)
			io.put_new_line
			end
			io.put_string ("Usage: test_rowset -dsn <data_source> -user <user_name> -pwd <password> [-sql <file_name>] [echo] [[-set <name>=<value> ]...]%N%
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
		
end -- class TEST_ROWSET
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
