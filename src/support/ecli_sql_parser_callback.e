indexing

	description:
	
			"Objects that are called back by an ECLI_SQL_PARSER."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_SQL_PARSER_CALLBACK

feature -- Status report

	is_valid : BOOLEAN is
			-- 
		deferred
		end
		
feature -- Basic operations

	add_new_parameter (a_parameter_name : STRING; a_position : INTEGER) is
		require
			valid_callback : is_valid
		deferred
		end

end
