indexing

	description: 
	
		"Errors related to Query Assistant."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class QA_ERROR

inherit
	
	UT_ERROR

feature -- Access

	default_template : STRING
	
	code : STRING
	
end -- class QA_ERROR
