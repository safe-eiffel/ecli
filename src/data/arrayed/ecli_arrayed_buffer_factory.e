indexing
	description: "Objects that create arrayed buffers for rowset commands"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ARRAYED_BUFFER_FACTORY

inherit
	ECLI_BUFFER_FACTORY
		redefine
			value_factory, value_anchor
		end
	
creation
	make
	
feature -- Initialization

	make (a_row_count : INTEGER) is
			-- make buffer for 'a_row_count'
		do
			row_count := a_row_count
		ensure
			row_count_set: row_count = a_row_count
		end
		
feature -- Access
	
	value_factory : ECLI_ARRAYED_VALUE_FACTORY is
		once
			!!Result.make (row_count)
		end
	
	value_anchor : ECLI_ARRAYED_VALUE is
			-- 
		do
			
		end
		
feature -- Measurement

	row_count : INTEGER
	
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

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	
invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_ARRAYED_BUFFER_FACTORY
