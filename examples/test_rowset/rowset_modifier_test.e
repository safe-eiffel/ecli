indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROWSET_MODIFIER_TEST

creation
	make
	
feature {NONE} -- Initialization

	make (a_session : ECLI_SESSION) is
			-- 
		do
			session := a_session
			create_table
			do_insert
			test_insert
--			do_update
--			test_update
--			drop_table
		end
		
feature -- Access
	names : ARRAY [STRING] is
			-- 
		once
			Result := <<
				"a",
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
			-- 
		once
			Result := <<
				1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
				11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
				21, 22, 23, 24, 25, 26
			>>
		end
		
feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	sql_create : STRING is "CREATE TABLE ROWSETSAMPLE (NAME VARCHAR(30), AGE INTEGER)"
	
	sql_insert : STRING is "INSERT INTO ROWSETSAMPLE VALUES (?name, ?age)"
	
	sql_update : STRING is "UPDATE ROWSETSAMPLE SET AGE = ?age WHERE NAME = ?name"
	
	sql_select : STRING is "SELECT NAME, AGE FROM ROWSETSAMPLE"
	
	sql_delete : STRING is "DELETE FROM ROWSETSAMPLE WHERE AGE = ?age"
	
	sql_drop : STRING is "DROP TABLE ROWSETSAMPLE"
	
	sql_count : STRING is "SELECT COUNT(*) AS ROW_COUNT FROM ROWSETSAMPLE"
	
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	create_table is
			-- 
		do
			do_simple_sql (sql_create)
		end
	
	drop_table is
			-- 
		do
			do_simple_sql (sql_drop)
		end

	do_insert is 
		do  
			do_rowset_sql (sql_insert, names, ages)
		end
		
	test_insert is 
		do  
			do_simple_sql (sql_count)	
		end
		
	do_update is do  end
	test_update is do  end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	
	session : ECLI_SESSION
	
	buffer_name : ECLI_ARRAYED_VARCHAR is
			-- 
		once
			!!Result.make (30, row_count)
		end
		
	buffer_age : ECLI_ARRAYED_INTEGER is
			-- 
		once
			!!Result.make (row_count)
		end
		
		
	do_simple_sql (a_sql : STRING) is
		do
			!!statement.make (session)
			statement.set_sql (a_sql)
			statement.execute
			check
				statement.is_ok
			end
			statement.close
		end
	
	do_rowset_sql (a_sql : STRING; name_array : ARRAY[STRING]; age_array : ARRAY[INTEGER]) is
			-- 
		local
			index, j : INTEGER
		do
			!! rowset_modifier.make (session, a_sql, row_count)
			-- put values in array
			from
				index := 1; j := 1
				rowset_modifier.put_parameter (buffer_age, "age")
				rowset_modifier.put_parameter (buffer_name, "name")
			until
				index > name_array.upper
			loop
				buffer_name.set_item_at (name_array @ index, j)
				buffer_age.set_item_at (age_array @ index, j)
				if j \\ 10 = 0 or index = name_array.upper then
					rowset_modifier.bind_parameters (j)
					rowset_modifier.execute
				end
				index := index + 1
				j := j \\ 10 + 1
			end
			rowset_modifier.close
		end

	statement : ECLI_STATEMENT
	
	rowset_modifier : ECLI_ROWSET_MODIFIER
	
	row_count : INTEGER is 10;
	
invariant
	invariant_clause: True -- Your invariant here

end -- class ROWSET_MODIFIER_TEST
