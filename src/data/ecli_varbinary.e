indexing
	description: "SQL VARBINARY (n) values."
	author: "Paul G. Crismer"
	
	library: "ECLI"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_VARBINARY

inherit
	ECLI_BINARY_VALUE
		
creation
	make
	
feature -- Access

	max_capacity : INTEGER is
			-- 
		once
			Result := 8_192
		end
		
	sql_type_code : INTEGER is
			-- 
		once
			Result := sql_varbinary
		end
		
end -- class ECLI_VARBINARY
