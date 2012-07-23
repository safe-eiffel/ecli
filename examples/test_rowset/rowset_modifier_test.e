indexing
	description: "Objects that test bulk operations."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ROWSET_MODIFIER_TEST

create
	make

feature {NONE} -- Initialization

	make (a_session : ECLI_SESSION) is
			-- make and run test on `a_session'
		do
			session := a_session
			drop_table
			create_table
			do_insert
			test_insert
			do_update
			test_update
		end

feature -- Access

	names : ARRAY [STRING] is
			-- array of names
		once
			Result := <<
				"a very long name",
				"b",
				"c",
				"d",
				"e",
				"f",
				"g",
				"h",
				"i",
				"j",
				"k",
				"l",
				"m",
				"n",
				"o",
				"p",
				"q",
				"r",
				"s",
				"t",
				"u",
				"v",
				"w",
				"x",
				"y",
				"z"
			>>
		end

	ages : ARRAY [INTEGER] is
			-- array of ages
		once
			Result := <<
				1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
				11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
				21, 22, 23, 24, 25, 26
			>>
		end

--| ffeature -- Measurement

--| ffeature -- Status report

--| ffeature -- Status setting

--| feature -- Cursor movement

feature -- Constants

	sql_create : STRING is "CREATE TABLE ROWSETSAMPLE (NAME VARCHAR(5), AGE INTEGER)"

	sql_insert : STRING is "INSERT INTO ROWSETSAMPLE VALUES (?name, ?age)"

	sql_update : STRING is "UPDATE ROWSETSAMPLE SET AGE = ?age WHERE NAME = ?name"

	sql_select : STRING is "SELECT NAME, AGE FROM ROWSETSAMPLE"

	sql_delete : STRING is "DELETE FROM ROWSETSAMPLE WHERE AGE = ?age"

	sql_drop : STRING is "DROP TABLE ROWSETSAMPLE"

	sql_count : STRING is "SELECT COUNT(*) AS ROW_COUNT FROM ROWSETSAMPLE"

--| feature -- Removal

--| feature -- Resizing

--| feature -- Transformation

--| feature -- Conversion

--| feature -- Duplication

--| feature -- Miscellaneous

feature -- Basic operations

	create_table is
			--
		do
			do_simple_sql (sql_create, True)
		end

	drop_table is
			--
		local
			tables_cursor: ECLI_TABLES_CURSOR
		do
			create tables_cursor.make (create {ECLI_NAMED_METADATA}.make (Void, Void, "ROWSETSAMPLE"), session)
			tables_cursor.start
			if not tables_cursor.after then
				do_simple_sql (sql_drop)

			end
		end

	do_insert is
		do
			print ("Trying bulk insert ... %N")
			print ("---------------------- %N")
			do_rowset_modify (sql_insert, names, ages)
			inserted_count := names.count - errors
		end

	test_insert is
		local
			i : INTEGER
		do
			create cursor.make (session, sql_count)
			cursor.start
			i := cursor.item_by_index (1).as_integer
			print ("Bulk insert : ")
			if i = inserted_count then
				print ("Passed")
				if inserted_count /= names.count then
					print (" whith ") print ((names.count - inserted_count).out) print (" errors")
				end
			else
				print ("Failed")
			end
			print ("%N")
			cursor.close
		end

	do_update is
		local
			update_array : ARRAY[INTEGER]
			index : INTEGER
		do
			print ("Trying bulk update...  %N")
			print ("---------------------- %N")
			-- create and setup update_array
			create  update_array.make (ages.lower, ages.upper)
			from
				index := ages.lower
			until
				index > ages.upper
			loop
				update_array.put (ages.item (index) + 2, index)
				index := index + 1
			end
			-- do update
			do_rowset_modify (sql_update, names, update_array)
		end

	test_update is
			-- test if bulk update was ok
		local
			ok : BOOLEAN
			index : INTEGER
		do
			-- sweep through updated values
			create cursor.make (session, sql_select)
			from
				cursor.start
				ok := True
			until
				not cursor.is_ok or else cursor.off or else not ok
			loop
				-- find index in names array, to find corresponding age
				index := index_of_array_string (names, cursor.item_by_index (1).as_string)
				if index > 0 then
					-- ok if retrieved value is ages.item (index) + 2
					ok := (cursor.item_by_index (2).as_integer = (ages.item (index) + 2) )
				end
				cursor.forth
			end
			cursor.close
			-- compare arrays
			print ("Bulk update : ")
			if ok then
				print ("Passed")
			else
				print ("Failed")
			end
			print ("%N")
		end

	index_of_array_string (a : ARRAY[STRING]; s : STRING) : INTEGER is
			-- index of `s' in `a'
		local
			index : INTEGER
		do
			from
				index := a.lower
			until
				index > a.upper or else a.item (index).is_equal (s)
			loop
				index := index + 1
			end
			if index <= a.upper then
				Result := index
			else
				Result := 0
			end
		end

--| feature -- Obsolete

--| feature -- Inapplicable

feature {NONE} -- Implementation

	session : ECLI_SESSION

	buffer_name : ECLI_ARRAYED_VARCHAR is
			--
		once
			create Result.make (30, row_count)
		end

	buffer_age : ECLI_ARRAYED_INTEGER is
			--
		once
			create Result.make (row_count)
		end


	do_simple_sql (a_sql : STRING; checked : BOOLEAN) is
		do
			create statement.make (session)
			statement.set_sql (a_sql)
			statement.execute
			if checked then
				check
					statement.is_ok
				end
			end
			statement.close
		end

	do_rowset_modify (a_sql : STRING; name_array : ARRAY[STRING]; age_array : ARRAY[INTEGER]) is
			--
		local
			index, j : INTEGER
		do
			errors := 0
			create  rowset_modifier.make (session, a_sql, row_count)
			-- put values in array
			from
				index := 1; j := 1
				rowset_modifier.put_parameter (buffer_age, "age")
				rowset_modifier.put_parameter (buffer_name, "name")
				rowset_modifier.bind_parameters
			until
				index > name_array.upper
			loop
				buffer_name.set_item_at (name_array @ index, j)
				buffer_age.set_item_at (age_array @ index, j)
				if j \\ 10 = 0 or index = name_array.upper then
					rowset_modifier.execute (j)
					handle_modifier_errors (rowset_modifier)
					if rowset_modifier.has_information_message or else rowset_modifier.is_error then
						print (rowset_modifier.diagnostic_message)
						print ("%N")
					end
				end
				index := index + 1
				j := j \\ 10 + 1
			end
			rowset_modifier.close
		end

	statement : ECLI_STATEMENT

	cursor : ECLI_ROW_CURSOR

	rowset_modifier : ECLI_ROWSET_MODIFIER

	row_count : INTEGER is 10;

	errors : INTEGER

	inserted_count : INTEGER
	updated_count : INTEGER

	handle_modifier_errors (r : ECLI_ROWSET_MODIFIER) is
			-- handle errors on 'r' after execution
			-- examine each status:
		local
			index : INTEGER
			const : ECLI_ROW_STATUS_CONSTANTS
			status : INTEGER
			stmt : ECLI_STATEMENT
			p_age : ECLI_INTEGER
			p_name : ECLI_VARCHAR

		do
			create const
			-- Error handling with bulk operations is not straigthforward.
			-- First, locate offending parameter set
			-- Then retry query with non-arrayed parameters and get the error information
			from
				index := 1
				create p_age.make
				create p_name.make (30)
			until
				index > r.row_count
			loop
				status := r.item_status (index)
				if status = const.Sql_row_error then
					-- Retry query with a single-value statement and get error message
					p_age.set_item (buffer_age.item_at (index))
					p_name.set_item (buffer_name.item_at (index))
					create stmt.make (session)
					stmt.set_sql (r.sql)
					stmt.put_parameter (p_age, "age")
					stmt.put_parameter (p_name, "name")
					stmt.bind_parameters
					stmt.execute
					check
						not stmt.is_ok
					end
					print ("Error : ")
					print (stmt.diagnostic_message);
					print ("SQL : "); print (stmt.sql); print ("%N")
					print ("Parameters:%N")
					print ("%Tage : "); print (p_age.out); print ("%N")
					print ("%Tname: '"); print (p_name.out); print ("'%N")
					stmt.close
					errors := errors + 1
				end

				index := index + 1
			end
		end

end -- class ROWSET_MODIFIER_TEST
