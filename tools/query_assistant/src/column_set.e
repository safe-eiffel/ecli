indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COLUMN_SET[G->HASHABLE]

inherit
	DS_HASH_SET[G]

creation
	make
	
feature -- Access

	parent : like Current
	
	local_items : like Current
	
feature -- Measurement

feature -- Status report

	is_flattened : BOOLEAN
	
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

	flatten is
			-- flatten so that columns of parent set are included in current set
		do
			if not is_flattened then
				create local_items.make (count)
				local_items.merge (Current)
				parent.flatten
				merge (parent)
			end
		ensure
			is_flattened: is_flattened
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class COLUMN_SET
