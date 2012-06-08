indexing

	description:

			"ISO Date formats and conversion facilities."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DATE_FORMAT

inherit

	ECLI_FORMAT [DT_DATE]
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
			create last_result.make_from_day_count (0)
		end

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	create_from_string (string : STRING) is
		local
			year, month, day : INTEGER
			s : STRING
		do
			regex.match (string)
			year := regex.captured_substring (1).to_integer
			month := regex.captured_substring (2).to_integer
			day := regex.captured_substring (3).to_integer
			create last_result.make (year, month , day)
			s := formatted (last_result)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	formatted (value : DT_DATE) : STRING is
		do
			create Result.make (20)
			Result.append_string ("{d '")
			Result.append_string(date_to_string (value))
			Result.append_string ("'}")
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	regex : RX_PCRE_REGULAR_EXPRESSION is
		local
			cli_regex : STRING
		once
			create Result.make
			create cli_regex.make_from_string ("\{d '")
			cli_regex.append_string (Date_regex)
			cli_regex.append_string ("'\}")
			Result.compile (cli_regex) -- "([0-9]{1,4})\-([0-9]{2})\-([0-9]{2}))
		end

	ifmt : ECLI_FORMAT_INTEGER is once create Result end

	regex_component_count : INTEGER is 3

invariant
	invariant_clause: True -- Your invariant here

end
