indexing
	description: "Text filters that take configuration parameters from context variables."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CONFIGURABLE_TEXT_FILTER

inherit
	ISQL_TEXT_FILTER
		redefine
			heading_begin,
			heading_separator ,
			heading_end ,
			row_begin ,
			column_separator ,
			row_end ,
			error_begin ,
			error_separator ,
			error_end
		end
	
creation
	make
	
feature -- Access

	heading_begin : STRING is 
		do 
			Result := variable_value (context.var_heading_begin)
		end
		
	heading_separator : STRING is do Result := variable_value (context.Var_heading_separator) end
	heading_end : STRING is do Result := variable_value (context.Var_heading_end) end
	row_begin : STRING is do Result := variable_value (context.Var_row_begin) end
	column_separator : STRING is do Result := variable_value (context.Var_column_separator) end
	row_end : STRING is do Result := variable_value (context.Var_row_end) end
	error_begin : STRING is do Result := Precursor end
	error_separator : STRING is do Result := Precursor end
	error_end : STRING is do Result := Precursor end
	
end -- class ISQL_CONFIGURABLE_TEXT_FILTER
