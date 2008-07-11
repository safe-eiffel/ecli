indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2008/07/11 16:04:38.411"

class PARTICIPANTS_BY_REG_TIME_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make is
			-- Creation of buffers
		do
			create reg_time.make_null
		ensure
			reg_time_is_null: reg_time.is_null
		end

feature  -- Access

	reg_time: ECLI_TIMESTAMP

end
