indexing

	description:
	
			"Procedure column type metadata constants."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_PROCEDURE_TYPE_METADATA_CONSTANTS

feature -- Constants

	Sql_param_type_unknown      : INTEGER is     0
	Sql_param_input             : INTEGER is     1
	Sql_param_input_output      : INTEGER is     2
	Sql_result_col              : INTEGER is     3
	Sql_param_output            : INTEGER is     4
	Sql_return_value            : INTEGER is     5

end
