indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2006/03/21 14:12:57.046"

class PARTICIPANTS_COUNT_BY_REMAINING_PARAMETERS

creation

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

end -- class PARTICIPANTS_COUNT_BY_REMAINING_PARAMETERS
