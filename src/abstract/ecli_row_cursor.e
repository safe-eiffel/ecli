indexing

	description:
	
		"Row cursors.%N%
			%A row cursor allows sweeping, row by row, through a result-set of a SQL query.%N%
			%The ECLI_VALUE buffers composing the row are built by `buffer_factory' using%N%
			%the result-set description obtained from the database server.%N%
			%Individual column items can be accessed by name or by index."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ROW_CURSOR

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

	make, open (a_session : ECLI_SESSION; sql_definition : STRING) is
			-- Make cursor for `a_session' on `sql_definition'
		require
			a_session_not_void: a_session /= Void
			a_session_connected: a_session.is_connected
			sql_definition_not_void: sql_definition /= Void
		do
			create_buffer_factory
			buffer_factory.set_precision_limit (buffer_factory.Default_precision_limit)
			make_with_buffer_factory (a_session, sql_definition, buffer_factory)
		ensure
			valid: is_valid
			definition_set: definition = sql_definition
			definition_is_sql: equal (definition, sql)
			buffer_factory_created: buffer_factory /= Void
			limit_set: buffer_factory.precision_limit = buffer_factory.Default_precision_limit
		end

	make_prepared, open_prepared (a_session : ECLI_SESSION; sql_definition : STRING) is
			-- Make prepared cursor for `a_session' on `sql_definition'
		require
			a_session_not_void: a_session /= Void
			a_session_connected: a_session.is_connected
			sql_definition_not_void: sql_definition /= Void
		do
			make (a_session, sql_definition)
			prepare
		ensure
			valid: is_valid
			definition_set: definition = sql_definition
			definition_is_sql: equal (definition, sql)
			buffer_factory_created: buffer_factory /= Void
			limit_set: buffer_factory.precision_limit = buffer_factory.Default_precision_limit
			prepared_if_ok: is_ok implies is_prepared
		end

	make_with_buffer_factory (a_session : ECLI_SESSION; sql_definition : STRING; a_buffer_factory : like buffer_factory) is
			-- Make cursor on `a_session' for `sql_definition', using `a_buffer_factory'
		require
			a_session_not_void: a_session /= Void
			a_session_connected: a_session.is_connected
			sql_definition_not_void: sql_definition /= Void
			a_buffer_factory_not_void: a_buffer_factory /= Void
		do
			definition := sql_definition
			cursor_make (a_session)
			buffer_factory := a_buffer_factory
		ensure
			valid: is_valid
			definition_set: definition = sql_definition
			definition_is_sql: equal (definition, sql)
			buffer_factory_assigned: buffer_factory = a_buffer_factory
		end
		
	make_prepared_with_buffer_factory (a_session : ECLI_SESSION; sql_definition : STRING; a_buffer_factory :  like buffer_factory) is
			-- Make cursor on `a_session' for prepared `sql_definition', using `a_buffer_factory'
		require
			a_session_not_void: a_session /= Void
			a_session_connected: a_session.is_connected
			sql_definition_not_void: sql_definition /= Void
			a_buffer_factory_not_void: a_buffer_factory /= Void
		do
			make_with_buffer_factory (a_session, sql_definition, a_buffer_factory)
			prepare
		ensure
			valid: is_valid
			definition_set: definition = sql_definition
			definition_is_sql: equal (definition, sql)
			buffer_factory_assigned: buffer_factory = a_buffer_factory
			prepared_if_ok: is_ok implies is_prepared
		end
		
feature -- Access

	buffer_factory : ECLI_BUFFER_FACTORY
			-- Buffer factory for automatic creation of result buffers

	definition : STRING
			-- Definition as an SQL query

	item (name : STRING) : like value_anchor is
			-- Column item by `name'
		require
			is_executed: is_executed
			name_not_void: name /= Void
			has_column_by_name: has_column (name)
		do
			Result := results.item (name_to_index.item (name))
		end

	item_by_index (index : INTEGER) : like value_anchor is
			-- Column item by `index'
		require
			is_executed: is_executed
			valid_index: index >= lower and index <= upper
		do
			Result := results.item (index)
		end

	column_name (index : INTEGER) : STRING is
			-- Column name by `index'
		require
			valid_index: index >= lower and index <= upper
		do
			Result := results_description.item (index).name
		ensure
			not_void: Result /= Void
		end

feature -- Measurement

	lower : INTEGER is
			-- Lower cursor index
		require
			is_executed: is_executed
		do
			Result := results.lower
		end

	upper : INTEGER is
			-- Upper cursor index; i.e. number of elements in result row
		require
			is_executed: is_executed
		do
			Result := results.upper
		end

feature -- Status report

	has_column (name : STRING) : BOOLEAN is
			-- Does `name' match the name of a column in Current ?
		require
			name_not_void: name /= Void
		do
			Result := name_to_index.has (name)
		end

feature -- Cursor movement

	start is
			-- Execute and start iterating on result set
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
			results_created_by_factory: (is_ok and then has_result_set) implies results /= Void
			off_if_not_query: is_ok implies (not has_result_set implies off)
		end

feature {NONE} -- Implementation

	name_to_index : DS_HASH_TABLE [INTEGER, STRING]
			-- Table mapping column name to column index

	create_buffer_factory is
		do
			create buffer_factory
		end

	create_row_buffers is
			-- Describe results and create data-transfer buffers using `buffer_factory'
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
		ensure then
			results_set_described: is_ok implies results_description /= Void
			results_set: is_ok implies  results = buffer_factory.last_buffers
			name_to_index_set: is_ok implies name_to_index = buffer_factory.last_index_table
		end

end
