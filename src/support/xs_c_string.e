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

	make_from_string (s : STRING) is
			-- make from `s'
		require
			s_not_void: s /= Void
		do
			make (s.count)
			from_string (s)
		ensure
			is_copy: item.is_equal (s)
		end
		
feature -- Access

	capacity : INTEGER
			-- string capacity
	
feature -- Conversion

	item : STRING is
			-- Current converted to a STRING
		do
			Result := pointer_to_string (handle)
		end

feature -- Element change

	from_string (s : STRING) is
			-- Copy `s' into Current
		require
			s_not_void: s /= Void
			enough_capacity: capacity >= s.count
		local
			index : INTEGER
		do
			--c_memory_copy (handle, string_to_pointer (s), s.count)
			from
				index := 1
			until
				index > s.count
			loop
				c_memory_put_int8 (c_memory_pointer_plus (handle, index-1), s.item (index).code)				
				index := index + 1
			end
			c_memory_put_int8 (c_memory_pointer_plus (handle, s.count), 0)
		ensure
			equal_strings: item.is_equal (s)
		end
		
end -- class XS_C_STRING
--
-- Copyright: 2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
