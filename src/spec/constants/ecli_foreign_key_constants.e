indexing
	description: "Constants relative to foreign keys."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_FOREIGN_KEY_CONSTANTS

feature -- Constants

	Sql_cascade	:	INTEGER is	0
	Sql_set_null	:	INTEGER is	2
	Sql_no_action	:	INTEGER is	3
	Sql_set_default	:	INTEGER is	4
	Sql_restrict	:	INTEGER is	
		obsolete "Since ODBC 2.5, use Sql_no_action"
		do
			Result := 1
		end


	Sql_initially_deferred	:	INTEGER is	5
	Sql_initially_immediate	:	INTEGER is	6
	Sql_not_deferrable	:	INTEGER is	7


end -- class ECLI_FOREIGN_KEY_CONSTANTS
