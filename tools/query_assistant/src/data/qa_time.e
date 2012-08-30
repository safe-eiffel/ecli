note
	description: "SQL TIME value."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_TIME

inherit
	ECLI_TIME
	
	QA_VALUE

create
	make_default
	
feature

	ecli_type : STRING = "ECLI_TIME"
		
	value_type : STRING = "DT_TIME"

	creation_call : STRING
		do
			Result := make_null_call
		end
		
end -- class QA_TIME
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
