indexing
	description: "ODBC Data sources."

	author: "Paul G. Crismer"
	
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_DATA_SOURCE

creation
	make
	
feature {NONE} -- Initialization

	make (cursor : ECLI_DATA_SOURCES_CURSOR) is
			-- create from current item in cursor
		require
			cursor_valid: cursor /= Void and then not cursor.off
		do
			name := clone (cursor.name)
			description := clone (cursor.description)
		end
		
feature -- Access
	
	name : STRING
			-- name of datasource
	
	description : STRING
			-- description

invariant
	name_not_void: name /= Void
	description_not_void: description /= Void

end -- class ECLI_DATA_SOURCE
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
