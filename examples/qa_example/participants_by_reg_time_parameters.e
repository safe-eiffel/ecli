indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2006/03/21 14:12:57.093"

class PARTICIPANTS_BY_REG_TIME_PARAMETERS

creation

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

end -- class PARTICIPANTS_BY_REG_TIME_PARAMETERS
