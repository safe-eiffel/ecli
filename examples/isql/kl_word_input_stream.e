indexing
	description: "Objects that read word streams."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	KL_WORD_INPUT_STREAM

inherit
	KL_STRING_INPUT_STREAM
		rename
			make as make_input_stream
		end


creation
	make

feature {NONE} -- Initialization

	make (a_string, a_separators : STRING) is
			-- make input stream, using `a_separators'
		require
			a_string_not_void: a_string /= Void
			a_separators_not_void: a_separators /= Void
			a_separators_not_empty: not a_separators.is_empty
		do
			make_input_stream (a_string)
			separators := a_separators
		ensure
			separators_affected: separators = a_separators
		end

feature -- Access

	separators : STRING
		-- set of word separators; a separator is any individual character in the string.

feature -- Status report

	is_last_string_quoted : BOOLEAN
		-- is the result of the last `read_quoted_word' quoted ?

feature -- Basic operations

	read_word is
			-- Read characters from input stream until a word separator
			-- or end of input is reached. Let the characters that have
			-- been read available in `last_string' and discard the line
			-- separator characters from the input stream.
		local
			done: BOOLEAN
			a_target: STRING
			c: CHARACTER
			is_eof: BOOLEAN
			skipping : BOOLEAN
		do
			init_before_reading
			is_eof := True
			skipping := True
			a_target := last_string
			from until done loop
				read_character
				if end_of_input then
					done := True
				else
					is_eof := False
					c := last_character
					if separators.has (c) then
						if not skipping then
							done := True
						end
					else
						skipping := False
						a_target.append_character (c)
					end
				end
			end
			end_of_input := is_eof
		end

	read_quoted_word is
			-- Read characters from input stream until a word separator
			-- or end of input is reached.
			-- When a word is quoted, all characters up to the next quoting character
			-- are read. The word available in `last_string'. The line
			-- separator characters are discarded from the input stream.
			-- word ::= \"[^\"]\" | \'[^\']\'
		local
			done: BOOLEAN
			a_target: STRING
			c: CHARACTER
			is_eof: BOOLEAN
			skipping : BOOLEAN
			is_quoted, is_double_quoted : BOOLEAN
		do
			init_before_reading
			is_eof := True
			skipping := True
			a_target := last_string
			from until done loop
				read_character
				if end_of_input then
					done := True
				else
					is_eof := False
					c := last_character
					if separators.has (c) then
						if not skipping and then not (is_quoted or else is_double_quoted) then
							done := True
						else
							a_target.append_character (c)
						end
					else
						if c = '%'' then
							is_quoted := not is_quoted
						elseif c = '%"' then
							is_double_quoted := not is_double_quoted
						end
						skipping := False
						a_target.append_character (c)
					end
					is_last_string_quoted := is_last_string_quoted or else (is_quoted or is_double_quoted)
				end
			end
			end_of_input := is_eof
		end

feature {NONE} -- Implementation

	init_before_reading is
			-- initialize `last_string' and `is_last_string_quoted'
		do
			is_last_string_quoted := False
			if last_string = Void then
				last_string := STRING_.make (256)
			else
				STRING_.wipe_out (last_string)
			end
		ensure
			last_string_empty: last_string /= Void and then last_string.is_empty
			not_is_last_string_quoted: not is_last_string_quoted
		end

invariant
	is_last_string_quoted: is_last_string_quoted implies
					((last_string.item (1) = '%'' and then last_string.item (last_string.count) = '%'')
			or else  (last_string.item (1) = '%"' and then last_string.item (last_string.count) = '%"'))

end -- class KL_WORD_INPUT_STREAM
