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

	match_string : STRING is once Result := "col" end

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
			cursor : like cursor_type
		do
			create stream.make (text, " %T")
			stream.read_word
			if not stream.end_of_input then
				--| try reading table_name
				stream.read_quoted_word
				if not stream.end_of_input then
					l_table := stream.last_string.twin
					if stream.is_last_string_quoted then
						l_table := l_table.substring (2, l_table.count-1)
					end
					stream.read_quoted_word
					if not stream.end_of_input then
						l_schema := l_table
						l_table := stream.last_string.twin
						if stream.is_last_string_quoted then
							l_table := l_table.substring (2, l_table.count-1)
						end
						stream.read_quoted_word
						if not stream.end_of_input then
							l_catalog := l_schema
							l_schema := l_table
							l_table := stream.last_string.twin
							if stream.is_last_string_quoted then
								l_table := l_table.substring (2, l_table.count-1)
							end
						end
					end
				end
				create query.make (l_catalog, l_schema, l_table)
				cursor := new_cursor (query, context.session)
				put_results (cursor, context)
				cursor.close
			end
		end

feature {NONE} -- Implementation

	new_cursor (a_table: ECLI_NAMED_METADATA; a_session: ECLI_SESSION) : ECLI_COLUMNS_CURSOR is
			--
		do
				create Result.make (a_table, a_session)
		end

	put_results (a_cursor : like cursor_type; context : ISQL_CONTEXT) is
			--
		local
			the_column : like column_type
		do
			if a_cursor.is_executed then
				from
					a_cursor.start
					context.filter.begin_heading
					put_heading (context.filter)
					context.filter.end_heading
				until
					not a_cursor.is_ok or else a_cursor.off
				loop
					the_column := a_cursor.item
					context.filter.begin_row
					put_detail (the_column, context.filter)
					context.filter.end_row
					a_cursor.forth
				end
			else
				context.filter.begin_error
				context.filter.put_error (sql_error_msg (a_cursor, "Cannot get columns metadata"))
				context.filter.end_error
			end
		end

	put_heading (filter : ISQL_FILTER) is
			--
		require
			filter_not_void: filter /= Void
			filter_heading_begun: filter.is_in_heading
		do
			filter.put_heading ("COLUMN_NAME")
			filter.put_heading ("TYPE")
			filter.put_heading ("TRANSFER_LENGTH")
			filter.put_heading ("PRECISION")
			filter.put_heading ("DECIMAL_DIGITS")
			filter.put_heading ("PRECISION_RADIX")
			filter.put_heading ("DESCRIPTION")
		end

	put_detail (the_column : like column_type; filter : ISQL_FILTER) is
			--
		require
			the_column_not_void: the_column /= Void
			filter_not_void: filter /= Void
			filter_row_begun: filter.is_in_row
		do
			filter.put_column (nullable_string (the_column.name))
			filter.put_column (nullable_string (the_column.type_name))
			if the_column.is_transfer_length_applicable then
				filter.put_column (the_column.transfer_length.out)
			else
				filter.put_column (null_constant)
			end
			if the_column.is_size_applicable then
				filter.put_column (the_column.size.out)
			else
				filter.put_column (null_constant)
			end
			if the_column.is_decimal_digits_applicable then
				filter.put_column (the_column.decimal_digits.out)
			else
				filter.put_column (null_constant)
			end
			if the_column.is_precision_radix_applicable then
				filter.put_column (the_column.precision_radix.out)
			else
				filter.put_column (null_constant)
			end
			filter.put_column (nullable_string (the_column.description))
		end

	column_type : ECLI_COLUMN is do end
	cursor_type : ECLI_COLUMNS_CURSOR is do end


end -- class ISQL_CMD_COLUMNS
