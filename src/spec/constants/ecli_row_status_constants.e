indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ROW_STATUS_CONSTANTS

inherit
		ECLI_API_CONSTANTS
			export
				{ANY} 
					Sql_row_added, 
					Sql_row_deleted, 
					Sql_row_error, 
					Sql_row_norow, 
					Sql_row_success,
					Sql_row_success_with_info
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
	invariant_clause: True -- Your invariant here

end -- class ECLI_ROW_STATUS_CONSTANTS
