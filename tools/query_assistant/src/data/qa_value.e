indexing
	description: 

		"ECLI_VALUE with eiffel generation metadata."

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
		ensure
			result_not_void: Result /= Void
		end


	make_call_with_precision : STRING is
		do
			create Result.make (12)
			Result.append ("make (")
			Result.append (size.out)
			Result.append (")")
		ensure
			result_not_void: Result /= Void
		end

	make_call_with_precision_and_digits : STRING is
		do
			create Result.make (25)
			Result.append_string ("make (")
			Result.append_string (size.out)
			Result.append_string (", ")
			Result.append_string (decimal_digits.out)
			Result.append_string (")")
		ensure
			result_not_void: Result /= Void
		end
		
	make_first_call : STRING is
		once
			create Result.make (12)
			Result.append ("make_first")
		ensure
			result_not_void: Result /= Void
		end
		
	make_default_call : STRING is
			-- 
		once
			create Result.make_from_string ("make_default")
		ensure
			result_not_void: Result /= Void
		end
		
	make_null_call : STRING is
		do
			create Result.make (12)
			Result.append_string ("make_null")
		ensure
			result_not_void: Result /= Void
		end
		
end -- class QA_VALUE
--
-- Copyright: 2000-2005, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
