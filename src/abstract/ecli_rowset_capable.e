indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ROWSET_CAPABLE

feature -- Measurement

	row_count : INTEGER
	
feature -- Status report

	item_status (index : INTEGER) : INTEGER is
			-- status of `index'th value in current rowset
		do
			Result := rowset_status.item (index)
		end

	processed_row_count : INTEGER
			-- number of rows processed by rowset operation

feature {NONE} -- implementation
	
	rowset_status : ECLI_ROWSET_STATUS
	
	status_array : ARRAY[INTEGER]
	
	fill_status_array is
			-- 
		local
			index: INTEGER
		do
			from index := 1
				!!status_array.make (1, processed_row_count)
			until index > processed_row_count
			loop
				status_array.put (rowset_status.item (index), index)
				index := index + 1
			end
		end
		

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_ROWSET_CAPABLE
