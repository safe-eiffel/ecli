indexing

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2006/03/21 14:12:57.109"

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

end -- class PARTICIPANT_COUNT
