indexing

	description: 
	
		"Catalogs of types supported by a particular database."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_TYPE_CATALOG

inherit
	ANY
	
	ECLI_TYPE_CONSTANTS
		export 
			{NONE} all
		end
		
creation
	
	make
	
feature {NONE} -- Initialization

	make (a_session : ECLI_SESSION) isµ
			-- Create for a database accessed through `a_session'.
		require
			a_session_not_void: a_session /= Void
			a_session_connected: a_session.is_connected
		local
			cursor : ECLI_SQL_TYPES_CURSOR
		do
			create types.make (10)		
			create cursor.make_all_types (a_session)
			from 
				cursor.start
			until
				cursor.off
			loop
				add_type (cursor.item)
				cursor.forth
			end
		end
		
feature -- Access

	types_for_id (id : INTEGER) : DS_LIST[ECLI_SQL_TYPE] is
			-- Types whose identifier is `id'.
		require
			known_id: has_type_id (id)
		do
			Result := types.item (id)
		ensure
			type_for_id_not_void: Result /= Void
		end
	
	numeric_types : DS_LIST[ECLI_SQL_TYPE] is
			-- Types that appear to be numeric
		local
			ht_cursor : DS_HASH_TABLE_CURSOR[DS_LIST[ECLI_SQL_TYPE], INTEGER]
			l_cursor : DS_LIST_CURSOR[ECLI_SQL_TYPE]
		do
			from
				ht_cursor := types.new_cursor
				ht_cursor.start
				create {DS_LINKED_LIST[ECLI_SQL_TYPE]}Result.make
			until
				ht_cursor.off
			loop
				from
					l_cursor := ht_cursor.item.new_cursor
					l_cursor.start
				until
					l_cursor.off
				loop
					if l_cursor.item.is_unsigned_applicable then
						Result.put_last (l_cursor.item)
					end
					l_cursor.forth
				end
				ht_cursor.forth
			end
		ensure
			result_not_void: Result /= Void
		end
		
feature -- Measurement

feature -- Status report

	has_type_id (id : INTEGER) : BOOLEAN is
			-- Does type identifier `id' exist in the catalog?
		do
			Result := types.has (id)
		end
		
	has_binary : BOOLEAN is
		do
			Result := types.has (Sql_binary)
		end

	has_char : BOOLEAN is
		do
			Result := types.has (Sql_char)
		end
		
	has_date : BOOLEAN is
		do
			Result := types.has (Sql_type_date)
		end
	
	has_date_time : BOOLEAN is
		do
			Result := types.has (Sql_type_timestamp)
		end
		
	has_double : BOOLEAN is
		do
			Result := types.has (Sql_double)
		end
		
	has_float : BOOLEAN is
		do
			Result := types.has (Sql_float)
		end
		
	has_integer : BOOLEAN is
		do
			Result := types.has (Sql_integer)
		end
		
	has_longvarbinary : BOOLEAN is
		do
			Result := types.has (Sql_longvarbinary)
		end
		
	has_longvarchar : BOOLEAN is
		do
			Result := types.has (Sql_longvarchar)
		end
		
	has_real : BOOLEAN is
		do
			Result := types.has (Sql_real)
		end
		
	has_time : BOOLEAN is
		do
			Result := types.has (Sql_type_time)
		end
		
	has_timestamp : BOOLEAN is
		do
			Result := types.has (Sql_type_timestamp)
		end
		
	has_varbinary : BOOLEAN is
		do
			Result := types.has (Sql_varbinary)
		end
		
	has_varchar : BOOLEAN is
		do
			Result := types.has (Sql_varchar)
		end
		
	has_numeric : BOOLEAN is
		do
			Result := has_type_id (Sql_numeric)
		end
		
	has_decimal : BOOLEAN is
		do
			Result := has_type_id (Sql_decimal)
		end
		
feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	types : DS_HASH_TABLE[DS_LIST[ECLI_SQL_TYPE],INTEGER]
	
	add_type (type : ECLI_SQL_TYPE) is
			-- Add `type' to Current catalog.
		require
			type_not_void: type /= Void
		local
			list : DS_LIST[ECLI_SQL_TYPE]
		do
			types.search (type.sql_type_code)
			if not types.found then
				create {DS_LINKED_LIST[ECLI_SQL_TYPE]}list.make
				types.force (list, type.sql_type_code)
			else
				list := types.found_item
			end
			list.put_last (type)
		ensure
			has_type_code: types.has (type.sql_type_code)
			has_type: types.item (type.sql_type_code).has (type)
		end
		
invariant
	
	types_not_void: types /= Void

end -- class ECLI_TYPE_CATALOG
