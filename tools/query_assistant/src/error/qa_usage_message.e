indexing

	description:
	
			"Usage messages"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class QA_USAGE_MESSAGE

inherit
	QA_ERROR

creation
	make
	
feature -- Initialization

	make (has_expat : BOOLEAN) is
		do
			default_template := usage_template
			create parameters.make (1, 2)
			parameters.put (argument_list, 1)
			if has_expat then
				parameters.put (has_expat_option, 2)
			else
				parameters.put (without_expat_option, 2)
			end
		end
		
feature {NONE} -- Implementation

	usage_template : STRING is "usage: $0 $2 $1"
	
	argument_list : STRING is "-input <input-file> -output_dir <output-directory> %
			 % -dsn <data-source-name> -user <user-name> -pwd <password> [-catalog <catalog>] [-schema <schema>] %
			 % [-access_routines_prefix <prefix>] [-max_length <max_length_for_long_data>]"
	
	has_expat_option : STRING is "(-expat|-eiffel)"
	without_expat_option : STRING is "-eiffel"

end -- class QA_USAGE_MESSAGE
