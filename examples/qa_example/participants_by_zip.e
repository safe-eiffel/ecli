indexing

	
		description: "Select participants by zip"
	
	warning: "Generated cursor 'PARTICIPANTS_BY_ZIP' : DO NOT EDIT !"
	author: "QUERY_ASSISTANT"
	date: "$Date : $"
	revision: "$Revision : $"
	licensing: "See notice at end of class"

class PARTICIPANTS_BY_ZIP

inherit

	ECLI_CURSOR


creation

	make

feature  -- -- Access

	parameters_object: PARTICIPANTS_BY_ZIP_PARAMETERS

	item: PARTICIPANTS_BY_ZIP_RESULTS

feature  -- -- Element change

	set_parameters_object (a_parameters_object: PARTICIPANTS_BY_ZIP_PARAMETERS) is
			-- set `parameters_object' to `a_parameters_object'
		require
			a_parameters_object_not_void: a_parameters_object /= Void
		do
			parameters_object := a_parameters_object
			put_parameter (parameters_object.zip,"zip")
			bind_parameters
		ensure
			bound_parameters: bound_parameters
		end

feature  -- Constants

	definition: STRING is "[
	select * from PARTICIPANT where
		zip = ?zip
	
]"

feature {NONE} -- Implementation

	create_buffers is
			-- -- Creation of buffers
		do
			create item.make
			create cursor.make (1,9)
			cursor.put (item.identifier, 1)
			cursor.put (item.first_name, 2)
			cursor.put (item.last_name, 3)
			cursor.put (item.street, 4)
			cursor.put (item.no, 5)
			cursor.put (item.zip, 6)
			cursor.put (item.city, 7)
			cursor.put (item.state, 8)
			cursor.put (item.country, 9)
		end

end -- class PARTICIPANTS_BY_ZIP
