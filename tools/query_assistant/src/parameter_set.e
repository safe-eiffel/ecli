indexing
	description: "Sets of parameters of an access modules"

	library: "Access_gen : Access Modules Generators utilities"
	
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
		do
			Precursor (a_name)
			set_equality_tester (create {KL_EQUALITY_TESTER [MODULE_PARAMETER]})
		end
		
end -- class PARAMETER_SET
