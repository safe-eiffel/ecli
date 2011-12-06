indexing

	description:

		"SQL LONGVARCHAR (n) values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_LONGVARCHAR

inherit

	ECLI_STRING_VALUE

create

	make, make_force_maximum_capacity

feature -- Access

	default_maximum_capacity : INTEGER is
		do
			Result := 1_000_000
		end

	sql_type_code: INTEGER is
		once
			Result := sql_longvarchar
		end

end
