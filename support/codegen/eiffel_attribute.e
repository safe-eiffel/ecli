note
	description: "Objects that represent Eiffel attributes."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Eiffel Code Generator"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	EIFFEL_ATTRIBUTE

inherit
	EIFFEL_FEATURE
		rename
			make as feature_make
		end

create

	make

feature -- Initialization

	make (new_name, new_type: STRING)
			-- Create a new attribute
		require
			new_name_not_void: new_name /= Void
			new_type_not_void: new_type /= Void
		do
			enable_ecma367v2
			feature_make (new_name)
			set_type (new_type)
			create value.make_empty
		end

feature -- Access

	type: STRING
			-- The type of this attribute.

	value: STRING
			-- The value of this attribute. If not Void, then
			-- this attribute is constant.

feature -- Status setting

	set_type (new_type: STRING)
			-- Set the type of this attribute
		do
			type := new_type
		end

	set_value (new_value: STRING)
			-- Set the value of this attribute. Makes the attribute
			-- constant.
		do
			value := new_value
		end

feature -- Basic operations

	write (output: KI_TEXT_OUTPUT_STREAM)
			-- Print source code representation of this attribute on 'output'
		do
			output.put_string ("%T" + name + ": " + type)
			if not value.is_empty then
				if is_ecma367v2 then
					output.put_string (" = " + value)
				else
					output.put_string (" is " + value)
				end
			end
			if not comment.is_empty then
				output.put_new_line
				output.put_string ("%T%T%T-- "+comment)
			end
			output.put_new_line
			output.put_new_line
		end

invariant

	type_not_void: type /= Void

end -- class EIFFEL_ATTRIBUTE
