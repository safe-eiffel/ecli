indexing
	description: "SQL LONGVARBINARY data objects"
	author: "Paul G. Crismer"
	
	library: "ECLI"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_LONGVARBINARY

inherit
	ECLI_LONGVARCHAR
		redefine
			c_type_code, sql_type_code, item
		end
		
creation
	make
	
feature -- Access

	c_type_code : INTEGER is
		once
			Result := sql_c_binary
		end
		
	sql_type_code : INTEGER is
		once
			Result := sql_varbinary
		end
		
	item : STRING is
		do
			if is_null then
				Result := Void
			else
				ext_item.copy_substring_to (1, count, impl_item)
				Result := impl_item
			end
		end

end -- class ECLI_LONGVARBINARY
