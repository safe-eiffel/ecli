indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ROWSET_CURSOR

inherit
	
	ECLI_ROW_CURSOR
		rename
			make as row_cursor_make, open as row_cursor_open
		export 
			{NONE} row_cursor_make, row_cursor_open
		redefine
			start, value_anchor, create_row_buffers, fill_cursor, 
			fetch_next_row, buffer_factory, create_buffer_factory
		end
		
creation
	make
	
feature -- Initialization

	make, open (a_session : ECLI_SESSION; a_definition : STRING; a_row_count : INTEGER) is
		require
			session_connected: a_session /= Void and then a_session.is_connected
			definition_exists: a_definition /= Void
			row_count_valid: a_row_count >= 1
		do
			row_count := a_row_count
			!!rowset_status.make (row_count)
			row_cursor_make (a_session, a_definition)
		ensure
			row_count_set: row_count = a_row_count
		end
		
feature -- Access

	value_anchor : ECLI_ARRAYED_VALUE
	
feature -- Measurement

	row_count : INTEGER
	
feature -- Status report

	item_status (index : INTEGER) : INTEGER is
			-- status of `index'th value in current rowset
		do
			Result := rowset_status.item (index)
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
		
		start is
				-- 
			do
				fetch_count := 0
				Precursor
			end
			
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	buffer_factory : ECLI_ARRAYED_BUFFER_FACTORY
	
	create_buffer_factory is
		do
			!!buffer_factory.make (row_count)
		end
		
		
	create_row_buffers is
			-- 
		do
			Precursor
			if cursor /= Void then
				bind_results
			end
		end
	
	bind_results is
			-- 
		local
			index : INTEGER
		do
			set_status (ecli_c_set_integer_statement_attribute (handle, Sql_attr_row_bind_type, Sql_bind_by_column))
			set_status (ecli_c_set_integer_statement_attribute (handle, Sql_attr_row_array_size, row_count))
			set_status (ecli_c_set_pointer_statement_attribute (handle, Sql_attr_row_status_ptr, rowset_status.to_external, 0))
			set_status (ecli_c_set_pointer_statement_attribute (handle, Sql_attr_rows_fetched_ptr, $fetched_rows_count, 0))
			
			from index := 1
			until index > result_column_count
			loop
				cursor.item (index).bind_as_result (Current, index)
				index := index + 1
			end
		end
		
	fetched_rows_count : INTEGER
			-- number of rows retrieved by last fetch operation

	fetch_count : INTEGER
			-- number of actual fetch operations
	
	rowset_status : ECLI_ROWSET_STATUS
	
	status_array : ARRAY[INTEGER]
	
	fill_status_array is
			-- 
		local
			index: INTEGER
		do
			from index := 1
				!!status_array.make (1, fetched_rows_count)
			until index > fetched_rows_count
			loop
				status_array.put (rowset_status.item (index), index)
				index := index + 1
			end
		end
		
	fill_cursor is
			-- 
		local
			index : INTEGER
		do
			from index := 1
			until index > result_column_count
			loop
				cursor.item (index).set_count (fetched_rows_count)
				index := index + 1
			end
		end

	fetch_next_row is
			-- 
		do
			if fetch_count > 0 and then fetch_count \\ row_count >= fetched_rows_count and then fetched_rows_count < row_count then
					go_after
			else
				if fetch_count \\ row_count = 0 then
					Precursor
					fill_status_array
					start_values
				else
					forth_values
				end
				fetch_count := fetch_count + 1
			end
		end
		
	start_values is
			-- 
		local
			index : INTEGER
		do
			from index := 1
			until index > result_column_count
			loop
				cursor.item (index).start
				index := index + 1
			end
		end
		
	forth_values is
			-- 
		local
			index : INTEGER
		do
			from index := 1
			until index > result_column_count
			loop
				cursor.item (index).forth
				index := index + 1
			end
			
		end
		
invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_ROWSET_CURSOR
