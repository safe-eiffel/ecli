indexing
	description: "Description of result-set column"
	author: "Paul G. Crismer"
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
			temp_name : STRING
			p_temp_name : POINTER
		do
			!! temp_name.make (max_name_length)
			p_temp_name := string_to_pointer (temp_name)
			stmt.set_status (
				ecli_c_describe_column (stmt.handle,
					index,
					p_temp_name,
					max_name_length,
					pointer ($actual_name_length),
					pointer ($sql_type_code),
					pointer ($column_precision),
					pointer ($decimal_digits),
					pointer ($nullability)))
			name := pointer_to_string (p_temp_name)
		end

feature -- Access

	name : STRING
			-- column name

feature {NONE} -- Implementation

	actual_name_length : INTEGER

end -- class ECLI_COLUMN_DESCRIPTION
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
