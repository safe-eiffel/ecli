note
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

	hash_code : INTEGER
			-- 
		do
			Result := name.hash_code
		end

	name : STRING
			-- name of metadata
		require
			metadata_available: metadata_available
		deferred
		end
	
	eiffel_name : STRING
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
	
	value_type : STRING do Result := implementation.value_type end	
	
	creation_call : STRING
			-- call for creating a corresponding eiffel entity
		require
			metadata_available: metadata_available
		do
			Result := implementation.creation_call
		end
		
	ecli_type : STRING
			-- ecli type for declaring a corresponding eiffel entity
		require
			metadata_available: metadata_available
		do
			Result := implementation.ecli_type			
		end

	sql_type_code : INTEGER
			-- corresponding sql type code
		require
			metadata_available: metadata_available
		deferred
		end
		
	size : INTEGER
			-- size in bytes
		require
			metadata_available: metadata_available
		deferred
		end
		
	decimal_digits : INTEGER
			-- 
		require
			metadata_available: metadata_available
		deferred
		end
		
feature -- Status report

	metadata_available : BOOLEAN
			-- 
		deferred
		end
	
	is_equal (other : like Current) : BOOLEAN
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

	factory : QA_VALUE_FACTORY
			-- 
		once
			create Result.make
		end
	
	create_implementation
			-- 
		do
			factory.create_instance (sql_type_code, size, decimal_digits)	
			impl_value := factory.last_result
		end
		
	impl_value : QA_VALUE
	
	implementation : QA_VALUE
			-- 
		do
			if impl_value = Void then
				create_implementation
			end
			Result := impl_value
		end
			
invariant
	name_not_void: name /= Void

end -- class ACCESS_MODULE_METADATA
--
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
