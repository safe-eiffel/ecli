indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DATA_TEST_HELPER

inherit
	TS_TEST_CASE
	
feature -- Access

feature -- Measurement

feature -- Status report

	assert_char_equal (tag, left, right : STRING) is
		local
			blanks, adjusted : STRING
		do
			if right.count > left.count then
				create blanks.make (right.count - left.count)
				blanks.fill_blank
				create adjusted.make_from_string (left)
				adjusted.append_string (blanks)
			else
				adjusted := left
			end
			assert_equal (tag, adjusted, right)
		end

	assert_double_equal (tag : STRING; left, right : DOUBLE) is
		do
			assert (tag, (left - right).abs < double_tolerance)
		end
		
	assert_real_equal (tag : STRING; left, right : REAL) is
		do
			assert (tag, (left - right).abs < real_tolerance)
		end
			
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

feature -- Constants

	double_tolerance : DOUBLE is 0.1e-15
	
	real_tolerance : DOUBLE is 0.1e-7
	

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class DATA_TEST_HELPER
