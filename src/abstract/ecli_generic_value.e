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
			out, copy
		end
		
feature -- Access

	item : G is
			-- Actual Eiffel value
		require
			not_null: not is_null
		do
			Result := impl_item
		ensure
			not_void: Result /= Void
		end

feature -- Element change

	set_item (value: G) is
			-- Set `item' with content of `value'
		require
			value_exists: value /= Void
		do
		ensure
			item_set: equal (item, formatted (value))
			not_null: not is_null
		end;

feature -- Conversion

	formatted (v : G) : G is
			-- 'v' formatted according to 'column_precision'
			-- does nothing, except for fixed format types like CHAR
			-- where values are either truncated or padded by blanks
		do
			Result := v
		end

	out : STRING is
		do
			if is_null then
				Result := out_null
			else
				Result := item.out
			end
		end
		
feature -- Duplication

	copy (other : like Current) is
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
			-- Reference to actual item this is always the same item !
		do
		end
		
	create_impl_item is
			-- Create impl_item
		do
		end
	
	out_null : STRING is 
			-- Default `out' when value `is_null'
		once 
			Result := "<NULL>"
		end
	
end -- class ECLI_GENERIC_VALUE
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
