indexing
	description: "Objects that define a row cursor and allow sweeping through it."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ROW_CURSOR

inherit
	ECLI_ABSTRACT_ROW_CURSOR [ECLI_VALUE,ECLI_VALUE]

creation
	make, open, make_prepared, open_prepared


feature
	
	create_buffer_factory is
			-- 
		do
			create {ECLI_BUFFER_FACTORY}buffer_factory
		end
		
end -- class ECLI_ROW_CURSOR
