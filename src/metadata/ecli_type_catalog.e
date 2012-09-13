indexing

	description:

		"Catalogs of types supported by a particular database."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_TYPE_CATALOG

inherit
	ANY
		redefine
			default_create
		end

	ECLI_TYPE_CONSTANTS
		undefine
			default_create
		end

create

	make

feature {NONE} -- Initialization

	default_create
		do

		end

	make (a_session : ECLI_SESSION) is
			-- Create for a database accessed through `a_session'.
		require
			a_session_not_void: a_session /= Void --FIXME: VS-DEL
			a_session_connected: a_session.is_connected
		local
			cursor : ECLI_SQL_TYPES_CURSOR
		do
			default_create
			create types.make (10)
			session := a_session
			create_dummy_statement
			create cursor.make_all_types (a_session)
			from
				cursor.start
			until
				cursor.off
			loop
				add_type (cursor.item)
				cursor.forth
			end
			cursor.close
		end

feature -- Access

	session : ECLI_SESSION
			-- Session.

	types_for_id (id : INTEGER) : DS_LIST[ECLI_SQL_TYPE] is
			-- Types whose identifier is `id'.
		require
			known_id: has_type_id (id)
		do
			Result := types.item (id)
		ensure
			type_for_id_not_void: Result /= Void --FIXME: VS-DEL
		end

	numeric_types : DS_LIST[ECLI_SQL_TYPE] is
			-- Types that appear to be numeric
		do
			if attached numerics_table as n then
				Result := n
			else
				create {DS_LINKED_LIST[ECLI_SQL_TYPE]}Result.make
				if attached types.new_cursor as ht_cursor then
					from
						ht_cursor.start
					until
						ht_cursor.off
					loop
						if attached ht_cursor.item.new_cursor as l_cursor then
							from
								l_cursor.start
							until
								l_cursor.off
							loop
								if l_cursor.item.is_unsigned_applicable
									and then l_cursor.item.is_auto_unique_value_applicable
									and then not l_cursor.item.is_auto_unique_value then
										Result.put_last (l_cursor.item)
								end
								l_cursor.forth
							end
						end
						ht_cursor.forth
					end
				end
				numerics_table := Result
			end
		ensure
			result_not_void: Result /= Void --FIXME: VS-DEL
		end

feature -- Measurement

feature -- Status report


	can_bind (a_value : ECLI_VALUE) : BOOLEAN
			-- Is `a_value' bindable ?
			-- WARNING: not trustable with some drivers (like Oracle 10g)
		require
			a_value_not_void: a_value /= Void --FIXME: VS-DEL
			session_connected: session.is_connected
		do
			dummy_statement.put_parameter (a_value, "parameter")
			dummy_statement.bind_parameters
			Result := dummy_statement.is_ok
		end

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

	has_big_integer : BOOLEAN is
		do
			Result := has_type_id (sql_bigint)
		end

feature {NONE} -- Implementation

	dummy_statement: ECLI_STATEMENT

	types : DS_HASH_TABLE[DS_LIST[ECLI_SQL_TYPE],INTEGER]

	add_type (type : ECLI_SQL_TYPE) is
			-- Add `type' to Current catalog.
		require
			type_not_void: type /= Void --FIXME: VS-DEL
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

	numerics_table : detachable like numeric_types


	create_dummy_statement is
		do
			create dummy_statement.make (session)
			dummy_statement.set_sql (dummy_statement_sql)
		end

	dummy_statement_sql : STRING is "select * from dummy_table where 1=?parameter"

invariant

	types_not_void: types /= Void --FIXME: VS-DEL
	session_not_void: session /= Void --FIXME: VS-DEL

end -- class ECLI_TYPE_CATALOG
