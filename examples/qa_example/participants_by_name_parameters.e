indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2006/03/21 14:12:57.031"

class PARTICIPANTS_BY_NAME_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make is
			-- Creation of buffers
		do
			create last_name.make (30)
		ensure
			last_name_is_null: last_name.is_null
		end

feature  -- Access

	last_name: ECLI_VARCHAR

end -- class PARTICIPANTS_BY_NAME_PARAMETERS
