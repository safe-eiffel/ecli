indexing
	description:

		"Cursors on metadata for tables, matching some criteria. %
		%Search criterias are (1) catalog name, (2) schema name, (3) table name.%
		%A Void criteria is considered as a wildcard."

	author: "Paul G. Crismer"
	
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_TABLES_CURSOR

inherit

	ECLI_METADATA_CURSOR
		rename
			queried_name as queried_table
		redefine
			item, impl_item
		end

creation
	make_all_tables, make_table, make

feature {NONE} -- Initialization

	make_all_tables (a_session : ECLI_SESSION) is
			-- make cursor for all types of session
		obsolete
			"Use feature `make' "
		require
			session_opened: a_session /= Void and then a_session.is_connected
		local
			search_criteria: ECLI_NAMED_METADATA
		do
			!!search_criteria.make (Void, Void, Void)
			make (search_criteria, a_session)
		ensure
			executed: is_ok implies is_executed
		end

	make_table (a_table_name : STRING; a_session : ECLI_SESSION) is
			-- make for `a_table_name'
		obsolete
			" Use feature `make'"
		require
			a_table_name_not_void: a_table_name /= Void
			a_sessin_not_void: a_session /= Void
			a_session_connected: a_session.is_connected
		local
			search_criteria: ECLI_NAMED_METADATA
		do
			!!search_criteria.make (Void, Void, a_table_name)
			make (search_criteria, a_session)
		end


feature -- Access

	item : ECLI_TABLE is
			-- item at current cursor position
		do
			Result := impl_item
		end

feature -- Cursor Movement

	create_item is
			-- create current item from buffer values
		do
			if not off then
				!!impl_item.make (Current)
			end
		end

feature {ECLI_TABLE} -- Access

	buffer_catalog_name : ECLI_VARCHAR
	buffer_schema_name : ECLI_VARCHAR
	buffer_table_name : ECLI_VARCHAR
	buffer_table_type : ECLI_VARCHAR
	buffer_description : ECLI_VARCHAR

feature {NONE} -- Implementation

	create_buffers is
				-- create buffers for cursor
		do
			create buffer_catalog_name.make (255)
			create buffer_schema_name.make (255)
			create buffer_table_name.make (255)
			create buffer_table_type.make (255)
			create buffer_description.make (255)

			set_results (<<
					buffer_catalog_name,
					buffer_schema_name,
					buffer_table_name,
					buffer_table_type,
					buffer_description
				>>)
		end

	impl_item : like item

	definition : STRING is once Result := "SQLTables" end

	do_query_metadata (a_catalog: POINTER; a_catalog_length: INTEGER; a_schema: POINTER; a_schema_length: INTEGER; a_name: POINTER; a_name_length: INTEGER) : INTEGER is
		do
			Result := ecli_c_get_tables (handle, a_catalog, a_catalog_length, a_schema, a_schema_length, a_name, a_name_length, default_pointer, 0)
		end

end -- class ECLI_TABLES_CURSOR
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
