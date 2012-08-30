note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2009/03/03 16:41:35.052"
	generator_version: "v1.3b"

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
