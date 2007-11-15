indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2006/03/21 14:12:57.093"

class PARTICIPANT_ROW

create

	make

feature {NONE} -- Initialization

	make is
			-- Creation of buffers
		do
			create identifier.make
			create first_name.make (30)
			create last_name.make (30)
			create street.make (100)
			create zip.make
			create city.make (50)
			create state.make (20)
			create country.make (20)
		ensure
			identifier_is_null: identifier.is_null
			first_name_is_null: first_name.is_null
			last_name_is_null: last_name.is_null
			street_is_null: street.is_null
			zip_is_null: zip.is_null
			city_is_null: city.is_null
			state_is_null: state.is_null
			country_is_null: country.is_null
		end

feature  -- Access

	identifier: ECLI_INTEGER

	first_name: ECLI_VARCHAR

	last_name: ECLI_VARCHAR

	street: ECLI_VARCHAR

	zip: ECLI_INTEGER

	city: ECLI_VARCHAR

	state: ECLI_VARCHAR

	country: ECLI_VARCHAR

end -- class PARTICIPANT_ROW
