note

	description:
	
			"Procedure column type metadata constants."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_PROCEDURE_TYPE_METADATA_CONSTANTS

feature -- Constants

	Sql_param_type_unknown      : INTEGER =     0
	Sql_param_input             : INTEGER =     1
	Sql_param_input_output      : INTEGER =     2
	Sql_result_col              : INTEGER =     3
	Sql_param_output            : INTEGER =     4
	Sql_return_value            : INTEGER =     5

end
