indexing
	description: "Objects that provide integer formatting routines"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_FORMAT_INTEGER

feature -- Conversion

	pad_integer_4 (value : INTEGER) : STRING is
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

	pad_integer_2 (value : INTEGER) : STRING is
		do
			create Result.make (2)
			if value < 10 then
				Result.append_string ("0")
			end
			Result.append_string (value.out)
		end


end -- class ECLI_FORMAT_INTEGER
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
