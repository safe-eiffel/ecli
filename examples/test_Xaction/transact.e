note
	description: "Transaction test appliation."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
class
	TRANSACT

create

	make

feature -- Initialization

	make
			-- TRANSACT
		local
			args : ARGUMENTS
		do
			create args
			create session.make_default
			-- session opening
			if args.argument_count < 3 then
				io.put_string ("Usage: transact <data_source> <user_name> <password>%N")
			else
				session.set_login_strategy (
					create {ECLI_SIMPLE_LOGIN}.make (
							 args.argument (1),
							 args.argument (2),
							 args.argument (3))
							)
				session.connect
				if session.has_information_message then
					io.put_string (session.cli_state)
					io.put_string (session.diagnostic_message)
				end
				if session.is_connected then
					io.put_string ("Connected !!!%N")
				end
				-- definition of statement on session
				create  statement.make (session)
				--
				-- actual test
				--
				if session.is_transaction_capable then
					do_test
				else
					io.put_string ("The data source is not transaction-capable !")
				end
				--
				-- cleanup
				statement.close
				session.disconnect
				session.close
			end;
		end

	do_test
		do
			show_initial_message
			create_table
			io.put_string ("* Trying 'commit'%N")

			io.put_string ("-2- Begin transaction%N")
			session.begin_transaction

			insert_tuple ("Henry", "James")
			io.put_string ("  > Commit <%N")
			session.commit
			if is_tuple_inserted ("Henry", "James") then
				io.put_string (    "*** -- commit worked%N")
			else
				io.put_string (    ":(  -- commit failed ****%N")
			end

			io.put_string ("* Trying 'rollback%N")
			io.put_string ("-3- Begin transaction%N")

			session.begin_transaction
			insert_tuple ("James", "Henry")
			io.put_string ("  > Rollback <%N")
			session.rollback
			if not is_tuple_inserted ("James", "Henry") then
				io.put_string ("    *** -- rollback worked%N")
			else
				io.put_string ("    :(  -- rollback failed ****%N")
			end

			drop_table
			io.put_string ("All done!%N")

		end

	print_error
		do
			io.put_string (" --- Diagnostic : ")
			io.put_string (statement.diagnostic_message)
			io.put_character ('%N')
		end

	create_table
		do
			io.put_string ("-1- Table creation. ")
			statement.set_sql ("create table EXTRANSACT (first_name varchar (20), last_name varchar (30))")
			statement.execute
			if statement.is_ok then
				io.put_string (" OK%N")
			else
				io.put_string (" *** ! table already exists, or error%N")
				print_error
			end
		end

	drop_table
		do
			io.put_string ("-4- Table destruction. ")
			statement.set_sql ("drop table EXTRANSACT")
			statement.execute
			if statement.is_ok then
				io.put_string (" OK%N")
			else
				io.put_string (" *** ! could not drop table.%N")
				print_error
			end
		end

	insert_tuple (first, last : STRING)
		do
			launch_statement ("insert into EXTRANSACT VALUES (?first, ?last)", first, last)
			if statement.is_ok then
				io.put_string ("%T- success : tuple inserted%N")
			else
				io.put_string ("%T- failure : tuple not inserted %N")
				print_error
			end
		end

	is_tuple_inserted (first, last : STRING) : BOOLEAN
		local
			n : INTEGER
		do
			io.put_string ("    Read data back ... %N")
			launch_statement ("select * from EXTRANSACT where first_name = ?first and last_name = ?last", first, last)
			if statement.is_ok then
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
				io.put_string ("    * ")
				io.put_string (n.out)
				io.put_string (" tuples read%N")
			else
				io.put_string ("    - failure : selection does not work %N")
				print_error
			end
			Result := n > 0
		end

	launch_statement (stmt, last, first : STRING)
		local
			param : ECLI_VARCHAR
		do
			io.put_string ("%TStatement : ")
			io.put_string (stmt)
			io.put_string ("%N%Twith arguments : first='")
			io.put_string (first)
			io.put_string ("', last='")
			io.put_string (last)
			io.put_string ("'%N")

			statement.set_sql (stmt)
			create  param.make (20)
			param.set_item (first)
			statement.put_parameter (param, "first")
			create  param.make (30)
			param.set_item (last)
			statement.put_parameter (param, "last")
			statement.bind_parameters
			statement.execute
		end

	statement : detachable ECLI_STATEMENT
		note
			stable: stable
		attribute
		end

	session : ECLI_SESSION

	create_compatible_cursor
		local
			i, cols : INTEGER
			v : ECLI_VARCHAR
			cursor : ARRAY[ECLI_VALUE]
		do
			from
				i := 1
				cols := statement.result_columns_count
				create  cursor.make_filled (create {ECLI_CHAR}.make (1), 1, cols)
				statement.describe_results
			until
				i > cols
			loop
				create  v.make (statement.results_description.item (i).size.as_integer_32)
				cursor.put (v, i)
				i := i + 1
			end
			statement.set_results (cursor)
		end

	show_initial_message
		do
			io.put_string ("ECLI 'transact' sample application.%N")
			io.put_string ("It tests transaction capabilities of a datasource.%N")
			io.put_string ("1. Creation of test table.%N")
			io.put_string ("2. Commited tuple insertion.  The tuple is read back to test for its presence.%N")
			io.put_string ("3. Rollbacked tuple insertion.  The tuple is read back to test for its absence.%N%N")
		end

end -- class TRANSACT
--
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
