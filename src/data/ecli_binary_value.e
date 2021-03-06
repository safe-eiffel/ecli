note

	description:

			"SQL Binary values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_BINARY_VALUE

inherit

	ECLI_STRING_VALUE
		redefine
			item, c_type_code
		end

feature -- Access


	item : STRING
		do
			if is_null then
				create Result.make_empty
			else
				ext_item.copy_substring_to (1, count, impl_item)
				Result := impl_item
			end
		end

	c_type_code : INTEGER
		once
			Result := sql_c_binary
		end

end
