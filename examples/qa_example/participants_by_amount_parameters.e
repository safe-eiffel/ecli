note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/05/08 18:11:42.109"
	generator_version: "v1.7.2"
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
