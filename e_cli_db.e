indexing
	description: "E_CLI_DB sample application";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"


class
	E_CLI_DB

creation

	make

feature -- Initialization

	make is
			-- Output a welcome message.
			--| (Automatically generated.)
		local
			session : 	ECLI_SESSION
			stmt : 		ECLI_STATEMENT
			vname : 	ECLI_CHAR
			vprice : 	ECLI_DOUBLE
			vbdate : 	ECLI_TIMESTAMP
			vfname : 	ECLI_VARCHAR
			pname : 	ECLI_CHAR
			vnbr : 		ECLI_INTEGER
			args :		expanded ARGUMENTS
		do
			-- session opening
			if args.argument_count < 3 then
				io.put_string ("Usage: e_cli_db <data_source> <user_name> <password>%N")
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
				create stmt.make (session)
				-- DDL statement
				-- | Uncomment next line for using MS Access driver or PostgreSQL
				stmt.set_sql ("CREATE TABLE ECLIESSAI (name CHAR(20), fname VARCHAR (20), nbr INTEGER, bdate DATETIME, price FLOAT)")
				-- 
				-- | Uncomment next line for using Oracle 8 driver, and comment previous one
				--stmt.set_sql ("CREATE TABLE ECLIESSAI (lname CHAR(20), fname VARCHAR2 (20), nbr NUMBER(10), bdate DATE, price FLOAT)")
				stmt.execute
				if stmt.is_ok then
					io.put_string ("Table ECLIESSAI created")
				else
					io.put_string (stmt.cli_state) 
					io.put_string (stmt.diagnostic_message)
				end
				-- DML statements
				stmt.raise_exception_on_error
				stmt.set_sql ("INSERT INTO ECLIESSAI VALUES ('Toto', 'Henri', 10, {ts '2000-05-24 08:20:15.00'}, 33.3)")
				stmt.execute
				stmt.set_sql ("INSERT INTO ECLIESSAI VALUES ('Lulu', 'Jimmy', 20, {ts '2000-06-25 09:34:00.00'}, 12.2)")
				stmt.execute
				stmt.set_sql ("INSERT INTO ECLIESSAI VALUES ('Didi', 'Anticonstitutionnellement', 30, {ts '2000-07-26 23:59:59.99'}, 42.4)")
				stmt.execute
				-- parameterized statement
				stmt.set_sql ("INSERT INTO ECLIESSAI VALUES (?some_name, ?some_name, 40, ?some_date, 89.02)")
				-- create and setup parameters
				create pname.make (20)
				pname.set_item ("Coco")
				create vbdate.make (1964, 9, 17, 14, 30, 02, 999999998)
				stmt.set_parameters (<<pname, pname, vbdate>>)
				stmt.bind_parameters
				-- using 'prepare' sets prepared_execution_mode
				stmt.prepare
				if not stmt.is_ok then
					io.put_string (stmt.diagnostic_message)
					io.put_character ('%N')
				end
				stmt.execute
				-- Change parameter value
				pname.set_null
				-- show how it is possible to bind a parameter 'by name'
				stmt.put_parameter (pname, "some_name")
				-- put_parameter 'unbind' previously bound parameters; they have to be bound again before execution
				stmt.bind_parameters
				stmt.execute
				if not stmt.is_ok then
					io.put_string (stmt.diagnostic_message)
					io.put_character ('%N')
				else
					-- change execution mode to immediate (no need to prepare)
					stmt.set_immediate_execution_mode
					stmt.set_sql ("SELECT * FROM ECLIESSAI")
					stmt.execute
					-- create result set 'value holders'
					create vname.make (20)
					create vnbr.make
					create vprice.make
					create vfname.make (20)
					-- define the container of value holders
					stmt.set_cursor (<<vname, vfname, vnbr, vbdate, vprice>>)
					-- iterate on result-set
					from
						stmt.start
					until
						stmt.off
					loop
						io.put_character ('%'')
						io.put_string (vname.out)
						io.put_character ('%'')
						io.put_character ('%N')
						io.put_character ('%'')
						io.put_string (vfname.out)
						io.put_character ('%'')
						io.put_character ('%N')
						io.put_string (vnbr.out)
						io.put_character ('%N')
						io.put_string (vbdate.out)
						io.put_character ('%N')
						io.put_string (vprice.out)
						io.put_character ('%N')				
						stmt.forth
					end
					-- finish reading result-set : mandatory even if result-set is empty !!!
					stmt.finish
				end
				-- DDL statement
				stmt.set_sql  ("DROP TABLE ECLIESSAI")
				stmt.execute 
				-- session disconnection
				session.disconnect
				if not session.is_connected then
				io.put_string ("Disconnected!!!%N")
				end
			end;
		end
	
invariant
end -- class E_CLI_DB
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
