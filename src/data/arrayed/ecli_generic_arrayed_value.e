indexing

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

deferred class ECLI_GENERIC_ARRAYED_VALUE [G]

inherit

	ECLI_ARRAYED_VALUE
		redefine
			out, 
--			is_equal, 
			copy
		end

feature -- Access

	item_at (index : INTEGER) : G is
			-- item at `index'th position
		require
			valid_index: index >= lower and index <= count
			not_null: not is_null_at (index)
		deferred
		end

feature -- Measurement

	item_size : INTEGER is
			-- maximum size of one item
		do
			Result := ecli_c_array_value_get_length (buffer)
		end
		
feature -- Element change

	set_item_at (value : G; index : INTEGER) is
			-- set `index'th value to `value'
		require
			valid_index: index >= lower and index <= count
		deferred
		ensure
--			item_set: equal (item_at (index), truncated (value))
			not_null: not is_null_at (index)
		end

	set_item (value : G) is
			-- affect 'value' to 'item'
		do
			set_item_at (value, cursor_index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Duplication

	copy (other : like Current) is
			-- copy 'other' to Current
		local
			index : INTEGER
		do
			if other.count > capacity then
				release_handle
				buffer := ecli_c_alloc_array_value (other.item_size,other.count)
				capacity := other.count
				count := capacity
			end
			from
				index := 1
			until
				index > other.count
			loop
				if other.is_null_at (index) then
					set_null_at (index)
				else
					set_item_at (other.item_at (index), index)
				end
				index := index + 1
			end
		end
		
feature -- Comparison

	is_equal (other : like Current) : BOOLEAN is
		local
			index : INTEGER
		do
			if count = other.count then
				from
					index := 1
					Result := True
				until
					index > count or else not Result
				loop
					if is_null_at (index) then
						Result := Result and then other.is_null_at (index)
					else
						Result := Result and then (item_at (index).is_equal (other.item_at (index)))
					end
					index := index + 1
				end
			end
		end
		
feature -- Conversion

	out : STRING is
		local
			i : INTEGER
		do
			from i := 1
				create Result.make (10)
				Result.append_string ("<<")
			until i > count
			loop
				if is_null_at (i) then
					Result.append_string ("NULL")
				else
					Result.append_string (out_item_at (i))
				end
				i := i + 1
				if i <= count then
					Result.append_string (", ")
				end
			end
			Result.append_string (">>")
		end

	formatted (value : G) : G is
			-- formatted 'value' - does nothing except for CHAR data
			-- where the result is truncated or padded
		deferred
		end

feature {NONE} -- Implementation

	out_item_at (index : INTEGER) : STRING is
		do
			Result := item_at (index).out
		end

end
