indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MODULE_RESULT

inherit
	HASHABLE
		redefine
			is_equal
		end
		
create
	make

feature {NONE} -- Initialization

	make (the_metadata : ECLI_COLUMN_DESCRIPTION; result_rank : INTEGER) is
			-- Initialize `Current'.
		require
			the_metadata_exist: the_metadata /= Void
			result_rank_positive: result_rank > 0
		do
			metadata := the_metadata
			rank := result_rank
		ensure
			metadata_assigned: metadata = the_metadata
			rank_assigned: rank = result_rank
		end

feature -- Access

	metadata : ECLI_COLUMN_DESCRIPTION
	
	implementation : QA_VALUE
	
	hash_code : INTEGER is
			-- 
		do
			Result := metadata.name.hash_code
		end
	
	rank : INTEGER
	
feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_implementation (value : QA_VALUE) is
			-- 
		require
			value_exists: value /= Void
		do
			implementation := value
		ensure
			implementation_assigned: implementation = value
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

	is_equal (other : like Current) : BOOLEAN is
			-- 
		do
			Result := metadata.is_equal (other.metadata)
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class MODULE_RESULT
