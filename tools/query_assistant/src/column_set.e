indexing
	description: "Set of columns"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	COLUMN_SET[G->HASHABLE]

inherit
	DS_HASH_SET[G]
		rename
			make as make_set
		end

creation
	make, make_with_parent_name
	
feature {NONE} -- Initialization

	make (a_name : STRING) is
			-- 
		require
			a_name_not_void: a_name /= Void
		do
			name := a_name
			make_set (initial_size)
			set_equality_tester (create {KL_EQUALITY_TESTER [like item]})
		ensure
			name_set: name = a_name
		end
		
	make_with_parent_name (a_name : STRING; a_parent_name : STRING) is
			-- 
		require
			a_name_not_void: a_name /= Void
			a_parent_name_not_void: a_parent_name /= Void
		do
			parent_name := a_parent_name
			make (a_name)
		ensure
			name_set: name = a_name
			parent_name_set: parent_name = a_parent_name
		end
		
feature -- Access

	name : STRING
	
	parent_name : STRING
	
	parent : PARENT_COLUMN_SET[G]
	
	local_items : DS_HASH_SET[G]

feature -- Measurement

feature -- Status report

	is_flattened : BOOLEAN
	
feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_parent (a_parent : like parent) is
			-- set `parent' to `a_parent'
		require
			a_parent_not_void: a_parent /= Void
			no_parent_yet: parent = Void
			parent_name_equal: parent_name /= Void implies parent_name.is_equal(a_parent.name)
		do
			parent := a_parent
			if parent_name = Void then
				parent_name := parent.name
			end
		ensure
			parent_set : parent = a_parent
		end
		
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
				local_items.set_equality_tester (equality_tester)
				if parent /= Void then
					parent.flatten
					merge (parent)
					local_items.merge (Current)
					local_items.symdif (parent)
				end
			end
		ensure
			is_flattened: is_flattened
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	initial_size : INTEGER is 5
	
invariant
	local_items_when_flattened: local_items /= Void implies is_flattened
	equality_tester_exists: equality_tester /= Void 
end -- class COLUMN_SET
