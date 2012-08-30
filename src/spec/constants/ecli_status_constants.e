note

	description:
	
			"Status constants."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_STATUS_CONSTANTS

feature -- Status Report

	--  return values from functions 
	Sql_success	:	INTEGER =	0
	Sql_success_with_info	:	INTEGER =	1
	Sql_no_data	:	INTEGER =	100 -- (ODBCVER >= 0x0300)
	Sql_error	:	INTEGER =	-1
	Sql_invalid_handle	:	INTEGER =	-2

	Sql_still_executing	:	INTEGER =	2
	Sql_need_data	:	INTEGER =	99
	Sql_no_total    : 	INTEGER =	-4

end
