indexing
	description: "Objects that list available datasourcess."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_SOURCES

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("sou[rces]", command_width)
			Result.append_string ("List all datasources defined on current system.")
		end

	match_string : STRING is "sou"
	
feature -- Status report
	
	needs_session : BOOLEAN is False
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- show sources of current configuration
		local
			cursor : ECLI_DATA_SOURCES_CURSOR
			data_source : ECLI_DATA_SOURCE
		do
			create cursor.make_all		
			from
				cursor.start
				context.filter.begin_heading
				context.filter.put_heading ("NAME")
				context.filter.put_heading ("DESCRIPTION")
				context.filter.end_heading
			until
				cursor.off
			loop
				data_source := cursor.item
				context.filter.begin_row
				context.filter.put_column (data_source.name)
				context.filter.put_column (data_source.description)
				context.filter.end_row
				cursor.forth
			end
			cursor.close
		end

end -- class ISQL_CMD_SOURCES
