indexing
	description: "C allocated arrays of 16 bits integer (short)."
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	XS_C_ARRAY_INT16

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
			Result := c_memory_short_to_integer (item_ptr)
		end
		
feature -- Measurement
	
	item_size : INTEGER is do Result := 2 end

feature -- Element change

	put (value : INTEGER; index : INTEGER) is
			-- put `value' at `index'
		local
			item_ptr : POINTER
		do
			item_ptr := item_pointer (index)
			c_memory_copy (item_ptr, $value, item_size)
		end
		
end -- class XS_C_ARRAY_INT16
--
-- Copyright: 2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
