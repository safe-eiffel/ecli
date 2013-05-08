note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/05/08 18:11:42.125"
	generator_version: "v1.7.2"
	source_filename: "access_modules.xml"

class PARTICIPANTS_BY_REG_TIME_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create reg_time.make_null
		ensure
			reg_time_is_null: reg_time.is_null
		end

feature  -- Access

	reg_time: ECLI_TIMESTAMP

end
