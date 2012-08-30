note

	description:

			"Description of result-set column."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_COLUMN_DESCRIPTION

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

create 

	make

feature {NONE} -- Initialization

	make (stmt : ECLI_STATEMENT; index : INTEGER; max_name_length : INTEGER)
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
			stmt.set_status ("stat", stat)
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

	hash_code : INTEGER
		do
			Result := name.hash_code
		end

feature -- Comparison

	is_equal (other : like Current) : BOOLEAN
			--
		do
			Result := same_description (other) and then name.is_equal (other.name)
		end

feature {NONE} -- Implementation

	ext_actual_name_length : XS_C_INT32 once create Result.make end

invariant
	name_not_void: name /= Void

end
