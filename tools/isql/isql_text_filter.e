indexing
	description: "Simple text filters."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_TEXT_FILTER

inherit
	ISQL_FILTER
		redefine
			begin_heading, end_heading, put_heading,
			begin_row, end_row, put_column,
			begin_error, put_error, end_error,
			end_message
		end

create
	make

feature {NONE} -- Initialization

	make (a_context : ISQL_CONTEXT) is
		require
			a_context_not_void: a_context /= Void
		do
			default_create
			context := a_context
		ensure
			context_set: context = a_context
		end

	make_null
		do
			default_create

		end

feature -- Trick

	set_context (a_context: like context)
		do

		end

feature -- Access

	context : ISQL_CONTEXT

	heading_begin : STRING is do Result := "" end
	heading_separator : STRING is do Result := "%T" end
	heading_end : STRING is do Result := "%N" end
	row_begin : STRING is do Result := "" end
	column_separator : STRING is do Result := "%T" end
	row_end : STRING is do Result := "%N" end
	error_begin : STRING is do Result := "" end
	error_separator : STRING is do Result := "; " end
	error_end : STRING is do Result := "%N" end

feature -- Basic operations

	begin_heading is
		do
			if not context.is_variable_true (context.var_no_heading) then
				output_file.put_string (heading_begin)
			end
			Precursor
		end

	end_heading is
		do
			if not context.is_variable_true (context.var_no_heading) then
				output_file.put_string (heading_end)
			end
			Precursor
		end

	put_heading (s : STRING) is
		do
			if not context.is_variable_true (context.var_no_heading) then
				if heading_count > 0 then
					output_file.put_string (heading_separator)
				end
				output_file.put_string (s)
			end
			Precursor (s)
		end

	begin_row is
		do
			output_file.put_string (row_begin)
			Precursor
		end

	end_row is
		do
			output_file.put_string (row_end)
			Precursor
		end

	put_column (s : STRING) is
		do
			if column_count > 0 then
				output_file.put_string (column_separator)
			end
			output_file.put_string (s)
			Precursor (s)
		end

	begin_error is
		do
			output_file.put_string (error_begin)
			Precursor
		end

	end_error is
		do
			output_file.put_string (error_end)
			Precursor
		end

	end_message is
		do
			output_file.put_string ("%N")
			Precursor
		end

	put_error (s : STRING) is
		do
			if error_count > 0 then
				output_file.put_string (error_separator)
			end
			output_file.put_string (s)
			Precursor (s)
		end

	put_message (s : STRING) is
		do
			output_file.put_string (s)
		end

feature {NONE} -- Implementation

	variable_value (var_name : STRING) : STRING is
			-- value of variable `var_name'
		require
			var_name_not_void: var_name /= Void
		do
			if context.has_variable (var_name) then
				Result := context.variable (var_name)
			else
				Result := ""
			end
		end

invariant
	context_not_void: context /= Void

end -- class ISQL_TEXT_FILTER
