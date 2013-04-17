note
	description: "Summary description for {ECLI_ARRAYED_BINARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ARRAYED_BINARY

inherit

	ECLI_ARRAYED_STRING_VALUE

create

	make

feature -- Access

	sql_type_code : INTEGER
		do
			Result := Sql_binary
		end

feature {NONE} -- Implementation

	default_maximum_capacity : INTEGER = 1_000_000

end
