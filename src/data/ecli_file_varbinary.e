note

	description:

			"SQL VARBINARY large data transferred from/into a file."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_FILE_VARBINARY

inherit

	ECLI_FILE_VALUE

create

	make_input, make_output

feature -- Access

	sql_type_code : INTEGER
		do
			Result := Sql_varbinary
		end

end
