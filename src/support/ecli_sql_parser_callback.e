indexing
	description: "Objects that are called back by an ECLI_SQL_PARSER"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ECLI_SQL_PARSER_CALLBACK

feature -- Access

feature -- Measurement

feature -- Status report

	is_valid : BOOLEAN is
			-- 
		deferred
		end
		
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

	add_new_parameter (a_parameter_name : STRING; a_position : INTEGER) is
		require
			valid_callback : is_valid
		deferred
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_SQL_PARSER_CALLBACK
