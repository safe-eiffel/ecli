indexing
	description: "SQL LONGVARBINARY data objects"
	author: "Paul G. Crismer"
	
	library: "ECLI"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_LONGVARBINARY

inherit
	ECLI_BINARY_VALUE
		
creation
	make
	
feature -- Access

	max_capacity : INTEGER is
		do
			Result := 1_000_000
		end
		
	sql_type_code : INTEGER is
		once
			Result := sql_varbinary
		end
		
end -- class ECLI_LONGVARBINARY
