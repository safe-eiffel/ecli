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
		end

	ECLI_HANDLE
		redefine
			prepare_for_disposal
		end

	PAT_SUBSCRIBER
		rename
			publisher as session,
			published as session_disconnect,
			has_publisher as has_session,
			unsubscribed as unattached
		redefine
			session, session_disconnect
		end

creation
	make

feature {NONE} -- Initialization

	make (a_session : ECLI_SESSION) is
			-- create a statement for use on 'session'
		require
			a_session_exists: a_session /= Void
			a_session_connected: a_session.is_connected
		do
			unattached := True
			attach (a_session)
		ensure
			session_ok: session = a_session and not unattached
			registered: session.is_registered_statement (Current)
			valid: is_valid
		end

feature -- 

	attach (a_session : ECLI_SESSION) is
		require
			unattached: unattached
			a_session_exists: a_session /= Void
			a_session_connected: a_session.is_connected
		do
			session := a_session
			set_status (ecli_c_allocate_statement (session.handle, $handle))
			if is_valid then
				session.register_statement (Current)
			end
			unattached := False
		ensure
			attached: session = a_session and not unattached
			registered: session.is_registered_statement (Current) and not unattached
			valid: is_valid
		end

	release is
		require
			valid_statement: is_valid
		do
			prepare_for_disposal
			release_handle
		ensure
			unattached: unattached and not (old session).is_registered_statement (Current)
			not_valid:  not is_valid
		end

feature -- Access

	sql : STRING

	parameter_positions (name : STRING) : DS_LIST[INTEGER] is
			-- positions of parameter 'name'
			-- same <name> can occur at multiple places in a SQL statement
			-- for example in a WHERE clause
		require
			valid_statement: is_valid
			name_ok: name /= Void
			has_parameter: parameter_count > 0
			defined_parameter: has_parameter (name)
		do
			Result := name_to_position.item (name)
		ensure
			good_position: Result /= Void and not Result.is_empty
		end

	parameter (name : STRING) : like value_anchor is
		require
			valid_statement: is_valid
			name_ok: name /= Void
			has_parameter: parameter_count > 0
			defined_parameter: has_parameter (name)
			parameters_exist: parameters /= Void
		do
			Result := parameters.item (parameter_positions (name).first)
		end
		
	parameter_names : DS_LIST[STRING] is
			-- names of parameters of query
		require
			valid_statement: is_valid
		local
			table_cursor : DS_HASH_TABLE_CURSOR[DS_LIST[INTEGER],STRING]
		do
			if impl_parameter_names = Void then
				create {DS_LINKED_LIST[STRING]} impl_parameter_names.make
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
			parameter_count: Result.count <= parameter_count
		end

	cursor : ARRAY[like value_anchor] 
			-- container where result fields are stored

	parameters : ARRAY[like value_anchor]
			-- current parameter values for the statement

	parameters_description : ARRAY[ECLI_PARAMETER_DESCRIPTION]

	cursor_description : ARRAY [ECLI_COLUMN_DESCRIPTION]

feature -- Measurement

	parameter_count : INTEGER is
			-- number of parameters in 'sql'
		require
			valid_statement: is_valid
			request: sql /= Void
		do
			Result := sql.occurrences ('?')
		end

	result_column_count : INTEGER is
			-- number of columns in result-set
			-- 0 if no result set is available
		require
			valid_statement: is_valid
			executed: is_executed
		do
			get_result_column_count
			Result := impl_result_column_count
		end

	has_results : BOOLEAN is
			-- has this statement a result-set ?
		require
			valid_statement: is_valid
			executed: is_executed
		do
			Result := result_column_count > 0
		ensure
			results: Result = (result_column_count > 0)
		end

	has_parameters : BOOLEAN is
			-- has this statement some parameters ?
		require
			valid_statement: is_valid
			request: sql /= Void
		do
			Result := (parameter_count > 0)
		ensure
			Result = (parameter_count > 0)
		end

feature -- Status report

	is_parsed : BOOLEAN is
			-- is the 'sql' statement parsed for parameters ?
		require
			valid_statement: is_valid
		do
			Result := impl_is_parsed
		end

	is_prepared : BOOLEAN

	is_executed : BOOLEAN

	is_prepared_execution_mode : BOOLEAN
			-- is it a 'prepared' execution mode ?

	bound_parameters :  BOOLEAN
			-- have the parameters been bound ?

	off : BOOLEAN is
			-- is there no current item ?
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
			-- has the statement a 'name' parameter ?
		require
			valid_statement: is_valid
			name_ok: name /= Void
		do
			Result := name_to_position.has (name)
		end

	cursor_status : INTEGER

	cursor_before, cursor_in, cursor_after : INTEGER is unique


feature -- Status setting

	set_prepared_execution_mode is
			-- set prepared execution mode
			-- statement execution occurs in two steps
		require
			valid_statement: is_valid
		do
			is_prepared_execution_mode := True
		ensure
			good_mode: is_prepared_execution_mode
		end

	set_immediate_execution_mode is
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
		require
			valid_statement: is_valid
			executed: is_executed
			before: before
		do
			set_cursor_in
			fetch_next_row
		ensure
			results: not off implies (has_results and not before)
		end

	forth is
			-- get next result row
		require
			valid_statement: is_valid
			executed: is_executed
			result_pending: not off and not before
		do
			fetch_next_row
		end

	close_cursor is
			-- close cursor
		require
			valid_statement: is_valid
			valid_state: is_executed and not after
			has_results: has_results			
		do
			set_status (ecli_c_close_cursor (handle))
			set_cursor_after
		ensure
			after: after
		end

feature -- Element change

	set_sql (a_sql : STRING) is
			-- set 'sql' statement to 'a_sql'
		require
			valid_statement: is_valid
		do
			sql := a_sql
			impl_sql := parsed_sql (sql)
			impl_parameter_names := Void
			is_executed := False
			is_prepared := False
			cursor_description := Void
			parameters_description := Void
			check
				impl_sql_different: sql /= impl_sql
			end
			bound_parameters := False
		ensure
			has_sql: sql = a_sql
			parsed:  is_parsed
			not_executed: not is_executed
			not_prepared: not is_prepared
			no_bound_parameters: not bound_parameters
			reset_descriptions: parameters_description = Void and cursor_description = Void
		end

	set_parameters (param : ARRAY[like value_anchor]) is
			-- set parameters value with 'param'
		require
			valid_statement: is_valid
			param_exist: param /= Void
			param_count: param.count = parameter_count
			params_not_void: True -- foreach p in param it_holds p /= Void
		do
			parameters := param
			bound_parameters := False
		ensure
			parameters_set: parameters = param
			not_bound: not bound_parameters
		end

	put_parameter (value : like value_anchor; key : STRING) is
			-- set parameter 'key' with 'value'
			-- WARNING : Case sensitive !
		require
			valid_statement: is_valid
			has_parameters: parameter_count > 0
			value_ok: value /= Void
			key_ok : key /= Void
			known_key: has_parameter (key)
		local
			plist : DS_LIST[INTEGER]
		do
			if parameters = Void then
				create parameters.make (1, parameter_count)
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

	set_cursor (row : ARRAY[like value_anchor]) is
			-- set cursor container with 'row'
		require
			valid_statement: is_valid
			row_exist: row /= Void
			row_count: row.count = result_column_count
			is_executed: is_executed
		do
			cursor := row
--			bind_results
		ensure
			cursor_set: cursor = row
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature {ECLI_SESSION} -- Miscellaneous

	session_disconnect (a_session : ECLI_SESSION) is
		do
			unattached := True
			release_handle
			session := Void
		ensure then
			not is_valid
		end

feature {NONE} -- Miscellaneous


	prepare_for_disposal is
		do
			if not unattached then
				session.unregister_statement (Current)
			end
			session := Void
			unattached := True
		end

	release_handle is
		do
			set_status (ecli_c_free_statement (handle))
			set_handle ( default_pointer)
			ready_for_disposal := True
		end

feature -- Basic operations

	execute is
		-- execute sql statement
		require
			valid_statement: is_valid
			query_is_parsed: is_parsed
			prepared_when_mode_prepared: is_prepared_execution_mode implies is_prepared
			parameters_set: parameter_count > 0 implies bound_parameters
		local
			tools : ECLI_EXTERNAL_TOOLS
		do
			if is_prepared_execution_mode then
				set_status (ecli_c_execute (handle) )
			else
				if is_executed and then has_results and then not after then
					close_cursor
				end
				set_status (ecli_c_execute_direct (handle, tools.string_to_pointer (impl_sql)))
			end
			if is_ok then
				is_executed := True
				if has_results then
					set_cursor_before
				else
					set_cursor_after
				end
			end
		ensure
			executed: is_executed implies is_ok
			cursor_state: is_executed implies 
						((has_results implies before) or
						(not has_results implies after))
		end

	describe_parameters is
			-- put description of parameters in 'parameters_description'
		require
			valid_statement: is_valid
			prepared: is_prepared
			has_parameters: parameter_count > 0
		local
			count, limit : INTEGER
			description : ECLI_PARAMETER_DESCRIPTION
		do
			limit := parameter_count
			create parameters_description.make (1, limit)
			from
				count := 1				
			until count > limit or not is_ok
			loop
				create description.make (Current, count)
				parameters_description.put (description, count)
				count := count + 1
			end	
			if not is_ok then
				parameters_description := Void
			end
		ensure
			description: is_ok implies 
				(parameters_description /= Void and then
				 parameters_description.count = parameter_count)			 		
		end

	describe_cursor is
			-- get metadata about current result-set in 'cursor_description'
		require
			valid_statement: is_valid
			executed: is_executed
			has_results: has_results
		local
			count, limit : INTEGER
			description : ECLI_COLUMN_DESCRIPTION
		do
			limit := result_column_count
			create cursor_description.make (1, limit)
			from
				count := 1				
			until count > limit or not is_ok
			loop
				create description.make (Current, count, 100)
				cursor_description.put (description, count)
				count := count + 1
			end
			if not is_ok then
				cursor_description := Void
			end
		ensure
			description: is_ok implies
				(cursor_description /= Void and then cursor_description.count = result_column_count)
		end	

	bind_parameters is
			-- bind parameters
		require
			valid_statement: is_valid
			parameters_exist: parameters /= Void and then parameters.count >= parameter_count
		local
			parameter_index : INTEGER
		do
			from
				parameter_index := 1
			until
				parameter_index > parameters.count
			loop
				bind_one_parameter (parameter_index)
				parameter_index := parameter_index + 1
			end
			bound_parameters := True
		ensure
			bound_parameters: bound_parameters
		end

	prepare is
			-- prepare the sql statement
		require
			valid_statement: is_valid
		local
			tools : ECLI_EXTERNAL_TOOLS
		do
			if is_executed and then (has_results and  not after) then
				close_cursor
			end
			set_status (ecli_c_prepare (handle, tools.string_to_pointer (impl_sql)))
			if is_ok then
				is_prepared := True
				set_prepared_execution_mode
			end

		ensure
			prepared_mode: is_ok implies is_prepared_execution_mode
			prepared_stmt: is_ok implies is_prepared
		end

feature -- Obsolete

feature -- Inapplicable

	value_anchor : ECLI_VALUE is
		do
		end

feature {NONE} -- Implementation

	parsed_sql (s : STRING) : STRING is
			-- parse s, replacing every '?<name>' by '?'
			-- and set up the name to position translation table
			-- <name> is [a-zA-Z_0-9]+
		local
			eq : DS_EQUALITY_TESTER[DS_LIST[INTEGER]]
			param_count, param_number, i_start, i_begin_parameter_name, i_end_parameter_name, i : INTEGER
			c : CHARACTER
			name_found : BOOLEAN
			name : STRING
		do
			create Result.make (s.count)
			param_count := s.occurrences ('?')
			--| create or resize translation table
			if param_count > 0 then
				if name_to_position = Void then
					create name_to_position.make (param_count)
					create eq
					name_to_position.set_equality_tester (eq)
				else
					if param_count > name_to_position.capacity then
						name_to_position.resize (param_count)
					end
					name_to_position.wipe_out
				end
				-- | loop through parameters
				-- | * insert a name to position item
				-- | * copy s to Result, except the parameter names
				from
					i_start := 1
					param_number := 1
				variant s.count+1 - i_start
				until
					param_number > param_count or i_start > s.count
				loop
					-- copy s[i_start..i_begin_parameter_name-1], where s@(i_begin_parameter_name-1) = '?'
					from
						i_begin_parameter_name := i_start
					until
						s.item (i_begin_parameter_name) = '?'
					loop
						Result.extend (s.item (i_begin_parameter_name))
						i_begin_parameter_name := i_begin_parameter_name + 1
					end
					Result.extend (s.item (i_begin_parameter_name))
					i_begin_parameter_name := i_begin_parameter_name + 1

					--| go past parameter name
					from
						i_end_parameter_name := i_begin_parameter_name+1
						name_found := False
					until
						 name_found or i_end_parameter_name > s.count
					loop
						inspect (s.item (i_end_parameter_name))
							when 'a'..'z', 'A'..'Z', '0'..'9', '_' then
								i_end_parameter_name := i_end_parameter_name + 1
							else
								name_found := True
						end
					end
					-- | parameter name is substring (i_begin_parameter_name, i_end_parameter_name-1)
					-- | put its position in the translation table
					name := s.substring(i_begin_parameter_name, i_end_parameter_name -1)
					--
					-- | same parameter name can occur at multiple position
					--
					add_new_parameter (name, param_number)
					-- | prepare for next iteration
					i_start := i_end_parameter_name
					param_number := param_number + 1
				end
				-- copy s[i_start..s.count] to Result
				from
				until
					i_start > s.count
				loop
					Result.extend (s.item(i_start))
					i_start := i_start + 1
				end
			else
				Result.copy (s)
			end
			set_parsed
		ensure
			is_parsed: is_parsed
		end
			
	name_to_position : DS_HASH_TABLE [DS_LIST[INTEGER], STRING]
	
	set_parsed is
		require
			valid_statement: is_valid
		do
			impl_is_parsed := True
		end

	get_result_column_count is
		require
			valid_statement: is_valid
		do
			set_status (ecli_c_result_column_count (handle, $impl_result_column_count))
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
			cursor_arity: cursor.count = result_column_count
		local
			index, index_max : INTEGER
			current_value : ECLI_VALUE
		do
			from
				index := 1
				index_max := result_column_count
			until 
				index > result_column_count
			loop
				current_value := cursor.item (index)
				current_value.read_result (Current, index)
				index := index + 1
			end		
		end

	session : ECLI_SESSION

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER  is
			-- Implementation of deferred feature 
		require else
			valid_statement: is_valid
		do
			Result := ecli_c_statement_error (handle, record_index, state, native_error, message, buffer_length, length_indicator)
		end


	impl_result_column_count : INTEGER
	
	impl_parameter_names : DS_LIST[STRING]

	impl_sql : STRING
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
			if status = cli_no_data then
				close_cursor
			else
				fill_cursor
			end
		end

	add_new_parameter (a_parameter_name : STRING; a_position : INTEGER) is
		require
			valid_statement: is_valid
		local
			position_list : DS_LIST[INTEGER]
		do
			if name_to_position.has (a_parameter_name) then
				name_to_position.item (a_parameter_name).put_right (a_position)
			else
				create {DS_LINKED_LIST[INTEGER]}position_list.make
				position_list.put_right (a_position)
				name_to_position.put (position_list, a_parameter_name)
			end					
		end
invariant


end -- class ECLI_STATEMENT
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
