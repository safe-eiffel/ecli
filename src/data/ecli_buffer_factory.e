indexing
	description: "Objects that create buffers for DB to application information exchange."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_BUFFER_FACTORY

feature -- Initialization

feature -- Access

	Default_precision_limit : INTEGER is 8192

	precision_limit : INTEGER is
			-- maximum acceptable precision
		do
			if precision_limit_impl /= 0 then
				Result := precision_limit_impl
			else
				Result := Default_precision_limit
			end
		end

	last_buffer : ARRAY [like value_anchor]
			-- last created buffer

	last_index_table : DS_HASH_TABLE [INTEGER, STRING]
			-- last table mapping column name to column index in last_buffer 
			
feature -- Element change

	set_precision_limit (p : INTEGER) is
			-- set maximum number of characters retrieved for each item 
		require
			greater_than_zero: p > 0
		do
			precision_limit_impl := p
		ensure
			limit_set: precision_limit = p
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

		create_buffers (cursor_description :ARRAY [ECLI_COLUMN_DESCRIPTION]) is
			-- create all ECLI_VALUE objects
		require
			cursor_description_not_void: cursor_description /= Void
			lower_is_one: cursor_description.lower = 1
		local
			i, cols, type_code : INTEGER
			factory : like value_factory
			column : ECLI_COLUMN_DESCRIPTION
			size : INTEGER
		do
			from
				factory := value_factory
				i := 1
				cols := cursor_description.upper
				!!last_buffer.make (1, cols)
				create_name_to_index (cols)
			until
				i > cols
			loop
				column := cursor_description @ i
				map_name_to_index (i, column.name)
				if column.size <= precision_limit then
					size := column.size
				else
					size := precision_limit
				end
				type_code := column.sql_type_code
				if not factory.valid_type (type_code) then
					type_code := factory.sql_longvarchar
				end
				factory.create_instance (type_code, size, column.decimal_digits)
				last_buffer.put (factory.last_result, i)
				i := i + 1
			end
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	
	map_name_to_index (index : INTEGER; name : STRING) is
			-- hook: map column `name' to column `index' 
		require
			index > 0
			name /= Void
		do
			last_index_table.put (index, name)
		end
	
	create_name_to_index (size : INTEGER) is
			-- hook: create name to index map
		do
			!!last_index_table.make (size)					
		end
	
	precision_limit_impl : INTEGER	
	
	value_factory : ECLI_VALUE_FACTORY is
		once
			!!Result.make
		end
	
	value_anchor : ECLI_VALUE is
			-- 
		do
			
		end
		
	
invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_BUFFER_FACTORY
