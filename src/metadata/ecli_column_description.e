indexing
	description: "Description of result-set column"
	author: "Paul G. Crismer"
	
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_COLUMN_DESCRIPTION

inherit
	ECLI_PARAMETER_DESCRIPTION
		rename
			make as make_parameter
		export {NONE} make_parameter
		redefine
			is_equal
		end

	KL_IMPORTED_STRING_ROUTINES
		undefine
			is_equal
		end

	HASHABLE
		undefine
			is_equal
		end

creation
	make

feature {NONE} -- Initialization

	make (stmt : ECLI_STATEMENT; index : INTEGER; max_name_length : INTEGER) is
			-- Describe `index'th column of current result-set of `stmt', limiting the name length to `max_name_length'
		require
			stmt_prepared_or_executed : stmt /= Void and then stmt.is_prepared or stmt.is_executed
			valid_index: index > 0
			valid_maximum: max_name_length > 0
		local
			stat : INTEGER
			c_name : XS_C_STRING
		do
			create c_name.make (max_name_length + 1)
			stat := ecli_c_describe_column (stmt.handle,
				index,
				c_name.handle,
				max_name_length,
				ext_actual_name_length.handle,
				ext_sql_type_code.handle,
				ext_size.handle,
				ext_decimal_digits.handle,
				ext_nullability.handle)
			stmt.set_status (stat)
			name := c_name.as_string
			--actual_name_length := ext_actual_name_length.item
			sql_type_code := ext_sql_type_code.item
			size := ext_size.item
			decimal_digits := ext_decimal_digits.item
			nullability := ext_nullability.item
		end

feature -- Access

	name : STRING
			-- column name

feature -- Measurement

	hash_code : INTEGER is
		do
			Result := name.hash_code
		end

feature -- Comparison

	is_equal (other : like Current) : BOOLEAN is
			-- 
		do
			Result := same_description (other) and then name.is_equal (other.name)
		end
		
feature {NONE} -- Implementation

	ext_actual_name_length : XS_C_INT32 is once create Result.make end

--	temporary_name : STRING is
--			-- 
--		once !!Result.make (100)
--		end

invariant
	name_exists: name /= Void
	
end -- class ECLI_COLUMN_DESCRIPTION
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
