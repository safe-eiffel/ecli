indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_COMMAND

inherit
	ANY

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all
		end


create
	make_file, make_interactive

feature {NONE} -- Initialization

	make_file (a_file : PLAIN_TEXT_FILE) is
			-- make for `a_file'
		require
			file_exists: a_file /= Void
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
			text := STRING_.make (1000)
		ensure
			interactive: is_interactive
		end

feature -- Access

	text : STRING
		-- command text

	input_file : PLAIN_TEXT_FILE
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


	is_begin  : BOOLEAN is
			-- is 's' a BEGIN TRANSACTION ?
			-- checking only first 3 charactercommand...
		do
			if text.count >= 3 then
				if      (text.item (1) = 'b' or else text.item  (1) = 'B')
					and (text.item (2) = 'e' or else text.item (2) = 'E')
					and (text.item (3) = 'g' or else text.item (3) = 'G')
				then
					Result := True
				end
			end
		end

	is_commit  : BOOLEAN is
			-- is 's' a COMMIT TRANSACTION ?
			-- checking only first 3 charactercommand...
		do
			if text.count >= 3 then
				if      (text.item (1) = 'c' or else text.item  (1) = 'C')
					and (text.item (2) = 'o' or else text.item (2) = 'O')
					and (text.item (3) = 'm' or else text.item (3) = 'M')
				then
					Result := True
				end
			end
		end

	is_rollback  : BOOLEAN is
			-- is 's' a ROLLBACK TRANSACTION ?
			-- checking only first 3 charactercommand...
		do
			if text.count >= 3 then
				if (text.item (1) = 'r' or text.item  (1) = 'R')
					and (text.item (2) = 'o' or text.item (2) = 'O')
					and (text.item (3) = 'l' or text.item (3) = 'L')
				then
					Result := True
				end
			end
		end

	is_query  : BOOLEAN is
			-- is `s' a SELECT ?
			-- checking only first 3 characters
		do
			if text.count >= 3 then
				if (text.item (1) = 's' or text.item  (1) = 'S')
					and (text.item (2) = 'e' or text.item (2) = 'E')
					and (text.item (3) = 'l' or text.item (3) = 'L')
				then
					Result := True
				end
			end
		end

	is_set  : BOOLEAN is
			-- is 's' a SET ?
		do
			if text.count >= 3 then
				if (text.item (1) = 's' or text.item  (1) = 'S')
					and (text.item (2) = 'e' or text.item (2) = 'E')
					and (text.item (3) = 't' or text.item (3) = 'T')
				then
					Result := True
				end
			end
		end

	is_quit : BOOLEAN is
			-- is this a 'quit'?
		do
			if text.count >=1 then
				inspect text.item (1)
				when 'q', 'Q' then
					Result := True
				else
					Result := False
				end
			end
		end

	is_help : BOOLEAN is
			-- is this a 'help'?
		do
			if text.count >=1 then
				inspect text.item (1)
				when 'h', 'H' then
					Result := True
				else
					Result := False
				end
			end
		end

	end_of_input : BOOLEAN is
			-- has 'end of file' been encountered?
		do
			if not is_interactive then
				Result := input_file.end_of_file
			end
		end

	is_tables : BOOLEAN is
			-- is this 'tables' ?
		do
			if text.count >=1 then
				inspect text.item (1)
				when 'T', 't' then
					inspect text.item (2) 
					when 'A', 'a' then
						Result := True
					else
					end
				else
				end				
			end
		end
		
	is_types : BOOLEAN is
			-- is this 'types' ?
		do
			if text.count >=1 then
				inspect text.item (1)
				when 'T', 't' then
					inspect text.item (2) 
					when 'Y', 'y' then
						Result := True
					else
					end
				else
				end				
			end
		end

	is_columns : BOOLEAN is
			-- is this 'columns' ?
		do
			if text.count >=2 then
				if text.item (1) = 'c' or else text.item (1) = 'C' then
					if text.item (2) = 'o' or else text.item (2) = 'O' then
						Result := True
					end
				end
			end
		end
	
	is_sources : BOOLEAN is
			-- is this 'sources' ?
		do
			if text.count >=2 then
				if text.item (1) = 's' or else text.item (1) = 'S' then
					if text.item (2) = 'o' or else text.item (2) = 'O' then
						Result := True
					end
				end
			end
		end
		
	is_procedures  : BOOLEAN is
			-- is 'text' equal to 'PROCEDURES' ?
		do
			if text.count >= 3 then
				if (text.item (1) = 'p' or text.item  (1) = 'P')
					and (text.item (2) = 'r' or text.item (2) = 'R')
					and (text.item (3) = 'o' or text.item (3) = 'O')
				then
					Result := True
				end
			end
		end
		
--|feature -- Status setting

--|feature -- Cursor movement

--|feature -- Element change

--|feature -- Removal

--|feature -- Resizing

--|feature -- Transformation

--|feature -- Conversion

--|feature -- Duplication

--|feature -- Miscellaneous

feature -- Basic operations

	read is
		-- read
		local
			done : BOOLEAN
			separator_index : INTEGER
		do
			text.copy("")
			-- prompt user
			from
				read_line
			until
				end_of_input or else done
			loop
				-- Trim trailing blanks
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
					text.append (last_string.substring (1, separator_index))
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
				input_file.read_line
				last_string := input_file.last_string
			end
		end

	last_string : STRING

invariant

	command_exists: text /= Void

end -- class ISQL_COMMAND
