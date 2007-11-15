indexing
	description: "NUMBER/DECIMAL values."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QA_DECIMAL

inherit
	ECLI_DECIMAL
	
	QA_VALUE
		undefine
			bind_as_parameter
		end

create
	make
	
feature

	ecli_type : STRING is "ECLI_DECIMAL"
		
	value_type : STRING is "MA_DECIMAL"

	creation_call : STRING is
		do
			Result := make_call_with_precision_and_digits
		end

end -- class QA_DECIMAL
