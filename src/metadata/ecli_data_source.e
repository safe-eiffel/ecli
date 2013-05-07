note

	description:

			"ODBC Data sources."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DATA_SOURCE

create

	make

feature {NONE} -- Initialization

	make (cursor : ECLI_DATA_SOURCES_CURSOR)
			-- create from current item in cursor
		require
			cursor_not_void: cursor /= Void  --FIXME: VS-DEL
			cursor_not_off: not cursor.off
			cursor_name_not_void: cursor.name /= Void  --FIXME: VS-DEL
			cursor_description_not_void: cursor.description /= Void --FIXME: VS-DEL
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
	name_not_void: name /= Void -- FIXME: VS-DEL
	description_not_void: description /= Void -- FIXME: VS-DEL

end
