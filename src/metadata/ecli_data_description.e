indexing
	description: "Properties of an ECLI data item"
	author: "Paul G. Crismer"
	
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

deferred class
	ECLI_DATA_DESCRIPTION
	
inherit
	ANY
		redefine
			is_equal
		end

feature -- Status report

	sql_type_code : INTEGER is
			-- (redefine in descendant classes)
		deferred
		end

	column_precision : INTEGER is
		obsolete "Use 'size' instead"
		do
			Result := size
		end
	
	size : INTEGER is
			-- maximum number of 'digits' used by the data type
			-- for character and binary data : number of bytes or characters
			-- for numeric data : number of sigificant digits
			-- (redefine in descendant classes)
		deferred
		end

	decimal_digits : INTEGER is
			-- decimal digits or scale
			-- (redefine in descendant classes)
		deferred
		end
		
feature -- Comparison

	is_equal (other : like Current) : BOOLEAN is
			-- is Current equal to `other' ?
		do
			Result := (sql_type_code = other.sql_type_code 
					and then size = other.size 
					and then decimal_digits = other.decimal_digits)
		ensure then
			same_code: Result implies (sql_type_code = other.sql_type_code)
			same_size: Result implies (size = other.size)
			same_decimal_digits: Result implies (decimal_digits = other.decimal_digits)
		end
		
end -- class ECLI_DATA_DESCRIPTION
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
