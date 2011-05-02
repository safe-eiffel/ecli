indexing

	description:

	    "Buffers for LONGVARCHAR(n) data accessed through STRING objects."

	usage: ""
	quality: ""
	refactoring: ""

	status: "see notice at end of class";
	date: "$Date$";
	revision: "$Revision$";
	author: ""

class
	QA_STRING_LONGVARCHAR

inherit
	QA_CHAR_VALUE
		undefine
			is_buffer_too_small,
			read_result,
			bind_as_parameter,
			put_parameter
		end

	ECLI_STRING_LONGVARCHAR

create
	make, make_force_maximum_capacity

feature

	ecli_type : STRING is do Result := "ECLI_STRING_LONGVARCHAR" end

	value_type : STRING is "STRING"

	creation_call : STRING is
		do
			Result := make_call_with_precision
		end

end
