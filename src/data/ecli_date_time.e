note

	description:

		"SQL DATETIME values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DATE_TIME

inherit

	ECLI_TIMESTAMP
		redefine
			sql_type_code
		end

create

	make, make_first, make_default

feature

	sql_type_code : INTEGER
		once
			Result := Sql_type_timestamp
		end

end
