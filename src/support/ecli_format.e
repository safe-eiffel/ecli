indexing
	description: "Objects that handle some data format"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ECLI_FORMAT [G]

inherit
	KL_IMPORTED_STRING_ROUTINES
	
feature -- Access

	last_result : G
		
feature -- Measurement

feature -- Status report

	matching_string (s : STRING) : BOOLEAN is
			-- is `s' matching current data type ?
		do
			regex.match (s)
			Result := regex.match_count >= regex_component_count
		end
		
feature -- Status setting

feature -- Cursor movement

feature -- Element change

	create_from_string (s : STRING) is
			-- create new `last_result' from `s'
		require
			s_exists: s /= Void
			s_matching: matching_string (s)
		deferred
		ensure
			last_result_exists: last_result /= Void
			last_result_same_as_s: formatted (last_result).is_equal (s)
		end
		
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	formatted (value : G) : STRING is
			-- `value' formatted with respect to Current format
		require
			value_exists: value /= Void
		deferred
		ensure
			result_exists: Result /= Void
			result_matching_format: matching_string (Result)
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	regex : RX_PCRE_REGULAR_EXPRESSION is
		deferred
		ensure
			result_exists: Result /= Void
			result_compiled: Result.is_compiled
		end
		
	regex_component_count : INTEGER is deferred end

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_FORMAT
