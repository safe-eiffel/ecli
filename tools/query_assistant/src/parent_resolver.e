indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARENT_RESOLVER [G->HASHABLE]

feature -- Access

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

	resolve_parents (items : DS_HASH_TABLE[COLUMN_SET [G], STRING]) : DS_HASH_TABLE [PARENT_COLUMN_SET [G], STRING] is
			--
		local
			cursor : DS_HASH_TABLE_CURSOR[COLUMN_SET [G],STRING]
			set : COLUMN_SET [G]
			parent_column_set : PARENT_COLUMN_SET[G]
			parent_cursor : DS_HASH_TABLE_CURSOR[PARENT_COLUMN_SET [G], STRING]
		do
			create Result.make (10)
			from
				cursor := items.new_cursor
				cursor.start
			until
				cursor.off
			loop
				set := cursor.item
				if set.parent_name /= Void then
					Result.search (set.parent_name)
					if not Result.found then
						create parent_column_set.make (set.parent_name)
						Result.put (parent_column_set, parent_column_set.name)
					else
						parent_column_set := Result.found_item
					end
					parent_column_set.descendants.put_last (set)
					set.set_parent (parent_column_set)
				end
				cursor.forth
			end
			from
				parent_cursor := Result.new_cursor
				parent_cursor.start
			until
				parent_cursor.off
			loop
				parent_cursor.item.flatten
				parent_cursor.forth	
			end
		end

	resolve_descendants (items : DS_HASH_TABLE[COLUMN_SET [G], STRING]) is
			-- 
		local
			cursor : DS_HASH_TABLE_CURSOR[COLUMN_SET [G],STRING]
		do
			from
				cursor := items.new_cursor
				cursor.start
			until
				cursor.off
			loop
				cursor.item.flatten
				cursor.forth
			end
		end
		
feature -- Obsolete

feature -- Inapplicable


feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class PARENT_RESOLVER
