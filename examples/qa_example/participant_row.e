indexing

	description: "Results objects ."
	status: "Automatically generated.  DOT NOT MODIFY !"

class PARTICIPANT_ROW

creation

	make

feature {NONE} -- Initialization

	make is
			-- -- Creation of buffers
		do
			create identifier.make
			create first_name.make (30)
			create last_name.make (30)
			create street.make (100)
			create no.make (10)
			create zip.make
			create city.make (50)
			create state.make (20)
			create country.make (20)
		end

feature  -- Access

	identifier: ECLI_INTEGER

	first_name: ECLI_VARCHAR

	last_name: ECLI_VARCHAR

	street: ECLI_VARCHAR

	no: ECLI_VARCHAR

	zip: ECLI_INTEGER

	city: ECLI_VARCHAR

	state: ECLI_VARCHAR

	country: ECLI_VARCHAR

end -- class PARTICIPANT_ROW
