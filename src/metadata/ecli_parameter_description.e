indexing
	description: "Description of Parameter data"
	author: "Paul G. Crismer"
	
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
class
	ECLI_PARAMETER_DESCRIPTION

inherit
	ECLI_DATA_DESCRIPTION

	-- begin mix-in
	ECLI_EXTERNAL_TOOLS
		export {NONE} all
		end

	ECLI_EXTERNAL_API
	
	ECLI_NULLABLE_METADATA
	-- end mix-in
	
creation
	make

feature {NONE} -- Initialization
	
	make (stmt : ECLI_STATEMENT; index : INTEGER) is
		do
			stmt.set_status (
				ecli_c_describe_parameter (stmt.handle,
					index,
					ext_sql_type_code.handle,
					ext_size.handle,
					ext_decimal_digits.handle,
					ext_nullability.handle))
			sql_type_code := ext_sql_type_code.item
			size := ext_size.item
			decimal_digits := ext_decimal_digits.item
			nullability := ext_nullability.item
		end

feature -- Access

	db_type_code : INTEGER is obsolete "Use sql_type_code instead." do Result := sql_type_code end
	
	sql_type_code : INTEGER
			-- type code of SQL data type
		
	column_precision : INTEGER is obsolete "Use 'size' instead" do Result := size end

	size : INTEGER
			-- The column size of numeric data types is defined as the maximum number of digits used 
			-- by the data type of the column or parameter, or the precision of the data. 
			-- For character types, this is the length in characters of the data; 
			-- for binary data types, column size is defined as the length in bytes of the data. 
			-- For the time, timestamp, and all interval data types, this is the number of characters 
			-- in the character representation of this data
	
	decimal_digits : INTEGER
			-- maximum number of digits to the right of the decimal point, or the scale of the data. For numeric types only.

feature {NONE} -- Implementation

		ext_sql_type_code : XS_C_INT32 is once create Result.make end
		ext_size : XS_C_INT32 is once create Result.make end
		ext_decimal_digits : XS_C_INT32 is once create Result.make end
		ext_nullability : XS_C_INT32 is once create Result.make end		

end -- class ECLI_PARAMETER_DESCRIPTION
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
