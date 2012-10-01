note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/09/03 16:46:50.952"
	generator_version: "v1.6"
	source_filename: "access_modules.xml"

class PARTICIPANT_COUNT

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create count.make
		ensure
			count_is_null: count.is_null
		end

feature  -- Access

	count: ECLI_INTEGER

end
