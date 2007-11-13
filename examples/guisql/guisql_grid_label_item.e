indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUISQL_GRID_LABEL_ITEM

inherit
	EV_GRID_LABEL_ITEM
		redefine
			make_with_text
		end

create
	make_with_text

feature {NONE} -- Initialization

	make_with_text (s : STRING) is
		do
			precursor (s)
			pointer_enter_actions.extend (agent show_tooltip)
			pointer_leave_actions.extend (agent hide_tooltip)
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	show_tooltip is
		do
			set_tooltip (text)
		end

	hide_tooltip is
		do
			set_tooltip (Void)
		end

invariant
	invariant_clause: True -- Your invariant here

end
