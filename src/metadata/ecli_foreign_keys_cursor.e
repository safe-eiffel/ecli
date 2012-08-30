note

	description:

		"Cursors on foreign keys of tables. %
		%Search criterias are (1) catalog name, (2) schema name, (3) table name.%
		%A Void criteria is considered as a wildcard."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_FOREIGN_KEYS_CURSOR

inherit

	ECLI_PRIMARY_KEY_CURSOR
		redefine
			item, make, forth, do_query_metadata, definition,
			set_buffer_into_cursor, create_buffers, create_item
		end

create

	make

feature {NONE} -- Initialization

	make (a_name: ECLI_NAMED_METADATA; a_session: ECLI_SESSION)
			-- create cursor for foreign keys in table identified by `a_name'
		do
			Precursor (a_name, a_session)
		end

feature -- Access

	item : ECLI_FOREIGN_KEY
			-- current type description
		do
			Result := impl_item
		end

	next_item : like item

feature -- Cursor Movement

	forth
			-- advance cursor to next item if any
		do
			if impl_item = Void or else creating_item or else next_item /= Void then
				if creating_item then
					fetch_next_row
				elseif next_item /= Void then
					impl_item := next_item
					next_item := Void
					fill_item
				end
			else
				cursor_status := Cursor_after
			end
		end

	create_item
			-- create item at current cursor position
		do
			if next_item /= Void then
				impl_item := next_item
				next_item := Void
				fill_item
			elseif impl_item = Void then
				create impl_item.make (Current)
				fill_item
			else
				impl_item := Void
			end
		end

feature {ECLI_FOREIGN_KEY} -- Access

	buffer_pk_table_cat : ECLI_VARCHAR
	buffer_pk_table_schem  : ECLI_VARCHAR
	buffer_pk_table_name  : ECLI_VARCHAR
	buffer_pk_column_name : ECLI_VARCHAR
	buffer_update_rule : ECLI_INTEGER
	buffer_delete_rule : ECLI_INTEGER
	buffer_fk_name : ECLI_VARCHAR
	buffer_deferrability : ECLI_INTEGER

feature {NONE} -- Implementation

	fill_item
			-- fill item with buffer values
		local
			done : BOOLEAN
		do
			from
				creating_item := True
				last_key_seq := buffer_key_seq.as_integer
			until
				off or else done
			loop
				forth
				if not off and then buffer_key_seq.as_integer > last_key_seq then
					impl_item.add_column (buffer_column_name.as_string, buffer_pk_column_name.as_string)
				else
					done := True
				end
				last_key_seq := buffer_key_seq.as_integer
			end
			if not off then
				-- prepare next key
				create next_item.make (Current)
			end
			creating_item := False
			Cursor_status := cursor_in
			fetched_columns_count := results.count
		end

	last_key_seq : INTEGER

	create_buffers
			-- create buffers for cursor
		do
			create buffer_pk_table_cat.make (255)
			create buffer_pk_table_schem.make (255)
			create buffer_pk_table_name.make (255)
			create buffer_pk_column_name.make (255)
			create buffer_update_rule.make
			create buffer_delete_rule.make
			create buffer_pk_name.make (255)
			create buffer_fk_name.make (255)
			create buffer_deferrability.make
			Precursor
		end

	set_buffer_into_cursor
			-- set results cursor with buffer array
		do
			set_results (<<
					buffer_pk_table_cat ,
					buffer_pk_table_schem  ,
					buffer_pk_table_name  ,
					buffer_pk_column_name ,
					buffer_table_cat ,
					buffer_table_schem  ,
					buffer_table_name  ,
					buffer_column_name ,
					buffer_key_seq ,
					buffer_update_rule ,
					buffer_delete_rule ,
					buffer_pk_name ,
					buffer_fk_name ,
					buffer_deferrability
				>>)
		end

	definition : STRING once Result := "SQLForeignKeys" end

	do_query_metadata (a_catalog: POINTER; a_catalog_length: INTEGER; a_schema: POINTER; a_schema_length: INTEGER; a_name: POINTER; a_name_length: INTEGER) : INTEGER
			-- actual external query
		do
			Result := ecli_c_get_foreign_keys ( handle,
				default_pointer, 0,
				default_pointer, 0,
				default_pointer, 0,
				a_catalog, a_catalog_length,
				a_schema, a_schema_length,
				a_name, a_name_length)
		end

end
