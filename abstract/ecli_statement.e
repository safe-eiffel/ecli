indexing
	description:

		 "Objects that represent statements that manipulate %
		% a database. They are defined on a connected session"

	author: 	"Paul G. Crismer"
	date: 		"$Date$"
	revision: 	"$Revision$"
	licensing: 	"See notice at end of class"

class
	ECLI_STATEMENT

inherit
	ECLI_STATUS

	ECLI_HANDLE

	PAT_SUBSCRIBER
		rename
			publisher as session,
			published as session_disconnect
		redefine
			session, session_disconnect
		end

creation
	make

feature -- Initialization

	make (a_session : ECLI_SESSION) is
			-- create a statement for use on 'session'
		require
			a_session_exists: a_session /= Void
			a_session_connected: a_session.is_connected
		do
			session := a_session
			set_status (ecli_c_allocate_statement (session.handle, $handle))
			if is_valid then
				session.register_statement (Current)
			end
		ensure
			session_ok: session = a_session
			registered: session.is_registered_statement (Current)
			valid: is_valid
		end

feature -- Access

	sql : STRING

	parameter_positions (name : STRING) : DS_LIST[INTEGER] is
			-- positions of parameter 'name'
			-- same <name> can occur at multiple places in a SQL statement
			-- for example in a WHERE clause
		require
			name_ok: name /= Void
			has_parameter: parameter_count > 0
			defined_parameter: has_parameter (name)
		do
			Result := name_to_position.item (name)
		ensure
			good_position: Result /= Void and not Result.is_empty
		end

	has_parameter (name : STRING) : BOOLEAN is
			-- has the statement a 'name' parameter ?
		require
			name_ok: name /= Void
		do
			Result := name_to_position.has (name)
		end

	cursor : ARRAY[ECLI_VALUE]
			-- container where result fields are stored

	parameters : ARRAY[ECLI_VALUE]
			-- current parameter values for the statement

feature -- Measurement

	parameter_count : INTEGER is
			-- number of parameters in 'sql'
		do
			Result := impl_sql.occurrences ('?')
		end

	result_column_count : INTEGER is
			-- number of columns in result-set
			-- 0 if no result set is available
		require
			executed: is_executed
		do
			get_result_column_count
			Result := impl_result_column_count
		end

	has_results : BOOLEAN is
			-- has this statement a result-set ?
		do
			Result := result_column_count = 0
		end

feature -- Status report

	is_parsed : BOOLEAN is
			-- is the 'sql' statement parsed for parameters ?
		do
			Result := impl_is_parsed
		end

	is_prepared : BOOLEAN

	is_executed : BOOLEAN

	is_prepared_execution_mode : BOOLEAN
			-- is it a 'prepared' execution mode ?

	bound_parameters :  BOOLEAN
			-- have the parameters been bound ?

	off : BOOLEAN
			-- is the statement finished with results ?

feature -- Status setting

	set_prepared_execution_mode is
			-- set prepared execution mode
			-- statement execution occurs in two steps
		do
			is_prepared_execution_mode := True
		ensure
			good_mode: is_prepared_execution_mode
		end

	set_immediate_execution_mode is
		do
			is_prepared_execution_mode := False
		ensure
			good_mode: not is_prepared_execution_mode
		end
			
feature -- Cursor movement

feature -- Element change

	set_sql (a_sql : STRING) is
			-- set 'sql' statement to 'a_sql'
		do
			sql := a_sql
			impl_sql := parsed_sql (sql)
			is_executed := False
			is_prepared := False
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
		end

	set_parameters (param : ARRAY[ECLI_VALUE]) is
			-- set parameters value with 'param'
		require
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

	put_parameter (value : ECLI_VALUE; key : STRING) is
			-- set parameter 'key' with 'value'
			-- WARNING : Case sensitive !
		require
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

	set_cursor (row : ARRAY[ECLI_VALUE]) is
			-- set cursor container with 'row'
		require
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
			release_handle
		ensure then
			not is_valid
		end

feature -- Basic operations

	execute is
		-- execute sql statement
		require
			query_is_parsed: is_parsed
			is_prepared_execution_mode implies is_prepared
			parameters_set: parameter_count > 0 implies bound_parameters
		local
			tools : ECLI_EXTERNAL_TOOLS
		do
			if is_prepared_execution_mode then
				set_status (ecli_c_execute (handle) )
			else
				if is_executed and not off then
					finish
				end
				set_status (ecli_c_execute_direct (handle, tools.string_to_pointer (impl_sql)))
			end
			off := false
			if is_ok then
				is_executed := True
			end
		ensure
			is_executed implies is_ok
			not_off : not off
		end

	bind_parameters is
			-- bind parameters
		require
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
			bound_parameters
		end

	prepare is
			-- prepare the sql statement
		local
			tools : ECLI_EXTERNAL_TOOLS
		do
			if is_executed and not off then
				finish
			end
			set_status (ecli_c_prepare (handle, tools.string_to_pointer (impl_sql)))
			if is_ok then
				is_prepared := True
			end
			set_prepared_execution_mode
		ensure
			prepared_mode: is_prepared_execution_mode
			prepared_stmt: is_ok implies is_prepared
		end

	start is
			-- get first result row, if available
		do
			set_status (ecli_c_fetch (handle))
			if status = cli_no_data then
				off := True
			else
				fill_cursor
			end
		end

	forth is
			-- get next result row
		require
			result_pending: not off
		do
			start
		end

	finish is
			-- finish reading results
		do
			set_status (ecli_c_close_cursor (handle))
			off := True
		ensure
			no_result_pending: off
		end

feature -- Obsolete

feature -- Inapplicable

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
			position_list : DS_LIST[INTEGER]
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
				variant param_count - param_number
				until
					param_number > param_count
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
					--
					-- i_begin_parameter_name := s.index_of ('?', i_start)+1
					
					check 
						i_begin_parameter_name > 1 
					end

					--| go past parameter name
					from
						i_end_parameter_name := i_begin_parameter_name+1
						name_found := False
					until
						 name_found
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
					if name_to_position.has (name) then
						name_to_position.item (name).put_right (param_number)
					else
						create {DS_LINKED_LIST[INTEGER]}position_list.make
						position_list.put_right (param_number)
						name_to_position.put (position_list, name)
					end					
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
				check
					parameter_count = name_to_position.count
				end
			else
				Result.copy (s)
			end
			set_parsed
		ensure
			impl_sql /= Void
			is_parsed: is_parsed
		end
			
	name_to_position : DS_HASH_TABLE [DS_LIST[INTEGER], STRING]
	
	impl_sql : STRING
		-- SQL string without parameter names, only with '?' markers

	impl_is_parsed : BOOLEAN

	set_parsed is
		do
			impl_is_parsed := True
		end

	impl_result_column_count : INTEGER
	
	get_result_column_count is
		do
			set_status (ecli_c_result_column_count (handle, $impl_result_column_count))
		end

	bind_one_parameter (i : INTEGER) is
		local
			parameter : ECLI_VALUE
		do
			parameter := parameters.item (i)
			set_status (ecli_c_bind_parameter (handle,
				i,
				parameter.c_type_code,
				parameter.db_type_code,
				parameter.column_precision,
				parameter.decimal_digits,
				parameter.to_external,
				parameter.transfer_octet_length,
				parameter.length_indicator_pointer))
		end

	bind_results is
		require
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
				set_status (ecli_c_bind_result (
					handle,
					index,
					current_value.c_type_code,
					current_value.to_external,
					 current_value.transfer_octet_length,
					current_value.length_indicator_pointer)
				)
				index := index + 1
			end		
		end

	fill_cursor is
		require
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
				set_status (ecli_c_get_data (
					handle,
					index,
					current_value.c_type_code,
					current_value.to_external,
					 current_value.transfer_octet_length,
					current_value.length_indicator_pointer)
				)
				index := index + 1
			end		
		end

	session : ECLI_SESSION

	release_handle is
		do
			session.unregister_statement (Current)
			free_statement_handle
		end

	free_statement_handle is
		do
			set_status (ecli_c_free_statement (handle))
			handle := default_pointer
		end

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER  is
			-- to be redefined in descendant classes
		do
			Result := ecli_c_statement_error (handle, record_index, state, native_error, message, buffer_length, length_indicator)
		end

invariant


end -- class ECLI_STATEMENT
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
