note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/09/03 16:46:50.930"
	generator_version: "v1.6"
	source_filename: "access_modules.xml"

class PARTICIPANTS_BY_REG_TIME_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create reg_time.make (8)
		ensure
			reg_time_is_null: reg_time.is_null
		end

feature  -- Access

	reg_time: ECLI_BINARY

end
