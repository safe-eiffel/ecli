indexing
	description: "Access module metadata objects."

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"	
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RDBMS_ACCESS_METADATA

inherit
	HASHABLE
		redefine
			is_equal, hash_code
		end
		
feature -- Access

	name : STRING is
			-- name of metadata
		require
			metadata_available: metadata_available
		deferred
		end
	
	eiffel_name : STRING is
			-- name of eiffel entity
		local
			index : INTEGER
		do
			create Result.make (name.count)
			from
				index := 1
			until
				index > name.count
			loop
				inspect name.item (index)
				when 'a'..'z', 'A'..'Z', '0'..'9', '_' then
					Result.append_character (name.item (index))
				else
					Result.append_character ('_')
				end
				index := index + 1
			end
			Result.to_lower
		end
	
	value_type : STRING is do Result := implementation.value_type end	
	
	creation_call : STRING is
			-- call for creating a corresponding eiffel entity
		require
			metadata_available: metadata_available
		do
			Result := implementation.creation_call
		end
		
	ecli_type : STRING is
			-- ecli type for declaring a corresponding eiffel entity
		require
			metadata_available: metadata_available
		do
			Result := implementation.ecli_type			
		end

	sql_type_code : INTEGER is
			-- corresponding sql type code
		require
			metadata_available: metadata_available
		deferred
		end
		
	size : INTEGER is
			-- size in bytes
		require
			metadata_available: metadata_available
		deferred
		end
		
	decimal_digits : INTEGER is
			-- 
		require
			metadata_available: metadata_available
		deferred
		end
		
feature -- Status report

	metadata_available : BOOLEAN is
			-- 
		deferred
		end
	
	is_equal (other : like Current) : BOOLEAN is
			-- 
		do
			if metadata_available and then other.metadata_available then
				Result := (sql_type_code = other.sql_type_code and then
				size = other.size and then
				decimal_digits = other.decimal_digits and then
				name.is_equal (other.name))
			end
		end
		
feature {NONE} -- Implementation

	factory : QA_VALUE_FACTORY is
			-- 
		once
			create Result.make
		end
	
	create_implementation is
			-- 
		do
			factory.create_instance (sql_type_code, size, decimal_digits)	
			impl_value := factory.last_result
		end
		
	impl_value : QA_VALUE
	
	implementation : QA_VALUE is
			-- 
		do
			if impl_value = Void then
				create_implementation
			end
			Result := impl_value
		end
	
	hash_code : INTEGER is
			-- 
		do
			Result := name.hash_code
		end
		
invariant
	name_not_void: name /= Void

end -- class ACCESS_MODULE_METADATA
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
