indexing

	description: "Results objects ."
	status: "Automatically generated.  DOT NOT MODIFY !"

class PARTICIPANTS_BY_REMAINING_RESULTS

inherit

	PARTICIPANT_AMOUNT_ROW
		redefine
			make
		end

creation

	make

feature {NONE} -- Initialization

	make is
			-- -- Creation of buffers
		do
			Precursor
			create remaining.make
		end

feature  -- Access

	remaining: ECLI_DOUBLE

end -- class PARTICIPANTS_BY_REMAINING_RESULTS
