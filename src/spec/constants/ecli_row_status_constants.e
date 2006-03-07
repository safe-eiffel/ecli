indexing

	description:
	
			"Objects that group row status constants."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ROW_STATUS_CONSTANTS

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

end
