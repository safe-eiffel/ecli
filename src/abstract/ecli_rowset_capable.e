indexing

	description:
	
		"Objects that are able of operating on a rowset%N%
		% A rowset is an array  of `row_capacity' rows.%N%
		% Database operations occur one rowset at a time.%N%
		% Status information is available for each row in the rowset."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_ROWSET_CAPABLE

feature -- Access

	item_status (index : INTEGER) : INTEGER is
			-- Status of `index'-th value in current rowset
		require
			index_within_bounds: index >= 1 and then index <= row_capacity
		do
			Result := rowset_status.item (index)
		end

	rowset_status : ECLI_ROWSET_STATUS
			-- Status of last operation, one per row in the set
	
feature -- Measurement

	row_capacity : INTEGER
			-- Maximum number of rows in this rowset
	
	row_count : INTEGER is
			-- Number of rows processed by rowset operation
		do
			Result := impl_row_count.item
		end
		
feature {NONE} -- Implementation
	
	status_array : ARRAY[INTEGER]
			-- For debugging purposes : rowset_status content cannot be viewed in the debugger
	
	fill_status_array is
		local
			index: INTEGER
		do
			from index := 1
				create status_array.make (1, row_capacity)
			until 
				index > row_capacity
			loop
				status_array.put (rowset_status.item (index), index)
				index := index + 1
			end
		end
		
	impl_row_count : XS_C_INT32 is deferred end

	make_row_count_capable is
			-- 
		deferred
		end
		
invariant
	row_capacity_valid: row_capacity >= 1
	row_count_valid: row_count <= row_capacity
	impl_row_count_not_void: impl_row_count /= Void --FIXME: VS-DEL
	rowset_status_not_void:rowset_status /= Void 
	rowset_capacity: rowset_status.count = row_capacity
	
end
