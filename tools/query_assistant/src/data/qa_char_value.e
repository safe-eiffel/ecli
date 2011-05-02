indexing

	description:

	    "Buffers of type CHAR(n)."

	usage: ""
	quality: ""
	refactoring: ""

	status: "see notice at end of class";
	date: "$Date$";
	revision: "$Revision$";
	author: ""

deferred class
	QA_CHAR_VALUE

inherit
	QA_VALUE
		redefine
			make_call_with_precision
		end

feature {NONE} -- Initialization

feature -- Access

	default_maximum_capacity : INTEGER is
		deferred
		end

feature -- Measurement

feature -- Comparison

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	make_call_with_precision : STRING
		do
			if size > default_maximum_capacity then
				create Result.make (10)
				Result.append_string ("make_force_maximum_capacity (")
				Result.append_integer (size)
				Result.append_string (")")
			else
				Result := Precursor
			end
		end
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature -- Constants

feature {NONE} -- Implementation

invariant
	invariant_clause: -- Your invariant here

end
