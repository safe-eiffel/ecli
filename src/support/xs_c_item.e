indexing
	description: "C item."
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

deferred class
	XS_C_ITEM [G->COMPARABLE]

inherit
	XS_C_MEMORY
	
feature {NONE} -- Initialization

feature -- Initialization

	make is
			-- make item
		do
			handle := c_memory_allocate (item_size)
		end
		
feature -- Access

	item : G is
			-- item
		deferred
		ensure
			result_within_bounds: Result >= minimum_value and Result <= maximum_value
		end

feature -- Measurement
	
	item_size : INTEGER is
			-- size in bytes of an item
		deferred
		ensure
			positive_size: Result > 0
		end

	minimum_value : G is
			-- minimum value for sur a type
		deferred
		end
		
	maximum_value : G is
			-- maximum value for sur a type
		deferred
		end

feature -- Element change

	put (value : G) is
			-- put `value' at `index'
		require
			value_within_bounds: value >= minimum_value and value <= maximum_value
		deferred
		ensure
			item_set: item.is_equal (value)
		end
		
end -- class XS_C_ITEM
--
-- Copyright: 2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
