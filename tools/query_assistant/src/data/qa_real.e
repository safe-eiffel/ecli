note
	description: "CLI SQL REAL value."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_REAL

inherit
	ECLI_REAL
	
	QA_VALUE
	
create
	make
	
feature


	ecli_type : STRING = "ECLI_REAL"
		
	value_type : STRING = "REAL"
		
	creation_call : STRING
		do
			Result := make_call
		end

end -- class QA_REAL
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
