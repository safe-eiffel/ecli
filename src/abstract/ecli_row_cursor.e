indexing
	description: "Objects that define a row cursor and allow sweeping through it."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ROW_CURSOR

inherit
	ECLI_CURSOR
		rename
			make as cursor_make, open as statement_open,
			make_prepared as cursor_make_prepared,
			create_buffers as create_row_buffers,
			start as cursor_start
		export
			{NONE} cursor_make, cursor_make_prepared;
			{ANY}
				is_valid, go_after, close, put_parameter, has_parameter,
				has_parameters, parameters_count, bound_parameters,
				bind_parameters, parameters
		end

creation
	make, open, make_prepared, open_prepared, make_with_buffer_factory,
	make_prepared_with_buffer_factory

feature {NONE} -- Initialization

	make, open (a_session : ECLI_SESSION; a_sql : STRING) is
			-- make cursor for `a_session' on `a_sql'
		require
			a_session_exists: a_session /= Void
			a_session_connected: a_session.is_connected
		do
			create_buffer_factory
			buffer_factory.set_precision_limit (buffer_factory.Default_precision_limit)
			make_with_buffer_factory (a_session, a_sql, buffer_factory)
		ensure
			valid: is_valid
			definition_set: definition = a_sql
			definition_is_sql: equal (definition, sql)
			buffer_factory_created: buffer_factory /= Void
			limit_set: buffer_factory.precision_limit = buffer_factory.Default_precision_limit
		end

	make_prepared, open_prepared (a_session : ECLI_SESSION; a_sql : STRING) is
			-- make prepared cursor for `a_session' on `a_sql'
		require
			a_session_exists: a_session /= Void
			a_session_connected: a_session.is_connected
		do
			make (a_session, a_sql)
			prepare
		ensure
			valid: is_valid
			definition_set: definition = a_sql
			definition_is_sql: equal (definition, sql)
			buffer_factory_created: buffer_factory /= Void
			limit_set: buffer_factory.precision_limit = buffer_factory.Default_precision_limit
			prepared_if_ok: is_ok implies is_prepared
		end

	make_with_buffer_factory (a_session : ECLI_SESSION; a_sql : STRING; a_buffer_factory : ECLI_BUFFER_FACTORY) is
			-- make cursor on `a_session' for `a_sql', using `a_buffer_factory'
		require
			a_session_exists: a_session /= Void
			a_session_connected: a_session.is_connected
			a_buffer_factory_exists: a_buffer_factory /= Void
		do
			definition := a_sql
			cursor_make (a_session)
			buffer_factory := a_buffer_factory
		ensure
			valid: is_valid
			definition_set: definition = a_sql
			definition_is_sql: equal (definition, sql)
			buffer_factory_assigned: buffer_factory = a_buffer_factory
		end
		
	make_prepared_with_buffer_factory (a_session : ECLI_SESSION; a_sql : STRING; a_buffer_factory : ECLI_BUFFER_FACTORY) is
			-- make cursor on `a_session' for prepared `a_sql', using `a_buffer_factory'
		require
			a_session_exists: a_session /= Void
			a_session_connected: a_session.is_connected
			a_buffer_factory_exists: a_buffer_factory /= Void
		do
			make_with_buffer_factory (a_session, a_sql, a_buffer_factory)
			prepare
		ensure
			valid: is_valid
			definition_set: definition = a_sql
			definition_is_sql: equal (definition, sql)
			buffer_factory_assigned: buffer_factory = a_buffer_factory
			prepared_if_ok: is_ok implies is_prepared
		end
		
feature -- Access

	definition : STRING
			-- definition as an SQL query

--	item, infix "@" (name : STRING) : like value_anchor is
	item (name : STRING) : like value_anchor is
			-- column item by `name'
		require
			is_executed: is_executed
			name_exists: name /= Void
			has_column_by_name: has_column (name)
		do
			Result := results.item (name_to_index.item (name))
		end

--	item_by_index, infix "|index|" (index : INTEGER) : like value_anchor is
	item_by_index (index : INTEGER) : like value_anchor is
			-- column item by `index'
		require
			is_executed: is_executed
			valid_index: index >= lower and index <= upper
		do
			Result := results.item (index)
		end

	column_name (index : INTEGER) : STRING is
			-- column name by `index'
		require
			valid_index: index >= lower and index <= upper
		do
			Result := results_description.item (index).name
		ensure
			not_void: Result /= Void
		end

feature -- Measurement

	lower : INTEGER is
			-- lower cursor index
		require
			is_executed: is_executed
		do
			Result := results.lower
		end

	upper : INTEGER is
			-- upper cursor index; i.e. number of elements in result row
		require
			is_executed: is_executed
		do
			Result := results.upper
		end

feature -- Status report

	has_column (name : STRING) : BOOLEAN is
			-- Does `name' match the name of a column in Current ?
		require
			name_exists: name /= Void
		do
			Result := name_to_index.has (name)
		end

feature -- Cursor movement

	start is
			-- start at first row of dataset
		require
			prepared: is_prepared_execution_mode implies is_prepared
			bound_parameters: has_parameters implies bound_parameters
			not_executed: not is_executed
		do
			execute
			if is_ok then
				if has_result_set then
					create_row_buffers
					statement_start
				else
					cursor_status := Cursor_after
				end
			else
				debug
					print (diagnostic_message)
					print ("%N")
				end
			end
		ensure
			executed: is_ok implies is_executed
			off_if_not_query: is_ok implies (not has_result_set implies off)
		end

feature {NONE} -- Implementation

	name_to_index : DS_HASH_TABLE [INTEGER, STRING]

	map_name_to_index (index : INTEGER; name : STRING) is
			-- hook: map column `name' to column `index'
		do
			name_to_index.put (index, name)
		end

	create_name_to_index (size : INTEGER) is
			-- hook: create name to index map
		do
			create name_to_index.make (size)
		end

	buffer_factory : ECLI_BUFFER_FACTORY

	create_buffer_factory is
		do
			create buffer_factory
		end

	create_row_buffers is
			-- create data-transfer buffers for row
		do
			describe_results
			results := Void
			if not is_ok then
				debug
					print (diagnostic_message)
					print ("%N")
				end
			else
				buffer_factory.create_buffers (results_description)
				set_results (buffer_factory.last_buffers)
				name_to_index := buffer_factory.last_index_table
			end
		end

end -- class ECLI_ROW_CURSOR
