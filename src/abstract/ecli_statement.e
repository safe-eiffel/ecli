indexing
	description:

		 "Objects that represent statements that manipulate %
		% a database. They are defined on a connected session.  %
		% Provide CLI/ODBC CORE and some Level 1 functionalities."

	author: 	"Paul G. Crismer"
	date: 		"$Date$"
	revision: 	"$Revision$"
	licensing: 	"See notice at end of class"

class
	ECLI_STATEMENT

inherit
	ECLI_STATUS
		export
			{ECLI_STATEMENT, ECLI_DATA_DESCRIPTION, ECLI_VALUE} set_status
		undefine
			dispose
		end

	ECLI_HANDLE
		export
			{ECLI_STATEMENT, ECLI_DATA_DESCRIPTION, ECLI_VALUE} handle
		end

	ECLI_TRACEABLE
	
	PAT_SUBSCRIBER
		rename
			publisher as session,
			published as session_disconnect,
			has_publisher as has_session,
			unsubscribed as is_closed
		redefine
			session_disconnect
		end

creation
	make

feature -- Initialization

	make, open (a_session : ECLI_SESSION) is
			-- create a statement for use on 'session'
		require
			a_session_exists: a_session /= Void
			a_session_connected: a_session.is_connected
			not_valid: not is_valid
		local
			eq : KL_EQUALITY_TESTER[DS_LIST[INTEGER]]
			ext_handle : XS_C_POINTER
		do
			create ext_handle.make
			create impl_result_columns_count.make
			session := a_session
			if session.exception_on_error then
				raise_exception_on_error
			end
			set_status (ecli_c_allocate_statement (session.handle, ext_handle.handle))
			handle := ext_handle.item
			if is_valid then
				session.register_statement (Current)
			end
			!!name_to_position.make (10)
			!!eq
			name_to_position.set_equality_tester (eq)
		ensure
			session_ok: session = a_session and not is_closed
			registered: session.is_registered_statement (Current)
			same_exception_on_error: exception_on_error = session.exception_on_error
			valid: 	is_valid
		end

feature -- Obsolete

	attach (a_session : ECLI_SESSION) is
		obsolete "Use open/close instead of attach/unattach"
		do
		end

	release is
		obsolete "Use open/close instead of attach/unattach"
		do
		end

feature -- Basic Operations

	close is
			-- close statement and release external resources
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
			no_session: 	session = Void
		end

feature {ECLI_SESSION} -- Basic Operations

	do_close is
			-- 
		require
			valid_statement: is_valid
			not_closed: not is_closed
		do
			session := Void
			release_handle			
		ensure
			not_valid:  	not is_valid
			no_session: 	session = Void			
		end
		
feature -- Access

	sql : STRING
			-- sql statement to be executed

	parameter_positions (name : STRING) : DS_LIST[INTEGER] is
			-- positions of parameter 'name'
			-- same <name> can occur at multiple places in a SQL statement
			-- for example in a WHERE clause
		require
			valid_statement: is_valid
			name_ok: name /= Void
			has_parameter: parameters_count > 0
			defined_parameter: has_parameter (name)
		do
			Result := name_to_position.item (name)
		ensure
			good_position: Result /= Void and not Result.is_empty
		end

	parameter (name : STRING) : like parameter_anchor is
			-- parameter value of `name'
		require
			valid_statement: is_valid
			name_ok: name /= Void
			has_parameter: parameters_count > 0
			defined_parameter: has_parameter (name)
			parameters_exist: parameters /= Void
		do
			Result := parameters.item (parameter_positions (name).first)
		end

	parameter_names : DS_LIST[STRING] is
			-- names of parameters in `sql' query
		require
			valid_statement: is_valid
		local
			table_cursor : DS_HASH_TABLE_CURSOR[DS_LIST[INTEGER],STRING]
		do
			if impl_parameter_names = Void then
				!DS_LINKED_LIST[STRING]! impl_parameter_names.make
				table_cursor := name_to_position.new_cursor
				from
					table_cursor.start
				until
					table_cursor.off
				loop
					impl_parameter_names.put_right (table_cursor.key)
					table_cursor.forth
				end
			end
			Result := impl_parameter_names
		ensure
			parameters_count: Result.count <= parameters_count
		end

	cursor : ARRAY[like value_anchor]
			-- container of result values (i.e. buffers for transferring
			-- data from program to database) content is meaningful only
			-- while sweeping through a result set, i.e. "not off"

	parameters : ARRAY[like parameter_anchor]
			-- current parameter values for the statement

	parameters_description : ARRAY[ECLI_PARAMETER_DESCRIPTION]
			-- parameter metadata

	cursor_description : ARRAY [ECLI_COLUMN_DESCRIPTION]
			-- cursor values metadata 

	last_bound_parameter_index : INTEGER
			-- index of last *successfuly* bound parameter after `bind_parameters'. Zero if none
			
feature -- Measurement

	parameter_count : INTEGER is
		obsolete "Please use 'parameters_count' instead (note 'parameters' is plural)."
		do Result := parameters_count end
		
	parameters_count : INTEGER is
			-- number of parameters in 'sql'
		require
			valid_statement: is_valid
			request: sql /= Void
		do
			--Result := sql.occurrences ('?')
			Result := parameters_count_impl
		end

	result_column_count : INTEGER is 
		obsolete "Please use 'result_columns_count' instead (note 'columns' is plural)." 
		do Result := result_columns_count end
	
	result_columns_count : INTEGER is
			-- number of columns in result-set
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
			-- number of columns retrieved by latest start or forth operation
		
feature -- Status Report

	is_describe_parameters_capable : BOOLEAN is
			-- can `describe_parameters' be called ?
		require
			valid_statement: is_valid
			open: not is_closed
		do
			Result := session.is_describe_parameters_capable
		end
		
	has_results : BOOLEAN is
			-- has this statement a result-set ?
		require
			valid_statement: is_valid
			executed_or_prepared: is_prepared or else is_executed
		do
			Result := result_columns_count > 0
		ensure
			results: Result = (result_columns_count > 0)
		end

	has_parameters : BOOLEAN is
			-- has this statement some parameters ?
		require
			valid_statement: is_valid
			request: sql /= Void
		do
			Result := (parameters_count > 0)
		ensure
			Result = (parameters_count > 0)
		end

	is_parsed : BOOLEAN is
			-- is the 'sql' statement parsed for parameters ?
		require
			valid_statement: is_valid
		do
			Result := impl_is_parsed
		end

	is_prepared : BOOLEAN
			-- is current `sql' query plan prepared by database server ?

	is_executed : BOOLEAN
			-- is current `sql' executed ?

	is_prepared_execution_mode : BOOLEAN
			-- is it a 'prepared' execution mode ?

	bound_parameters :  BOOLEAN
			-- have the parameters been bound ?

	off : BOOLEAN is
			-- is there no current cursor content ?
		require
			valid_statement: is_valid
		do
			Result := (before or after)
		ensure
			Result = (before or after)
		end

	after : BOOLEAN is
			-- is there no valid position to the right of current cursor position ?
		require
			valid_statement: is_valid
		do
			Result := cursor_status = cursor_after
		ensure
			Result = (cursor_status = cursor_after)
		end

	before : BOOLEAN is
			-- is cursor 'before' results (no results or not yet started reading) ?
		require
			valid_statement: is_valid
		do
			Result := cursor_status = cursor_before
		ensure
			Result = (cursor_status = cursor_before)
		end

	has_parameter (name : STRING) : BOOLEAN is
			-- has the statement a `name' parameter ?
		require
			valid_statement: is_valid
			name_ok: name /= Void
		do
			Result := name_to_position.has (name)
		end

	cursor_status : INTEGER
			-- cursor status

	cursor_before, cursor_in, cursor_after : INTEGER is unique
			-- cursor status values

	can_trace : BOOLEAN is
			-- can Current trace itself ?
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

	set_prepared_execution_mode is
			-- set prepared execution mode
			-- `sql' must be prepared before being executed
		require
			valid_statement: is_valid
		do
			is_prepared_execution_mode := True
		ensure
			good_mode: is_prepared_execution_mode
		end

	set_immediate_execution_mode is
			-- query plan is evaluated each time `sql' is executed
		require
			valid_statement: is_valid
		do
			is_prepared_execution_mode := False
		ensure
			good_mode: not is_prepared_execution_mode
		end

feature -- Cursor movement


	start is
			-- get first result row, if available
			-- min (result_columns_count, cursor.count) items shall be retrieved
		require
			valid_statement: is_valid
			executed: is_executed and is_ok
			before: before
			cursor_ready: cursor /= Void and then not array_routines.has(cursor,Void)
		do
			set_cursor_in
			fetch_next_row
		ensure
			results: not off implies (has_results and not before)
			fetched_columns: not off implies fetched_columns_count = result_columns_count.min (cursor.count)
		end

	forth is
			-- get next result row
			-- min (result_columns_count, cursor.count) items shall be retrieved
		require
			valid_statement: is_valid
			executed: is_executed
			result_pending: not off and not before
			cursor_ready: cursor /= Void and then not array_routines.has (cursor,Void)
		do
			fetch_next_row
		ensure
			fetched_columns: not off implies fetched_columns_count = result_columns_count.min (cursor.count)			
		end

	close_cursor, go_after is
			-- go after the last result row and release internal cursor state
		require
			valid_statement: is_valid
			valid_state: is_executed and not after
			has_results: has_results
		do
			set_status (ecli_c_close_cursor (handle))
			set_cursor_after
			fetched_columns_count := 0
		ensure
			after: after
			fetched_columns: fetched_columns_count = 0
		end

feature -- Element change

	set_sql (a_sql : STRING) is
			-- set 'sql' statement to 'a_sql'
		require
			valid_statement: is_valid
		do
			sql := a_sql
			name_to_position.wipe_out
			parser.parse (sql, Current)
			create impl_sql.make_from_string (parser.parsed_sql) -- parsed_sql (sql)
			set_parsed
			parameters_count_impl := parser.parameters_count
			impl_parameter_names := Void
			impl_result_columns_count.put (-1) -- do not know
			is_executed := False
			is_prepared := False
			cursor_description := Void
			parameters_description := Void
			parameters := Void
			bound_parameters := False
		ensure
			has_sql: sql = a_sql
			parsed:  is_parsed
			not_executed: not is_executed
			not_prepared: not is_prepared
			no_bound_parameters: not bound_parameters
			no_more_parameters: parameters = Void
			reset_descriptions: parameters_description = Void and cursor_description = Void
		end

	set_parameters (param : like parameters) is
			-- set parameters value with 'param'
		require
			valid_statement: is_valid
			param_exist: param /= Void
			param_lower: param.lower = 1
			param_count: param.count = parameters_count
			params_not_void: not array_routines.has (param, Void)
		do
			parameters := param
			bound_parameters := False
		ensure
			parameters_set: parameters = param
			not_bound: not bound_parameters
		end

	put_parameter (value : like parameter_anchor; key : STRING) is
			-- set parameter 'key' with 'value'
			-- WARNING : Case sensitive !
		require
			valid_statement: is_valid
			has_parameters: parameters_count > 0
			value_ok: value /= Void
			key_ok : key /= Void
			known_key: has_parameter (key)
		local
			plist : DS_LIST[INTEGER]
		do
			if parameters = Void then
				!! parameters.make (1, parameters_count)
			end
			from plist := parameter_positions (key)
				plist.start
			until
				plist.off
			loop
				parameters.put (value, plist.item_for_iteration)
				plist.forth
			end
			bound_parameters := False
		ensure
			parameter_set: True --for each i in parameter_positions(key) it_holds parameters.item (i) = value
			not_bound: not bound_parameters
		end

	set_cursor (row : like cursor) is -- ARRAY[like value_anchor]) is
			-- set cursor container with 'row'
		require
			valid_statement: is_valid
			row_exist: row /= Void
			row_lower: row.lower = 1
			row_count: row.count > 0
			is_executed: is_executed
		do
			cursor := row
		ensure
			cursor_set: cursor = row
		end

feature {ECLI_SESSION} -- Miscellaneous

	session_disconnect (a_session : like session) is
		do
			release_handle
			session := Void
		ensure then
			not is_valid
		end

feature {NONE} -- Miscellaneous

	release_handle is
		do
			set_status (ecli_c_free_statement (handle))
			set_handle ( default_pointer)
		end

feature -- Basic operations

	execute is
		-- execute sql statement
		require
			valid_statement: is_valid
			query_is_parsed: is_parsed
			prepared_when_mode_prepared: is_prepared_execution_mode implies is_prepared
			parameters_set: parameters_count > 0 implies bound_parameters
		local
			tools : expanded ECLI_EXTERNAL_TOOLS
			
		do
			if session.is_tracing then
				trace (session.tracer)
			end
			if is_executed and then has_results and then not after then
				close_cursor
			end
			if is_prepared_execution_mode then
				set_status (ecli_c_execute (handle) )
			else
				set_status (ecli_c_execute_direct (handle, impl_sql.handle))
			end
			if is_ok then
				is_executed := True
				if has_results then
					set_cursor_before
				else
					set_cursor_after
				end
			else
				impl_result_columns_count.put (0)
			end
		ensure
			executed: is_executed implies is_ok
			cursor_state: is_executed implies
						((has_results implies before) or
						(not has_results implies after))
		end

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.trace (impl_sql.item, parameters)
		end
		
	describe_parameters is
			-- put description of parameters in 'parameters_description'
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
			!! parameters_description.make (1, limit)
			from
				count := 1
			until count > limit or not is_ok
			loop
				!! description.make (Current, count)
				parameters_description.put (description, count)
				count := count + 1
			end
			if not is_ok then
				parameters_description := Void
			end
		ensure
			description: is_ok implies
				(parameters_description /= Void and then
				 parameters_description.count = parameters_count)
		end

	describe_cursor is
			-- get metadata about current result-set in 'cursor_description'
		require
			valid_statement: is_valid
			executed_or_prepared: is_prepared or else is_executed 
			has_results: has_results
		local
			count, limit : INTEGER
			description : ECLI_COLUMN_DESCRIPTION
		do
			limit := result_columns_count
			!! cursor_description.make (1, limit)
			from
				count := 1
			until count > limit or not is_ok
			loop
				!! description.make (Current, count, 100)
				cursor_description.put (description, count)
				count := count + 1
			end
			if not is_ok then
				cursor_description := Void
			end
		ensure
			description: is_ok implies
				(cursor_description /= Void and then cursor_description.lower = 1 and then cursor_description.count = result_columns_count)
		end

	bind_parameters is
			-- bind parameters
		require
			valid_statement: is_valid
			parameters_exist: parameters /= Void and then parameters.count >= parameters_count
		local
			parameter_index : INTEGER
		do
			from
				parameter_index := 1
			until
				not is_ok or else parameter_index > parameters.count
			loop
				bind_one_parameter (parameter_index)
				parameter_index := parameter_index + 1
			end
			if is_ok then
				last_bound_parameter_index := parameter_index - 1
				bound_parameters := True
			else
				last_bound_parameter_index := parameter_index - 2
				bound_parameters := False
			end
		ensure
			bound_parameters: is_ok implies bound_parameters
			parameter_index_less: not is_ok implies last_bound_parameter_index < parameters.upper  
			parameter_index_n: is_ok implies last_bound_parameter_index = parameters.upper
			parameter_index_bounds: last_bound_parameter_index >= 0 and last_bound_parameter_index <= parameters.upper
		end

	prepare is
			-- prepare the sql statement
		require
			valid_statement: is_valid
		local
			tools : expanded ECLI_EXTERNAL_TOOLS
		do
			if is_executed and then (has_results and  not after) then
				close_cursor
			end
			set_status (ecli_c_prepare (handle, impl_sql.handle))
			if is_ok then
				is_prepared := True
				set_prepared_execution_mode
			end

		ensure
			prepared_mode: is_ok implies is_prepared_execution_mode
			prepared_stmt: is_ok implies is_prepared
		end

feature -- Inapplicable

	value_anchor : ECLI_VALUE is
		do
		end

	parameter_anchor : ECLI_VALUE is
		do
		end
		
	array_routines : expanded KL_ARRAY_ROUTINES[ANY]

feature {ECLI_SQL_PARSER} -- Callback

	add_new_parameter (a_parameter_name : STRING; a_position : INTEGER) is
		require
			valid_statement: is_valid
		local
			position_list : DS_LIST[INTEGER]
		do
			if name_to_position.has (a_parameter_name) then
				name_to_position.item (a_parameter_name).put_right (a_position)
			else
				!DS_LINKED_LIST[INTEGER]!position_list.make
				position_list.put_right (a_position)
				name_to_position.force (position_list, a_parameter_name)
			end
		end

feature {ECLI_STATUS} -- Inapplicable

	can_use_arrayed_parameters : BOOLEAN is
			-- can we use arrayed parameters ?
		do
			set_status (ecli_c_set_integer_statement_attribute (handle, Sql_attr_paramset_size, 2))
			Result := is_ok
			--| get back to original situation
			set_status (ecli_c_set_integer_statement_attribute (handle, Sql_attr_paramset_size, 1))
		end

	can_use_arrayed_results : BOOLEAN is
			-- can we use arrayed results ?
		do
			set_status (ecli_c_set_integer_statement_attribute (handle, Sql_attr_row_bind_type, Sql_bind_by_column))
			Result := is_ok
		end

feature {NONE} -- Implementation

--	parsed_sql (s : STRING) : STRING is
--			-- parse s, replacing every '?<name>' by '?'
--			-- and set up the name to position translation table
--			-- <name> is [a-zA-Z_0-9]+
--		local
--			eq : KL_EQUALITY_TESTER[DS_LIST[INTEGER]]
--			param_count, param_number, i_start, i_begin_parameter_name, i_end_parameter_name : INTEGER
--			name_found : BOOLEAN
--			name : STRING
--			string_routines : expanded KL_STRING_ROUTINES
--		do
--			Result := string_routines.make (s.count)
--			param_count := s.occurrences ('?')
--			--| create or resize translation table
--			if param_count > 0 then
--				if name_to_position = Void then
--					!! name_to_position.make (param_count)
--					!! eq
--					name_to_position.set_equality_tester (eq)
--				else
--					if param_count > name_to_position.capacity then
--						name_to_position.resize (param_count)
--					end
--					name_to_position.wipe_out
--				end
--				-- | loop through parameters
--				-- | * insert a name to position item
--				-- | * copy s to Result, except the parameter names
--				from
--					i_start := 1
--					param_number := 1
--				variant s.count+1 - i_start
--				until
--					param_number > param_count or i_start > s.count
--				loop
--					-- copy s[i_start..i_begin_parameter_name-1], where s@(i_begin_parameter_name-1) = '?'
--					from
--						i_begin_parameter_name := i_start
--					until
--						s.item (i_begin_parameter_name) = '?'
--					loop
--						Result.extend (s.item (i_begin_parameter_name))
--						i_begin_parameter_name := i_begin_parameter_name + 1
--					end
--					Result.extend (s.item (i_begin_parameter_name))
--					i_begin_parameter_name := i_begin_parameter_name + 1
--
--					--| go past parameter name
--					from
--						i_end_parameter_name := i_begin_parameter_name+1
--						name_found := False
--					until
--						 name_found or i_end_parameter_name > s.count
--					loop
--						inspect (s.item (i_end_parameter_name))
--							when 'a'..'z', 'A'..'Z', '0'..'9', '_' then
--								i_end_parameter_name := i_end_parameter_name + 1
--							else
--								name_found := True
--						end
--					end
--					-- | parameter name is substring (i_begin_parameter_name, i_end_parameter_name-1)
--					-- | put its position in the translation table
--					name := s.substring(i_begin_parameter_name, i_end_parameter_name -1)
--					--
--					-- | same parameter name can occur at multiple position
--					--
--					add_new_parameter (name, param_number)
--					-- | prepare for next iteration
--					i_start := i_end_parameter_name
--					param_number := param_number + 1
--				end
--				-- copy s[i_start..s.count] to Result
--				from
--				until
--					i_start > s.count
--				loop
--					Result.extend (s.item(i_start))
--					i_start := i_start + 1
--				end
--			else
--				Result.copy (s)
--			end
--			set_parsed
--		ensure
--			is_parsed: is_parsed
--		end

	name_to_position : DS_HASH_TABLE [DS_LIST[INTEGER], STRING]

	set_parsed is
		require
			valid_statement: is_valid
		do
			impl_is_parsed := True
		end

	get_result_columns_count is
		require
			valid_statement: is_valid
		do
			set_status (ecli_c_result_column_count (handle, impl_result_columns_count.handle))
		end

	bind_one_parameter (i : INTEGER) is
		require
			valid_statement: is_valid
		local
			a_parameter : ECLI_VALUE
		do
			a_parameter := parameters.item (i)
			a_parameter.bind_as_parameter (Current, i)
		end

	fill_cursor is
		require
			valid_statement: is_valid
			cursor_exists: cursor /= Void
			-- cursor_arity: cursor.count >= result_columns_count
		local
			index, index_max : INTEGER
			current_value : ECLI_VALUE
			l_cursor : ARRAY[ECLI_VALUE]
		do
			from
				index := 1
				index_max := result_columns_count.min (cursor.count)
				l_cursor := cursor
			until
				index > index_max
			loop
				current_value := l_cursor.item (index)
				current_value.read_result (Current, index)
				index := index + 1
			end
			fetched_columns_count := result_columns_count.min (cursor.count)
		ensure
			fetched_columns_count_set: fetched_columns_count = result_columns_count.min (cursor.count)
		end

	session : ECLI_SESSION

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER  is
			-- Implementation of deferred feature
		require else
			valid_statement: is_valid
		do
			Result := ecli_c_statement_error (handle, record_index, state, native_error, message, buffer_length, length_indicator)
		end


	impl_result_columns_count : XS_C_INT32
		-- -1 : do not know; must call `get_result_column_count'
		--  0 : no result-set
		-- >0  :number of columns in result-set

	impl_parameter_names : DS_LIST[STRING]

	impl_sql : XS_C_STRING
		-- SQL string without parameter names, only with '?' markers

	impl_is_parsed : BOOLEAN

	set_cursor_before is
		do
			cursor_status := cursor_before
		ensure
			before
		end

	set_cursor_in is
		do
			cursor_status := cursor_in
		ensure
			not off and not before
		end

	set_cursor_after is
		do
			cursor_status := cursor_after
		end

	fetch_next_row is
		require
			valid_statement: is_valid
		do
			set_status (ecli_c_fetch (handle))
			if status = sql_no_data then
				close_cursor
			else
				fill_cursor
			end
		end

	is_ready_for_disposal : BOOLEAN is
			-- is this object ready for disposal ?
		do
			Result := is_closed
		end

	disposal_failure_reason : STRING is
			-- why is this object not ready_for_disposal
		once
			Result := "ECLI_STATEMENT must be closed te be disposable."
		end

	parser_impl : ECLI_SQL_PARSER
	
	parser : ECLI_SQL_PARSER is
		do
			if parser_impl = Void then
				create parser_impl.make
			end
			Result := parser_impl
		end
		
		parameters_count_impl : INTEGER

invariant
	closed_is_no_session: session /= Void implies not is_closed

end -- class ECLI_STATEMENT
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
