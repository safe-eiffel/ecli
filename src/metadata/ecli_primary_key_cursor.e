note

	description:

		"Cursors on primary keys of tables. %
		%Search criterias are (1) catalog name, (2) schema name, (3) table name.%
		%A Void criteria is considered as a wildcard."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_PRIMARY_KEY_CURSOR

inherit

	ECLI_METADATA_CURSOR
		rename
			queried_name as queried_table
		redefine
			item, make, forth
		end

create

	make

feature {NONE} -- Initialization

	make (a_name: ECLI_NAMED_METADATA; a_session: ECLI_SESSION)
			-- create cursor for primary keys on `a_name' (catalog, schema, table)
		do
			Precursor (a_name, a_session)
		end

feature -- Access

	item : ECLI_PRIMARY_KEY
			-- item at current cursor position
		do
			Result := impl_item
		end

feature -- Cursor Movement

	forth
			-- advance cursor to next item if any
		do
			if impl_item = Void or else creating_item then
				if creating_item then
					fetch_next_row
				end
			else
				cursor_status := Cursor_after
			end
		end

	create_item
			-- create item at current cursor position
		do
			if impl_item = Void then
					create impl_item.make (Current)
					from
						creating_item := True
					until
						off
					loop
						forth
						if not off then
							impl_item.add_column (buffer_column_name.as_string)
						end
					end
					creating_item := False
					Cursor_status := cursor_in
					fetched_columns_count := results.count
			else
				impl_item := Void
			end
		end

feature {ECLI_PRIMARY_KEY} -- Access

		buffer_table_cat : ECLI_VARCHAR
		buffer_table_schem  : ECLI_VARCHAR
		buffer_table_name  : ECLI_VARCHAR
		buffer_column_name : ECLI_VARCHAR
		buffer_key_seq : ECLI_INTEGER
		buffer_pk_name : ECLI_VARCHAR

feature -- Basic operations

feature {NONE} -- Implementation

	create_buffers
			-- create buffers for cursor
		do
			create buffer_table_cat.make (255)
			create buffer_table_schem.make (255)
			create buffer_table_name.make (255)
			create buffer_column_name.make (255)
			create buffer_key_seq.make
			create buffer_pk_name.make (255)
			set_buffer_into_cursor
		end

	set_buffer_into_cursor
			-- set results cursor with buffer values
		do
			set_results (<<
				buffer_table_cat,
				buffer_table_schem,
				buffer_table_name,
				buffer_column_name,
				buffer_key_seq,
				buffer_pk_name
				>>)
		ensure
			results_not_void: results /= Void
		end

	definition : STRING once Result := "SQLPrimaryKeys" end

	do_query_metadata (a_catalog: POINTER; a_catalog_length: INTEGER; a_schema: POINTER; a_schema_length: INTEGER; a_name: POINTER; a_name_length: INTEGER) : INTEGER
			-- actual external query
		do
			Result := ecli_c_get_primary_keys ( handle,
				a_catalog, a_catalog_length,
				a_schema, a_schema_length,
				a_name, a_name_length)
		end

	creating_item : BOOLEAN

	query_metadata_feature_name : STRING do Result := "ecli_c_get_primary_keys" end

end
