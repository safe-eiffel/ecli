indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2008/07/11 16:04:38.318"

class PARTICIPANTS_COUNT_BY_REMAINING_PARAMETERS

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
