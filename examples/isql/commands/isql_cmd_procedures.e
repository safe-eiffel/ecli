indexing
	description: "Commands that list procedures available on a datasource."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_PROCEDURES

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING is
		do
			Result := padded ("pro[cedures]", command_width)
			Result.append_string ("List all procedures in current catalog")
		end

	match_string : STRING is "pro"
	
feature -- Status report
	
	needs_session : BOOLEAN is True
	
	matches (text: STRING) : BOOLEAN is
		do
			Result := matches_single_string (text, match_string)
		end
		
feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT) is
			-- show procedures of current datasource
		local
			query : ECLI_NAMED_METADATA
			cursor : ECLI_PROCEDURES_CURSOR
			l_procedure : ECLI_PROCEDURE_METADATA
		do
			create query.make (Void, Void, Void)
			create cursor.make (query, context.session)
			if cursor.is_executed then
				from
					cursor.start
					context.filter.begin_heading
					context.filter.put_heading ("CATALOG")
					context.filter.put_heading ("SCHEMA")
					context.filter.put_heading ("PROCEDURE_NAME")
					context.filter.put_heading ("DESCRIPTION")
					context.filter.put_heading ("TYPE")
					context.filter.end_heading
				until
					not cursor.is_ok or else cursor.off
				loop
					l_procedure := cursor.item
					context.filter.begin_row
					context.filter.put_column (nullable_string (l_procedure.catalog))
					context.filter.put_column (nullable_string (l_procedure.schema))
					context.filter.put_column (nullable_string (l_procedure.name))
					context.filter.put_column (nullable_string (l_procedure.description))
					if l_procedure.is_function then
						context.filter.put_column ("Function")
					elseif l_procedure.is_procedure then
						context.filter.put_column ("Procedure")
					else
						context.filter.put_column ("Unknown type")
					end
					context.filter.end_row
					cursor.forth
				end
			else
				context.filter.begin_error
				context.filter.put_error (sql_error_msg (cursor,"Cannot get procedures metadata"))
				context.filter.end_error
			end			
			cursor.close
		end

end -- class ISQL_CMD_PROCEDURES
