indexing

	description: "Results objects ."
	status: "Automatically generated.  DOT NOT MODIFY !"

class PARTICIPANTS_BY_AMOUNT_PARAMETERS

creation

	make

feature {NONE} -- Initialization

	make is
			-- -- Creation of buffers
		do
			create paid_amount.make
		end

feature  -- Access

	paid_amount: ECLI_DOUBLE

end -- class PARTICIPANTS_BY_AMOUNT_PARAMETERS
