indexing

	description:

		"Shared CLI environment."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_SHARED_ENVIRONMENT

inherit
	ECLI_EXTERNAL_API

	ECLI_ENVIRONMENT_ATTRIBUTE_CONSTANTS

feature -- Basic operations

	enable_connection_pooling
		local
			res : INTEGER
		do
			 res := ecli_c_set_natural_environment_attribute (default_pointer, sql_attr_connection_pooling, sql_cp_one_per_henv, sql_is_integer)
		end

	disable_connection_pooling
		local
			res : INTEGER
		do
			 res := ecli_c_set_natural_environment_attribute (default_pointer, sql_attr_connection_pooling, sql_cp_off, sql_is_integer)
		end

feature -- Access

	shared_environment : ECLI_ENVIRONMENT is
		once
			create Result.make
		end

end
