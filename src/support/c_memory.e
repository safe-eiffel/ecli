indexing
	description: "Objects give access to C memory"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	C_MEMORY

inherit
	MEMORY
		export {NONE} all
		redefine
			dispose
		end
		
feature -- Access

	handle : POINTER
	
feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

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

	dispose is
			-- 
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

end -- class C_MEMORY
