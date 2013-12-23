note

	description:

			"Objects that cache SQL parsers."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_SQL_PARSER_CACHE

create

	make

feature {NONE} -- Initialization

	make (a_parser: ECLI_SQL_PARSER; a_name_to_position : DS_HASH_TABLE [DS_LIST[INTEGER], STRING])
			-- Create the cache.
		require
			a_parser_not_void: a_parser /= Void
			a_name_to_position_not_void: a_name_to_position /= Void
		do
			parser := a_parser
			name_to_position := a_name_to_position
		ensure
			parser_set: parser = a_parser
			name_to_position_set: name_to_position = a_name_to_position
		end

feature -- Access

	parser: ECLI_SQL_PARSER
			-- SQL parser

	name_to_position : DS_HASH_TABLE [DS_LIST[INTEGER], STRING]
			-- Name to position table

invariant
	parser_not_void: parser /= Void
	name_to_position_not_void: name_to_position /= Void

end
