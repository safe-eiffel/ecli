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
		redefine
			dispose, is_equal
		end

	ECLI_EXTERNAL_TOOLS
		undefine
			dispose, is_equal
		end
	
creation
	make, make_from_string, make_shared_from_pointer, set_empty
	
feature {NONE} -- Initialization

	make (a_capacity : INTEGER) is
			-- make for `a_capacity' characters
		require
			a_capacity_positive: a_capacity >= 0
		do
			if a_capacity > 0 then
				handle := c_memory_allocate (a_capacity + 1)
			else
				make_shared_from_pointer (empty_string.handle, 0)
			end
			capacity := a_capacity
		ensure
			capacity_set: capacity = a_capacity
			shared_when_empty: (a_capacity = 0) implies (Current = empty_string or else (is_shared and then handle = empty_string.handle))
		end

	make_from_string (s : STRING) is
			-- make from `s'
		require
			s_not_void: s /= Void
		do
			make (s.count)
			if not is_shared then
				from_string (s)
			end
		ensure
			capacity_set: capacity = s.count
			shared_when_empty: (s.count = 0) implies (is_shared and then handle = empty_string.handle)
			is_copy: item.is_equal (s)
		end

	make_shared_from_pointer (p : POINTER; a_capacity : INTEGER) is
			-- 
		require
			p_not_default: p /= default_pointer
			a_capacity_positive: a_capacity >= 0
		do
			handle := p
			capacity := a_capacity
			is_shared := True
		ensure
			handle_set: handle = p
			capacity_set: capacity = a_capacity
			is_shared: is_shared
		end
		
feature -- Access

	capacity : INTEGER
			-- string capacity
			
feature -- Status report

	is_shared : BOOLEAN 
		-- is the handle of this string shared with other objects ?
		
feature -- Conversion

	item : STRING is
			-- Current converted to a STRING
		do
			Result := pointer_to_string (handle)
		end

feature -- Constants

	empty_string : XS_C_STRING is
			-- empty string
		once
			create Result.set_empty
		end

feature -- Comparison

	is_equal (other : like Current) : BOOLEAN is
			-- is 'other' equal to current ?
		do
			if other = Current or else handle = other.handle then
				Result := True
			else
				Result := item.is_equal (other.item)
			end
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

	dispose is
			-- 
		do
			if not is_shared then
				Precursor {XS_C_MEMORY}
			end
		end

feature {NONE} -- Implementation

	set_empty is 
		do
			if empty_string /= Void then
				make_shared_from_pointer (empty_string.handle, 0)
			else
				handle := c_memory_allocate ( 1)
				c_memory_put_int8 (handle, 0)
			end
		end
		
end -- class XS_C_STRING
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
