indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_TIME_FORMAT

inherit
	ECLI_FORMAT [DT_TIME]
	
	ECLI_ISO_FORMAT_CONSTANTS
	
feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	create_from_string (string : STRING) is
		local
			hour, minute, second, fraction : INTEGER
		do
			regex.match (string)
			hour := regex.captured_substring (1).to_integer
			minute := regex.captured_substring (2).to_integer
			second := regex.captured_substring (3).to_integer
			if regex.match_count = 5 then
				fraction := regex.captured_substring (5).to_integer
			end
			create last_result.make (hour, minute, second)
			if fraction > 0 then
				last_result.set_millisecond (fraction)
			end
		end
		
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	formatted (value : DT_TIME) : STRING is
		do
			create Result.make (20)
			Result.append_string ("{t '")
			Result.append_string (time_to_string (value))
			Result.append_string ("'}")
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	regex : RX_PCRE_REGULAR_EXPRESSION is
		once
			create Result.make
			Result.compile ("\{t '([0-9]{2})\:([0-9]{2})\:([0-9]{2})(\.([0-9]+))'\}")
		end

	ifmt : ECLI_FORMAT_INTEGER is
		once create Result end
	
	regex_component_count : INTEGER is 4
	
invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_TIME_FORMAT
