note
	description: "CLI SQL FLOAT value."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_FLOAT

inherit
	ECLI_FLOAT

	QA_VALUE
		undefine
			column_precision
		end

create
	make

feature

	ecli_type : STRING = "ECLI_FLOAT"

	value_type : STRING = "DOUBLE"

	creation_call : STRING
		do
			Result := make_call
		end

end -- class QA_FLOAT
--
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
