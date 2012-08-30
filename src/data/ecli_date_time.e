note

	description:

		"SQL DATETIME values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
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
