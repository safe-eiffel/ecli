indexing
	description: "Sets of parameters of an access modules"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	PARAMETER_SET

inherit
	COLUMN_SET[MODULE_PARAMETER]
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
			set_equality_tester (create {KL_EQUALITY_TESTER [MODULE_PARAMETER]})
		end
		
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
