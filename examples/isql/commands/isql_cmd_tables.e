indexing
	description: "Objects that list tables on current session."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_TABLES

inherit
	ISQL_COMMAND
	
feature -- Access

	help_message : STRING is
		do
			Result := padded ("tab[les]", command_width)
			Result.append_string ("List all tables in current catalog.")
		end

	match_string : STRING is "tab"
	
feature -- Status report
	
	needs_session : BOOLEAN is True
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- show tables of current datasource
		local
			index : INTEGER
			table : ECLI_TABLE
			tables_cursor : ECLI_TABLES_CURSOR
			query : ECLI_NAMED_METADATA
		do
			from index := 1
				--if not context.no_headings then
				--	context.output_file.put_string ("CATALOG%T SCHEMA%T TABLE_NAME%T TYPE%T DESCRIPTION%N")					
				--end
				context.filter.begin_heading
				context.filter.put_heading ("CATALOG")
				context.filter.put_heading ("SCHEMA")
				context.filter.put_heading ("TABLE_NAME")
				context.filter.put_heading ("TYPE")
				context.filter.put_heading ("DESCRIPTION")
				context.filter.end_heading
				
				create query.make (Void, Void, Void)
				!!tables_cursor.make (query, context.session)
				tables_cursor.start
			until
				not tables_cursor.is_ok or else tables_cursor.off
			loop
				table := tables_cursor.item
				context.filter.begin_row
				context.filter.put_column (nullable_string (table.catalog))
				context.filter.put_column (nullable_string (table.schema))
				context.filter.put_column (nullable_string (table.name))
				context.filter.put_column (nullable_string (table.type))
				context.filter.put_column (nullable_string (table.description))
				context.filter.end_row
				tables_cursor.forth
			end
			if not tables_cursor.is_ok then
				context.filter.begin_error
				context.filter.put_error ("Error getting tables metadata : '")
				context.filter.put_error (tables_cursor.diagnostic_message)
				context.filter.end_error
			end
			tables_cursor.close
		end
		
end -- class ISQL_CMD_TABLES
