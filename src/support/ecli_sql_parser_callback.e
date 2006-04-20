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
			a_parameter_name_not_void: a_parameter_name /= Void
			a_position_stricly_positive: a_position > 0
		deferred
		end

end
