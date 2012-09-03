note

	description:
	
			"Input/Output parameters in SQL statements."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_INPUT_OUTPUT_PARAMETER

inherit

	ECLI_STATEMENT_PARAMETER

create

	make
	
feature -- Status report

	is_input : BOOLEAN 
		do 
			Result := False 
		ensure then
			is_false: not Result
		end
		
	is_input_output : BOOLEAN 
		do 
			Result := True 
		ensure then
			is_true: Result
		end
		
	is_output : BOOLEAN 
		do 
			Result := False 
		ensure then
			is_false: not Result
		end

feature {ECLI_STATEMENT} -- Basic operations

	bind (statement : ECLI_STATEMENT; position : INTEGER)
		do
			item.bind_as_input_output_parameter (statement, position)
		end

invariant
	is_input_output: is_input_output

end
