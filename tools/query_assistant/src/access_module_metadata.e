indexing
	description: "Access module metadata objects"

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"	
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ACCESS_MODULE_METADATA

inherit
	HASHABLE
	
feature -- Access

	name : STRING is
			-- name of metadata
		require
			metadata_available: metadata_available
		deferred
		end
	
	eiffel_name : STRING is
			-- name of eiffel entity
		do
			create Result.make_from_string (name)
			Result.to_lower
		end
		
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
	
invariant
	name_exists: name /= Void

end -- class ACCESS_MODULE_METADATA
