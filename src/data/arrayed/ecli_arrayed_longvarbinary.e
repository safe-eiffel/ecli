note
	description: "Summary description for {ECLI_ARRAYED_LONGVARBINARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ARRAYED_LONGVARBINARY

inherit

	ECLI_ARRAYED_BINARY
		redefine
			sql_type_code
		end

create

	make

feature -- Access

	sql_type_code : INTEGER
		do
			Result := Sql_longvarbinary
		end

end
