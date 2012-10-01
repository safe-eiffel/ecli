note

	description:

			"Cursors on database metadata."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_METADATA_CURSOR

inherit

	ECLI_CURSOR
		rename
			make as cursor_make
		export
			{ANY} close
		redefine
			start, forth, create_buffers, definition, default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create queried_catalog_impl.make (20)
			create queried_schema_impl.make (20)
			create queried_name_impl.make (20)
		end

	make (criteria : ECLI_NAMED_METADATA_PATTERN; a_session : ECLI_SESSION) is
			-- Create cursor on items matching `criteria'
			-- Void values for criteria.catalog, criteria.schema, criteria.name can be Void are 'wildcards'
		require
			criteria_not_void: criteria /= Void  --FIXME: VS-DEL
			a_session_not_void: a_session /= Void --FIXME: VS-DELid
			a_session_connected: a_session.is_connected
		local
			catalog_length, schema_length, name_length : INTEGER
			p_catalog, p_schema, p_name : POINTER
		do
			cursor_make (a_session)
			set_metadata_id
			if attached criteria.catalog as cat then
				create queried_catalog_impl.make_from_string (cat)
				catalog_length := criteria.catalog.count
				p_catalog := queried_catalog_impl.handle
			end
			if attached criteria.schema as sc then
				create queried_schema_impl.make_from_string (sc)
				schema_length := criteria.schema.count
				p_schema := queried_schema_impl.handle
			end
			if attached criteria.name as nm then
				create queried_name_impl.make_from_string (nm)
				name_length := nm.count
				p_name := queried_name_impl.handle
			end
			set_status (query_metadata_feature_name,
				do_query_metadata (
					p_catalog, catalog_length,
					p_schema, schema_length,
					p_name, name_length))
			update_state_after_execution
		ensure
			executed: is_ok implies is_executed
			queried_catalog_set: criteria.catalog /= Void implies equal (queried_catalog, criteria.catalog)
			queried_schema_set: criteria.schema /= Void implies equal (queried_schema, criteria.schema)
			queried_name_set: criteria.name /= Void implies equal (queried_name, criteria.name)
		end

feature -- Access

	queried_catalog : detachable STRING
			-- queried catalog name
		do
			if queried_catalog_impl /= Void then
				Result := queried_catalog_impl.as_string
			end
		end

	queried_schema : detachable STRING
			-- queried schema name
		do
			if queried_schema_impl /= Void then
				Result := queried_schema_impl.as_string
			end
		end

	queried_name : detachable STRING
			-- queried name (table, column or procedure)
		do
			if queried_name_impl /= Void then
				Result := queried_name_impl.as_string
			end
		end

	item : ANY
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

feature -- Status report

	are_metadata_identifiers : BOOLEAN
			-- Are metadata identifiers ?
			--	True: the string argument of catalog functions are treated as identifiers.
			--		  The case is not significant. For nondelimited strings, the driver removes any trailing spaces
			--		  and the string is folded to uppercase. For delimited strings, the driver removes any leading or
			--		  trailing spaces and takes whatever is between the delimiters literally.
			--	False: the string arguments of catalog functions are not treated as identifiers.
			--		 The case is significant. They can either contain a string search pattern or not,
			--		 depending on the argument.

feature -- Cursor Movement

	start
			-- advance cursor at first item if any
		do
			if results.is_empty then
				create_buffers
			end
			statement_start --Precursor
			if not off then
				create_item
			else
				impl_item := Void
			end
		end

	forth
			-- advance cursor to next item
		do
			Precursor
			if not off then
				create_item
			end
		end

feature {NONE} -- Implementation

	create_buffers
			-- create buffers for cursor
		deferred
		end

	create_item
			-- create item from current cursor value
		deferred
		end

	impl_item : detachable like item

	definition : STRING
			-- definition of query
	 	deferred
	 	end

	update_state_after_execution
			-- post_make action
		do
			if is_ok then
				get_result_columns_count
				is_executed := True
				if has_result_set then
					set_cursor_before
					create_buffers
				else
					set_cursor_after
				end
			else
				impl_result_columns_count.put (0)
			end
		end

	do_query_metadata (a_catalog : POINTER; a_catalog_length : INTEGER;
		a_schema : POINTER; a_schema_length : INTEGER;
		a_name : POINTER; a_name_length : INTEGER) : INTEGER
			-- query metadata
		deferred
		end

	query_metadata_feature_name : STRING
			-- query metadata feature name
		deferred
		ensure
			query_metadata_feature_name_not_void: Result /= Void --FIXME: VS-DEL
		end

	queried_catalog_impl : XS_C_STRING
	queried_schema_impl : XS_C_STRING
	queried_name_impl : XS_C_STRING

	set_metadata_id
		local
			v : INTEGER_32
		do
			if are_metadata_identifiers then
				v := sql_true
			else
				v := sql_false
			end
			set_status ("ecli_c_set_integer_statement_attribute", ecli_c_set_integer_statement_attribute (handle, sql_attr_metadata_id, v))
		end

end
