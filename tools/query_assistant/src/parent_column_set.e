indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARENT_COLUMN_SET [G->HASHABLE]

inherit
	COLUMN_SET[G]
		redefine
			copy, make, flatten
		end

creation
	make
	
feature {NONE} -- Initialization

	make (a_name: STRING) is
			-- 
		do
			create {DS_LINKED_LIST[like column_set_anchor]} descendants.make
			Precursor (a_name)
		end
		
feature -- Access

	descendants : DS_LIST [like column_set_anchor]
	
	column_set_anchor : COLUMN_SET[G] is do end
	
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

	copy (other : like Current) is
			-- 
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
			-- 
		local
			cursor : DS_LIST_CURSOR [like column_set_anchor]
			set : DS_HASH_SET [G]
		do
			if not is_flattened then
				from
					cursor := descendants.new_cursor
					cursor.start
				until
					cursor.off
				loop
					if set = Void then
						create set.make (capacity)
						set.merge (cursor.item)
						set.set_equality_tester (equality_tester)
					else
						set.intersect (cursor.item)
					end
					cursor.forth
				end
			end
			merge (set)
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class PARENT_COLUMN_SET
