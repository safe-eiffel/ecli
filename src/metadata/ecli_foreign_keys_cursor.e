indexing
	description:

		"Objects that search the database repository for primary key columns of a table. %
		%Search criterias are (1) catalog name, (2) schema name, (3) table name.%
		%A Void criteria is considered as a wildcard."

	author: "Paul G. Crismer"
	
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_FOREIGN_KEYS_CURSOR

inherit
	ECLI_PRIMARY_KEY_CURSOR
		redefine
			item, make, forth, do_query_metadata, definition,
			set_buffer_into_cursor, create_buffers, create_item
		end

creation
	make

feature {NONE} -- Initialization

	make (a_name: ECLI_NAMED_METADATA; a_session: ECLI_SESSION) is
			-- create cursor for foreign keys in table identified by `a_name'
		do
			Precursor (a_name, a_session)
		end

feature -- Access

	item : ECLI_FOREIGN_KEY is
			-- current type description
		do
			Result := impl_item
		end

	next_item : like item

feature -- Cursor Movement

	forth is
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

	create_item is
			-- create item at current cursor position
		do
			if next_item /= Void then
				impl_item := next_item
				next_item := Void
				fill_item
			elseif impl_item = Void then
				!!impl_item.make (Current)
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

	fill_item is
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
				!!next_item.make (Current)
			end
			creating_item := False
			Cursor_status := cursor_in
			fetched_columns_count := cursor.count
		end

	last_key_seq : INTEGER

	create_buffers is
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

	set_buffer_into_cursor is
			-- set cursor with buffer array
		do
			set_cursor (<<
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


	definition : STRING is once Result := "SQLForeignKeys" end

	do_query_metadata (a_catalog: POINTER; a_catalog_length: INTEGER; a_schema: POINTER; a_schema_length: INTEGER; a_name: POINTER; a_name_length: INTEGER) : INTEGER is
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

end -- class ECLI_FOREIGN_KEYS_CURSOR
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
