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
			close as cursor_close, statement_close as close,
			create_buffers as create_row_buffers
		export 
			{NONE} cursor_make
			{ANY} is_valid, go_after, close, put_parameter, has_parameter, has_parameters, parameter_count,
				bound_parameters, bind_parameters, parameters
		end
	
--	ECLI_BUFFER_FACTORY
--		redefine
--			create_name_to_index, map_name_to_index
--		end
		
create
	make, open

feature {NONE} -- Initialization

	make, open (a_session : ECLI_SESSION; a_sql : STRING) is
			-- 
		require
			a_session_exists: a_session /= Void
			a_session_connected: a_session.is_connected
		do
			definition := a_sql
			cursor_make (a_session)
			create_buffer_factory
			buffer_factory.set_precision_limit (buffer_factory.Default_precision_limit)
		ensure
			valid: is_valid
			definition_set: definition = a_sql
			ok: is_ok implies is_prepared
			definition_is_a_query:  has_results or else not is_ok
			limit_set: buffer_factory.precision_limit = buffer_factory.Default_precision_limit
		end
		
feature -- Access

	definition : STRING
			-- definition as an SQL query

	item, infix "@" (name : STRING) : like value_anchor is
			-- 
		require
			is_executed: is_executed
			name_exists: name /= Void
			has_column_by_name: has_column (name)
		do
			Result := cursor.item (name_to_index.item (name))
		end
		
	item_by_index, infix "@i" (index : INTEGER) : like value_anchor is
			-- column item by `index'
		require
			is_executed: is_executed
			valid_index: index >= lower and index <= upper
		do
			Result := cursor.item (index)	
		end

	column_name (index : INTEGER) : STRING is
			-- column name by `index'
		require
			valid_index: index >= lower and index <= upper
		do
			Result := cursor_description.item (index).name
		end
		
feature -- Measurement

	lower : INTEGER is
			-- 
		require
			is_executed: is_executed
		do
			Result := cursor.lower
		end
		
	upper : INTEGER is
			-- 
		require
			is_executed: is_executed
		do
			Result := cursor.upper
		end

	
feature -- Status report

	has_column (name : STRING) : BOOLEAN is
			-- 
		require
			name_exists: name /= Void
		do
			Result := name_to_index.has (name)
		end
		
feature -- Status setting

feature -- Cursor movement

	start is
			-- start at first row of dataset
		require
			prepared: is_prepared
			bound_parameters: has_parameters implies bound_parameters
		do
			execute
			if is_ok then
				if has_results then
					create_row_buffers
					statement_start
				end
			else
				print (diagnostic_message)
				print ("%N")
			end
		ensure
			executed: is_executed
		end
		
feature -- Element change
		
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

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
			!!name_to_index.make (size)					
		end
	
	buffer_factory : ECLI_BUFFER_FACTORY
	
	create_buffer_factory is
		do
			!!buffer_factory
		end
		
	create_row_buffers is
			-- 
		do
			describe_cursor
			cursor := Void
			if not is_ok then
				print (diagnostic_message)
				print ("%N")
			else
				buffer_factory.create_buffers (cursor_description)
				set_cursor (buffer_factory.last_buffer)
				name_to_index := buffer_factory.last_index_table			
			end
		end
		
invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_ROW_CURSOR
