indexing
	description: "CLI SQL FLOAT value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_FLOAT

inherit
	ECLI_FLOAT
	
	QA_VALUE

creation
	make
	
feature

	ecli_type : STRING is "ECLI_FLOAT"
		
	value_type : STRING is "DOUBLE"

	creation_call : STRING is
		do
			Result := make_call
		end
		
end -- class QA_FLOAT
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
