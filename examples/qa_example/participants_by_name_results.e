indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2009/03/03 16:41:32.896"
	generator_version: "v1.3b"

class PARTICIPANTS_BY_NAME_RESULTS

inherit

	PARTICIPANT_ROW
		redefine
			make
		end

create

	make

feature {NONE} -- Initialization

	make is
			-- Creation of buffers
		do
			Precursor
			create no.make (10)
		ensure then
			no_is_null: no.is_null
		end

feature  -- Access

	no: ECLI_VARCHAR

end
