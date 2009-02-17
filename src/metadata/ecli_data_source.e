indexing

	description:

			"ODBC Data sources."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DATA_SOURCE

create

	make

feature {NONE} -- Initialization

	make (cursor : ECLI_DATA_SOURCES_CURSOR) is
			-- create from current item in cursor
		require
			cursor_valid: cursor /= Void and then not cursor.off
			cursor_name_not_void: cursor.name /= Void
			cursor_description_not_void: cursor.description /= Void
		do
			name := cursor.name.twin
			description := cursor.description.twin
		end

feature -- Access

	name : STRING
			-- name of datasource

	description : STRING
			-- description

invariant
	name_not_void: name /= Void
	description_not_void: description /= Void

end
