indexing

	description:

		"Cursors on metadata for tables, matching some criteria. %
		%Search criterias are (1) catalog name, (2) schema name, (3) table name.%
		%A Void criteria is considered as a wildcard."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TABLES_CURSOR

inherit

	ECLI_METADATA_CURSOR
		rename
			queried_name as queried_table
		redefine
			item, impl_item, default_create
		end

create

	make

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create_object_buffers
		end

feature -- Access

	item : ECLI_TABLE is
			-- item at current cursor position
		do
			check attached impl_item as i then
				Result := i
			end
		end

feature -- Cursor Movement

	create_item is
			-- create current item from buffer values
		do
			if not off then
				create impl_item.make (Current)
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
			set_results (<<
					buffer_catalog_name,
					buffer_schema_name,
					buffer_table_name,
					buffer_table_type,
					buffer_description
				>>)
		end

	create_object_buffers
		do
			create buffer_catalog_name.make (255)
			create buffer_schema_name.make (255)
			create buffer_table_name.make (255)
			create buffer_table_type.make (255)
			create buffer_description.make (255)

		end

	impl_item : detachable like item

	definition : STRING is once Result := "SQLTables" end

	do_query_metadata (a_catalog: POINTER; a_catalog_length: INTEGER; a_schema: POINTER; a_schema_length: INTEGER; a_name: POINTER; a_name_length: INTEGER) : INTEGER is
		do
			Result := ecli_c_get_tables (handle, a_catalog, a_catalog_length, a_schema, a_schema_length, a_name, a_name_length, default_pointer, 0)
		end

	query_metadata_feature_name : STRING is do Result := "ecli_c_get_tables" end

end
