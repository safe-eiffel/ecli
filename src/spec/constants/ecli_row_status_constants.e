indexing
	description: "Objects that group row status constants"
	
	library: "ECLI"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ROW_STATUS_CONSTANTS

inherit
		ECLI_API_CONSTANTS
			export
				{ANY} 
					Sql_row_added, 
					Sql_row_deleted, 
					Sql_row_error, 
					Sql_row_norow, 
					Sql_row_success,
					Sql_row_success_with_info
			end

end -- class ECLI_ROW_STATUS_CONSTANTS
