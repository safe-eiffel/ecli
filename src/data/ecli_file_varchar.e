note

	description:

			"SQL VARCHAR large data transferred from/into a file."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_FILE_VARCHAR

inherit

	ECLI_FILE_LONGVARCHAR
		redefine
			sql_type_code
		end

create

	make_input, make_output

feature -- Access

	sql_type_code : INTEGER
		do
			Result := Sql_varchar
		end

end
