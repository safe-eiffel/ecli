note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/09/03 16:46:50.910"
	generator_version: "v1.6"
	source_filename: "access_modules.xml"

class PARTICIPANTS_BY_AMOUNT_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create paid_amount.make
		ensure
			paid_amount_is_null: paid_amount.is_null
		end

feature  -- Access

	paid_amount: ECLI_REAL

end
