indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2009/03/03 16:41:34.021"
	generator_version: "v1.3b"

class PARTICIPANTS_BY_REMAINING_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make is
			-- Creation of buffers
		do
			create remaining_amount.make
		ensure
			remaining_amount_is_null: remaining_amount.is_null
		end

feature  -- Access

	remaining_amount: ECLI_DOUBLE

end
