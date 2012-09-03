note

	description:

			"Objects that know the iso TIMESTAMP format and are able to convert from/to it."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TIMESTAMP_FORMAT

inherit

	ECLI_FORMAT [DT_DATE_TIME]

	ECLI_ISO_FORMAT_CONSTANTS

feature -- Access

	item : DT_DATE_TIME

	last_nanoseconds_fraction : INTEGER
			-- Last fraction as nanoseconds

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	create_from_string (string : STRING)
		local
			year, month, day, hour, minute, second, milliseconds : INTEGER
			l_fraction : STRING
			l_original_fraction : STRING
			l_milliseconds : STRING
		do
			last_nanoseconds_fraction := 0
			regex.match (string)
			year := regex.captured_substring (1).to_integer
			month := regex.captured_substring (2).to_integer
			day := regex.captured_substring (3).to_integer
			hour := regex.captured_substring (4).to_integer
			minute := regex.captured_substring (5).to_integer
			second := regex.captured_substring (6).to_integer
			if regex.match_count >= 8 then
				create l_fraction.make_filled ('0', 9)
				l_original_fraction := regex.captured_substring (8)
				l_fraction.subcopy (l_original_fraction, 1, l_original_fraction.count.min (9), 1)
				l_milliseconds := l_fraction.substring (1, 3)
				milliseconds := l_milliseconds.to_integer
				last_nanoseconds_fraction := l_fraction.to_integer_32
			end
			create last_result.make (year, month, day, hour, minute, second)
			if milliseconds > 0 then
				last_result.set_millisecond (milliseconds)
			end

		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	formatted (value : DT_DATE_TIME) : STRING
		do
			create Result.make (20)
			Result.append_string ("{ts '")
			Result.append_string (timestamp_to_string (value))
			Result.append_string ("'}")
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	regex : RX_PCRE_REGULAR_EXPRESSION
			-- regular expression for pattern matching
		local
			cli_regex_string : STRING
		once
			create Result.make
			create cli_regex_string.make (50)
			cli_regex_string.append_string ("\{ts '")
			cli_regex_string.append_string (date_regex)
			cli_regex_string.append_string (" ")
			cli_regex_string.append_string (time_regex)
			cli_regex_string.append_string ("'}")
			Result.compile (cli_regex_string)
		ensure then
			regex_not_void: Result /= Void
		end

	ifmt : ECLI_FORMAT_INTEGER
		once
			create Result
		ensure
			result_not_void: Result /= Void
		end

	regex_component_count : INTEGER = 7

invariant
	invariant_clause: True -- Your invariant here

end
