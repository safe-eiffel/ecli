indexing
	description: "C allocated strings"
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

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
			-- make for `a_capacity' characters
		require
			a_capacity_positive: a_capacity > 0
		do
			handle := c_memory_allocate (a_capacity + 1)
			capacity := a_capacity
		end
		
feature -- Access

	capacity : INTEGER
			-- string capacity
	
feature -- Conversion

	to_string : STRING is
			-- Current converted to a STRING
		do
			Result := pointer_to_string (handle)
		end
		
end -- class XS_C_STRING
--
-- Copyright: 2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
