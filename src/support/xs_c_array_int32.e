indexing
	description: "C allocated arrays of 32bits integer."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	XS_C_ARRAY_INT32

inherit
	XS_C_ARRAY [INTEGER]
	
creation
	make
			
feature -- Access

	item (index : INTEGER) : INTEGER is
			-- item at `index'
		local
			item_ptr : POINTER
		do
			item_ptr := item_pointer (index)
			c_memory_copy ($actual_value, item_ptr, item_size)
			Result := actual_value
		end
		
feature -- Measurement
	
	item_size : INTEGER is do Result := 4 end

feature -- Element change

	put (value : INTEGER; index : INTEGER) is
			-- 
		local
			item_ptr : POINTER
		do
			item_ptr := item_pointer (index)
			c_memory_copy (item_ptr, $value, item_size)
		end
	
	actual_value : INTEGER
	
end -- class XS_C_ARRAY_INT32
