indexing

	description:
	
			"Tools for Eiffel/External (to C) communication"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_EXTERNAL_TOOLS

inherit

	ECLI_EXTERNAL_TOOLS_COMMON

feature -- Basic operations

	string_to_pointer (s : STRING) : POINTER is
			-- pointer to "C" version of 's'
		local
			a : ANY
		do
			a := s.to_c
			Result := pointer($a)
		end

	pointer_to_string (p : POINTER) : STRING is
		do
			create Result.make (0)
			Result.from_c (p)
		end

	string_copy_from_pointer (s : STRING; p : POINTER) is
			-- copy 'C' string at `p' into `s'
		do
			s.from_c (p)
		end
		
feature {NONE} -- Implementation

		pointer (ptr : POINTER) : POINTER is
			do
				Result := ptr
			end

invariant
	invariant_clause: -- Your invariant here

end
