indexing
	description: "Objects that describe a SQL type, as supported by a datasource."
	author: "Paul G. Crismer"
	
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_SQL_TYPE

inherit
	ECLI_NULLABLE_METADATA
		redefine
			out
		end

creation
	make

feature {ECLI_SQL_TYPES_CURSOR} -- Initialization

	make (type_cursor : ECLI_SQL_TYPES_CURSOR) is
			-- create type description from current cursor tuple
		require
			type_cursor: type_cursor /= Void
			current_exists: not type_cursor.off
		do
			impl_name := type_cursor.buffer_type_name.as_string
			impl_sql_type_code := type_cursor.buffer_data_type.to_integer
			if not type_cursor.buffer_column_size.is_null then
				impl_size := type_cursor.buffer_column_size.to_integer
				is_size_applicable := True
			end
			if not type_cursor.buffer_literal_prefix.is_null then
				impl_literal_prefix := type_cursor.buffer_literal_prefix.as_string
				is_literal_prefix_applicable := True
			end
			if not type_cursor.buffer_literal_suffix.is_null then
				impl_literal_suffix := type_cursor.buffer_literal_suffix.as_string
				is_literal_suffix_applicable := True
			end
			if not type_cursor.buffer_create_params.is_null then
				impl_create_params := type_cursor.buffer_create_params.as_string
				is_create_params_applicable := True
			end
			nullability := type_cursor.buffer_nullable.to_integer
			impl_searchable := type_cursor.buffer_searchable.to_integer
			if not type_cursor.buffer_unsigned_attribute.is_null then
				impl_unsigned := type_cursor.buffer_unsigned_attribute.to_integer
				is_unsigned_applicable := True
			end
			impl_fixed_precision_scale := type_cursor.buffer_fixed_prec_scale.to_integer
			if not type_cursor.buffer_auto_unique_value.is_null then
				impl_auto_unique_value := type_cursor.buffer_auto_unique_value.to_integer
				is_auto_unique_value_applicable := True
			end
			if not type_cursor.buffer_local_type_name.is_null then
				impl_local_type_name := type_cursor.buffer_local_type_name.as_string
				is_local_type_name_applicable := True
			end
			if not type_cursor.buffer_minimum_scale.is_null then
				impl_minimum_scale := type_cursor.buffer_minimum_scale.to_integer
				is_minimum_scale_applicable := True
			end
			if not type_cursor.buffer_maximum_scale.is_null then
				impl_maximum_scale := type_cursor.buffer_maximum_scale.to_integer
				is_maximum_scale_applicable := True
			end
			if type_cursor.is_odbc_v3 then
				if not type_cursor.buffer_sql_data_type.is_null then
					impl_sql_data_type := type_cursor.buffer_sql_data_type.to_integer
					exists_sql_data_type := True
				end
				if not type_cursor.buffer_sql_date_time_sub.is_null then
					impl_sql_date_time_sub := type_cursor.buffer_sql_date_time_sub.to_integer
					exists_sql_date_time_sub := True
				end
				if not type_cursor.buffer_num_prec_radix.is_null then
					impl_num_prec_radix := type_cursor.buffer_num_prec_radix.to_integer
					exists_num_prec_radix := True
				end
				if not type_cursor.buffer_interval_precision.is_null then
					impl_interval_precision := type_cursor.buffer_interval_precision.to_integer
					exists_interval_precision := True
				end
			end
		end

feature -- Access

	name :  STRING is
			-- Data-source dependent type name
		do
			Result := impl_name
		ensure
			exists: Result /= Void
		end

	sql_type_code : INTEGER is
			-- SQL data type code
		do
			Result := impl_sql_type_code
		end

	size : INTEGER is
			-- The maximum column size that the server supports for this data type.
			-- For numeric data, this is the maximum precision.
			-- For string data, this is the length in characters.
			-- For datetime data types, this is the length in characters of the string representation
			--  (assuming the maximum allowed precision of the fractional seconds component.)
		do
			Result := impl_size
		ensure
			significant: is_size_applicable implies Result /= 0
		end

	literal_prefix : STRING is
			-- Character(s) used to prefix a literal
		do
			Result := impl_literal_prefix
		ensure
			significant: is_literal_prefix_applicable implies Result /= Void
		end

	literal_suffix : STRING is
			-- Character(s) used to prefix a literal
		do
			Result := impl_literal_suffix
		ensure
			significant: is_literal_prefix_applicable implies Result /= Void
		end

	create_params : STRING is
			-- A list of keywords, separated by commas, corresponding to each parameter
			-- that the application may specify in parentheses when using the name that is returned
			-- in the TYPE_NAME field.
			-- The keywords in the list can be any of the following:
			-- length, precision, scale.
			-- They appear in the order that the syntax requires that they be used.
			-- The driver supplies the CREATE_PARAMS text in the language of the country where it is used.
		do
			Result := impl_create_params
		ensure
			significant: is_create_params_applicable implies Result /= Void
		end

	is_case_sensitive : BOOLEAN is
			-- If a character datatype, denotes the case sensitivity in comparisons
			-- and in collations
		do
			Result := impl_case_sensitive = sql_true
		end

	searchable : INTEGER is
			-- is this type searchable ?
		do
			Result := impl_searchable
		end

	is_unsigned : BOOLEAN is
			-- is it unsigned ?
		require
			is_unsigned_applicable
		do
			Result := impl_unsigned	= sql_true
		end

	is_fixed_precision_scale : BOOLEAN is
			-- is the precision scale fixed ?
		do
			Result := impl_fixed_precision_scale = sql_true
		end

	is_auto_unique_value : BOOLEAN is
			-- Is the data type auto incrementing ?
		require
			is_auto_unique_value_applicable
		do
			Result := impl_auto_unique_value = sql_true
		end

	local_type_name : STRING is
			-- Localized version of the type name
		do
			Result := impl_local_type_name
		ensure
			significant: is_local_type_name_applicable implies Result /= Void
		end

	minimum_scale : INTEGER is
			-- minimum scale for numeric values
		require
			is_minimum_scale_applicable
		do
			Result := impl_minimum_scale
		end


	maximum_scale : INTEGER is
			-- maximum scale for numeric values
		require
			is_maximum_scale_applicable
		do
			Result := impl_maximum_scale
		end

	sql_data_type : INTEGER is
			-- sql data type code (ODBC >= V3.0)
		require
			exists_sql_data_type
		do
			Result := impl_sql_data_type
		end

	sql_date_time_sub : INTEGER is
			-- sql subcode if date time or interval (ODBCV >= 3.0)
		require
			exists_sql_date_time_sub
		do
			Result := impl_sql_date_time_sub
		end

	num_prec_radix : INTEGER is
			-- precision radix for numeric (ODBCV >= 3.0)
		require
			exists_num_prec_radix
		do
			Result := impl_num_prec_radix
		end

	interval_precision : INTEGER is
			-- precision if interval (ODBCV >= 3.0)
		require
			exists_interval_precision
		do
			Result := impl_interval_precision
		end

feature -- Measurement

feature -- Status report

	is_size_applicable : BOOLEAN

	is_create_params_applicable : BOOLEAN

	is_literal_prefix_applicable : BOOLEAN

	is_literal_suffix_applicable : BOOLEAN

	is_unsigned_applicable : BOOLEAN 
			-- True if it is a numeric type

	is_local_type_name_applicable : BOOLEAN

	is_auto_unique_value_applicable : BOOLEAN
			-- Can such type be autoincremented ?

	is_minimum_scale_applicable : BOOLEAN

	is_maximum_scale_applicable : BOOLEAN

	exists_sql_data_type : BOOLEAN

	exists_sql_date_time_sub : BOOLEAN

	exists_num_prec_radix : BOOLEAN

	exists_interval_precision : BOOLEAN

feature -- Conversion

	out : STRING is
			-- terse visual representation
		do
			!!Result.make (128)
			Result.append_string (name)
			Result.append_string ("%T")
			Result.append_string (sql_type_code.out) Result.append_string ("%T")
			Result.append_string (size.out) Result.append_string ("%T")
			if is_literal_prefix_applicable then Result.append_string (literal_prefix) else Result.append_string ("NULL") end
			Result.append_string ("%T")
			if is_literal_suffix_applicable then Result.append_string (literal_suffix) else Result.append_string ("NULL") end
			Result.append_string ("%T")
			if is_create_params_applicable then Result.append_string (create_params) else Result.append_string ("NULL") end
			Result.append_string ("%T")
			Result.append_string (is_case_sensitive.out) Result.append_string ("%T")
			Result.append_string (searchable.out) Result.append_string ("%T")
			if is_unsigned_applicable then Result.append_string (is_unsigned.out) else Result.append_string ("NULL") end
			Result.append_string ("%T")
			Result.append_string (is_fixed_precision_scale.out) Result.append_string ("%T")
			if is_auto_unique_value_applicable then Result.append_string (is_auto_unique_value.out) else Result.append_string ("NULL") end
			Result.append_string ("%T")
			if local_type_name /= Void then Result.append_string (local_type_name.out) else Result.append_string ("NULL") end
			Result.append_string ("%T")
			if is_minimum_scale_applicable then Result.append_string (minimum_scale.out) else Result.append_string ("NULL") end
			Result.append_string ("%T")
			if is_maximum_scale_applicable then Result.append_string (maximum_scale.out) else Result.append_string ("NULL") end
			Result.append_string ("%T")
			if exists_sql_data_type then
				Result.append_string (sql_data_type.out) Result.append_string ("%T")
				Result.append_string (sql_date_time_sub.out) Result.append_string ("%T")
				Result.append_string (num_prec_radix.out) Result.append_string ("%T")
				Result.append_string (interval_precision.out) Result.append_string ("%T")
			end
		end

feature {NONE} -- Implementation

	impl_name : STRING
	impl_sql_type_code : INTEGER
	impl_size : INTEGER
	impl_literal_prefix : STRING
	impl_literal_suffix : STRING
	impl_create_params : STRING
	impl_case_sensitive : INTEGER
	impl_searchable : INTEGER
	impl_unsigned : INTEGER
	impl_fixed_precision_scale : INTEGER
	impl_auto_unique_value : INTEGER
	impl_local_type_name : STRING
	impl_minimum_scale : INTEGER
	impl_maximum_scale : INTEGER
	impl_sql_data_type : INTEGER
	impl_sql_date_time_sub : INTEGER
	impl_num_prec_radix : INTEGER
	impl_interval_precision : INTEGER

end -- class ECLI_SQL_TYPE
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
