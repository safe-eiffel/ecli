note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/05/08 18:11:42.062"
	generator_version: "v1.7.2"
	source_filename: "access_modules.xml"

class PARTICIPANTS_BY_ZIP_RESULTS

inherit

	PARTICIPANT_ROW
		redefine
			make
		end

create

	make

feature {NONE} -- Initialization

	make
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
