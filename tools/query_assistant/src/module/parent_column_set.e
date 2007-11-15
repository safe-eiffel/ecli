indexing
	description: "Column sets with descendants."

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	PARENT_COLUMN_SET [G->RDBMS_ACCESS_METADATA]

inherit
	COLUMN_SET[G]
		redefine
			copy, make, flatten
		end

create
	make
	
feature {NONE} -- Initialization

	make (a_name: STRING) is
		do
			create {DS_LINKED_LIST[like column_set_anchor]} descendants.make
			Precursor (a_name)
		end
		
feature -- Access

	descendants : DS_LIST [like column_set_anchor]
	
	column_set_anchor : COLUMN_SET[G] is do end
	
feature -- Basic operations

	copy (other : like Current) is
		do
			Precursor (other)
			if other.descendants /= Void then
				if descendants = Void then
					create {DS_LINKED_LIST[like column_set_anchor]}descendants.make
				end
				descendants.copy (other.descendants)
			end
		end

	flatten is
		local
			cursor : DS_LIST_CURSOR [like column_set_anchor]
			set, item_as_set_metadata : DS_HASH_SET [G]
		do
			if not is_flattened then
				from
					cursor := descendants.new_cursor
					cursor.start
				until
					cursor.off
				loop
					create item_as_set_metadata.make (cursor.item.count)
					item_as_set_metadata.set_equality_tester (equality_tester)
					item_as_set_metadata.append_last (cursor.item)
					if set = Void then
						create set.make (capacity)
						set.set_equality_tester (equality_tester)
						set.merge (item_as_set_metadata)
					else
						set.intersect (item_as_set_metadata)
					end
					cursor.forth
				end
				is_flattened := True
				merge (set)
			end
		end

feature {NONE} -- Implementation

	item_eiffel_type (an_item : like item) : STRING is
		do
			Result := an_item.value_type
		end
		
	item_eiffel_name (an_item : like item) : STRING is
			-- 
		do
			Result := an_item.eiffel_name
		end
		
end -- class PARENT_COLUMN_SET
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
