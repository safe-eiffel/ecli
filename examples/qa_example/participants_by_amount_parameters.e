indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2009/03/03 16:41:34.568"
	generator_version: "v1.3b"

class PARTICIPANTS_BY_AMOUNT_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make is
			-- Creation of buffers
		do
			create paid_amount.make
		ensure
			paid_amount_is_null: paid_amount.is_null
		end

feature  -- Access

	paid_amount: ECLI_DOUBLE

end
