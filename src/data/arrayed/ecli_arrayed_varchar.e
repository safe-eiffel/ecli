indexing

	description:
	
			"SQL VARCHAR (n) arrayed values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_VARCHAR

inherit

	ECLI_ARRAYED_STRING_VALUE

creation

	make

feature -- Access

--	max_content_capacity : INTEGER is
--		do
--			Result := 255
--		end

feature -- Status report

	sql_type_code: INTEGER is
		once
			Result := sql_varchar
		end

feature {NONE} -- Implementation

	default_maximum_capacity : INTEGER is 255
	
end
