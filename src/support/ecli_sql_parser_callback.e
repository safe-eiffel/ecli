indexing
	description: "Objects that are called back by an ECLI_SQL_PARSER"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ECLI_SQL_PARSER_CALLBACK

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

end -- class ECLI_SQL_PARSER_CALLBACK
