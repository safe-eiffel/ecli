indexing
	description: "Foreign keys of a table, referring to a primary key of other table.%
		% The table identified by [catalog, schema, table] is the referring table.%
		% The foreign key of the referring table is composed of `columns' and is identified by `key_name'.%
		% The referenced table primary key is `referenced key'."
		
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_FOREIGN_KEY

inherit
	ECLI_PRIMARY_KEY
		rename
			make as make_pk, add_column as add_pk_column
		export {NONE} make_pk, add_pk_column
		redefine
			out
		end
	
	ECLI_FOREIGN_KEY_CONSTANTS
		undefine
			out
		end
		
creation
	make
	
feature {NONE} -- Initialization

	make (cursor : ECLI_FOREIGN_KEYS_CURSOR) is
			-- create from `cursor' current position
		require
			cursor_exists: cursor /= Void
			cursor_not_off: not cursor.off
		local
			pk_catalog, pk_schema, pk_table, primary_key_name : STRING
		do
			set_catalog (cursor.buffer_table_cat)
			set_schema (cursor.buffer_table_schem )
			set_name (cursor.buffer_table_name)

			if not cursor.buffer_pk_table_cat.is_null then
				pk_catalog := cursor.buffer_pk_table_cat.to_string
			end
			if not cursor.buffer_pk_table_schem.is_null then
				pk_schema := cursor.buffer_pk_table_schem.to_string
			end
			if not cursor.buffer_pk_table_name.is_null then
				pk_table := cursor.buffer_pk_table_name.to_string
			end
			if not cursor.buffer_pk_name.is_null then
				primary_key_name := cursor.buffer_pk_name.to_string
			end
			if not cursor.buffer_fk_name.is_null then
				key_name := cursor.buffer_fk_name.to_string
			end
			create {DS_LINKED_LIST[STRING]} columns.make
			columns.put_last (cursor.buffer_column_name.to_string)
			create referenced_key.make_by_name (pk_catalog, pk_schema, pk_table, primary_key_name,cursor.buffer_pk_column_name.to_string)
		end
		
feature -- Access

	referenced_key : ECLI_PRIMARY_KEY
		-- key of referenced table

	update_rule : INTEGER is
			-- update rule
		require
			update_rule_applicable: is_update_rule_applicable
		do
			Result := update_rule_impl 
		end
		
	delete_rule : INTEGER is
			-- Action to be applied to the foreign key when the SQL operation is DELETE
		require
			delete_rule_applicable: is_delete_rule_applicable
		do
			Result := delete_rule_impl
		end
		
	deferrability : INTEGER is
			--  deferrability of 
		require
			deferrability_applicable: is_deferrability_applicable
		do
			Result := deferrability_impl 
		end
	
feature -- Status report

	is_update_rule_applicable : BOOLEAN
	is_delete_rule_applicable : BOOLEAN
	is_deferrability_applicable : BOOLEAN

feature -- Measurement
	
	add_column (a_column_name : STRING; a_pk_column_name : STRING) is
			-- add `a_column_name' in columns with corresponding `a_pk_column_name' into `primary_key_c'
		require
			a_column_name_not_void: a_column_name /= Void
			a_pk_column_name_not_void: a_pk_column_name /= Void
		do
			columns.put_last (a_column_name)
			referenced_key.add_column (a_pk_column_name)
		end
		
feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out : STRING is
		do
			!!Result.make (0)
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	update_rule_impl : INTEGER
	delete_rule_impl : INTEGER
	deferrability_impl : INTEGER

invariant
	referenced_key_not_void: referenced_key /= Void
	columns_count_equal: columns.count = referenced_key.columns.count
	update_rule_value: is_update_rule_applicable implies (update_rule = Sql_cascade or else update_rule = Sql_set_null or else update_rule = Sql_set_default or else update_rule = Sql_no_action)
	delete_rule_value: is_delete_rule_applicable implies (delete_rule = Sql_cascade or else delete_rule = Sql_set_null or else delete_rule = Sql_set_default or else delete_rule = Sql_no_action)
	deferrability_value: is_deferrability_applicable implies (deferrability = Sql_initially_deferred or else deferrability = Sql_initially_immediate or else deferrability = Sql_not_deferrable)

end -- class ECLI_FOREIGN_KEY
