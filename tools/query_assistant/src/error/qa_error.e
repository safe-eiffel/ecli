note

	description: 
	
		"Errors related to Query Assistant."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class QA_ERROR

inherit
	
	UT_ERROR

feature -- Access

	default_template : STRING
	
	code : STRING
	
end -- class QA_ERROR
