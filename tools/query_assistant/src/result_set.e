indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RESULT_SET

inherit
	COLUMN_SET[MODULE_RESULT]
		rename
			put as put_set, force as force_set
		redefine
			make
		end
		
creation
	make, make_with_parent_name
	
feature {NONE} -- Initialization

		make (a_name: STRING) is
			-- 
		do
			Precursor (a_name)
			create rank.make (capacity)
			set_equality_tester (create {KL_EQUALITY_TESTER [MODULE_RESULT]})
		end

feature -- Access

	rank : DS_HASH_TABLE[INTEGER, STRING]
	
feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	put (column : like item; column_rank : INTEGER) is
			-- 
		require
			column_exists: column /= Void
			column_rank_positive: column_rank > 0
		do
			put_set (column)
			rank.put (column_rank, column.metadata.name)
		end

	force (column : like item; column_rank : INTEGER) is
			-- 
		require
			column_exists: column /= Void
			column_rank_positive: column_rank > 0
		do
			force_set (column)
			rank.force (column_rank, column.metadata.name)
		end
			
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class RESULT_SET
