note
	description: "SQL TIMESTAMP values."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_TIMESTAMP

inherit
	ECLI_TIMESTAMP
	
	QA_VALUE
	
create
	make, make_default

feature

	ecli_type : STRING = "ECLI_TIMESTAMP"
		
	value_type : STRING = "DT_DATE_TIME"
		
	creation_call : STRING
		do
			Result := make_null_call
		end


end -- class QA_TIMESTAMP
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
