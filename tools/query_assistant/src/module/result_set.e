note
	description: "Result sets."

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	RESULT_SET

inherit
	COLUMN_SET[RDBMS_ACCESS_RESULT]
		rename
			put as put_set, force as force_set
		redefine
			make
		end
		
create
	make, make_with_parent_name
	
feature {NONE} -- Initialization

		make (a_name: STRING)
			-- create result set with `a_name'
			do
				Precursor (a_name)
				create rank.make (capacity)
--				set_equality_tester (create {KL_EQUALITY_TESTER [MODULE_RESULT]})
			end
		
feature -- Access

	rank : DS_HASH_TABLE[INTEGER, STRING]
			-- rank of each item in result set
			
feature -- Element change

	put (column : like item; column_rank : INTEGER)
			-- put `column' with position `column_rank'
		require
			column_not_void: column /= Void
			column_rank_positive: column_rank > 0
		do
			put_set (column)
			rank.put (column_rank, column.name)
		end

	force (column : like item; column_rank : INTEGER)
			-- force `column' with position `column_rank'
		require
			column_not_void: column /= Void
			column_rank_positive: column_rank > 0
		do
			force_set (column)
			rank.force (column_rank, column.name)
		end

feature {NONE} -- Implementation

	item_eiffel_type (an_item : like item) : STRING
		do
			Result := an_item.value_type
		end
		
	item_eiffel_name (an_item : like item) : STRING
			-- 
		do
			Result := an_item.eiffel_name
		end
		
end -- class RESULT_SET
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
