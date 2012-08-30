note
	description: "Objects that represent an Eiffel feature, either an attribute, function or procedure."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Eiffel Code Generator"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	EIFFEL_FEATURE

inherit

	EIFFEL_CODE

feature -- Initialization

	make (new_name: STRING)
			-- Create a new Eiffel feature with 'name'
		require
			name_not_void: new_name /= Void
		do
			set_name (new_name)
		end

feature -- Access

	name: STRING
			-- Name of feature.

	comment : STRING
			-- Comment of feature
			
feature -- Status setting

	set_name (new_name: STRING)
			-- Set feature name to 'name'
		require
			name_not_void: new_name /= Void
		do
			name := new_name
		end

	set_comment (new_comment: STRING)
			-- Set feature comment to 'new_comment'
		require
			comment_not_void: new_comment /= Void
		do
			comment := new_comment
		end

invariant

	name_not_void: name /= Void

end -- class EIFFEL_FEATURE
