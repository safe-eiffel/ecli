indexing
	description: "Procedure column type metadata constants"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_PROCEDURE_TYPE_METADATA_CONSTANTS

feature -- Constants

	Sql_param_type_unknown      : INTEGER is     0
	Sql_param_input             : INTEGER is     1
	Sql_param_input_output      : INTEGER is     2
	Sql_result_col              : INTEGER is     3
	Sql_param_output            : INTEGER is     4
	Sql_return_value            : INTEGER is     5

end -- class ECLI_PROCEDURE_TYPE_METADATA_CONSTANTS
