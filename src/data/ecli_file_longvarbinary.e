indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_FILE_LONGVARBINARY

inherit

	ECLI_FILE_VALUE

creation
	make_input, make_output
	
feature -- Access
		
	sql_type_code : INTEGER is
		do
			Result := Sql_longvarbinary
		end

end -- class ECLI_FILE_LONGVARBINARY
