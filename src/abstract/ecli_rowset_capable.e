indexing
	description: "Objects that are capable of operating on a rowset."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ECLI_ROWSET_CAPABLE

feature -- Measurement

	row_capacity : INTEGER
			-- maximum number of rows in this rowset
	
feature -- Status report

	item_status (index : INTEGER) : INTEGER is
			-- status of `index'th value in current rowset
		require
			index_within_bounds: index >= 1 and then index <= row_capacity
		do
			Result := rowset_status.item (index)
		end

	row_count : INTEGER is
			-- number of rows processed by rowset operation
		do
			Result := impl_row_count.item
		end
		
	rowset_status : ECLI_ROWSET_STATUS
			-- status of last operation, one per row in the set
	
feature {NONE} -- implementation
	
	
	status_array : ARRAY[INTEGER]
			-- for debugging purposes : rowset_status content cannot be viewed in the debugger
	
	fill_status_array is
			-- fill status array
		local
			index: INTEGER
		do
			from index := 1
				!!status_array.make (1, row_capacity)
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
	impl_row_count_not_void: impl_row_count /= Void
	rowset_status_capacity: rowset_status /= Void and then rowset_status.count = row_capacity
	
end -- class ECLI_ROWSET_CAPABLE
