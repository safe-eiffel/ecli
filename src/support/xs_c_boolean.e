indexing
	description: "C allocated 8 bit boolean : False = 0; True /= False."
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	XS_C_BOOLEAN

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

	item : BOOLEAN is
			-- item
		do
			Result := (c_memory_get_int8 (handle) /= ext_false)
		end
		
feature -- Measurement
	
	item_size : INTEGER is do Result := 1 end

feature -- Element change

	put (value : BOOLEAN) is
			-- put `value'
		local
			l_int : INTEGER
		do
			if value then
				l_int := ext_true
			else
				l_int := ext_false
			end
			c_memory_put_int8 (handle, l_int)
		end
		
	ext_true : INTEGER is 1
	ext_false : INTEGER is 0
	
invariant
	handle_not_default_pointer: handle /= default_pointer
	
end -- class XS_C_BOOLEAN
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
