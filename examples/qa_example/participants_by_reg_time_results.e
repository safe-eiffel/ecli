note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/09/03 16:46:50.934"
	generator_version: "v1.6"
	source_filename: "access_modules.xml"

class PARTICIPANTS_BY_REG_TIME_RESULTS

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
			create paid_amount.make
		ensure then
			reg_time_is_null: reg_time.is_null
			paid_amount_is_null: paid_amount.is_null
		end

feature  -- Access

	reg_time: ECLI_BINARY

	paid_amount: ECLI_REAL

end
