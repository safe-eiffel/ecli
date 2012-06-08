indexing

	description:

		"Cursors over columns of tables. Columns match search criterias :%
		%(1) catalog name, (2) schema name, (3) table name.%
		%A Void criteria is considered as a wildcard."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_COLUMNS_CURSOR

inherit

	ECLI_METADATA_CURSOR
		rename
			queried_name as queried_table
		redefine
			item, impl_item, make, default_create
		end

create

	make, make_query_column -- , make_all_columns

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create_buffer_values
		end

	make_query_column (a_search_criteria : ECLI_NAMED_METADATA; a_column_name : detachable STRING; a_session : ECLI_SESSION) is
			-- search for column whose name matches `a_search_criteria' and `a_column_name'
			-- Void values are wildcards
		do
			if a_column_name /= Void then
				create queried_column_impl.make_from_string (a_column_name)
			end
			make (a_search_criteria, a_session)
		end

	make (criteria : ECLI_NAMED_METADATA; a_session: ECLI_SESSION) is
			-- make cursor on all columns matching `criteria'
		do
			Precursor (criteria, a_session)
		end

feature -- Access

	queried_column : detachable STRING is
			-- queried column name; Void if all columns in a table
		do
			if attached queried_column_impl as q then
				Result := q.as_string
			end
		end

	item : ECLI_COLUMN is
			-- item at current cursor position
		do
			check attached impl_item as i then
				Result := i
			end
		end

feature -- Status report

-- 	buffers_created : BOOLEAN

feature -- Cursor Movement

	create_item is
			-- create item at current cursor position
		do
			if not off then
				create impl_item.make (Current)
			else
				impl_item := Void
			end
		end

feature {ECLI_COLUMN} -- Access

	buffer_table_cat : ECLI_VARCHAR
	buffer_table_schem  : ECLI_VARCHAR
	buffer_table_name  : ECLI_VARCHAR
	buffer_column_name : ECLI_VARCHAR
	buffer_data_type : ECLI_INTEGER
	buffer_type_name : ECLI_VARCHAR
	buffer_column_size : ECLI_INTEGER
	buffer_buffer_length : ECLI_INTEGER
	buffer_decimal_digits : ECLI_INTEGER
	buffer_num_prec_radix : ECLI_INTEGER
	buffer_nullable : ECLI_INTEGER
	buffer_remarks : ECLI_VARCHAR
	buffer_column_def : ECLI_VARCHAR
	buffer_sql_data_type : ECLI_INTEGER
	buffer_sql_datetime_sub : ECLI_INTEGER
	buffer_char_octet_length : ECLI_INTEGER
	buffer_ordinal_position : ECLI_INTEGER
	buffer_is_nullable : ECLI_VARCHAR

feature -- Basic operations

feature {NONE} -- Implementation

	create_buffers is
				-- create buffers for cursor
		do
--			if not buffers_created then
--				create_buffer_values
				set_buffer_values_array
--				buffers_created := True
--	end
		end

	create_buffer_values is
		do
			create buffer_table_cat.make (255)
			create buffer_table_schem.make (255)
			create buffer_table_name.make (255)
			create buffer_column_name.make (255)
			create buffer_data_type.make
			create buffer_type_name.make (255)
			create buffer_column_size.make
			create buffer_buffer_length.make
			create buffer_decimal_digits.make
			create buffer_num_prec_radix.make
			create buffer_nullable.make
			create buffer_remarks.make (255)
			create buffer_column_def.make (255)
			create buffer_sql_data_type.make
			create buffer_sql_datetime_sub.make
			create buffer_char_octet_length.make
			create buffer_ordinal_position.make
			create buffer_is_nullable.make (255)
		end

	set_buffer_values_array is
		do
			set_results (<<
				buffer_table_cat,
				buffer_table_schem,
				buffer_table_name,
				buffer_column_name,
				buffer_data_type,
				buffer_type_name,
				buffer_column_size,
				buffer_buffer_length,
				buffer_decimal_digits,
				buffer_num_prec_radix,
				buffer_nullable,
				buffer_remarks,
				buffer_column_def,
				buffer_sql_data_type,
				buffer_sql_datetime_sub,
				buffer_char_octet_length,
				buffer_ordinal_position,
				buffer_is_nullable
				>>)
		end

	impl_item : detachable like item

	definition : STRING is once Result := "SQLColumns" end

	do_query_metadata (a_catalog: POINTER; a_catalog_length: INTEGER; a_schema: POINTER; a_schema_length: INTEGER; a_name: POINTER; a_name_length: INTEGER) : INTEGER is
			-- actual external query
		local
			a_column : POINTER
			a_column_length : INTEGER
		do
			if queried_column /= Void then
				a_column := queried_column_impl.handle
				a_column_length := queried_column_impl.count
			end
			Result := ecli_c_get_columns ( handle,
				a_catalog, a_catalog_length,
				a_schema, a_schema_length,
				a_name, a_name_length,
				a_column, a_column_length)
		end

	queried_column_impl : detachable XS_C_STRING

	query_metadata_feature_name : STRING is do Result := "ecli_c_get_columns" end

end
