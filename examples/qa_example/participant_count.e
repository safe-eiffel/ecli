indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2009/03/03 16:41:35.490"
	generator_version: "v1.3b"

class PARTICIPANT_COUNT

create

	make

feature {NONE} -- Initialization

	make is
			-- Creation of buffers
		do
			create count.make
		ensure
			count_is_null: count.is_null
		end

feature  -- Access

	count: ECLI_INTEGER

end
