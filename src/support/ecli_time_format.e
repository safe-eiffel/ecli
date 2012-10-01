note

	description:

			"Time formats, ISO specification."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TIME_FORMAT

inherit

	ECLI_FORMAT [DT_TIME]
		redefine
			default_create
		end

	ECLI_ISO_FORMAT_CONSTANTS
		undefine
			default_create
		end

feature {} -- Initialization

	default_create
		do
			create last_result.make_from_second_count (0)
		end

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	create_from_string (string : STRING)
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

	formatted (value : DT_TIME) : STRING
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

	regex : RX_PCRE_REGULAR_EXPRESSION
		local
			cli_regex : STRING
		once
			create Result.make
			create cli_regex.make_from_string ("\{t '")
			cli_regex.append_string (Time_regex)
			cli_regex.append_string ("'\}")
			Result.compile (cli_regex) -- "\{t '([0-9]{2})\:([0-9]{2})\:([0-9]{2})(\.([0-9]+))'\}")
		end

	ifmt : ECLI_FORMAT_INTEGER
		once create Result end

	regex_component_count : INTEGER = 4

end
