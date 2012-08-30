note
	description: "Objects that share a same schema name."

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_SCHEMA_NAME

feature -- Access

	shared_schema_name : STRING
			-- 
		once
			create Result.make (0)
		end
		
feature -- Element change

	set_shared_schema_name (a_name : STRING)
			-- 
		require
			a_name_not_void: a_name /= Void
		do
			shared_schema_name.copy (a_name)
		ensure
			shared_schema_name_set: shared_schema_name.is_equal (a_name)
		end

end -- class SHARED_SCHEMA_NAME
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--

