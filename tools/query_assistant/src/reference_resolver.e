indexing
	description: "Objects that resolve access module metadata references to parents or descendants"

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	REFERENCE_RESOLVER [G -> ACCESS_MODULE_METADATA]

feature -- Basic operations

	resolve_parents (items : DS_HASH_TABLE[COLUMN_SET [G], STRING]) : DS_HASH_TABLE [PARENT_COLUMN_SET [G], STRING] is
			-- extract parent information from `items' and create collection of parent object into Result
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
			-- infer local content of each item in `items' wrt to their respective parent if any
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
		
end -- class REFERENCE_RESOLVER
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
