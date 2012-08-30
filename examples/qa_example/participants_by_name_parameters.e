note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2009/03/03 16:41:32.787"
	generator_version: "v1.3b"

class PARTICIPANTS_BY_NAME_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create last_name.make (30)
		ensure
			last_name_is_null: last_name.is_null
		end

feature  -- Access

	last_name: ECLI_VARCHAR

end
