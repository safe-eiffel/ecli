note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/05/08 18:11:42.093"
	generator_version: "v1.7.2"
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
			create no.make
			create reg_time.make_null
			create remaining.make
		ensure then
			no_is_null: no.is_null
			reg_time_is_null: reg_time.is_null
			remaining_is_null: remaining.is_null
		end

feature  -- Access

	no: ECLI_INTEGER

	reg_time: ECLI_TIMESTAMP

	remaining: ECLI_DOUBLE

end
