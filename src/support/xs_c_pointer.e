indexing
	description: "C allocated 16 bits integer (short)."
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	XS_C_POINTER

inherit
	XS_C_MEMORY
	
creation
	make
			
feature -- Initialization

	make is
		do
			handle := c_memory_allocate (item_size)
		end
		
feature -- Access

	item : POINTER is
			-- item
		do
			Result := c_memory_get_pointer (handle)
		end
		
feature -- Measurement
	
	item_size : INTEGER is do Result := 4 end

feature -- Element change

	put (value : POINTER) is
			-- put `value'
		do
			c_memory_put_pointer (handle, value)
		end
		
invariant
	handle_not_default_pointer: handle /= default_pointer
	
end -- class XS_C_POINTER
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
