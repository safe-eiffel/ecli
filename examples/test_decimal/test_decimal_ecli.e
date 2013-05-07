note

class TEST_DECIMAL_ECLI

inherit

	MA_DECIMAL_CONSTANTS

	KL_SHARED_ARGUMENTS

create

	make

feature {NONE} -- Initialization

	make
			-- Create and execute test.
		do
			io.put_string ("*** test_decimal : Test DECIMAL input/output ***%N%N")
			create session.make_default
			create decimal_18_0.make(18, 0)
			create decimal_18_2.make(18, 2)
			create decimal_5_3.make (5, 3)
			create decimal_18_4.make(18, 4)

			if arguments.argument_count < 3 then
				io.put_string ("Usage: test_decimal <data_source> <user_name> <password>%N")
			else
				session.set_login_strategy (
					create {ECLI_SIMPLE_LOGIN}.make (
						arguments.argument (1),
						arguments.argument (2),
						arguments.argument (3))
					)
				session.connect
				if session.is_connected then
					create stmt.make (session)
					io.put_string ("1. Supported numeric types : %N")
					show_supported_numeric_types
					io.put_string ("%N2. Create test table.%N")
					create_test_table
					if stmt.is_ok then
						io.put_string ("Done.%N")
						-- populate
						io.put_string ("%N3. Insert sample values.%N")
						stmt.set_sql ("insert into TEST_DECIMAL VALUES (123456789012345678,'1234567890123456.78', '25.212', '12345678901234.5678')")
						stmt.execute
					end
					stmt.close
					io.put_string ("%N4. Insert values and check if they have been inserted.%N")
					execute_insert_test
					print ("%N")
					io.put_string ("%N5. Show table content.%N")
					show_table_content
					io.put_string ("%N6. That's all folks!%N")
					session.disconnect
					session.close
				else
					io.put_string ("Connection failed : "+session.diagnostic_message+"%N")
				end
			end
		end

feature -- Basic operations

	show_table_content
		do
			create stmt.make (session)
			stmt.set_sql ("select * from TEST_DECIMAL")
			stmt.execute
			stmt.describe_results
			if stmt.is_ok then
				from
					stmt.set_results (<<decimal_18_0, decimal_18_2, decimal_5_3, decimal_18_4>>)
					stmt.start
				until not stmt.is_ok or else stmt.off
				loop
					print (decimal_18_0.out)
					print ("%T")
					print (decimal_18_2.out)
					print ("%T")
					print (decimal_5_3.out)
					print ("%T")
					print (decimal_18_4.out)
					print ("%N")
					decimal_18_0.set_null
					decimal_18_2.set_null
					decimal_5_3.set_null
					decimal_18_4.set_null
					stmt.forth
				end
			else
				print (stmt.diagnostic_message)
			end
			stmt.close
		end

	execute_insert_test
		local
			ctx : MA_DECIMAL_CONTEXT
			insert : ECLI_STATEMENT
			my_decimal, ten : MA_DECIMAL
		do
			--| 1 insert
			create ctx.make (189,0)
			create my_decimal.make_from_string_ctx ("12345", ctx)
			my_decimal.set_shared_decimal_context (ctx)
			create ten.make_from_integer (10)
			decimal_18_0.set_item (my_decimal)
			my_decimal := my_decimal / ten
			my_decimal := my_decimal / ten
			decimal_18_2.set_item (my_decimal)
			my_decimal := my_decimal / ten
			decimal_5_3.set_item (my_decimal)
			my_decimal := my_decimal / ten
			decimal_18_4.set_item (my_decimal)
			create insert.make (session)
			insert.set_sql ("insert into TEST_DECIMAL (d18) VALUES (?)")
			test_insert (insert, decimal_18_0)
			insert.set_sql ("insert into TEST_DECIMAL (d182) VALUES (?)")
			test_insert (insert, decimal_18_2)
			insert.set_sql ("insert into TEST_DECIMAL (dl83) VALUES (?)")
			test_insert (insert, decimal_5_3)
			insert.set_sql ("insert into TEST_DECIMAL (d184) VALUES (?)")
			test_insert (insert, decimal_18_4)
		end

	test_insert (insert : ECLI_STATEMENT; value : ECLI_DECIMAL)
		do
				insert.set_parameters (<<value>>)
				print ("Trying to insert%T")
						print (value.out)
						print ("%T")
				insert.bind_parameters
				insert.execute
				if not insert.is_ok then
					print ("Error : %T")
					print (insert.cli_state)
					print (" ")
					print (insert.native_code.out)
					print (" ")
					print (insert.diagnostic_message)
					print ("%N")
				else
					print ("OK%N")
				end
		end

feature -- Access

	session : ECLI_SESSION
	stmt : detachable ECLI_STATEMENT
		note
			stable: stable
		attribute
		end

	decimal_18_0 : ECLI_DECIMAL
	decimal_18_2 : ECLI_DECIMAL
	decimal_5_3 : ECLI_DECIMAL
	decimal_18_4 : ECLI_DECIMAL

--	tables_cursor: ECLI_TABLES_CURSOR

--	type_catalog : ECLI_TYPE_CATALOG

feature -- Constants

	ddl_sql_server : STRING = "[
		CREATE TABLE TEST_DECIMAL (d18 NUMERIC(18,0), d182 NUMERIC (18,2), dl83 NUMERIC (18,3), d184 NUMERIC(18,4))
		]"

	ddl_firebird_interbase : STRING = "[
		CREATE TABLE TEST_DECIMAL (d18 DECIMAL(18,0), d182 DECIMAL (18,2), dl83 DECIMAL (5,3), d184 DECIMAL(18,4))
		]"

	ddl_sql92 : STRING = "[
		CREATE TABLE TEST_DECIMAL (d18 DECIMAL(18,0), d182 DECIMAL (18,2), dl83 DECIMAL (5,3), d184 DECIMAL(18,4))
		]"

	ddl_access : STRING = "[
		CREATE TABLE TEST_DECIMAL (d18 CURRENCY, d182 CURRENCY, dl83 CURRENCY, d184 CURRENCY)
		]"

	dbms_sql_server : STRING = "Microsoft SQL Server"

	dbms_firebird : STRING = "Firebird 1.5"

	dbms_access : STRING = "ACCESS"

feature -- Implementation

	create_test_table
		local
			dbms : STRING
		do
			drop_test_table
			dbms := session.info.dbms_name
			if dbms.is_equal (dbms_sql_server) then
					stmt.set_sql (ddl_sql_server)
			elseif dbms.is_equal (dbms_firebird) then
					stmt.set_sql (ddl_firebird_interbase)
			elseif dbms.is_equal (dbms_access) then
					stmt.set_sql (ddl_access)
			else
				io.put_string ("Do not know this DBMS: '"+dbms+"' - trying SQL 92%N")
				stmt.set_sql (ddl_sql92)
			end
			stmt.execute
		end

	drop_test_table
		local
			nm : ECLI_NAMED_METADATA
			table_exists : BOOLEAN
			tables_cursor : ECLI_TABLES_CURSOR
		do
			create nm.make (Void, Void, "TEST_DECIMAL");
			create tables_cursor.make (nm, session)
			tables_cursor.start
			table_exists := not tables_cursor.off
			tables_cursor.close
			if table_exists then
				stmt.set_sql ("drop table test_decimal")
				stmt.execute
			else
			end
		end

	show_supported_numeric_types
		local
			numerics : DS_LIST[ECLI_SQL_TYPE]
			type_catalog : ECLI_TYPE_CATALOG
		do
			create type_catalog.make (session)
			numerics := type_catalog.numeric_types
			from
				numerics.start
			until
				numerics.off
			loop
				print ("Name : "+numerics.item_for_iteration.name)
				print ("%T ("+numerics.item_for_iteration.size.out)
				if numerics.item_for_iteration.is_maximum_scale_applicable then
					print (", "+numerics.item_for_iteration.maximum_scale.out)
				end
				print (")")
				print ("%N")
				numerics.forth
			end
		end

end
