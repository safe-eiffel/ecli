indexing
	description: "Objects that execute SQL statements."
	author: "Paul G. Crismer."
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_SQL

inherit
	ISQL_COMMAND

	ECLI_STRING_ROUTINES
		export {NONE} all
		end

feature -- Access

	help_message : STRING is
		do
			Result := padded ("<any sql statement>", command_width)
			Result.append_string ("Execute any SQL statement or procedure call.")
		end

feature -- Status report

	needs_session : BOOLEAN is True

	matches (text : STRING) : BOOLEAN  is
		do
			Result := True
		end

feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- execute a sql command
		local
			cursor : ECLI_ROW_CURSOR
			after_first : BOOLEAN
			a_statement : ECLI_STATEMENT
		do
--			if context.session.is_bind_arrayed_results_capable then
--				create {ECLI_ROWSET_CURSOR}cursor.make_prepared (context.session, text , 20)	
--			else
				create cursor.make (context.session, text)
--			end
			if cursor.is_ok then
				if cursor.has_parameters then
					if context.variables /= Void then
						set_parameters (cursor, context)
						if cursor.parameters /= Void and then cursor.parameters.count >= cursor.parameters_count then
							cursor.bind_parameters
						end
					end
				end
				cursor.start
				if cursor.is_executed then
					if cursor.has_result_set then
						from
							if cursor.has_information_message then
								print_error (cursor, context)
							end
						until
							not cursor.is_ok or else cursor.off
						loop
							if not after_first then
								show_column_names (cursor, context)
								after_first := True
							end
							show_one_row (cursor, context)
							cursor.forth
						end
						if not cursor.is_ok then
							print_error (cursor, context)
						end
					end
				else
					print_error (cursor, context)
				end
			else
				print_error (cursor, context)
			end
			cursor.close
		end

feature {NONE} -- Implementation

	current_context : ISQL_CONTEXT

	set_parameters (stmt : ECLI_STATEMENT; context : ISQL_CONTEXT) is
		require
			stmt_not_void: stmt /= Void
			context_not_void: context /= Void
		local
			value : ECLI_VARCHAR
			cursor : DS_LIST_CURSOR[STRING]
			var : STRING
		do
			from
				cursor := stmt.parameter_names.new_cursor
				cursor.start
			until
				cursor.off
			loop
				if context.has_variable (cursor.item) then
					var := context.variable (cursor.item)
					create value.make (var.count)
					value.set_item (var)
					stmt.put_parameter (value, cursor.item)
				end
				cursor.forth
			end
		end


	print_error (cursor : ECLI_STATEMENT; context : ISQL_CONTEXT) is
		do
			context.filter.begin_error
			context.filter.put_error (sql_error (cursor))
			context.filter.end_error
		end

	show_column_names (cursor : ECLI_ROW_CURSOR; context : ISQL_CONTEXT) is
		local
			i : INTEGER
		do
			from
				i := 1
				context.filter.begin_heading
			until
				i > cursor.upper
			loop
				context.filter.put_heading (column_name (cursor, i))
				i := i + 1
			end
			context.filter.end_heading
		end

	column_name (cursor : ECLI_ROW_CURSOR; i : INTEGER) : STRING is
		local
			l_capacity : INTEGER
			l_statement : ECLI_STATEMENT
		do
			l_statement ?= cursor
			l_capacity := l_statement.results_description.item (i).size.min (50)
			create Result.make (l_capacity)
			Result.append_string (cursor.column_name (i))
		end


	show_one_row (cursor : ECLI_ROW_CURSOR; context : ISQL_CONTEXT) is
		require
			cursor /= Void and then not cursor.off
		local
			index : INTEGER
		do
			from
				index := cursor.lower
				context.filter.begin_row
			until
				index > cursor.upper
			loop
				if cursor.item_by_index (index).is_null then
					context.filter.put_column ("NULL")
				else
					context.filter.put_column (cursor.item_by_index(index).as_string)
				end
				index := index + 1
			end
			--
			--io.put_character ('%N')
			context.filter.end_row
		end

end -- class ISQL_CMD_SQL
