indexing
	description: "Length indicator constants"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_LENGTH_INDICATOR_CONSTANTS

feature -- Status Report

	--  special length/indicator values 
	Sql_null_data	:	INTEGER is	-1
	Sql_data_at_exec	:	INTEGER is	-2

end -- class ECLI_LENGTH_INDICATOR_CONSTANTS
