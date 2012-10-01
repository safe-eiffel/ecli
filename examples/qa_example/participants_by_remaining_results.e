note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/09/03 16:46:50.895"
	generator_version: "v1.6"
	source_filename: "access_modules.xml"

class PARTICIPANTS_BY_REMAINING_RESULTS

inherit

	PARTICIPANT_ROW
		redefine
			make
		end

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			Precursor
			create reg_time.make (8)
			create remaining.make
		ensure then
			reg_time_is_null: reg_time.is_null
			remaining_is_null: remaining.is_null
		end

feature  -- Access

	reg_time: ECLI_BINARY

	remaining: ECLI_REAL

end
