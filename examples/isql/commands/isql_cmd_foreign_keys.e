indexing
	description: "Commands that list the foreign key columns of a table."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_FOREIGN_KEYS

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("fk <table-name>", command_width)
			Result.append ("List all foreign columns in <table-name>.")
		end

	match_string : STRING is "fk"
	
feature -- Status report
	
	needs_session : BOOLEAN is True
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- show foreign keys
		local
			stream : KL_WORD_INPUT_STREAM
			l_table, l_schema, l_catalog : STRING
			query : ECLI_NAMED_METADATA
			cursor : ECLI_FOREIGN_KEYS_CURSOR
		do
			create stream.make (text, " %T")
			stream.read_quoted_word
			if not stream.end_of_input then
				--| try reading table_name
				stream.read_quoted_word
				if not stream.end_of_input then
					l_table := clone (stream.last_string)
					stream.read_quoted_word
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
				if l_table.item (1) = '%'' and then l_table.item (l_table.count)='%'' then
					l_table := l_table.substring (2, l_table.count -1)
				end
				if l_table.item (1) = '%"' and then l_table.item (l_table.count)='%"' then
					l_table := l_table.substring (2, l_table.count -1)
				end
				create query.make (l_catalog, l_schema, l_table)
				create cursor.make (query, context.session)
				put_results (cursor, context)
				cursor.close
			end
		end
		
feature {NONE} -- Implementation

	put_results (a_cursor : ECLI_FOREIGN_KEYS_CURSOR; context : ISQL_CONTEXT) is
			-- 
		local
			the_key : ECLI_FOREIGN_KEY
			ref_key : ECLI_PRIMARY_KEY
			index : INTEGER
			columns_cursor, ref_cols_cursor : DS_LIST_CURSOR[STRING]
		do
			if a_cursor.is_executed then
				from
					a_cursor.start
					context.filter.begin_heading
					context.filter.put_heading ("FROM_KEY_NAME")
					context.filter.put_heading ("TO_KEY_NAME")
					context.filter.put_heading ("SEQ")
					context.filter.put_heading ("FROM_CATALOG")
					context.filter.put_heading ("FROM_SCHEMA")
					context.filter.put_heading ("FROM_TABLE")
					context.filter.put_heading ("FROM_COLUMN_NAME")
					context.filter.put_heading ("TO_CATALOG")
					context.filter.put_heading ("TO_SCHEMA")
					context.filter.put_heading ("TO_TABLE")
					context.filter.put_heading ("TO_COLUMN_NAME")
					context.filter.put_heading ("UPDATE_RULE")
					context.filter.put_heading ("DELETE_RULE")
					context.filter.put_heading ("DEFERRABILITY")
					context.filter.end_heading
				until
					not a_cursor.is_ok or else a_cursor.off
				loop
					the_key := a_cursor.item
					ref_key := a_cursor.item.referenced_key 
					from
						columns_cursor := the_key.columns.new_cursor
						ref_cols_cursor := ref_key.columns.new_cursor
						columns_cursor.start
						ref_cols_cursor.start
						index := 1
					until
						columns_cursor.off
					loop
						context.filter.begin_row
						context.filter.put_column (nullable_string (the_key.key_name))
						context.filter.put_column (nullable_string (ref_key.key_name))
						context.filter.put_column (index.out)
						context.filter.put_column (nullable_string (the_key.catalog))
						context.filter.put_column (nullable_string (the_key.schema))
						context.filter.put_column (nullable_string (the_key.table))
						context.filter.put_column (nullable_string (columns_cursor.item))
						context.filter.put_column (nullable_string (ref_key.catalog))
						context.filter.put_column (nullable_string (ref_key.schema))
						context.filter.put_column (nullable_string (ref_key.table))
						context.filter.put_column (nullable_string (ref_cols_cursor.item))
						if the_key.is_update_rule_applicable then
							context.filter.put_column (the_key.update_rule.out)
						else
							context.filter.put_column ("NULL")
						end
						if the_key.is_delete_rule_applicable then
							context.filter.put_column (the_key.delete_rule.out)
						else
							context.filter.put_column ("NULL")
						end
						
						if the_key.is_deferrability_applicable then
							context.filter.put_column (the_key.deferrability.out)						
						else
							context.filter.put_column ("NULL")
						end
						context.filter.end_row
						columns_cursor.forth
						ref_cols_cursor.forth
						index := index + 1
					end
					a_cursor.forth
				end			
			else
				context.filter.begin_error
				context.filter.put_error ("Cannot get foreign key metadata%N" + a_cursor.diagnostic_message)
				context.filter.end_error
			end
		end
		
end -- class ISQL_CMD_FOREIGN_KEYS
