indexing
	description: "Objects that iterate over columns metadata for a table."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_COLUMNS_CURSOR

inherit
	ECLI_CURSOR
		rename
			statement_start as start,
			close as cursor_close, statement_close as close
		export 
			{ANY} close
		redefine
			start, forth, close
		end

	ECLI_EXTERNAL_TOOLS
	
create
	make_all_columns -- , make_by_type
	
feature {NONE} -- Initialization

	make_all_columns (a_session : ECLI_SESSION; a_table : ECLI_TABLE) is
			-- make cursor on all columns of `a_table'
		require
			session_opened: a_session /= Void and then a_session.is_connected
			a_table_not_void: a_table /= Void
		local
			schema_pointer : POINTER
			catalog_pointer : POINTER
			table_name_pointer : POINTER
			schema_length, catalog_length, table_name_length : INTEGER
		do
			make (a_session)
			if a_table.catalog /= Void then
				catalog_pointer := string_to_pointer (a_table.catalog)
				catalog_length := a_table.catalog.count
			end
			if a_table.schema /= Void then
				schema_pointer := string_to_pointer (a_table.schema)
				schema_length := a_table.schema.count
			end
			if a_table.name /= Void then
				table_name_pointer := string_to_pointer (a_table.name)
				table_name_length := a_table.name.count
			end
			--set_status (ecli_c_set_integer_statement_attribute (handle, sql_attr_metadata_id, sql_true))
			set_status (ecli_c_get_columns ( handle, 
				catalog_pointer, catalog_length,
				schema_pointer, schema_length,
				table_name_pointer, table_name_length, 
				default_pointer, 0))
			if is_ok then
				get_result_column_count
				is_executed := True
				if has_results then
					set_cursor_before
				else
					set_cursor_after
				end
	         else
	         	impl_result_column_count := 0
			end
			create_buffers
			table := a_table
		ensure
			executed: is_ok implies is_executed
		end
	
feature -- Access

	item : ECLI_COLUMN is
			-- current type description
		require
			not_off: not off
		do
			Result := impl_item
		ensure
			definition: Result /= Void
		end
		
	table : ECLI_TABLE
	
feature -- Cursor Movement

	start is
		do
			if cursor  = Void then
				create_buffers
			end
			Precursor
			if not off then
				!!impl_item.make (Current)
			end	
		end
		
	forth is
		do
			Precursor
			if not off then
				!!impl_item.make (Current)
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

	close is
			-- 
		do
			table := Void
			Precursor
		end
		
feature {NONE} -- Implementation

		create_buffers is
				-- create buffers for cursor
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
			
			set_cursor (<<
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

	impl_item : ECLI_COLUMN
	
	definition : STRING is once Result := "SQLColumns" end

end -- class ECLI_COLUMNS_CURSOR
