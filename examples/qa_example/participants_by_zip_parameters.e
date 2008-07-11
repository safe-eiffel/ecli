indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2008/07/11 16:04:38.286"

class PARTICIPANTS_BY_ZIP_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make is
			-- Creation of buffers
		do
			create zip.make
		ensure
			zip_is_null: zip.is_null
		end

feature  -- Access

	zip: ECLI_INTEGER

end
