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
				create query.make (Void, Void, Void)
				create tables_cursor.make (query, context.session)
				tables_cursor.start
				put_headings (tables_cursor, context)
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
				context.filter.put_error (sql_error_msg (tables_cursor,"Unable to get tables metadata"))
				context.filter.end_error
			end
			tables_cursor.close
		end

	put_headings (cursor : ECLI_STATEMENT; context : ISQL_CONTEXT) is
		local
			l_catalog : STRING
			l_schema : STRING
			l_name : STRING
			l_type : STRING
			l_description : STRING
		do
			cursor.describe_results
			create l_catalog.make (cursor.results_description.item(1).size.min(c_maximum_initial_column_capacity))
			l_catalog.append_string ("CATALOG")
			create l_schema.make (cursor.results_description.item(2).size.min(c_maximum_initial_column_capacity))
			l_schema.append_string ("SCHEMA")
			create l_name.make (cursor.results_description.item(3).size.min(c_maximum_initial_column_capacity))
			l_name.append_string ("TABLE_NAME" )
			create l_type.make (cursor.results_description.item(4).size.min(c_maximum_initial_column_capacity))
			l_type.append_string ("TYPE")
			create l_description.make (cursor.results_description.item(5).size.min(c_maximum_initial_column_capacity))
			l_description.append_string ("DESCRIPTION" )
			context.filter.begin_heading
			context.filter.put_heading (l_catalog)
			context.filter.put_heading (l_schema)
			context.filter.put_heading (l_name)
			context.filter.put_heading (l_type)
			context.filter.put_heading (l_description)
			context.filter.end_heading
		end

	c_maximum_initial_column_capacity : INTEGER is 25

end -- class ISQL_CMD_TABLES
