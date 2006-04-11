indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2006/03/21 14:12:57.046"

class PARTICIPANTS_BY_ZIP_RESULTS

inherit

	PARTICIPANT_ROW
		redefine
			make
		end

creation

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

end -- class PARTICIPANTS_BY_ZIP_RESULTS
