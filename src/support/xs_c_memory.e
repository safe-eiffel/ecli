indexing
	description: "Objects give access to C memory"
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	XS_C_MEMORY

inherit
	MEMORY
		export {NONE} all
		redefine
			dispose
		end
		
feature -- Access

	handle : POINTER
	
feature {NONE} -- Implementation

	dispose is
			-- free external resources
		do
			c_memory_free (handle)
		end
		
	c_memory_pointer_plus (pointer : POINTER; offset : INTEGER) : POINTER is
		external "C"
		alias "c_memory_pointer_plus"
		end

	c_memory_copy (destination : POINTER; source : POINTER; length : INTEGER) is
		external "C"
		alias "c_memory_copy"
		end

	c_memory_allocate (size : INTEGER) : POINTER is
		external "C"
		alias "c_memory_allocate"
		end

 	c_memory_free (pointer : POINTER) is
		external "C"
		alias "c_memory_free"
		end 

 	c_memory_short_to_integer (pointer : POINTER) : INTEGER is
		external "C"
		alias "c_memory_short_to_integer"
		end	

invariant
	memory_allocated: handle /= default_pointer

end -- class XS_C_MEMORY
--
-- Copyright: 2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
