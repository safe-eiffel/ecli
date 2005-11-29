indexing

	description: "Results objects ."
	status: "Automatically generated.  DOT NOT MODIFY !"

class PARTICIPANTS_BY_NAME_PARAMETERS

creation

	make

feature {NONE} -- Initialization

	make is
			-- -- Creation of buffers
		do
			create last_name.make (30)
		end

feature  -- Access

	last_name: ECLI_VARCHAR

end -- class PARTICIPANTS_BY_NAME_PARAMETERS
