note

	description:

		 "Objects that represent statements that manipulate %
		% a database. They are defined on a connected session.  %
		% Provide CLI/ODBC CORE and some Level 1 functionalities."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_STATEMENT

inherit

	ECLI_STATUS
		export
			{ECLI_STATEMENT, ECLI_DATA_DESCRIPTION, ECLI_VALUE} set_status
		redefine
			default_create
		end

	ECLI_HANDLE
		export
			{ECLI_STATEMENT, ECLI_DATA_DESCRIPTION, ECLI_VALUE} handle
		undefine
			default_create
		end

	ECLI_TRACEABLE
		undefine
			default_create
		end

	PAT_SUBSCRIBER[ECLI_SESSION]
		rename
			publisher as session,
			published as session_disconnect,
			has_publisher as has_session,
			unsubscribed as is_closed
		undefine
			default_create
		redefine
			session_disconnect, session
		end

	KL_IMPORTED_ARRAY_ROUTINES
		export
			{NONE} all
		undefine
			default_create
		end

	ECLI_SQL_PARSER_CALLBACK
		undefine
			default_create
		end

create

	make

feature {} -- Initialization

	make, open (a_session : ECLI_SESSION)
			-- Create a statement for use on `session'
		require
			a_session_not_void: a_session /= Void --FIXME: VS-DEL
			a_session_connected: a_session.is_connected
			not_valid: not is_valid
		local
			ext_handle : XS_C_POINTER
		do
			default_create
			--| error handler
			create_error_handler (a_session)

			--| external values
			create ext_handle.make
			create impl_result_columns_count.make

			--| session
			session := a_session
			if session.exception_on_error then
				raise_exception_on_error
			end

			--| statement handle
			set_status_without_report ("ecli_c_allocate_statement", ecli_c_allocate_statement (session.handle, ext_handle.handle))
			handle := ext_handle.item

			--| name to position map table for parameters
			create name_to_position.make (10)
			name_to_position.set_equality_tester (create {KL_EQUALITY_TESTER[DS_LIST[INTEGER]]})
			initialize
			if is_valid then
				session.register_statement (Current)
			end
		ensure
			session_ok: session = a_session and not is_closed
			registered: session.is_registered_statement (Current)
			same_exception_on_error: exception_on_error = session.exception_on_error
			same_error_handler: error_handler = session.error_handler
			valid: 	is_valid
		end

feature {NONE} -- Initialization

	default_create
		do
			Precursor {ECLI_HANDLE}
			Precursor {ECLI_STATUS}
			--|
			create sql.make_empty
			create results.make_empty
			create parameters.make_empty
			--| metadata
			create parameters_description.make_empty
			create results_description.make_empty
			--| internals
			create impl_row_count.make
			create name_to_position.make_default
			create impl_sql.make (1)
			create {DS_LINKED_LIST[STRING]}impl_parameter_names.make
		end

	create_error_handler (a_session : ECLI_SESSION)
			-- create `error_handler´
		do
			error_handler := a_session.error_handler
		ensure
			error_handler_set: error_handler = a_session.error_handler
		end

	initialize
			-- Initialize internal state just before registering to session
		do
		end

feature -- Basic operations

	close
			-- Close statement and release external resources
		require
			valid_statement: is_valid
			not_closed: not is_closed
		do
			if not is_closed then
				session.unregister_statement (Current)
			end
			do_close
		ensure
			closed: 		is_closed
			unregistered: 	not (old session).is_registered_statement (Current)
			not_valid:  	not is_valid
			no_session: 	not (attached session)
		end

feature {ECLI_SESSION} -- Basic Operations

	do_close
			-- Close unconditionally without unregistering from the session
		require
			valid_statement: is_valid
			not_closed: not is_closed
		local
			session_default : like session
		do
			session := session_default
			release_handle
		ensure
			not_valid:  	not is_valid
			no_session: 	not attached session
		end

feature -- Access

	info : ECLI_DBMS_INFORMATION
			-- DBMS information
		do
-- ?? Not VEVI error while session is detachable???
			Result := session.info
		ensure
			info_not_void: Result /= Void --FIXME: VS-DEL
		end

	sql : STRING
			-- Sql statement to be executed

	parameter_positions (parameter_name : STRING) : DS_LIST[INTEGER]
			-- Positions of parameter `parameter_name' in `sql' statement.
		require
			valid_statement: is_valid
			parameter_name_ok: parameter_name /= Void --FIXME: VS-DEL
			has_parameter: parameters_count > 0
			defined_parameter: has_parameter (parameter_name)
		do
			Result := name_to_position.item (parameter_name)
		ensure
			Result_not_void: Result /= Void
			Result_not_empty: not Result.is_empty
		end

	parameter (parameter_name : STRING) : like parameter_anchor
			-- Parameter value of `parameter_name'
		require
			valid_statement: is_valid
			parameter_name_ok: parameter_name /= Void
			has_parameter: parameters_count > 0
			defined_parameter: has_parameter (parameter_name)
			parameters_not_void: parameters /= Void
		do
			Result := parameters.item (parameter_positions (parameter_name).first)
		ensure
			Result_not_void: Result /= Void
		end

	parameter_names : DS_LIST[STRING]
			-- Unique names of parameters in `sql' query
			--| FIXME: this should be a DS_SET[STRING] !
		require
			valid_statement: is_valid
		do
			if impl_parameter_names.is_empty and then not name_to_position.is_empty then
				create {DS_LINKED_LIST[STRING]} impl_parameter_names.make
				if attached name_to_position.new_cursor as table_cursor then
					from
						table_cursor.start
					until
						table_cursor.off
					loop
						impl_parameter_names.put_right (table_cursor.key)
						table_cursor.forth
					end
				end
			end
			Result := impl_parameter_names
		ensure
			Result_not_void: Result /= Void --FIXME: VS-DEL
			Result_count_less_or_equal_parameters_count: Result.count <= parameters_count
		end

--	cursor : ARRAY[attached like value_anchor] is
--		obsolete "Use `results'"
--		do Result := results end

	results : ARRAY[attached like value_anchor]
			-- Container of result values (i.e. buffers for transferring
			-- data from program to database) content is meaningful only
			-- while sweeping through a result set, i.e. `not off and has_result_set'

	parameters : ARRAY[attached like parameter_anchor]
			-- Current parameter values for the statement

	parameters_description : ARRAY[ECLI_PARAMETER_DESCRIPTION]
			-- Metadata for parameters, available after calling `describe_parameters' successfully

	results_description : ARRAY [ECLI_COLUMN_DESCRIPTION]
			-- Metadata for results, available after calling `describe_results'

	cursor_description : like results_description
		obsolete "Use `results_description'."
		do
			Result := results_description
		end

	last_bound_parameter_index : INTEGER
			-- Index of last *successfuly* bound parameter after `bind_parameters'.
			-- Zero if none has been bound.

feature -- Measurement

	modified_row_count : INTEGER
			-- Number of rows modified by some inserting, updating or deleting operation.
			-- Invalid for query operations
		require
			executed: is_executed
			not_a_query: not has_result_set
		do
			Result := impl_row_count.item.as_integer_32 --FIXME 64/32 bits
		end

	parameter_count : INTEGER
		obsolete "Please use `parameters_count' instead (note `parameters' is plural)."
		do Result := parameters_count end

	parameters_count : INTEGER
			-- Number of parameters in `sql'
		require
			valid_statement: is_valid
--			sql_meaningful: not sql.is_empty
		do
			Result := parameters_count_impl
		end

	result_column_count : INTEGER
		obsolete "Please use `result_columns_count' instead (note `columns' is plural)."
		do Result := result_columns_count end

	result_columns_count : INTEGER
			-- Number of columns in result-set
			-- 0 if no result set is available
		require
			valid_statement: is_valid
			executed_or_prepared: is_prepared or else is_executed
		do
			if impl_result_columns_count.item = -1 then
				get_result_columns_count
			end
			Result := impl_result_columns_count.item
		end

	fetched_columns_count : INTEGER
			-- Number of columns retrieved by latest `start' or `forth' operation

feature -- Status Report

	is_describe_parameters_capable : BOOLEAN
			-- Can `describe_parameters' be called ?
		require
			valid_statement: is_valid
			open: not is_closed
		do
			Result := session.is_describe_parameters_capable
		end

	has_results : BOOLEAN
			-- Has this statement a result-set ?
		obsolete "Use `has_result_set'."
		require
			valid_statement: is_valid
			executed_or_prepared: is_prepared or else is_executed
		do
			Result := has_result_set
		end

	has_another_result_set : BOOLEAN
			-- Has this statement another result-set ?

	has_result_set : BOOLEAN
			-- Has this statement a result-set ?
		require
			valid_statement: is_valid
			executed_or_prepared: is_prepared or else is_executed
		do
			Result := result_columns_count > 0
		ensure
			results: Result = (result_columns_count > 0)
		end

	has_parameters : BOOLEAN
			-- Has this statement some parameters ?
		require
			valid_statement: is_valid
--			request: sql /= Void
		do
			Result := (parameters_count > 0)
		ensure
			Result = (parameters_count > 0)
		end

	is_parsed : BOOLEAN
			-- Is the `sql' statement parsed for parameters ?
		require
			valid_statement: is_valid
		do
			Result := impl_is_parsed
		end

	is_prepared : BOOLEAN
			-- Is current `sql' query plan prepared by database server ?

	is_executed : BOOLEAN
			-- Is current `sql' executed ?

	is_prepared_execution_mode : BOOLEAN
			-- Is it a `prepared' execution mode ?

	bound_parameters :  BOOLEAN
			-- Have the parameters been bound ?

	off : BOOLEAN
			-- Is there no current cursor content ?
		require
			valid_statement: is_valid
		do
			Result := (before or after)
		ensure
			Result = (before or after)
		end

	after : BOOLEAN
			-- Is there no valid position to the right of current cursor position ?
		require
			valid_statement: is_valid
		do
			Result := cursor_status = cursor_after or else cursor_status = cursor_closed
		ensure
			Result = (cursor_status = cursor_after or else cursor_status = cursor_closed)
		end

	before : BOOLEAN
			-- Is cursor `before' results (no results or not yet started reading) ?
		require
			valid_statement: is_valid
		do
			Result := cursor_status = cursor_before
		ensure
			Result = (cursor_status = cursor_before)
		end

	has_parameter (name : STRING) : BOOLEAN
			-- Has the statement a `name' parameter ?
		require
			valid_statement: is_valid
			name_ok: name /= Void --FIXME: VS-DEL
		do
			Result := name_to_position.has (name)
		end

	can_trace : BOOLEAN
			-- Can Current trace itself ?
		do
			Result := (is_valid and is_parsed and
				 (is_prepared_execution_mode implies is_prepared) and
				 (parameters_count > 0 implies bound_parameters))
		ensure then
			definition : Result implies
				(is_valid and is_parsed and
				 (is_prepared_execution_mode implies is_prepared) and
				 (parameters_count > 0 implies bound_parameters))
		end

feature -- Status setting

	set_prepared_execution_mode
			-- Set execution mode where `prepare' evaluates the query plan of `sql' once
			-- and where `execute' just executes the query plan
		require
			valid_statement: is_valid
		do
			is_prepared_execution_mode := True
		ensure
			good_mode: is_prepared_execution_mode
		end

	set_immediate_execution_mode
			-- Set execution mode where `execute' (1) evaluates and (2) executes the query plan of `sql'
		require
			valid_statement: is_valid
		do
			is_prepared_execution_mode := False
		ensure
			good_mode: not is_prepared_execution_mode
		end

feature -- Cursor movement

	start
			-- Start iterating on result set
		require
			valid_statement: is_valid
			executed: is_executed and is_ok
			before: before
--			results_ready: results /= Void and then not array_routines.has(results,Void)
		do
			set_cursor_in
			fetch_next_row
		ensure
			results: not off implies (has_result_set and not before)
			fetched_columns: not off implies fetched_columns_count = result_columns_count.min (results.count)
		end

	forth
			-- Advance cursor in result set
		require
			valid_statement: is_valid
			executed: is_executed
			result_pending: not off and not before
--			results_ready: results /= Void and then not array_routines.has (results,Void)
		do
			fetch_next_row
		ensure
			fetched_columns: not off implies fetched_columns_count = result_columns_count.min (results.count)
		end

	finish, close_cursor
			-- Finish iterating on all result sets, releasing internal resources.
		require
			valid_statement: is_valid
			valid_state: is_executed
			has_result_set: has_result_set
		do
			if not after then
				set_cursor_after
				has_another_result_set := False
				set_status ("ecli_c_close_cursor", ecli_c_close_cursor (handle))
			end
			fetched_columns_count := 0
		ensure
			after: after
			fetched_columns: fetched_columns_count = 0
		end

	go_after
			-- Finish iterating on current result set.
		require
			valid_statement: is_valid
			valid_state: is_executed
			has_result_set: has_result_set
		do
			if not after then
				set_cursor_after
				set_status ("ecli_c_more_results", ecli_c_more_results (handle))
				if is_ok and then not is_no_data then
					has_another_result_set := True
				else
					has_another_result_set := False
					cursor_status := Cursor_closed
				end
			end
			fetched_columns_count := 0
		ensure
			after: after
			fetched_columns: fetched_columns_count = 0
		end

	forth_result_set
			-- Advance to next result set.
		require
			has_another_result_set: has_another_result_set
		do
			cursor_status := cursor_before
			impl_result_columns_count.put (-1)
			get_result_columns_count
			if not has_result_set then
				get_row_count
			end
		ensure
			before: before
		end

feature -- Element change

	set_sql (new_sql : STRING)
			-- Set `sql' statement to `new_sql'
		require
			valid_statement: is_valid
			sql_meaningful: not new_sql.is_empty
		do
			reset_status
			sql := new_sql
			name_to_position.wipe_out
			parser.parse (sql, Current)
			create impl_sql.make_from_string (parser.parsed_sql)
			set_parsed
			parameters_count_impl := parser.parameters_count
			create {DS_LINKED_LIST[STRING]}impl_parameter_names.make
			impl_result_columns_count.put (-1) -- do not know
			is_executed := False
			is_prepared := False
			create results_description.make_empty
			create parameters_description.make_empty
			create parameters.make_empty
			last_bound_parameter_index := 0
			bound_parameters := False
		ensure
			has_sql: sql = new_sql
			parsed:  is_parsed
			not_executed: not is_executed
			not_prepared: not is_prepared
			no_bound_parameters: not bound_parameters and then last_bound_parameter_index = 0
			no_more_parameters: parameters.is_empty
			reset_descriptions: parameters_description.is_empty and results_description.is_empty
			is_ok: is_ok
		end

	set_parameters (parameters_array : like parameters)
			-- Set `parameters' value with `parameters_array'
			-- all parameters are taken as input parameters
		require
			valid_statement: is_valid
			parameters_array_not_void: parameters_array /= Void --FIXME: VS-DEL
			parameters_array_valid_bounds: parameters_array.lower = 1 and then parameters_array.count = parameters_count
---			no_void_parameter: not array_routines.has (parameters_array, Void)
		do
			parameters := parameters_array
			bound_parameters := False
		ensure
			parameters_set: parameters = parameters_array
			not_bound: not bound_parameters
		end

	put_parameter (value : attached like parameter_anchor; parameter_name : STRING)
			-- Put `value' as `parameter_name'
			-- WARNING : Case sensitive !
		require
			valid_statement: is_valid
			statement_has_parameters: has_parameters
			value_not_void: value /= Void --FIXME: VS-DEL
			parameter_name_exists : parameter_name /= Void --FIXME: VS-DEL
			known_parameter_name: has_parameter (parameter_name)
		do
			put_parameter_with_hint (value, parameter_name, create {ECLI_INPUT_PARAMETER}.make (value))
		ensure
			parameter_set: parameter (parameter_name) = value --for each i in parameter_positions(key) it_holds parameters.item (i) = value
			not_bound: not bound_parameters
		end

--	set_cursor (row : like cursor) -- ARRAY[like value_anchor]) is
--		obsolete "Use `set_results' instead."
--		do
--			set_results (row)
--		end

	set_results (row : like results)
			-- Set `results' container with `row'
		require
			valid_statement: is_valid
			row_not_void: row /= Void --FIXME: VS-DEL
			row_lower: row.lower = 1
			row_count: row.count > 0
		do
			results := row
		ensure
			results_set: results = row
		end

feature {ECLI_SESSION} -- Miscellaneous

	session_disconnect (a_session : like session)
		do
			release_handle
			session := Void
		ensure then
			not is_valid
		end

feature {NONE} -- Miscellaneous

	release_handle
		do
			set_status_without_report ("ecli_c_free_statement", ecli_c_free_statement (handle))
			set_handle ( default_pointer)
		end

feature -- Basic operations

	execute
			-- Execute sql statement
		require
			valid_statement: is_valid
			query_is_parsed: is_parsed
			prepared_when_mode_prepared: is_prepared_execution_mode implies is_prepared
			parameters_set: parameters_count > 0 implies bound_parameters
		local
			value_pointer : XS_C_INT32
			exec_status : ECLI_STATUS_VALUE
--			colcount_status : ECLI_STATUS_VALUE
		do
			reset_status
			if is_executed then
				if has_result_set and then not after then
					finish
				end
				if parameters_count > 0 then
					bind_parameters
				end
			end
			if session.is_tracing then
				if session.tracer.is_tracing_time then
					session.tracer.begin_execution_timing
				end
			end
			if is_prepared_execution_mode then
				set_status ("ecli_c_execute", ecli_c_execute (handle) )
			else
				set_status ("ecli_c_execute_direct", ecli_c_execute_direct (handle, impl_sql.handle))
			end
			create exec_status.make_copy (Current)
			--| reset column count
			reset_result_columns_count
			--|
			if session.is_tracing and then attached session.tracer as l_tracer then
				trace (l_tracer)
				if session.tracer.is_tracing_time then
					session.tracer.end_execution_timing
				end
			end
			--| restore status
			status := exec_status.status
			if status = Sql_need_data then
				create value_pointer.make
				from
					set_status ("ecli_c_param_data", ecli_c_param_data (handle, value_pointer.handle))
				until
					status /= Sql_need_data
				loop
					parameters.item (value_pointer.item).put_parameter (Current, value_pointer.item)
					set_status ("ecli_c_param_data", ecli_c_param_data (handle, value_pointer.handle))
				end
			end
			if is_ok then
				is_executed := True
				if has_result_set then
					set_cursor_before
				else
					set_cursor_after
					get_row_count
				end
			else
				impl_result_columns_count.put (0)
				is_executed := False
			end
		ensure
			is_executed_implies_is_ok: is_executed implies is_ok
			consistent_cursor_state: is_executed implies
						((has_result_set implies before) or
						(not has_result_set implies after))
		end

	trace (a_tracer : ECLI_TRACER)
			-- Trace in `a_tracer'
		do
			a_tracer.trace (impl_sql.as_string, parameters)
		end

	describe_parameters
			-- Get metadata about parameters in `parameters_description'
		require
			valid_statement: is_valid
			describe_capable: is_describe_parameters_capable
			prepared: is_prepared
			has_parameters: parameters_count > 0
		local
			count, limit : INTEGER
			description : ECLI_PARAMETER_DESCRIPTION
		do
			limit := parameters_count
			create parameters_description.make_empty
			from
				reset_status
				count := 1
			until count > limit or not is_ok
			loop
				create description.make (Current, count)
				parameters_description.force (description, count)
				count := count + 1
			end
			if not is_ok then
				create parameters_description.make_empty
			end
		ensure
			parameter_description_updated: is_ok implies
				(not parameters_description.is_empty and then
				 parameters_description.count = parameters_count)
		end

	describe_cursor
		obsolete "Use `describe_results'."
		do
			describe_results
		end

	describe_results
			-- Get metadata about current result-set in `results_description'
		require
			valid_statement: is_valid
			executed_or_prepared: is_prepared or else is_executed
			has_result_set: has_result_set
		local
			count, limit : INTEGER
			description : ECLI_COLUMN_DESCRIPTION
		do
			limit := result_columns_count
			create results_description.make_filled (create {ECLI_COLUMN_DESCRIPTION}.make_iznogoud, 1, limit)
			from
				count := 1
				reset_status
			until count > limit or not is_ok
			loop
				create description.make (Current, count, 100)
				results_description.put (description, count)
				count := count + 1
			end
			if not is_ok then
				create results_description.make_empty
			end
		ensure
			results_described: is_ok implies
				(not results_description.is_empty and then results_description.lower = 1 and then results_description.count = result_columns_count)
		end

	bind_parameters
			-- Bind parameters
		require
			valid_statement: is_valid
			parameters_exist: parameters_count > 0
			parameters_not_void: parameters /= Void --FIXME: VS-DEL
			parameters_are_set: parameters.count >= parameters_count
		local
			parameter_index : INTEGER
		do
			from
				parameter_index := 1
				reset_status
			until
				not is_ok or else parameter_index > parameters.count
			loop
				if bound_parameters then
					rebind_parameter_if_buffer_too_small (parameter_index)
				else
					bind_one_parameter (parameter_index)
				end
				parameter_index := parameter_index + 1
			end
			if is_ok then
				last_bound_parameter_index := parameter_index - 1
				bound_parameters := True
			else
				last_bound_parameter_index := (0).max(parameter_index - 2)
				bound_parameters := False
			end
		ensure
			bound_parameters: is_ok implies bound_parameters
			parameter_index_less: not is_ok implies last_bound_parameter_index < parameters.upper
			parameter_index_n: is_ok implies last_bound_parameter_index = parameters.upper
		end

	prepare
			-- Prepare the sql statement
		require
			valid_statement: is_valid
		do
			if is_executed and then (has_result_set and  not after) then
				finish
			end
			set_status ("ecli_c_prepare", ecli_c_prepare (handle, impl_sql.handle))
			if is_ok then
				get_result_columns_count
				--| getting result columns count can get more error than a single prepare
				if is_ok then
					is_prepared := True
					set_prepared_execution_mode
				end
			end

		ensure
			prepared_mode: is_ok implies is_prepared_execution_mode
			prepared_stmt: is_ok implies is_prepared
		end

feature -- Inapplicable

	value_anchor : detachable ECLI_VALUE
		do
		end

	parameter_anchor : detachable ECLI_VALUE
		do
		end


--	array_routines : KL_ARRAY_ROUTINES[ANY] is do Result := Any_array_ end

feature {ECLI_SQL_PARSER} -- Callback

	add_new_parameter (a_parameter_name : STRING; a_position : INTEGER)
		local
			position_list : DS_LIST[INTEGER]
		do
			if name_to_position.has (a_parameter_name) then
				name_to_position.item (a_parameter_name).put_right (a_position)
			else
				create {DS_LINKED_LIST[INTEGER]}position_list.make
				position_list.put_right (a_position)
				name_to_position.force (position_list, a_parameter_name)
			end
		end

	on_table_literal (a_sql: STRING; i_begin, i_end: INTEGER)
		do
		end

	on_parameter (a_sql: STRING; i_begin, i_end: INTEGER)
		do
		end

	on_string_literal (a_sql: STRING; i_begin, i_end: INTEGER)
		do
		end

	on_word (a_sql: STRING; i_begin, i_end: INTEGER)
		do
		end

	on_parameter_marker (a_sql: STRING; index: INTEGER)
		do
		end

feature {ECLI_STATUS} -- Inapplicable

	can_use_arrayed_parameters : BOOLEAN
			-- Can we use arrayed parameters ?
		do
			set_status ("ecli_c_set_integer_statement_attribute", ecli_c_set_integer_statement_attribute (handle, Sql_attr_paramset_size, 2))
			Result := is_ok
			--| get back to original situation
			set_status ("ecli_c_set_integer_statement_attribute", ecli_c_set_integer_statement_attribute (handle, Sql_attr_paramset_size, 1))
		end

	can_use_arrayed_results : BOOLEAN
			-- Can we use arrayed results ?
		do
			set_status ("ecli_c_set_integer_statement_attribute", ecli_c_set_integer_statement_attribute (handle, Sql_attr_row_bind_type, Sql_bind_by_column))
			Result := is_ok
		end

feature {NONE} -- Implementation

	name_to_position : DS_HASH_TABLE [DS_LIST[INTEGER], STRING]

	set_parsed
		require
			valid_statement: is_valid
		do
			impl_is_parsed := True
		end

	reset_result_columns_count
		do
			impl_result_columns_count.put (-1)
		ensure
			reset: impl_result_columns_count.item = -1
		end

	get_result_columns_count
		require
			valid_statement: is_valid
		do
			set_status ("ecli_c_result_column_count", ecli_c_result_column_count (handle, impl_result_columns_count.handle))
			if not is_ok then
				impl_result_columns_count.put (-1)
			end
		end

	bind_one_parameter (i : INTEGER)
		require
			valid_statement: is_valid
		local
			a_parameter : ECLI_VALUE
		do
			a_parameter := parameters.item (i)
			a_parameter.bind_as_parameter (Current, i)
		end

	rebind_parameter_if_buffer_too_small (i : INTEGER)
		local
			l_parameter : ECLI_VALUE
		do
			l_parameter := parameters.item (i)
			if l_parameter.is_buffer_too_small then
				bind_one_parameter (i)
			end
		end

	fill_results
		require
			valid_statement: is_valid
			results_not_void: results /= Void --FIXME: VS-DEL
			results_not_empty: not results.is_empty
			-- results_arity: results.count >= result_columns_count
		local
			index, index_max : INTEGER
			current_value : ECLI_VALUE
			l_results : ARRAY[ECLI_VALUE]
		do
			from
				index := 1
				index_max := result_columns_count.min (results.count)
				l_results := results
			until
				index > index_max
			loop
				current_value := l_results.item (index)
				current_value.read_result (Current, index)
				index := index + 1
			end
			fetched_columns_count := result_columns_count.min (results.count)
		ensure
			fetched_columns_count_set: fetched_columns_count = result_columns_count.min (results.count)
		end

	session : detachable ECLI_SESSION

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER
			-- Implementation of deferred feature
		require else
			valid_statement: is_valid
		do
			Result := ecli_c_statement_error (handle, record_index, state, native_error, message, buffer_length, length_indicator)
		end

	impl_row_count : ECLI_API_SQLLEN
		-- Buffer for storing number of rows affected

	impl_result_columns_count : XS_C_INT32
		-- -1 : do not know; must call `get_result_column_count'
		--  0 : no result-set
		-- >0  :number of columns in result-set

	impl_parameter_names : DS_LIST[STRING]

	impl_sql : XS_C_STRING
		-- SQL string without parameter names, only with '?' markers

	impl_is_parsed : BOOLEAN

	set_cursor_before
		do
			cursor_status := cursor_before
		ensure
			before
		end

	set_cursor_in
		do
			cursor_status := cursor_in
		ensure
			not off and not before
		end

	set_cursor_after
		do
			cursor_status := cursor_after
		end

	fetch_next_row
		require
			valid_statement: is_valid
		do
			set_status ("ecli_c_fetch", ecli_c_fetch (handle))
			if status = sql_no_data then
				go_after
			else
				fill_results
			end
		end

	is_ready_for_disposal : BOOLEAN
			-- Is this object ready for disposal ?
		do
			Result := is_closed
		end

	disposal_failure_reason : STRING
			-- Why is this object not ready_for_disposal
		once
			Result := "ECLI_STATEMENT must be closed te be disposable."
		end

	parser_impl : detachable ECLI_SQL_PARSER

	parser : ECLI_SQL_PARSER
		do
			if attached parser_impl as p then
				Result := p
			else
				create Result.make
				parser_impl := Result
			end
		end

		parameters_count_impl : INTEGER

	create_parameters
		require
			parameters_empty: parameters.is_empty
		do
			create parameters.make_filled (default_parameter, 1, parameters_count)
		ensure
			parameters_not_void: parameters /= Void --FIXME: VS-DEL
			parameters_count_consistent: parameters.count = parameters_count
		end

	put_single_parameter_with_hint (value : attached like parameter_anchor; position : INTEGER; hint : ECLI_STATEMENT_PARAMETER)
		do
			parameters.put (value, position)
		end

	put_parameter_with_hint (value : attached like parameter_anchor; key : STRING; hint : ECLI_STATEMENT_PARAMETER)
			-- Set all parameters named `key' occurring in `sql' with `value'
			-- WARNING : Case sensitive !
		require
			valid_statement: is_valid
			has_parameters: parameters_count > 0
			value_ok: value /= Void --FIXME: VS-DEL
			key_ok : key /= Void --FIXME: VS-DEL
			known_key: has_parameter (key)
		local
			plist : DS_LIST[INTEGER]
		do
			if parameters.is_empty then
				create_parameters
			end
			from plist := parameter_positions (key)
				plist.start
			until
				plist.off
			loop
				put_single_parameter_with_hint (value, plist.item_for_iteration, hint)
				plist.forth
			end
			bound_parameters := False
		ensure
			parameter_set: True --for each i in parameter_positions(key) it_holds parameters.item (i) = value
			not_bound: not bound_parameters
		end

	cursor_status : INTEGER
			-- Cursor status

	cursor_before : INTEGER = 1
	cursor_in : INTEGER = 2
	cursor_after : INTEGER = 3
	cursor_closed : INTEGER = 4

feature {NONE} -- Hooks for descendants

	get_row_count
			-- Get number of rows affected by latest execution
		require
			executed: is_executed
			not_has_result_set: not has_result_set
		do
			if impl_row_count = Void then --FIXME: VS-DEL
				create impl_row_count.make --FIXME: VS-DEL
			end --FIXME: VS-DEL
			set_status ("ecli_c_row_count", ecli_c_row_count (handle, impl_row_count.handle))
		ensure
			impl_row_count_not_void: impl_row_count /= Void --FIXME: VS-DEL
		end

	default_parameter : attached like parameter_anchor
		do
			create {ECLI_VARCHAR}Result.make (1)
		end

invariant
	existing_session_implies_not_closed: attached session implies not is_closed
	parameter_index_bounds: last_bound_parameter_index >= 0 and then (parameters /= Void implies last_bound_parameter_index <= parameters.upper) --FIXME: VS-DEL
--	parameters_description_without_void: parameters_description /= Void implies not array_routines.has (parameters_description,Void)

end
