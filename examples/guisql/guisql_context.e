note
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUISQL_CONTEXT

inherit
	ISQL_CONTEXT
		redefine
			filter, command_stream,
			create_filter, create_command_stream,
			do_session
		end

create
	make, make_gui

feature {NONE} -- Initialization

	make_gui (a_data : like sql_data ; a_messages : EV_TEXT; a_status : EV_TEXTABLE; an_output_file : like output_file; a_commands : like commands)
		do
			sql_data := a_data
			messages := a_messages
			status_messages := a_status
			make (an_output_file, a_commands)
		end

feature -- Access

	filter : GUISQL_FILTER

	command_stream : GUISQL_COMMAND_STREAM

	sql_data : EV_GRID

	messages : EV_TEXT
	status_messages : EV_TEXTABLE

feature -- Measurement

	execute_text (a_text : EV_TEXT)
		local
			input_stream : KL_STRING_INPUT_STREAM
		do
			create input_stream.make (query_text (a_text))
			create command_stream.make_file (input_stream)
			do_session
		end

	do_session
		do
			precursor
		end

feature -- Status report

	query_text (a_text : EV_TEXT) : STRING
		local
			l_begin, l_end : INTEGER
			l_semicolon : INTEGER
		do
			Result := a_text.text
			if Result.count > 0 then
				l_end := a_text.caret_position
				l_end := Result.count.min (l_end - 1)
				l_semicolon := Result.index_of (';', l_end)
				-- end
				if l_semicolon > 0 then
					l_end := l_semicolon
				end

				-- begin
				l_begin := 1
				l_semicolon := Result.index_of (';', l_begin)
				from

				until
					l_semicolon = 0 or else l_semicolon >= l_end
				loop
					l_begin := l_semicolon
					l_semicolon := Result.index_of (';', l_begin+1)
				end
				if l_begin >= 1 and l_begin < Result.count then
					if Result.item (l_begin + 1) = '%N' then
						l_begin := l_begin + 1
					end
				end
				if l_begin < l_end then
					Result := Result.substring (l_begin, l_end)
				end
			end
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

feature -- Inapplicable

feature {NONE} -- Implementation

	create_filter
		do
			create filter.make (sql_data, messages, status_messages)
		end

	create_command_stream (stream: KI_TEXT_INPUT_STREAM)
		do
			precursor (stream)
		end

invariant
	invariant_clause: True -- Your invariant here

end
