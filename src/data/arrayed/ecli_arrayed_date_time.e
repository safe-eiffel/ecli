indexing
	description: "Arrayed Date and time objects; synonym of ECLI_TIMESTAMP"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ARRAYED_DATE_TIME

inherit
	ECLI_ARRAYED_TIMESTAMP
		redefine
			sql_type_code			
		end

creation
	make

feature -- Access

	sql_type_code : INTEGER is
		once
			Result := Sql_datetime
		end

end -- class ECLI_ARRAYED_DATE_TIME
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
