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
		undefine
			is_equal
		end
		
	HASHABLE
		redefine
			is_equal
		end
		
create
	make

feature {NONE} -- Initialization

	make (the_metadata : ECLI_COLUMN_DESCRIPTION) is
			-- Initialize `Current'.
		require
			the_metadata_exist: the_metadata /= Void
		do
			metadata := the_metadata
		ensure
			metadata_assigned: metadata = the_metadata
		end

feature -- Access

	metadata : ECLI_COLUMN_DESCRIPTION
	
	hash_code : INTEGER is
			-- 
		do
			Result := metadata.name.hash_code
		end
			
	sql_type_code : INTEGER is
		do
			Result := metadata.sql_type_code
		end
		
	size : INTEGER is
		do
			Result := metadata.size
		end
		
	decimal_digits : INTEGER is
		do
			Result := metadata.decimal_digits
		end
	
	name : STRING is
		do
			Result := metadata.name
		end

feature -- Status report

	metadata_available : BOOLEAN is
		do
			Result := metadata /= Void
		end
		
feature -- Inapplicable

	is_equal (other : like Current) : BOOLEAN is
		do
			Result := metadata.is_equal (other.metadata)
		end

end -- class MODULE_RESULT
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
