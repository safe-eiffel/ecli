indexing
	description: "Commands that list the columns of a stored procedure."
	author: "Paul G. Crismer"
	
	application: "clisql"
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_PROCEDURE_COLUMNS

inherit
	ISQL_CMD_COLUMNS
		redefine
			help_message,
			match_string,
			put_heading,
			put_detail,
			new_cursor
		end	
	
	ECLI_PROCEDURE_TYPE_METADATA_CONSTANTS
	
feature -- Access

	help_message : STRING is
		do
			Result := padded ("pcol[umns] <procedure-name>", command_width)
			Result.append_string ("List all columns in <procedure-name>.")
		end

	match_string : STRING is "pcol"

feature {NONE} -- Implementation

	new_cursor (a_procedure : ECLI_NAMED_METADATA; a_session: ECLI_SESSION) : ECLI_PROCEDURE_COLUMNS_CURSOR is
			-- new cursor on `a_procedure' columns metadata, querying `a_session' catalog.
		do
			create Result.make (a_procedure, a_session)
		end
		
	put_heading (filter: ISQL_FILTER) is
			-- put heading in `filter' stream
		do
			Precursor (filter)
			filter.put_heading ("Type")
		end
		
	put_detail (the_column: ECLI_PROCEDURE_COLUMN; filter: ISQL_FILTER) is
			-- put `the_column' in `filter' stream
		local
			type_label : STRING
		do
			Precursor (the_column, filter)
			inspect the_column.column_type 
			when Sql_result_col then
				type_label := "Result-set"
			when Sql_param_input_output then
				type_label := "Input/Output"
			when Sql_param_input then
				type_label := "Input"
			when Sql_param_output then
				type_label := "Output"
			when Sql_return_value then
				type_label := "Function Result"
			else									
				type_label := "Unknown"
			end
			filter.put_column (type_label)
		end
		
end -- class ISQL_CMD_PROCEDURE_COLUMNS
