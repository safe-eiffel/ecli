indexing
	description: "Commands that list the columns of a table."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_COLUMNS

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("col[umns] <table-name>", command_width)
			Result.append_string ("List all columns in <table-name>.")
		end

	match_string : STRING is "col"
	
feature -- Status report
	
	needs_session : BOOLEAN is True
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- show columns
		local
			stream : KL_WORD_INPUT_STREAM
			l_table, l_schema, l_catalog : STRING
			query : ECLI_NAMED_METADATA
			cursor : ECLI_COLUMNS_CURSOR
		do
			create stream.make (text, " %T")
			stream.read_word
			if not stream.end_of_input then
				--| try reading table_name
				stream.read_word
				if not stream.end_of_input then
					l_table := clone (stream.last_string)
					stream.read_word
					if not stream.end_of_input then
						l_schema := l_table
						l_table := clone (stream.last_string)
						stream.read_word
						if not stream.end_of_input then
							l_catalog := l_schema
							l_schema := l_table
							l_table := clone (stream.last_string)
						end
					end
				end
				create query.make (l_catalog, l_schema, l_table)
				create cursor.make (query, context.session)
				put_results (cursor, context)
				cursor.close
			end
		end
		
feature {NONE} -- Implementation

	put_results (a_cursor : ECLI_COLUMNS_CURSOR; context : ISQL_CONTEXT) is
			-- 
		local
			the_column : ECLI_COLUMN
		do
			if a_cursor.is_executed then
				from
					a_cursor.start
					context.filter.begin_heading
					context.filter.put_heading ("COLUMN_NAME")
					context.filter.put_heading ("TYPE")
					context.filter.put_heading ("SIZE")
					context.filter.put_heading ("DESCRIPTION")
					context.filter.end_heading
				until
					not a_cursor.is_ok or else a_cursor.off
				loop
					the_column := a_cursor.item
					context.filter.begin_row
					context.filter.put_column (nullable_string (the_column.name))
					context.filter.put_column (nullable_string (the_column.type_name))
					context.filter.put_column (nullable_string (the_column.size.out))
					context.filter.put_column (nullable_string (the_column.description))
					context.filter.end_row
					a_cursor.forth
				end			
			else
				context.filter.begin_error
				context.filter.put_error ("Cannot get columns metadata")
				context.filter.end_error
			end
		end

end -- class ISQL_CMD_COLUMNS
