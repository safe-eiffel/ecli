note

	description:

			"Description of Parameter data."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

	class ECLI_PARAMETER_DESCRIPTION

inherit

	ECLI_DATA_DESCRIPTION

	-- begin mix-in
	ECLI_EXTERNAL_API
		undefine
			is_equal
		end

	ECLI_NULLABLE_METADATA
		undefine
			is_equal
		end
	-- end mix-in

create

	make

feature {NONE} -- Initialization

	make (stmt : ECLI_STATEMENT; index : INTEGER)
		do
			stmt.set_status ("ecli_c_describe_parameter", ecli_c_describe_parameter (stmt.handle,
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

	db_type_code : INTEGER obsolete "Use sql_type_code instead." do Result := sql_type_code end

	sql_type_code : INTEGER
			-- type code of SQL data type

	size : INTEGER_64
			-- The column size of numeric data types is defined as the maximum number of digits used
			-- by the data type of the column or parameter, or the precision of the data.
			-- For character types, this is the length in characters of the data;
			-- for binary data types, column size is defined as the length in bytes of the data.
			-- For the time, timestamp, and all interval data types, this is the number of characters
			-- in the character representation of this data

	decimal_digits : INTEGER
			-- maximum number of digits to the right of the decimal point, or the scale of the data. For numeric types only.

feature -- Comparison

feature {NONE} -- Implementation

		ext_sql_type_code : XS_C_INT32 once create Result.make end
		ext_size : XS_C_INT64 once create Result.make end
		ext_decimal_digits : XS_C_INT32 once create Result.make end
		ext_nullability : XS_C_INT32 once create Result.make end

end
