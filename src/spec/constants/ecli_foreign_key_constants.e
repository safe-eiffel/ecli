note

	description:
	
			"Constants relative to foreign keys."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_FOREIGN_KEY_CONSTANTS

feature -- Constants

	Sql_cascade	:	INTEGER =	0
	Sql_set_null	:	INTEGER =	2
	Sql_no_action	:	INTEGER =	3
	Sql_set_default	:	INTEGER =	4
	Sql_restrict	:	INTEGER	
		obsolete "Since ODBC 2.5, use Sql_no_action"
		do
			Result := 1
		end

	Sql_initially_deferred	:	INTEGER =	5
	Sql_initially_immediate	:	INTEGER =	6
	Sql_not_deferrable	:	INTEGER =	7

end
