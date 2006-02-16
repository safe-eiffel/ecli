indexing

	description:
	
			"SQL VARBINARY large data transferred from/into a file."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_FILE_VARBINARY

inherit

	ECLI_FILE_VALUE

creation

	make_input, make_output
	
feature -- Access
		
	sql_type_code : INTEGER is
		do
			Result := Sql_varbinary
		end

	c_type_code : INTEGER is
		do
			Result := sql_c_binary
		end
		end
		
end
