indexing

	description:
	
			"Argument Errors."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class QA_ARGUMENTS_ERROR

inherit

	QA_ERROR

creation
	
	make_missing,
	make_invalid
	
feature {NONE} -- Initialization

	make_missing (argument_name, explanation : STRING) is
			-- Make for missing `argument_name' using `explanation'.
		require
			argument_name_not_void: argument_name /= Void
			explanation_not_void: explanation /= Void
		do
			default_template := missing_template
			make (argument_name, explanation)
		end

	make_invalid (argument_name, explanation : STRING) is
			-- Make for invalid `argument_name' using `explanation'.
		require
			argument_name_not_void: argument_name /= Void
			explanation_not_void: explanation /= Void
		do
			default_template := invalid_template
			make (argument_name, explanation)
		end
	
	make (argument_name, explanation : STRING) is
			-- Make for `argument_name' using `explanation'.
		require
			argument_name_not_void: argument_name /= Void
			explanation_not_void: explanation /= Void
			default_template_not_void: default_template /= Void
		do
			create parameters.make (1,2)
			parameters.put (argument_name, 1)
			parameters.put (explanation, 2)
		end
			
feature {NONE} -- Implementation

	missing_template : STRING is "[E-ARG-MISSING] Argument '$1' missing : $2."
	invalid_template : STRING is "[E-ARG-INVALID] Argument '$1' invalid : $2."

end -- class QA_ARGUMENTS_ERROR
