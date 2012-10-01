note
	description: "Summary description for {QA_BINARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QA_BINARY
	
inherit

	ECLI_BINARY

	QA_CHAR_VALUE

create
	make, make_force_maximum_capacity

feature

	ecli_type : STRING do Result := "ECLI_BINARY" end

	value_type : STRING = "STRING"

	creation_call : STRING
		do
			Result := make_call_with_precision
		end

end
--
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
