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
			Result.append ("Execute any SQL statement or procedure call.")
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
			if context.session.is_bind_arrayed_results_capable then
				create {ECLI_ROWSET_CURSOR}cursor.make_prepared (context.session, text , 20)	
			else
				create cursor.make_prepared (context.session, text)
			end
			if cursor.is_ok then
				if cursor.has_parameters then
					if context.variables /= Void then
						set_parameters (cursor)
						cursor.bind_parameters
					end
				end
				if cursor.is_prepared then 
					if cursor.has_results then
						from 
							cursor.start
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
						else
							--| io.put_string ("OK%N")				
						end				
					else
						a_statement := cursor
						a_statement.execute
						if not a_statement.is_ok then
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
	
	set_parameters (stmt : ECLI_STATEMENT) is
		local
			value : ECLI_VARCHAR
			cursor : DS_HASH_TABLE_CURSOR[STRING,STRING]
		do
			from
				cursor := current_context.variables.new_cursor
				cursor.start
			until
				cursor.off
			loop
				if stmt.has_parameter (cursor.key) then
					!!value.make (cursor.item.count)
					value.set_item (cursor.item)
					stmt.put_parameter (value, cursor.key)
				end
				cursor.forth
			end					
		end

	sql_error (stmt : ECLI_STATUS) : STRING is
		do
			create Result.make (0)
			Result.append ("** ERROR **%N")
			Result.append (stmt.diagnostic_message)
			Result.append_character ('%N')
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
				context.filter.put_heading (cursor.column_name (i))
				i := i + 1
			end
			context.filter.end_heading
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
					context.filter.put_column (cursor.item_by_index(index).to_string)
				end
				index := index + 1
			end
			--
			--io.put_character ('%N')
			context.filter.end_row
		end

end -- class ISQL_CMD_SQL
