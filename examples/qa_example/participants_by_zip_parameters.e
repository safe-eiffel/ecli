note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/09/03 16:46:50.865"
	generator_version: "v1.6"
	source_filename: "access_modules.xml"

class PARTICIPANTS_BY_ZIP_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create zip.make
		ensure
			zip_is_null: zip.is_null
		end

feature  -- Access

	zip: ECLI_INTEGER

end
