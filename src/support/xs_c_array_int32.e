indexing
	description: "C allocated arrays of 32 bits integers."
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

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
			Result := c_memory_get_int32 (item_ptr)
		end
		
feature -- Measurement
	
	item_size : INTEGER is do Result := 4 end

feature -- Element change

	put (value : INTEGER; index : INTEGER) is
			-- put `value' at `index'
		local
			item_ptr : POINTER
		do
			item_ptr := item_pointer (index)
			c_memory_put_int32 (item_ptr, value)
		end
		
end -- class XS_C_ARRAY_INT32
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
