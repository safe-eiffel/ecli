indexing
	description: "Objects that modify the database one rowset at a time."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ROWSET_MODIFIER

inherit
	ECLI_STATEMENT
		rename
			make as statement_make, open as statement_open, bind_parameters as statement_bind_parameters,
			execute as statement_execute
		export 
			{NONE} cursor, cursor_description, start, forth, go_after, off, set_cursor, close_cursor, 
				describe_cursor, after, before, cursor_status, Cursor_after, Cursor_before, Cursor_in,
				statement_make, statement_open, statement_bind_parameters, statement_execute, set_sql
		redefine
			parameter_anchor--, execute
		end
	
	ECLI_ROWSET_CAPABLE
	
creation
	make
	
feature {NONE} -- Initialization

	make, open (a_session : ECLI_SESSION; a_sql : STRING; a_row_capacity : INTEGER) is
			-- create modifier on `a_session', using SQL `a_sql' for maximum `a_row_capacity' rows
		require
			session_connected: a_session /= Void and then a_session.is_connected
			sql_exists: a_sql /= Void
			a_row_capacity_valid: a_row_capacity >= 1
		do
			make_row_count_capable
			row_capacity := a_row_capacity
			!!rowset_status.make (row_capacity)
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
	
	parameter_anchor : ECLI_ARRAYED_VALUE is do end
	
feature -- Measurement

--	bound_rows_count : INTEGER
	
feature -- Status report

	valid_parameters_count (a_row_count : INTEGER) : BOOLEAN is
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
		
--| feature -- Status setting

--| feature -- Cursor movement

--| feature -- Element change

--| feature -- Removal

--| feature -- Resizing

--| feature -- Transformation

--| feature -- Conversion

--| feature -- Duplication

--| feature -- Miscellaneous

feature -- Basic operations

	execute (a_count : INTEGER) is
			-- execute for 'a_count' rows
		require
			valid_count: a_count <= row_capacity
			valid_parameters_count: valid_parameters_count (a_count)
		do
			execute_count (a_count)
		ensure
			command: not has_results
		end

	bind_parameters is
			-- bind parameters 
		local
			index : INTEGER
		do
			--| advise ODBC that we are using parameter arrays, by column
			set_status (ecli_c_set_integer_statement_attribute (handle, Sql_attr_param_bind_type, Sql_parameter_bind_by_column))
			--| bind status array
			set_status (ecli_c_set_pointer_statement_attribute (handle, Sql_attr_param_status_ptr, rowset_status.to_external, 0))
			
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
		
--|feature -- Obsolete

--|feature -- Inapplicable

feature {NONE} -- Implementation

	execute_count (a_count : INTEGER) is
		require
			valid_count: a_count <= row_capacity
			valid_parameters_count: valid_parameters_count (a_count)
		do
			set_status (ecli_c_set_pointer_statement_attribute (handle, Sql_attr_params_processed_ptr, impl_row_count.handle, 0))
			set_status (ecli_c_set_integer_statement_attribute (handle, Sql_attr_paramset_size, a_count))
			statement_execute
			fill_status_array
		ensure
			command: not has_results
		end
	
end -- class ECLI_ROWSET_MODIFIER
