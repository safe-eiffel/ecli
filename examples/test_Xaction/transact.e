indexing
	description: "Transaction test appliation";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
class
	TRANSACT

creation

	make

feature -- Initialization

	make is
			-- TRANSACT
		local
			args :          expanded ARGUMENTS
		do
			-- session opening
			if args.argument_count < 3 then
				io.put_string ("Usage: TRANSACT <data_source> <user_name> <password>%N")
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
			create_table
			io.put_string ("* Trying 'commit'%N")
			session.begin_transaction
			insert_tuple ("Henry", "James")
			io.put_string ("  > Commit <%N")
			session.commit
			if is_tuple_inserted ("Henry", "James") then
				io.put_string ("*** -- commit worked%N")
			else
				io.put_string (":(  -- commit failed ****%N")			
			end
			io.put_string ("* Trying 'rollback%N")
			session.begin_transaction
			insert_tuple ("James", "Henry")
			io.put_string ("  > Rollback <%N")
			session.rollback
			if not is_tuple_inserted ("James", "Henry") then
				io.put_string ("*** -- rollback worked")
			else
				io.put_string (":(  -- rollback failed ****%N")
			end			
		end

	print_error is
		do
			io.put_string (" --- Diagnostic : ")
			io.put_string (statement.diagnostic_message)
			io.put_character ('%N')
		end
	
	create_table is
		do
			statement.set_sql ("create table EXTRANSACT (first_name varchar (20), last_name varchar (30))")
			statement.execute
			if statement.is_ok then
				io.put_string ("- table created%N")
			else
				io.put_string ("! table already exists, or error%N")
				print_error
			end
		end
		
	insert_tuple (first, last : STRING) is
		do
			launch_statement ("insert into EXTRANSACT VALUES (?first, ?last)", first, last)
			if statement.is_ok then
				io.put_string ("- success : tuple inserted%N")
			else
				io.put_string ("- failure : tuple not inserted %N")
				print_error
			end
		end
		
	is_tuple_inserted (first, last : STRING) : BOOLEAN is
		local
			n : INTEGER
		do
			launch_statement ("select * from EXTRANSACT where first_name = ?first and last_name = ?last", first, last)
			if statement.is_ok then
				io.put_string ("- success : ")
				from
					create_compatible_cursor
					statement.start
					n := 0
				until
					statement.off
				loop
					n := n + 1
					statement.forth
				end
				io.put_string (n.out)
				io.put_string (" tuples read%N")
			else
				io.put_string ("- failure : selection does not work %N")
				print_error
			end
			Result := n > 0		
		end
		
	launch_statement (stmt, last, first : STRING) is
		local
			param : ECLI_VARCHAR
		do
			statement.set_sql (stmt)
			create param.make (20)
			param.set_item (first)
			statement.put_parameter (param, "first")
			create param.make (30)
			param.set_item (last)
			statement.put_parameter (param, "last")
			statement.bind_parameters
			statement.execute
		end
	
	statement : ECLI_STATEMENT
	
	session : ECLI_SESSION

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
				statement.describe_cursor
			until
				i > cols
			loop
				create v.make (statement.cursor_description.item (i).column_precision)
				cursor.put (v, i)
				i := i + 1
			end
			statement.set_cursor (cursor)
		end
	
end -- class TRANSACT
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--