indexing

	description: "Objects that list DRIVERS registered in ODBC."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_DRIVERS

inherit
	ISQL_COMMAND

	ECLI_EXTERNAL_API
	
feature -- Access

	help_message : STRING is
		do
			Result := padded ("dri[vers]", Command_width)
			Result.append_string ("List registered drivers.")
		end

	match_string : STRING is "dri"
	
feature -- Status report
	
	needs_session : BOOLEAN is False
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- connect to a datasource
		local
			cursor : ECLI_DRIVERS_CURSOR
		do
			from
				create cursor.make
				cursor.start
				show_headings (context.filter)
			until
				cursor.off
			loop
				show_driver (cursor.item, context.filter)
				cursor.forth
			end
		end

	show_driver (driver : ECLI_DRIVER; filter : ISQL_FILTER) is
			-- Show `driver' through `filter'.
		do
			filter.begin_row
			filter.put_column (driver.name)
			filter.put_column (format_attributes (driver.attributes))
			filter.end_row
		end
		
	show_headings (filter : ISQL_FILTER) is
			-- Show headings through `filter'.
		do
			filter.begin_heading
			filter.put_heading ("NAME")
			filter.put_heading ("Attributes")
			filter.end_heading
		end
		
	format_attributes (attributes : DS_HASH_TABLE[STRING, STRING]) : STRING is
			-- format `attributes' on a single line.
		local
			cursor : DS_HASH_TABLE_CURSOR [STRING, STRING]
		do
			create Result.make (200)
			from
				cursor := attributes.new_cursor
				cursor.start
			until
				cursor.off
			loop
				Result.append_string (cursor.key)
				Result.append_character ('=')
				Result.append_string (cursor.item)
				cursor.forth
				if not cursor.off then
					Result.append_character (';')
				end
			end
		end
		
end -- class ISQL_CMD_DRIVERS
