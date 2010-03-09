indexing
	description: "Access module generator XML constants."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCESS_MODULE_XML_CONSTANTS

feature -- Access

	t_access : STRING is "access"

	t_parameter_map : STRING is "parameter_map"

	t_name : STRING is "name"

	t_type : STRING is "type"

	t_sql : STRING is "sql"

	t_result_set : STRING is "result_set"

	t_extends : STRING is "extends"

	t_parameter_set : STRING is "parameter_set"

	t_table : STRING is "table"

	t_column : STRING is "column"

	t_description : STRING is "description"

	t_parameter : STRING is "parameter"

	t_direction : STRING is "direction"

	t_sample : STRING is "sample"

	t_modules : STRING is "modules"

	v_input : STRING is "input"
	v_output: STRING is "output"
	v_input_output: STRING is "input-output"

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class ACCESS_MODULE_XML_CONSTANTS
