indexing
	description: "Objects that ..."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_PARAMETER_DESCRIPTION

inherit
	ECLI_PARAMETER_DESCRIPTION
		rename
			make as ecli_make
		end

creation
	make_by_statement, make_by_description

feature {NONE} -- Initialization

	make_by_description (description : ECLI_PARAMETER_DESCRIPTION; a_name : STRING) is
			--	
		require
			description: description /= Void
			name:		 a_name /= Void
		do
			ecli_make (stmt, index)
			name := a_name
		ensure
			name: name = a_name
		end

	make (a_name : STRING; a_db_type_code, a_column_precision, a_decimal_digits : INTEGER) is
		do
			name := a_name
			db_type_code := a_db_type_code
			column_precision := a_column_precision
			decimal_digits := a_decimal_digits
		ensure
			name: name = a_name
			type: db_type_code = a_db_type_code
			precision: column_precision = a_column_precision
			digits: decilam_digits = a_decimal_digits
		end

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: -- Your invariant here

end -- class QA_PARAMETER_DESCRIPTION
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
