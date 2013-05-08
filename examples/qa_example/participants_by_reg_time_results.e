note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/05/08 18:11:42.140"
	generator_version: "v1.7.2"
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
			create no.make
			create reg_time.make_null
			create paid_amount.make
		ensure then
			no_is_null: no.is_null
			reg_time_is_null: reg_time.is_null
			paid_amount_is_null: paid_amount.is_null
		end

feature  -- Access

	no: ECLI_INTEGER

	reg_time: ECLI_TIMESTAMP

	paid_amount: ECLI_REAL

end
