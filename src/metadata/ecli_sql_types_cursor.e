indexing

	description:

			"Cursors over the SQL types supported by the datasource related to a session."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_SQL_TYPES_CURSOR

inherit

	ECLI_CURSOR
		rename
			make as cursor_make
		export
			{ANY} close
		redefine
			start, forth, default_create
		end

	ECLI_TYPE_CONSTANTS
		export {NONE} all;
		{ANY}
			sql_char,
			sql_numeric,
			sql_decimal,
			sql_integer,
			sql_smallint,
			sql_float,
			sql_real,
			sql_double,
			sql_varchar,
			sql_type_date,
			sql_type_time,
			sql_type_timestamp,
			sql_longvarchar
		undefine
			default_create
		end

--	KL_IMPORTED_ARRAY_ROUTINES

create

	make_all_types, make

feature {} -- Initialization

	default_create
		do
			Precursor {ECLI_CURSOR}
			create_buffer_objects
		end

	make_all_types, open_all_types (a_session : ECLI_SESSION) is
			-- make cursor for all types supported by `a_session'
		require
			session_not_void: a_session /= Void  --FIXME: VS-DEL
			a_session_connected: a_session.is_connected
			closed: is_closed
		do
			make (sql_all_types, a_session)
		ensure
			executed: is_ok implies is_executed
			open: not is_closed
		end


	make (a_type : INTEGER; a_session : ECLI_SESSION) is
			-- make cursor for `a_type', if it is a type known by the datasource
		require
			a_session_not_void: a_session /= Void --FIXME: VS-DEL
			a_session_connected: a_session.is_connected
			valid_type: supported_types.has (a_type)
			closed: is_closed
		do
			cursor_make (a_session)
			get_type_info (a_type)
		ensure
			executed: is_ok implies is_executed
			open: not is_closed
		end

feature -- Access

	item : ECLI_SQL_TYPE is
			-- item at current cursor position
		require
			not_off: not off
		do
			check attached impl_item as i then
				Result := i
			end
		ensure
			definition: Result /= Void --FIXME: VS-DEL
		end

	supported_types : ARRAY[INTEGER] is
			-- array of supported types
		once
			Result := <<
				sql_char,
				sql_numeric,
				sql_decimal,
				sql_integer,
				sql_smallint,
				sql_float,
				sql_real,
				sql_double,
				sql_varchar,
				sql_type_date,
				sql_type_time,
				sql_type_timestamp,
				sql_longvarchar,
				sql_all_types
			>>
		end

feature -- Cursor Movement

	start is
			-- advance cursor to first position if any
		do
			if results.is_empty then
				create_buffers
			end
			statement_start
			if not off then
				create impl_item.make (Current)
			end
		end

	forth is
			-- advance cursor to next position
		do
			Precursor
			if not off then
				create impl_item.make (Current)
			else
				impl_item := Void
			end
		end

feature {ECLI_SQL_TYPE} -- Status

	is_odbc_v3 : BOOLEAN is
			-- does this type description contain ODBC > 3.x information ?
		do
			Result := result_columns_count > 15
		end

feature {ECLI_SQL_TYPE} -- Access

	buffer_type_name : ECLI_VARCHAR
	buffer_literal_prefix : ECLI_VARCHAR
	buffer_literal_suffix : ECLI_VARCHAR
	buffer_create_params : ECLI_VARCHAR
	buffer_local_type_name : ECLI_VARCHAR

	buffer_data_type : ECLI_INTEGER
	buffer_column_size : ECLI_INTEGER
	buffer_nullable : ECLI_INTEGER
	buffer_case_sensitive : ECLI_INTEGER
	buffer_searchable : ECLI_INTEGER
	buffer_unsigned_attribute : ECLI_INTEGER
	buffer_fixed_prec_scale : ECLI_INTEGER
	buffer_auto_unique_value : ECLI_INTEGER
	buffer_minimum_scale : ECLI_INTEGER
	buffer_maximum_scale : ECLI_INTEGER
	buffer_sql_data_type : ECLI_INTEGER
	buffer_sql_date_time_sub : ECLI_INTEGER
	buffer_num_prec_radix : ECLI_INTEGER
	buffer_interval_precision : ECLI_INTEGER

feature {NONE} -- Implementation

		create_buffers is
				-- create buffers for results
		do
			set_results (<<
				buffer_type_name,
				buffer_data_type,
				buffer_column_size,
				buffer_literal_prefix,
				buffer_literal_suffix,
				buffer_create_params,
				buffer_nullable,
				buffer_case_sensitive,
				buffer_searchable,
				buffer_unsigned_attribute,
				buffer_fixed_prec_scale,
				buffer_auto_unique_value,
				buffer_local_type_name,
				buffer_minimum_scale,
				buffer_maximum_scale,
				buffer_sql_data_type,
				buffer_sql_date_time_sub,
				buffer_num_prec_radix,
				buffer_interval_precision
				>>)
		end

	create_buffer_objects
		do
			create buffer_type_name.make (40)
			create buffer_literal_prefix.make (20)
			create buffer_literal_suffix.make (20)
			create buffer_create_params.make (40)
			create buffer_local_type_name.make (40)

			create buffer_data_type.make
			create buffer_column_size.make
			create buffer_nullable.make
			create buffer_case_sensitive.make
			create buffer_searchable.make
			create buffer_unsigned_attribute.make
			create buffer_fixed_prec_scale.make
			create buffer_auto_unique_value.make
			create buffer_minimum_scale.make
			create buffer_maximum_scale.make
			create buffer_sql_data_type.make
			create buffer_sql_date_time_sub.make
			create buffer_num_prec_radix.make
			create buffer_interval_precision.make
		end

	impl_item : detachable ECLI_SQL_TYPE

	definition : STRING is once Result := "SQLGetTypeInfo" end

	get_type_info (type : INTEGER) is
			-- get information on `type'
		do
			set_status ("ecli_c_get_type_info", ecli_c_get_type_info (handle, type))
			if is_ok then
				get_result_columns_count
				is_executed := True
				if has_result_set then
					set_cursor_before
				else
					set_cursor_after
				end
			 else
				impl_result_columns_count.put (0)
			end
			create_buffers
		end

end
