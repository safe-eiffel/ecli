indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	XS_C_STRING

inherit
	XS_C_MEMORY

	ECLI_EXTERNAL_TOOLS
		undefine
			dispose
		end
	
creation
	make
	
feature {NONE} -- Initialization

	make (a_capacity : INTEGER) is
			-- 
		require
			a_capacity_positive: a_capacity > 0
		do
			handle := c_memory_allocate (a_capacity)
			capacity := a_capacity
		end
		
feature -- Access

	capacity : INTEGER
	
feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	to_string : STRING is
			-- 
		do
			Result := pointer_to_string (handle)
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class XS_C_STRING
