indexing
	description: "Tools for Eiffel/External (to C) communication"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

expanded class
	ECLI_EXTERNAL_TOOLS

feature -- Basic operations

	string_to_pointer (s : STRING) : POINTER is
			-- pointer to "C" version of 's'
		require
			good_string: s /= Void
		do
			Result := s.to_external
		end

	pointer_to_string (p : POINTER) : STRING is
		require
			good_pointer: p /= default_pointer
		do
			create Result.from_external_copy (p)
		end

feature -- Inapplicable

feature {NONE} -- Implementation

		pointer (ptr : POINTER) : POINTER is
			do
				Result := ptr
			end

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_EXTERNAL_TOOLS
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
