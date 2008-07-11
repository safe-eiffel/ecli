indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2008/07/11 16:04:38.302"

class PARTICIPANTS_BY_ZIP_RESULTS

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
