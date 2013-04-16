note

	description:

			"Objects that modify the database one rowset at a time."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ROWSET_MODIFIER

inherit

	ECLI_STATEMENT
		rename
			make as statement_make, open as statement_open, bind_parameters as statement_bind_parameters,
			execute as statement_execute
		export
			{NONE} results, results_description, start, forth, go_after, off, set_results, close_cursor,
				describe_results, after, before, cursor_status, Cursor_after, Cursor_before, Cursor_in,
				statement_make, statement_open, statement_bind_parameters, statement_execute, set_sql
--				,
--				cursor, set_cursor
		redefine
			parameter_anchor, default_create, default_parameter
		end

	ECLI_ROWSET_CAPABLE
		undefine
			default_create
		end

create

	make

feature {NONE} -- Initialization

	default_create
		do
			Precursor {ECLI_STATEMENT}
			create status_array.make_empty
		end

	make, open (a_session : ECLI_SESSION; a_sql : STRING; a_row_capacity : INTEGER)
			-- create modifier on `a_session', using SQL `a_sql' for maximum `a_row_capacity' rows
		require
			asession_not_void: a_session /= Void --FIXME: VS-DEL
			a_session_connected: a_session.is_connected
			sql_not_void: a_sql /= Void --FIXME: VS-DEL
			a_row_capacity_valid: a_row_capacity >= 1
		do
			make_row_count_capable
			row_capacity := a_row_capacity
			create rowset_status.make (row_capacity)
			statement_make (a_session)
			set_sql (a_sql)
		ensure
			row_capacity_set: row_capacity = a_row_capacity
			sql_set: sql = a_sql
			session_ok: session = a_session and not is_closed
			registered: session.is_registered_statement (Current)
			valid: 	is_valid
		end

feature -- Access

	parameter_anchor : detachable ECLI_ARRAYED_VALUE do end

feature -- Status report

	valid_parameters_count (a_row_count : INTEGER) : BOOLEAN
			-- is `a_row_count' a valid parameters count ?
		local
			index : INTEGER
			last_count : INTEGER
		do
			Result := a_row_count <= row_capacity
			from
				index := 1
				last_count := -1
			until
				index > parameters.count
			loop
				Result := Result and a_row_count <= parameters.item (index).count
				if last_count > -1 then
					Result := Result and (last_count = parameters.item (index).count)
				end
				last_count := parameters.item (index).count
				index := index + 1
			end
		ensure
			valid: True -- For each p in parameters, it_holds p.count <= a_row_count
			same_count: True -- Every p in parameters have the same count
		end

feature -- Basic operations

	execute (a_count : INTEGER)
			-- execute for 'a_count' rows
		require
			valid_count: a_count <= row_capacity
			valid_parameters_count: valid_parameters_count (a_count)
		do
			execute_count (a_count)
		ensure
			command: not has_result_set
		end

	bind_parameters
			-- bind parameters
		local
			index : INTEGER
		do
			--| advise ODBC that we are using parameter arrays, by column
			set_status ("ecli_c_set_integer_statement_attribute", ecli_c_set_integer_statement_attribute (handle, Sql_attr_param_bind_type, Sql_parameter_bind_by_column))
			--| bind status array
			set_status ("ecli_c_set_pointer_statement_attribute", ecli_c_set_pointer_statement_attribute (handle, Sql_attr_param_status_ptr, rowset_status.to_external, 0))

			--| bind parameter arrays
			from index := 1
			until index > parameters.upper
			loop
				bind_one_parameter (index)
				index := index + 1
			end
			bound_parameters := True
		ensure
			bound_parameters: bound_parameters
		end

feature {NONE} -- Implementation

	execute_count (a_count : INTEGER)
		require
			valid_count: a_count <= row_capacity
			valid_parameters_count: valid_parameters_count (a_count)
		do
			set_status ("ecli_c_set_pointer_statement_attribute", ecli_c_set_pointer_statement_attribute (handle, Sql_attr_params_processed_ptr, impl_row_count.handle, 0))
			set_status ("ecli_c_set_integer_statement_attribute", ecli_c_set_integer_statement_attribute (handle, Sql_attr_paramset_size, a_count))
			statement_execute
			fill_status_array
		ensure
			command: not has_result_set
		end

	make_row_count_capable
			--
		do
			create impl_row_count.make
		end

	default_parameter : attached like parameter_anchor
		do
			create {ECLI_ARRAYED_VARCHAR}Result.make (1, row_capacity)
		end

end
