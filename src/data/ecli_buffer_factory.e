indexing
	description: 
		
		"Objects that create buffers for DB to application information exchange."

	author: "Paul G. Crismer."
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_BUFFER_FACTORY

inherit
	ECLI_ABSTRACT_BUFFER_FACTORY [ECLI_VALUE]
	
feature
	
	value_factory : ECLI_VALUE_FACTORY is
			-- 
		once
			create Result.make
		end
		
	
end -- class ECLI_BUFFER_FACTORY
