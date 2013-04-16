note

	description:
	
			"Input parameters in SQL statements."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_INPUT_PARAMETER

inherit

	ECLI_STATEMENT_PARAMETER

create

	make
	
feature -- Status report

	is_input : BOOLEAN do Result := True end
	is_input_output : BOOLEAN do Result := False end
	is_output : BOOLEAN do Result := False end
	
feature {ECLI_STATEMENT} -- Basic operations

	bind (statement : ECLI_STATEMENT; position : INTEGER)
		do
			item.bind_as_parameter (statement, position)
		end

invariant
	is_input: is_input

end
