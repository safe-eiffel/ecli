indexing

	description: "Results objects "
	status: "Automatically generated.  DOT NOT MODIFY !"

class PARTICIPANTS_BY_REMAINING_PARAMETERS

creation

	make

feature {NONE} -- Initialization

	make is
			-- -- Creation of buffers
		do
			create remaining_amount.make
		end

feature  -- Access

	remaining_amount: ECLI_DOUBLE

end -- class PARTICIPANTS_BY_REMAINING_PARAMETERS
