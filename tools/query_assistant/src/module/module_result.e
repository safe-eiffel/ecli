indexing
	description: "Module result metadata"

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	MODULE_RESULT

inherit
	ACCESS_MODULE_METADATA
		
	HASHABLE
		undefine
			is_equal
		end
		
create
	make

feature {NONE} -- Initialization

	make (the_metadata : ECLI_COLUMN_DESCRIPTION; maximum_length : INTEGER) is
			-- Initialize `Current'.
		require
			the_metadata_not_void: the_metadata /= Void
		do
			metadata := the_metadata
			if maximum_length > 0 then
				size_impl := maximum_length.min (metadata.size)
			else
				size_impl := metadata.size
			end
		ensure
			metadata_assigned: metadata = the_metadata
		end

feature {NONE}-- Access

	metadata : ECLI_COLUMN_DESCRIPTION
	
feature -- Access

			
	sql_type_code : INTEGER is
		do
			Result := metadata.sql_type_code
		end
		
	size : INTEGER is
		do
			Result := size_impl -- metadata.size
		end
		
	decimal_digits : INTEGER is
		do
			Result := metadata.decimal_digits
		end
	
	name : STRING is
		do
			Result := clone(metadata.name)
			Result.to_lower
		end

feature -- Status report

	metadata_available : BOOLEAN is
		do
			Result := metadata /= Void
		end
		
feature {NONE} -- implementation

	size_impl : INTEGER

end -- class MODULE_RESULT
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
