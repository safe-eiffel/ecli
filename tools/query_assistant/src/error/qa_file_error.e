note
	description:
	
			"File Errors."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class QA_FILE_ERROR

inherit
	
	QA_ERROR
	
create
	
	make_cannot_read,
	make_cannot_write
	
feature {NONE} -- Initialization

	make_cannot_read (a_file_name : STRING)
			-- Create error because `a_file_name' cannot be open for read.
		require
			a_file_name_not_void: a_file_name /= Void
		do
			make (cannotread_template, a_file_name)
		end
		
	make_cannot_write (a_file_name : STRING)
			-- Create error because `a_file_name' cannot be open for write.
		require
			a_file_name_not_void: a_file_name /= Void
		do
			make (cannotwrite_template, a_file_name)
		end
		
	make (a_template : STRING; a_file_name : STRING)
			-- Create error using `a_template' and `a_file_name'.
		require
			a_template_not_void: a_template /= Void
			a_file_name_not_void: a_file_name /= Void
		do
			create parameters.make (1,1)
			parameters.put (a_file_name, 1)
			default_template := a_template
		end
		
feature {NONE} -- Implementation

	cannotread_template : STRING = "[E-FIL-NOTRDBL] File  not readable : '$1'"
	cannotwrite_template : STRING = "[E-FIL-NOTWRBL] File not writable : '$1'"

invariant


end
