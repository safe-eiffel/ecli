indexing

	description:
	
			"Arrayed Date and time objects; synonym of ECLI_TIMESTAMP"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_DATE_TIME

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
			Result := Sql_type_timestamp
		end

end
