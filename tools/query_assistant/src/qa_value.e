indexing
	description: 

		"ECLI_VALUE with eiffel generation metadata"

	author: 	"Paul G. Crismer"
	date: 		"$Date$"
	revision: 	"$Revision$"
	licensing: 	"See notice at end of class"

deferred class
	QA_VALUE

inherit
	ECLI_VALUE
		undefine
			out,
			as_character, convertible_as_character,
			as_double, convertible_as_double,
			as_integer, convertible_as_integer,
			as_string, convertible_as_string,
			as_real, convertible_as_real,
			as_date, convertible_as_date,
			as_timestamp, convertible_as_timestamp,
			as_time, convertible_as_time,
			copy
		end


feature

	ecli_type : STRING is 
		deferred
		end
		
	value_type : STRING is
		deferred
		end
		
	creation_call : STRING is
		deferred
		ensure			
		end

feature {NONE} -- implementation

	make_call : STRING is
		do
			create Result.make (12)
			Result.append ("make")
		end


	make_call_with_precision : STRING is
		do
			create Result.make (12)
			Result.append ("make (")
			Result.append (size.out)
			Result.append (")")
		end

	make_first_call : STRING is
		once
			create Result.make (12)
			Result.append ("make_first")
		end
		
	make_default_call : STRING is
			-- 
		once
			create Result.make_from_string ("make_default")
		end
		
end -- class QA_VALUE
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
