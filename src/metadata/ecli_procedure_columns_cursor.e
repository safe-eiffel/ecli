indexing

	description:
	
		"Cursor on catalog metadata regarding columns of stored procedures. %N%
		% Columns match search criterias : (1) catalog name, (2) schema name, (3) procedure name.%N%
		% A Void criteria is considered as a wildcard."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_PROCEDURE_COLUMNS_CURSOR

inherit

	ECLI_COLUMNS_CURSOR
		redefine
			set_buffer_values_array, create_buffer_values,
		    item, create_item, do_query_metadata, definition
		end

creation

	make
	
feature -- Access

	item : ECLI_PROCEDURE_COLUMN is
			-- 
		do
			Result := impl_item
		end
		
feature -- Element change

	create_item is
			-- create item at current cursor position
		do
			if not off then
				!!impl_item.make (Current)
			else
				impl_item := Void
			end
		end

feature -- Inapplicable

	buffer_column_type : ECLI_INTEGER
	
feature {NONE} -- Implementation

	create_buffer_values is
				-- create buffers for cursor
		do
			Precursor
			create buffer_column_type.make
		end
	
	set_buffer_values_array is
		do
			set_results (<<
				buffer_table_cat,
				buffer_table_schem,
				buffer_table_name,
				buffer_column_name,
				buffer_column_type,
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

	definition : STRING is once Result := "SQLProcedureColumns" end

	do_query_metadata (a_catalog: POINTER; a_catalog_length: INTEGER; a_schema: POINTER; a_schema_length: INTEGER; a_name: POINTER; a_name_length: INTEGER) : INTEGER is
			-- actual external query
		local
			a_column : POINTER
			a_column_length : INTEGER
		do
			if queried_column /= Void then
				a_column := queried_column_impl.handle
				a_column_length := queried_column.count
			end
			Result := ecli_c_get_procedure_columns ( handle,
				a_catalog, a_catalog_length,
				a_schema, a_schema_length,
				a_name, a_name_length,
				a_column, a_column_length)
		end
	
invariant
	invariant_clause: True -- Your invariant here

end
