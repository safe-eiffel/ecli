indexing

	description:
	
			"SQL VARBINARY (n) values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_VARBINARY

inherit

	ECLI_BINARY_VALUE
		
creation

	make, make_force_maximum_capacity
	
feature -- Access

	default_maximum_capacity : INTEGER is
		do
			Result := 8_192
		end
		
	sql_type_code : INTEGER is
			-- 
		once
			Result := sql_varbinary
		end

end
