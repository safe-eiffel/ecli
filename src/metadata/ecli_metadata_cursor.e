indexing
	description: "Objects that open a cursor on database metadata"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ECLI_METADATA_CURSOR

inherit

	ECLI_CURSOR
		rename
			statement_start as start, make as cursor_make
		export 
			{ANY} close
		redefine
			start, forth
		end

	ECLI_EXTERNAL_TOOLS
		export
			{NONE} all
		end
		
feature -- 

	make (a_name : ECLI_NAMED_METADATA; a_session : ECLI_SESSION) is
			-- Void values for a_name.catalog, a_name.schema, a_name.name can be Void are 'wildcards'
		require
			a_name_not_void: a_name /= Void
			a_session_not_void: a_session /= Void
			a_session_connected: a_session.is_connected				
		local
			l_catalog, l_schema, l_name : POINTER
			catalog_length, schema_length, name_length : INTEGER
		do
			cursor_make (a_session)
			if a_name.catalog /= Void then
				l_catalog := string_to_pointer (a_name.catalog)
				catalog_length := a_name.catalog.count
			end
			if a_name.schema /= Void then
				l_schema := string_to_pointer (a_name.schema)
				schema_length := a_name.schema.count
			end
			if a_name.name /= Void then
				l_name := string_to_pointer (a_name.name)
				name_length := a_name.name.count
			end
			queried_catalog := a_name.catalog
			queried_schema := a_name.schema
			queried_name := a_name.name
			set_status (
				do_query_metadata ( l_catalog, catalog_length, l_schema, schema_length, l_name, name_length))
			update_state_after_execution
		ensure
			executed: is_ok implies is_executed
			queried_catalog_set: queried_catalog = a_name.catalog
			queried_schema_set: queried_schema = a_name.schema
			queried_name_set: queried_name = a_name.name
		end
	
feature -- Access

	queried_catalog : STRING
	
	queried_schema : STRING
	
	queried_name : STRING
	
	item : ANY is
			-- 
		do
			Result := impl_item
		end
	
feature -- Cursor Movement

	start is
		do
			if cursor  = Void then
				create_buffers
			end
			Precursor
			if not off then
				create_item	
			else
				impl_item := Void
			end
		end
		
	forth is
		do
			Precursor
			if not off then
				create_item
			end
		end

			
feature {NONE} -- Implementation

	create_buffers is
				-- create buffers for cursor
		deferred
		ensure
			cursor_set: cursor /= Void
		end

	create_item is
			-- create item from current cursor value
		deferred
		end
		
	impl_item : like item
	
	definition : STRING is
			-- definition of query
	 	deferred 
	 	end

	update_state_after_execution is
			-- post_make action
		do
			if is_ok then
				get_result_columns_count
				is_executed := True
				if has_results then
					set_cursor_before
					create_buffers		
				else
					set_cursor_after
				end
			else
				impl_result_columns_count := 0
			end
		end

	do_query_metadata (a_catalog : POINTER; a_catalog_length : INTEGER;
		a_schema : POINTER; a_schema_length : INTEGER;
		a_name : POINTER; a_name_length : INTEGER) : INTEGER is
			-- query metadata
		deferred
		end
		
end -- class ECLI_PROCEDURES_CURSOR
