indexing
	description: 

		"Objects that represent typed values to be exchanged with the database"

	author: 	"Paul G. Crismer"
	date: 		"$Date$"
	revision: 	"$Revision$"
	licensing: 	"See notice at end of class"

deferred class
	ECLI_GENERIC_VALUE [G]

inherit
	ECLI_VALUE
		redefine
			out, is_equal, copy
		end
		
feature -- Access

	item : G is
			-- Actual value : to be redefined in descendant classes
		require
			not_null: not is_null
		do
		ensure
			not_void: Result /= Void
		end

feature -- Element change

	set_item (value: G) is
			-- set `item' with content of `value'
		require
			value /= Void
		do
		ensure
--			item_set: equal (item, truncated (value))
			not_null: not is_null
		end;

feature -- Conversion

	truncated (v : G) : G is
			-- truncated 'v' according to 'column_precision'
			-- does nothing, except for fixed format types like CHAR
		do
			Result := v
		end

	out : STRING is
			-- 
		do
			Result := item.out
		end
		
feature -- Duplication

	copy (other : like Current) is
			-- 
		do
			if other.is_null then
				set_null
			else
				set_item (other.item)
			end
		end
		
feature -- Comparison

	is_equal (other : like Current) : BOOLEAN is
			do
				Result := (is_null and then other.is_null) or else (item.is_equal (other.item))
			end
		
feature {NONE} -- Implementation

	impl_item : G is
			-- reference to actual item this is always the same item !
		do
		end
		
	create_impl_item is
			-- create impl_item
		do
		end
		
end -- class ECLI_GENERIC_VALUE
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
