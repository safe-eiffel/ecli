indexing

	description:

			"SQL VARCHAR (n) values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_VARCHAR

inherit

	ECLI_STRING_VALUE

create

	make, make_force_maximum_capacity

feature -- Constants

	default_maximum_capacity : INTEGER is
		do
			Result := 255
		end

	sql_type_code: INTEGER is
		once
			Result := sql_varchar
		end

end
