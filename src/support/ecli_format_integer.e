note

	description:
	
			"Objects that provide integer formatting routines."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_FORMAT_INTEGER

feature -- Conversion

	pad_integer_4 (value : INTEGER) : STRING
		do
			create Result.make (4)
			if value < 10 then
				Result.append_string ("000")
			elseif value < 100 then
				Result.append_string ("00")
			elseif value < 1000 then
				Result.append_string ("0")
			end
			Result.append_string (value.out)
		end

	pad_integer_2 (value : INTEGER) : STRING
		do
			create Result.make (2)
			if value < 10 then
				Result.append_string ("0")
			end
			Result.append_string (value.out)
		end

end
