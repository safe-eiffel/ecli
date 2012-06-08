indexing

	description:

		"Objects that create buffers for DB to application information exchange."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_BUFFER_FACTORY

inherit

	ANY
		redefine
			default_create
		end

feature -- Initialization

	default_create
		do
			create last_buffers.make_empty
			create last_index_table.make (0)
		end

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

	last_buffers : ARRAY [attached like value_anchor]
			-- last created buffers

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
			-- Create all ECLI_VALUE objects.
			-- Empty column names are replaced by the column index.
		require
			cursor_description_not_void: cursor_description /= Void --FIXME: VS-DEL
			lower_is_one: cursor_description.lower = 1
		local
			i, cols, type_code : INTEGER
			factory : like value_factory
			column : ECLI_COLUMN_DESCRIPTION
			size : INTEGER_64
			name : STRING
		do
			from
				factory := value_factory
				i := 1
				cols := cursor_description.upper
				create last_buffers.make_filled (default_buffer_value, 1, cols)
				create_name_to_index (cols)
			until
				i > cols
			loop
				column := cursor_description @ i
				if column.name.is_empty then
					name := i.out
				else
					name := column.name
				end
				map_name_to_index (i, name)
				if column.size <= precision_limit then
					size := column.size
				else
					size := precision_limit
				end
				type_code := column.sql_type_code
				if not factory.valid_type (type_code) then
					type_code := factory.sql_longvarchar
				end
				factory.create_instance (type_code, size.as_integer_32, column.decimal_digits)
				last_buffers.put (factory.last_result, i)
				i := i + 1
			end
		ensure
			last_buffers_created: last_buffers /= Void --FIXME: VS-DEL
			same_buffers_count_as_cursor_description: last_buffers.count = cursor_description.count
			same_buffers_lower_as_cursor_count: last_buffers.lower = 1
			last_index_table_not_void: last_index_table /= Void
			same_index_table_count_as_cursor_description: last_index_table.count = cursor_description.count
		end

feature -- Obsolete

feature -- Inapplicable

	value_anchor : detachable ECLI_VALUE is
		do
		end

feature {NONE} -- Implementation

	default_buffer_value : ECLI_VALUE
		do
			create {ECLI_CHAR}Result.make (1)
		end

	map_name_to_index (index : INTEGER; name : STRING) is
			-- hook: map column `name' to column `index'
		require
			index_stricly_positive: index > 0
			name_not_void: name /= Void --FIXME: VS-DEL
		do
			last_index_table.put (index, name)
		end

	create_name_to_index (size : INTEGER) is
			-- hook: create name to index map
		do
			create last_index_table.make (size)
		end

	precision_limit_impl : INTEGER

	impl_value_factory : detachable like value_factory

	value_factory : ECLI_VALUE_FACTORY is
		do
			if attached impl_value_factory as l_factory then
				Result := l_factory
			else
				create Result.make
				impl_value_factory := Result
			end
		ensure
			result_not_void: Result /= Void --FIXME: VS-DEL
			impl_value_factory_set: impl_value_factory = Result
		end

invariant
	invariant_clause: -- Your invariant here

end
