indexing
	description: "Objects that give access to metadata objects of a datasource"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_REPOSITORY

--inherit
--	ECLI_TYPE_CODES
--		export {NONE} all
--		end
		
creation
	make
	
feature {NONE} -- Initialization

	make (a_session : ECLI_SESSION) is
			-- create for `session'
		require
			session_not_void: a_session /= Void
			session_connected: a_session.is_connected
		do
			session := a_session
			is_ok := True
		ensure
			session_set: session = a_session
		end

feature -- Access
		
	session : ECLI_SESSION
			-- session on which Current gives metadata information

	tables : ARRAY [ECLI_TABLE] is
			-- tables defined in curret session repository
			-- they are cached, unless reset has been called
		local
			cursor : ECLI_TABLES_CURSOR
			item : ECLI_TABLE
		do
			if tables_ = Void then
				!!cursor.make_all_tables (session)
				!!tables_.make (1, 0)
				if cursor.is_ok then
					from
						cursor.start
					until
						cursor.off
					loop
						!!item.make (cursor, Current)
						tables_.force (item, tables_.count+1)
						cursor.forth
					end
				else
					diagnostic_message := clone (cursor.diagnostic_message)
				end
				cursor.close
				is_ok := cursor.is_ok
				end
			Result := tables_
		end
		
	procedures : ARRAY [ECLI_PROCEDURE] is
			-- procedures defined in curret session repository
			-- they are cached, unless reset has been called
		local
			cursor : ECLI_PROCEDURES_CURSOR
		do
			if procedures_ = Void then
				!!cursor.make_all_procedures (session)
				!!procedures_.make (1, 0)
				if cursor.is_ok then
					from
						cursor.start
					until
						cursor.off
					loop
						procedures_.force (cursor.item, procedures_.count+1)
						cursor.forth
					end
				else
					diagnostic_message := clone (cursor.diagnostic_message)
				end
				is_ok := cursor.is_ok
				cursor.close
			end
			Result := procedures_
		end

	types : DS_HASH_TABLE[ECLI_SQL_TYPE, INTEGER] is
			-- types supported by current session repository
			-- they are cached, unless reset has been called
		local
			cursor : ECLI_SQL_TYPES_CURSOR
		do
			if types_ = Void then
				!!types_.make (10)
				!!cursor.open_all_types (session)
				-- get all types information, included unsupported ones
				fill_from_types_cursor (cursor)
				cursor.close				
				is_ok := cursor.is_ok
			end	
			Result := types_
		end
		
	found_table : ECLI_TABLE
	
feature -- Measurement

feature -- Status report
	
	is_table_found : BOOLEAN
	
	is_ok : BOOLEAN
	
	diagnostic_message : STRING
	
feature -- Status setting

feature -- Cursor movement
		
feature -- Element change

	reset is
			-- force reading information from server
		do
			tables_ := Void
			procedures_ := Void
			types_ := Void
			
		end
		
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	find_table (table_name : STRING) is
			-- find table with `table_name'
		local
			index : INTEGER
		do
			from 
				index := tables.lower
				is_table_found := False
				found_table := Void
			until
				index > tables.upper or else is_table_found
			loop
				if tables.item (index).name.is_equal (table_name) then
					is_table_found := True
				else
					index := index + 1
				end
			end
			if is_table_found then
				found_table := tables.item (index)
			end
		ensure
			table_found: is_table_found implies found_table /= Void and then found_table.name.is_equal (table_name)
			table_not_found: (not is_table_found) implies found_table = Void
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	tables_ : ARRAY [ECLI_TABLE]
	procedures_ : ARRAY [ECLI_PROCEDURE]
	types_ : DS_HASH_TABLE [ECLI_SQL_TYPE, INTEGER]
		
	fill_from_types_cursor (cursor : ECLI_SQL_TYPES_CURSOR) is
		do
			if cursor.is_ok then
				from 
					cursor.start
				until
					cursor.off
				loop
					types_.force (cursor.item, cursor.item.sql_type_code)
					cursor.forth
				end
			else
				diagnostic_message := clone (cursor.diagnostic_message)
			end
		end
		
--	supported_types : ARRAY[INTEGER] is 
--		once
--			Result := << 	
--				sql_char,
--				sql_numeric,
--				sql_decimal,
--				sql_integer,
--				sql_smallint,
--				sql_float,
--				sql_real,
--				sql_double,
--				sql_varchar,
--				sql_type_date,
--				sql_type_time,
--				sql_type_timestamp,
--				sql_longvarchar	
--		>>
--		end

invariant
	session_exists: session /= Void and then session.is_connected

end -- class ECLI_REPOSITORY
