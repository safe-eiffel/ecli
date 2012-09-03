note
	description: "Objects that represent a group of Eiffel feature with common export status."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Eiffel Code Generator"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	EIFFEL_FEATURE_GROUP

inherit

	EIFFEL_CODE

create

	make

feature -- Initialization

	make (new_comment: STRING)
			-- Create an empty feature group with 'comment'
		require
			comment_not_void: new_comment /= Void
		do
			enable_ecma367v2
			set_comment (new_comment)
			create exports.make
			create features.make
		end

feature -- Access

	comment: STRING
			-- Feature group comment

	exports: DS_LINKED_LIST [STRING]
			-- Class names in export list of this group.

	features: DS_LINKED_LIST [EIFFEL_FEATURE]
			-- Features in this group.

feature -- Status setting

	set_comment (new_comment: like comment)
			-- Set the comment for this feature group.
		require
			new_comment_not_void: new_comment /= Void
		do
			comment := new_comment
		end

	add_export (class_name: STRING)
			-- Add 'class_name' to export list for this group.
		require
			class_name_not_void: class_name /= Void
		do
			exports.force_last (class_name)
		end

	add_feature (new_feature: EIFFEL_FEATURE)
			-- Add 'new_feature' to the features of this group.
		require
			new_feature_not_void: new_feature /= Void
		do
			features.force_last (new_feature)
		end

feature -- Basic operations

	write (output: KI_TEXT_OUTPUT_STREAM)
			-- Print code representation of this feature group to 'output'
		do
			write_header (output)
			write_features (output)
		end

feature {NONE} -- Implementation

	write_header (output: KI_TEXT_OUTPUT_STREAM)
		do
			output.put_string ("feature ")
			if not exports.is_empty then
				write_exports (output)
			end
			output.put_string (" -- " + comment)
			output.put_new_line
			output.put_new_line
		end

	write_exports (output: KI_TEXT_OUTPUT_STREAM)
		do
			output.put_string ("{")
			from
				exports.start
			until
				exports.off
			loop
				output.put_string (exports.item_for_iteration)
				if not exports.is_last then
					output.put_string (", ")
				end
				exports.forth
			end
			output.put_string ("}")
		end

	write_features (output: KI_TEXT_OUTPUT_STREAM)
		do
			from
				features.start
			until
				features.off
			loop
				features.item_for_iteration.write (output)
				features.forth
			end
		end

invariant

	comment_not_void: comment /= Void
	feature_not_void: features /= Void
	exports_not_void:exports /= Void

end -- class EIFFEL_FEATURE_GROUP
