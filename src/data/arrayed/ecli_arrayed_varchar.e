note

	description:

			"SQL VARCHAR (n) arrayed values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_VARCHAR

inherit

	ECLI_ARRAYED_STRING_VALUE

create

	make


feature -- Status report

	sql_type_code: INTEGER
		once
			Result := sql_varchar
		end

feature {NONE} -- Implementation

	default_maximum_capacity : INTEGER = 255

end
