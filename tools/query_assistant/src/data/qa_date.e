note
	description: "SQL DATE value."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_DATE

inherit
	ECLI_DATE
	
	QA_VALUE

create
	make, make_default
	
feature


	ecli_type : STRING = "ECLI_DATE"
			
	value_type : STRING = "DT_DATE"		

	creation_call : STRING
		do
			Result := make_null_call
		end

end -- class QA_DATE
--
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
