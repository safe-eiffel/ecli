note

	description:
	
		"Objects that represent ARRAYs of typed values to be exchanged with the database.%
		% These mainly are exchange buffers.  The capacity is set at creation and cannot be changed.%
		% The actual number of elements to take into account is set using set_count.%
		% 'set_count' must not be used by a client except when passing parameters.  The other private usage is %
		% when a rowset_cursor fetches the last set of data (usually less than the capacity)."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

	usage: "Used in row-set operations : column-wise binding for result-sets, %
		% or column-wise binding of parameters for modifications.%
		% Access modes: direct ('item_at'), linear ('start', 'forth', 'item')."

deferred class ECLI_ARRAYED_VALUE

inherit

	ECLI_VALUE
		undefine
			set_null, length_indicator_pointer,
			can_trace
		redefine
			release_handle, to_external, is_null
		end

feature -- Initialization

	make (a_capacity : INTEGER)
			-- make for `a_capacity' items
		deferred
		ensure
			capacity_set: capacity = a_capacity
			count_set: count = capacity
			cursor_before: before
			all_null: is_all_null -- foreach i in 1..count : is_null_at (i)
		end

feature -- Access

	cursor_index : INTEGER
			-- index of internal cursor

feature -- Measurement

	capacity : INTEGER
			-- capacity of array

	count : INTEGER
			-- actual number of values

	lower : INTEGER = 1
			-- lower index

	upper : INTEGER
			-- upper index
		do
			Result := count
		end
		
feature -- Status report

	is_null_at (index : INTEGER) : BOOLEAN
			-- is `index'th item NULL ?
		require
			valid_index: index >= lower and index <= count
		do
			Result := (ecli_c_array_value_get_length_indicator_at (buffer, index) = Sql_null_data)
		end

	is_null : BOOLEAN
			-- is element at `cursor_index' NULL ?
		do
			if off then
				Result := True
			else
				Result := is_null_at (cursor_index)
			end
		ensure then
			null_when_off: off implies Result
			definition: (not off) implies (Result = is_null_at (cursor_index))
		end

	is_all_null : BOOLEAN
			-- are all element NULL ?
		local
			index : INTEGER
		do
			from
				Result := True
				index := 1
			until
				Result = False or else index > count
			loop
				Result := Result and is_null_at (index)
				index := index + 1
			end
		end

	off : BOOLEAN
			-- is there any item at current cursor position ?
		do
			Result := cursor_index < lower or else cursor_index > count
		end

	before : BOOLEAN
			-- is cursor before any valid element ?
		do
			Result := (cursor_index < lower)
		end

	after : BOOLEAN
			-- is cursor after any valid element ?
		do
			Result := (cursor_index > count)
		end

feature -- Status setting

	set_null
			-- set current item to NULL
		do
			if not off then
				set_null_at (cursor_index)
			end
		end

feature -- Cursor movement

	start
			-- start internal cursor
		do
			cursor_index := lower
		ensure
			definition: not before or else after
		end

	forth
			-- advance internal cursor
		do
			cursor_index := cursor_index + 1
		end

	go (ith : INTEGER)
			-- advance internal cursor
		require
			ith: ith > 0 and ith <= count
		do
			cursor_index := ith
		ensure
			cursor_index = ith
		end

feature -- Element change

	set_null_at (index: INTEGER)
			-- set `index'th value to NULL
		require
			valid_index: index >= lower and index <= count
		do
			ecli_c_array_value_set_length_indicator_at (buffer, Sql_null_data, index)
		ensure
			null_set: is_null_at (index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out_item_at (index : INTEGER) : STRING
		require
			valid_index: index >= 1 and index <= count
		deferred
		ensure
			result_not_void: Result /= Void
		end
	
--	as_string : STRING is
--			-- visible representation of current item
--		do
--			Result := out_item_at (cursor_index)
--		end

	to_external : POINTER
			-- external 'C' address of value array
			-- contiguous memory block of 'capacity' * 'transfer_octet_length'
			-- use at your own risks !
		do
			Result := ecli_c_array_value_get_value (buffer)
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	set_count (a_count : INTEGER)
			-- set `count' to `a_count'
			-- used to indicate that index ranging from 'a_count' + 1 to 'capacity'
			-- do not hold interesting values
		require
			valid_count: a_count >= lower and a_count <= capacity
		do
			count := a_count
		ensure
			count_set: count = a_count
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	release_handle
		do
			ecli_c_free_array_value (buffer)
			buffer := default_pointer
		end

	length_indicator_pointer : POINTER
			-- external 'C' address of length indicator
		do
			Result := ecli_c_array_value_get_length_indicator_pointer (buffer)
		end

	set_all_null
			-- set all element to NULL
		local
			index : INTEGER
		do
			from
				index := 1
			until
				index > count
			loop
				set_null_at (index)
				index := index + 1
			end
		end

invariant
	valid_count: count >= lower and count <= capacity
	valid_capacity: capacity >= lower
	lower: lower = 1
	upper: upper = count
	limits: lower <= upper
end
