note
	description: "Procedure reference columns for parameters."

	library: "Access_gen : Access Modules Generators utilities"

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	PROCEDURE_REFERENCE_COLUMN

inherit
	REFERENCE_COLUMN
		rename
			table as procedure
		redefine
			new_cursor
		end

create
	make

feature -- Access

	new_cursor (a_procedure : ECLI_NAMED_METADATA; a_session: ECLI_SESSION) : ECLI_COLUMNS_CURSOR
			-- New cursor on `a_procedure' columns metadata, querying `a_session' catalog.
		do
			create {ECLI_PROCEDURE_COLUMNS_CURSOR} Result.make_query_column (a_procedure, column, a_session)
		end

end
