note

	description:

		"Row cursors that physically fetch sets of rows.%N%
			%Rows are physically retrieved `row_count' at a time, minimizing network traffic."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ROWSET_CURSOR

inherit

	ECLI_ROW_CURSOR
		rename
			make as row_cursor_make, open as row_cursor_open,
			make_prepared as row_cursor_make_prepared, open_prepared as row_cursor_open_prepared,
			make_with_buffer_factory as row_cursor_make_with_buffer_factory,
			make_prepared_with_buffer_factory as row_cursor_make_prepared_with_buffer_factory
		export
			{NONE} row_cursor_make, row_cursor_open
		redefine
			start, value_anchor, create_row_buffers, fill_results,
			fetch_next_row, buffer_factory, create_buffer_factory,
			default_create
		end

	ECLI_ROWSET_CAPABLE
		undefine
			default_create
		end

create

	make, make_prepared, open, open_prepared

feature -- Initialization

	make, open (a_session : ECLI_SESSION; a_definition : STRING; a_row_capacity : INTEGER)
		require
			a_session_not_void: a_session /= Void --FIXME: VS-DEL
			a_session_connected: a_session.is_connected
			session_handles_arrayed_results: a_session.is_bind_arrayed_results_capable
			definition_not_void: a_definition /= Void --FIXME: VS-DEL
			row_count_valid: a_row_capacity >= 1
		do
			row_capacity := a_row_capacity
			make_row_count_capable
			create rowset_status.make (row_capacity)
			row_cursor_make (a_session, a_definition)
		ensure
			valid: is_valid
			definition_set: definition = a_definition
			definition_is_sql: equal (definition, sql)
			limit_set: buffer_factory.precision_limit = buffer_factory.Default_precision_limit
			row_count_set: row_capacity = a_row_capacity
		end

	make_prepared, open_prepared (a_session : ECLI_SESSION; a_definition : STRING; a_row_capacity : INTEGER)
			-- make prepared cursor for `a_session' on `a_definition', for fetching at most `a_row_capacity' at a time
		require
			a_session_not_void: a_session /= Void --FIXME: VS-DEL
			a_session_connected: a_session.is_connected
			session_handles_arrayed_results: a_session.is_bind_arrayed_results_capable
			definition_not_void: a_definition /= Void --FIXME: VS-DEL
			row_count_valid: a_row_capacity >= 1
		do
			make (a_session, a_definition, a_row_capacity)
			prepare
		ensure
			valid: is_valid
			definition_set: definition = a_definition
			definition_is_sql: equal (definition, sql)
			prepared_if_ok: is_ok implies is_prepared
			definition_is_a_query:  is_ok implies has_result_set
			limit_set: buffer_factory.precision_limit = buffer_factory.Default_precision_limit
			row_count_set: row_capacity = a_row_capacity
		end

	make_with_buffer_factory (a_session : ECLI_SESSION; sql_definition : STRING; a_row_capacity : INTEGER; a_buffer_factory : like buffer_factory)
			-- Make cursor on `a_session' for `sql_definition', using `a_buffer_factory'
		require
			a_session_not_void: a_session /= Void --FIXME: VS-DEL
			a_session_connected: a_session.is_connected
			session_handles_arrayed_results: a_session.is_bind_arrayed_results_capable
			sql_definition_not_void: sql_definition /= Void --FIXME: VS-DEL
			a_buffer_factory_not_void: a_buffer_factory /= Void --FIXME: VS-DEL
		do
			row_capacity := a_row_capacity
			make_row_count_capable
			create rowset_status.make (row_capacity)
			row_cursor_make_with_buffer_factory (a_session, sql_definition, a_buffer_factory)
		ensure
			valid: is_valid
			definition_set: definition = sql_definition
			definition_is_sql: equal (definition, sql)
			buffer_factory_assigned: buffer_factory = a_buffer_factory
			row_count_set: row_capacity = a_row_capacity
		end

	make_prepared_with_buffer_factory (a_session : ECLI_SESSION; sql_definition : STRING; a_row_capacity : INTEGER; a_buffer_factory :  like buffer_factory)
			-- Make cursor on `a_session' for prepared `sql_definition', using `a_buffer_factory'
		require
			a_session_not_void: a_session /= Void --FIXME: VS-DEL
			a_session_connected: a_session.is_connected
			session_handles_arrayed_results: a_session.is_bind_arrayed_results_capable
			sql_definition_not_void: sql_definition /= Void --FIXME: VS-DEL
			a_buffer_factory_not_void: a_buffer_factory /= Void --FIXME: VS-DEL
		do
			make_with_buffer_factory (a_session, sql_definition, a_row_capacity, a_buffer_factory)
			prepare
		ensure
			valid: is_valid
			definition_set: definition = sql_definition
			definition_is_sql: equal (definition, sql)
			buffer_factory_assigned: buffer_factory = a_buffer_factory
			row_count_set: row_capacity = a_row_capacity
			prepared_if_ok: is_ok implies is_prepared
		end

	default_create
		do
			Precursor  {ECLI_ROW_CURSOR}
			create status_array.make_filled (0, 1, row_capacity)
		end

feature -- Access

	value_anchor : detachable ECLI_ARRAYED_VALUE

	buffer_factory : ECLI_ARRAYED_BUFFER_FACTORY

feature -- Basic operations

	start
			-- Execute query `definition', positioning cursor on first available result row
		do
			physical_fetch_count := 0; fetch_increment := 0
			Precursor
		ensure then
			results_exists: (is_executed and then has_result_set) implies (results /= Void and then results.count = result_columns_count) -- FIXME: VS-MOD (suppress 'results /= Void')
			fetched_columns_count_set: (is_executed and then has_result_set) implies (fetched_columns_count = result_columns_count.min (results.count))
		end

feature {NONE} -- Implementation

	create_buffer_factory
		do
			create buffer_factory.make (row_capacity)
		end

	create_row_buffers
			-- Create `cursor' array filled with ECLI_VALUE descendants
		do
			Precursor
			if not results.is_empty then
				bind_results
			end
		end

	bind_results
			-- Bind results to cursor buffer values
		local
			index : INTEGER
		do
			--| Bind by column
			set_status ("ecli_c_set_integer_statement_attribute", ecli_c_set_integer_statement_attribute (handle, Sql_attr_row_bind_type, Sql_bind_by_column))
			--| Declare maximum number of retrieved values at a time
			set_status ("ecli_c_set_integer_statement_attribute", ecli_c_set_integer_statement_attribute (handle, Sql_attr_row_array_size, row_capacity))
			--| Declare status indicator array
			set_status ("ecli_c_set_pointer_statement_attribute", ecli_c_set_pointer_statement_attribute (handle, Sql_attr_row_status_ptr, rowset_status.to_external, 0))
			from index := 1
			until index > result_columns_count
			loop
				results.item (index).bind_as_result (Current, index)
				index := index + 1
			end
		end

	logical_fetch_count : INTEGER
			-- logical number of fetch operations
		do
			Result := physical_fetch_count * row_capacity + fetch_increment
		end

	physical_fetch_count : INTEGER
			-- physical number of fetches (with database transfers)

	fetch_increment : INTEGER
			-- number of logical fetches since last physical one

	fill_results
			-- update 'count' of all values in cursor
		local
			index : INTEGER
		do
			from index := 1
			until index > result_columns_count
			loop
				results.item (index).set_count (row_count.as_integer_32)
				index := index + 1
			end
			fetched_columns_count := result_columns_count
		end

	fetch_next_row
			-- logical fetch of one row
		do
			if physical_fetch_count > 0 and then row_count < row_capacity and then fetch_increment >= row_count then
					go_after
			else
				if fetch_increment \\ row_capacity = 0 then
					--| Bind `row_count' for getting the actual number of rows fetched
					set_status ("ecli_c_set_pointer_statement_attribute", ecli_c_set_pointer_statement_attribute (handle, Sql_attr_rows_fetched_ptr, impl_row_count.handle, 0))
					--| Do actual fetch
					Precursor
					fill_status_array
					start_values
					physical_fetch_count := physical_fetch_count + 1
					fetch_increment := 1
					fetched_columns_count := result_columns_count.min (results.count)
				else
					forth_values
					fetch_increment := fetch_increment + 1
				end
			end
		end

	start_values
			-- call 'start' on each value in cursor
		local
			index : INTEGER
		do
			from index := 1
			until index > result_columns_count
			loop
				results.item (index).start
				index := index + 1
			end
		end

	forth_values
			-- call 'forth' on each value in cursor
		local
			index : INTEGER
		do
			from index := 1
			until index > result_columns_count
			loop
				results.item (index).forth
				index := index + 1
			end

		end

	make_row_count_capable
			--
		do
			create impl_row_count.make
		end

end
