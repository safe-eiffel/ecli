indexing
	description: "Sets of parameters of an access modules"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	PARAMETER_SET

inherit
	COLUMN_SET[MODULE_PARAMETER]

creation
	make, make_with_parent_name
	
feature {NONE} -- Initialization
		
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

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class PARAMETER_SET
