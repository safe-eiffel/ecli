note

	description:
	
			"Objects that are procedure type metadata."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_PROCEDURE_TYPE_METADATA

inherit

	ECLI_PROCEDURE_TYPE_METADATA_CONSTANTS
	
feature {NONE} -- Access

	column_type : INTEGER
	
feature -- Measurement

feature -- Status report

	is_type_input_parameter : BOOLEAN
			-- Input parameter
		do
			Result := column_type = Sql_param_input
		end
		
	is_type_output_parameter : BOOLEAN
			-- Output parameter
		do
			Result := column_type = Sql_param_output
		end

	is_type_input_output_parameter : BOOLEAN
			-- Input/output parameter
		do
			Result := column_type = Sql_param_input_output
		end

	is_type_result : BOOLEAN
			-- Return value of a procedure
		do
			Result := column_type = Sql_return_value
		end

	is_type_unknow : BOOLEAN
			-- Unkown type
		do
			Result := column_type = Sql_param_type_unknown
		end

	is_type_column : BOOLEAN
			-- Column of result-set
		do
			Result := column_type = Sql_result_col
		end
		
end
