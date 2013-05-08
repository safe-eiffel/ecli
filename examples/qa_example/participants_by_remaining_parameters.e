note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/05/08 18:11:42.093"
	generator_version: "v1.7.2"
	source_filename: "access_modules.xml"

class PARTICIPANTS_BY_REMAINING_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create remaining_amount.make
		ensure
			remaining_amount_is_null: remaining_amount.is_null
		end

feature  -- Access

	remaining_amount: ECLI_REAL

end
