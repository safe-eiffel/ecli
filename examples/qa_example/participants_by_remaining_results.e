indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2008/07/11 16:04:38.365"

class PARTICIPANTS_BY_REMAINING_RESULTS

inherit

	PARTICIPANT_ROW
		redefine
			make
		end

create

	make

feature {NONE} -- Initialization

	make is
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
