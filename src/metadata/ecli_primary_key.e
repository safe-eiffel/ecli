indexing

	description:
	
			"Primary keys of a table."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_PRIMARY_KEY

inherit

	ECLI_NAMED_METADATA
		rename
			make as make_metadata,
			name as table
		export {NONE} make_metadata
		undefine
			out
		end
	
creation

	make 

creation

	{ECLI_FOREIGN_KEY} make_by_name
	
feature {NONE} -- Initialization

	make (cursor : ECLI_PRIMARY_KEY_CURSOR) is
			-- create from `cursor' current position
		require
			cursor_not_void: cursor /= Void
			cursor_not_off: not cursor.off
		do
			set_catalog (cursor.buffer_table_cat)
			set_schema (cursor.buffer_table_schem )
			set_name (cursor.buffer_table_name)
			if not cursor.buffer_pk_name.is_null then
				key_name := cursor.buffer_pk_name.as_string
			end
			create {DS_LINKED_LIST[STRING]} columns.make
			columns.put_last (cursor.buffer_column_name.as_string)
		end

	make_by_name (a_catalog_name, a_schema_name, a_table_name, a_key_name, a_column_name : STRING) is
			-- create for `a_catalog_name', `a_schema_name', `a_table_name', `a_key_name', `a_column_name'
		require
			a_table_name_not_void: a_table_name /= Void
			a_column_name_not_void: a_column_name /= Void
		do
			catalog := a_catalog_name
			schema := a_schema_name
			table := a_table_name
			key_name := a_key_name
			create {DS_LINKED_LIST[STRING]}columns.make
			columns.put_last (a_column_name)
		ensure
			catalog_set: catalog = a_catalog_name
			schema_set: schema = a_schema_name
			table_set: table = a_table_name
			key_name_set: key_name = a_key_name
			columns_has_name: columns.has (a_column_name) and then columns.count = 1
		end
		
feature -- Access

	key_name : STRING
		-- name of the key if it is applicable
	
	columns : DS_LIST[STRING]
		-- list of column names
	
feature {ECLI_PRIMARY_KEY_CURSOR, ECLI_PRIMARY_KEY}-- Measurement
	
	add_column (a_column_name : STRING) is
			-- add `a_column_name' in columns
		require
			a_column_name_not_void: a_column_name /= Void
		do
			columns.put_last (a_column_name)
		ensure
			column_added: columns.has (a_column_name) and then columns.count = old columns.count + 1
		end

feature -- Conversion

	out : STRING is
			-- terse printable representation
		do
			!!Result.make (0)
		end

invariant
	table_name_not_void: table /= Void
	columns_not_void: columns /= Void and then not columns.has (Void)

end
