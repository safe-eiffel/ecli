indexing
	description: "C allocated arrays of 16bits integer (short)."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	C_ARRAY_INT16

inherit
	C_MEMORY
	
creation
	make
			
feature
	make (a_capacity : INTEGER) is
			-- 
		require
			valid_capacity: a_capacity > 0
		do
			handle := c_memory_allocate (a_capacity * item_size)
			capacity := a_capacity
		ensure
			capacity_set: capacity = a_capacity
		end
		

feature -- Access

	item (index : INTEGER) : INTEGER is
			-- item at `index'
		require
			valid_index: index > 0 and index <= capacity
		local
			item_ptr : POINTER
		do
			item_ptr := item_pointer (index)
			Result := c_memory_short_to_integer (item_ptr)
		end
		
feature -- Measurement

	capacity : INTEGER

	count : INTEGER is do Result := capacity end
	
	item_size : INTEGER is do Result := 2 end
	
feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	put (value : like item; index : INTEGER) is
			-- 
		require
			valid_index: index > 0 and index <= capacity
		local
			item_ptr : POINTER
		do
			item_ptr := item_pointer (index)
			c_memory_copy (item_ptr, $value, item_size)
		ensure
			item_set: item (index).is_equal (value)
		end
		
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

	item_pointer (index : INTEGER) : POINTER is
			-- 
		do
			Result := c_memory_pointer_plus (handle, (index - 1) * item_size)
		end
		
invariant
	invariant_clause: True -- Your invariant here

end -- class C_ARRAY_INT16
