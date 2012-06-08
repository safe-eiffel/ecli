indexing
	description: "Objects that are streams of ISQL commands."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_COMMAND_STREAM

inherit
	ANY

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all
		end


create
	make_file, make_interactive

feature {NONE} -- Initialization

	make_file (a_file : KI_TEXT_INPUT_STREAM) is
			-- make for `a_file'
		require
			file_not_void: a_file /= Void
			file_open_read: a_file.is_open_read
		do
			make_interactive
			input_file := a_file
		ensure
			file_set: input_file = a_file
			not_interactive: not is_interactive
		end

	make_interactive is
			-- make interactive
		do
			create text.make (1000)
			create buffer_text.make_empty
			create last_string.make_empty
		ensure
			interactive: is_interactive
		end

feature -- Access

	buffer_text: STRING
			-- buffer of text prepared for next reading

	text : STRING
		-- command text

	input_file : detachable KI_TEXT_INPUT_STREAM
		-- input file.  Void => interactive

--|feature -- Measurement

feature -- Status report

	is_interactive : BOOLEAN is
			-- is this an interactive text ?
		do
			Result := (input_file = Void)
		ensure
			interactive: Result = (input_file = Void)
		end

	end_of_input : BOOLEAN is
			-- has 'end of file' been encountered?
		do
			if not is_interactive then
				Result := input_file.end_of_input
			end
		end

	is_comment (a_text : STRING) : BOOLEAN is
			-- is `a_text' a comment ?
		local
			index, eos : INTEGER
			done : BOOLEAN
		do
			-- skip blanks
			from
				index := 1
				eos := a_text.count
			until
				index > eos or else done
			loop
				inspect a_text.item (index)
				when ' ','%T' then
					index := index + 1
				else
					done := True
				end
			end
			-- test if "--" begins a_text
			if index + 1 <= eos then
				Result := a_text.item (index) = '-' and then a_text.item (index + 1) = '-'
			end
		end

feature -- Element change

	set_buffer_text (a_buffer_text: STRING) is
			-- Set `buffer_text' to `a_buffer_text'.
		do
			buffer_text := a_buffer_text
		ensure
			buffer_text_assigned: buffer_text = a_buffer_text
		end

feature -- Basic operations

	read is
		-- read
		local
			done : BOOLEAN
			separator_index : INTEGER
		do
			if not buffer_text.is_empty then
				text.copy (buffer_text)
				buffer_text.wipe_out
				skip_prompting := True
			else
				text.copy("")
			end
			from
				read_line
			until
				end_of_input or else done
			loop
				if not is_comment (last_string) then
					-- Trim trailing blanks
	--| FIXME: verify existence of this operation in ELKS or GOBO routines
					from
						separator_index := last_string.count
					until
						separator_index < 1 or else
						(last_string.item(separator_index) /= ' ' and then
						last_string.item(separator_index) /= '%T')
					loop
						separator_index := separator_index - 1
					end
					-- End of text ?
					if separator_index >= 1 then
						if last_string.item (separator_index) = ';' then
							done := True
							separator_index := separator_index - 1
						end
					end
					-- Append if not empty string
					if separator_index >= 1 then
						-- Add a blank if necessary to avoid concatenating text statements...
						if text.count > 0 and then (text.item (text.count) /= ' ' or else
						   last_string.item (1) /= ' ') then
						   text.append_character (' ')
						end
						-- Append next text segment
						text.append_string (last_string.substring (1, separator_index))
					end
				end
				if not done then
					read_line
				end
			end
		ensure
			command_set: text /= Void
		end

--|feature -- Obsolete

--|feature -- Inapplicable

feature {NONE} -- Implementation

	read_line is
		do
			if is_interactive then
				io.read_line
				last_string := io.last_string
			else
				if not input_file.end_of_input and then attached input_file.last_string as ls then
					input_file.read_line
					last_string := ls
				end
			end
		end

	last_string : STRING

	skip_prompting : BOOLEAN

invariant

	command_not_void: text /= Void

end -- class ISQL_COMMAND_STREAM
