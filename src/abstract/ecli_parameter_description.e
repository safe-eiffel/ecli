indexing
	description: "Description of Parameter data"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_PARAMETER_DESCRIPTION

inherit
	ECLI_DATA_DESCRIPTION

	ECLI_EXTERNAL_TOOLS -- mix-in
		export {NONE} all
		end

	ECLI_EXTERNAL_API

creation
	make

feature {NONE} -- Initialization
	
	make (stmt : ECLI_STATEMENT; index : INTEGER) is
		do
			stmt.set_status (
				ecli_c_describe_parameter (stmt.handle,
					index,
					pointer ($db_type_code),
					pointer ($column_precision),
					pointer ($decimal_digits),
					pointer ($nullability)))			
		end

feature -- Status report

	db_type_code : INTEGER
		
	column_precision : INTEGER

	decimal_digits : INTEGER

	is_nullable : BOOLEAN is
		require
			known_nullability: is_known_nullability
		do
			Result := nullability = cli_nullable
		end

	is_not_nullable : BOOLEAN is
		require
			known_nullability: is_known_nullability
		do
			Result := nullability = cli_no_nulls
		end

	is_known_nullability : BOOLEAN is
		do
			Result := not (nullability = cli_nullable_unknown)
		end

feature {NONE}  -- Implementation

	nullability : INTEGER

	cli_nullable : INTEGER is
		once
			Result := ecli_c_nullable
		end

	cli_nullable_unknown : INTEGER is
		once
			Result := ecli_c_nullable_unknown
		end

	cli_no_nulls : INTEGER is
		once
			Result := ecli_c_no_nulls
		end

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_PARAMETER_DESCRIPTION
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
