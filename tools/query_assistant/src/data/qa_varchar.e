note
	description: "SQL VARCHAR (n) values."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_VARCHAR

inherit

	ECLI_VARCHAR

	QA_CHAR_VALUE

create
	make, make_force_maximum_capacity

feature


	ecli_type : STRING = "ECLI_VARCHAR"

	value_type : STRING = "STRING"

	creation_call : STRING
		do
			Result := make_call_with_precision
		end

end -- class QA_VARCHAR
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
