indexing
	description: "Objects that represent ARRAYs of typed values to be exchanged with the database.%
		% These mainly are exchange buffers.  The capacity is set at creation and cannot be changed.%
		% The actual number of elements to take into account is set using set_count.%
		% 'set_count' must not be used by a client except when passing parameters.  The other private usage is %
		% when a rowset_cursor fetches the last set of data (usually less than the capacity)."
		
	author: "Paul G. Crismer"
	
	usage: "Used in row-set operations : column-wise binding for result-sets, %
		% or column-wise binding of parameters for modifications.%
		% Access modes: direct ('item_at'), linear ('start', 'forth', 'item')."

	date: "$Date$"
	revision: "$Revision$"

deferred class
	ECLI_ARRAYED_VALUE

inherit

	ECLI_VALUE
		undefine
			to_character, convertible_to_character,
			to_boolean, convertible_to_boolean,
			to_integer, convertible_to_integer,
			to_real, convertible_to_real,
			to_double, convertible_to_double,
			to_date, convertible_to_date,
			to_time, convertible_to_time,
			to_timestamp, convertible_to_timestamp,
			set_item, set_null, length_indicator_pointer,
			can_trace		
		redefine
			release_handle, to_external, length_indicator_pointer , is_null, out,
			to_string
		end
		
feature -- Access

	cursor_index : INTEGER

	item_at (index : INTEGER) : like item is
			-- item at `index'th position
		require
			valid_index: index >= 1 and index <= count
		deferred			
		end
		
feature -- Measurement

	capacity : INTEGER
	
	count : INTEGER
			-- actual number of values
	
feature -- Status report

	is_null_at (index : INTEGER) : BOOLEAN is
			-- is `index'th item NULL ?
		require
			valid_index: index >= 1 and index <= count
		do
			Result := (ecli_c_array_value_get_length_indicator_at (buffer, index) = Sql_null_data)
		end

	is_null : BOOLEAN is
			-- is element at `cursor_index' NULL ?
		do
			Result := is_null_at (cursor_index)
		end
		
	off : BOOLEAN is
			-- 
		do
			Result := cursor_index < 1 or else cursor_index > count
		end

feature -- Status setting
		
feature -- Cursor movement

	start is
		do
			cursor_index := 1
		end
		
	forth is
			-- 
		do
			cursor_index := cursor_index + 1
		end
	
	go (ith : INTEGER) is
			-- 
		require
			ith: ith > 0 and ith <= count
		do
			cursor_index := ith	
		ensure
			cursor_index = ith
		end
		
feature -- Element change

	set_item_at (value : like item; index : INTEGER) is
			-- set `index'th value to `value'
		require
			valid_index: index >= 1 and index <= count
		deferred
		ensure
			item_set: equal (item_at (index), truncated (value))
		end
	
	set_null_at (index: INTEGER) is
			-- set `index'th value to NULL
		require
			valid_index: index >= 1 and index <= count
		do
			ecli_c_array_value_set_length_indicator_at (buffer, Sql_null_data, index)
		ensure
			null_set: is_null_at (index)
		end
		
	set_item (value : like item) is
		do
			set_item_at (value, cursor_index)
		end
		
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	to_string : STRING is
			-- 
		do
			Result := out_item_at (cursor_index)
		end
		
	out : STRING is
		local
			i : INTEGER
		do
			from i := 1
				!!Result.make (10)
				Result.append ("<<")
			until i > count
			loop
				if is_null_at (i) then
					Result.append ("NULL")
				else
					Result.append (out_item_at (i))
				end
				i := i + 1
				if i <= count then
					Result.append (", ")
				end
			end
			Result.append (">>")
		end

	to_external : POINTER is
			-- external 'C' address of value array 
			-- contiguous memory block of 'capacity' * 'transfer_octet_length'
			-- use at your own risks !
		do
			Result := ecli_c_array_value_get_value (buffer)
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	set_count (a_count : INTEGER) is
			-- set `count' to `a_count'
			-- used to indicate that index ranging from 'a_count' + 1 to 'capacity'
			-- do not hold interesting values
		require
			valid_count: a_count >= 1 and a_count <= capacity
		do
			count := a_count
		ensure
			count_set: count = a_count
		end
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	release_handle is
		do
			ecli_c_free_array_value (buffer)
			buffer := default_pointer
		end

	length_indicator_pointer : POINTER is
			-- external 'C' address of length indicator
		do
			Result := ecli_c_array_value_get_length_indicator_pointer (buffer)
		end

	out_item_at (index : INTEGER) : STRING is
		require
			valid_index: index >= 1 and index <= count
		do
			Result := item_at (index).out
		end
		
invariant
	valid_count: count >= 1 and count <= capacity
	valid_capacity: capacity >= 1

end -- class ECLI_ARRAYED_VALUE
