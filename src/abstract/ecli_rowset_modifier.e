indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ROWSET_MODIFIER

inherit
	ECLI_STATEMENT
		rename
			make as statement_make, open as statement_open, bind_parameters as statement_bind_parameters
		export 
			{NONE} cursor, cursor_description, start, forth, go_after, off, set_cursor, close_cursor, 
				describe_cursor, after, before, cursor_status, Cursor_after, Cursor_before, Cursor_in,
				statement_make, statement_open, statement_bind_parameters
		redefine
			parameter_anchor, execute
		end
	
	ECLI_ROWSET_CAPABLE
	
creation
	make
	
feature {NONE} -- Initialization

	make, open (a_session : ECLI_SESSION; a_definition : STRING; a_row_count : INTEGER) is
			-- create modifier on `a_session', using SQL `a_definition' for maximum `a_row_count' rows
		require
			session_connected: a_session /= Void and then a_session.is_connected
			definition_exists: a_definition /= Void
			row_count_valid: a_row_count >= 1
		do
			row_count := a_row_count
			!!rowset_status.make (row_count)
			definition := a_definition
			statement_make (a_session)
			set_sql (definition)
		ensure
			row_count_set: row_count = a_row_count
			definition_set: definition = a_definition
			session_ok: session = a_session and not is_closed
			registered: session.is_registered_statement (Current)
			valid: 	is_valid
			definition_is_sql: definition = sql
		end

feature -- Access

	definition : STRING
	
	parameter_anchor : ECLI_ARRAYED_VALUE is do end
	
feature -- Measurement

	bound_rows_count : INTEGER
	
feature -- Status report

	valid_parameters_count (a_row_count : INTEGER) : BOOLEAN is
			-- is `a_row_count' a valid parameters count ?
		local
			index : INTEGER
		do
			Result := a_row_count <= row_count
			from
				index := 1
			until
				index > parameters.count
			loop
				Result := Result and a_row_count <= parameters.item (index).count 
				index := index + 1
			end
		ensure
			valid: True -- For each p in parameters, it_holds p.count <= a_row_count
		end
		
feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	execute is
		do
			Precursor
			fill_status_array
		ensure then
			command: not has_results
		end
		
	bind_parameters (a_row_count : INTEGER) is
			-- bind parameters for `a_rows_count'
		require
			valid_count: a_row_count <= row_count
			valid_parameters_count: valid_parameters_count (a_row_count)
		local
			index : INTEGER
		do
			set_status (ecli_c_set_integer_statement_attribute (handle, Sql_attr_param_bind_type, Sql_parameter_bind_by_column))
			set_status (ecli_c_set_integer_statement_attribute (handle, Sql_attr_paramset_size, a_row_count))
			set_status (ecli_c_set_pointer_statement_attribute (handle, Sql_attr_param_status_ptr, rowset_status.to_external, 0))
			set_status (ecli_c_set_pointer_statement_attribute (handle, Sql_attr_params_processed_ptr, $processed_row_count, 0))
			
			from index := 1
			until index > parameters.upper
			loop
				bind_one_parameter (index)
				parameters.item (index).set_count (a_row_count)
				index := index + 1
			end
			bound_parameters := True
		ensure
			bound_parameters: bound_parameters			
		end		
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_ROWSET_MODIFIER
