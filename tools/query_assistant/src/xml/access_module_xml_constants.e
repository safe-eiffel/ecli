note
	description: "Access module generator XML constants."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCESS_MODULE_XML_CONSTANTS

feature -- Access

	t_access : STRING = "access"

	t_parameter_map : STRING = "parameter_map"

	t_name : STRING = "name"

	t_type : STRING = "type"

	t_sql : STRING = "sql"

	t_result_set : STRING = "result_set"

	t_extends : STRING = "extends"

	t_parameter_set : STRING = "parameter_set"

	t_table : STRING = "table"

	t_column : STRING = "column"

	t_description : STRING = "description"

	t_parameter : STRING = "parameter"

	t_direction : STRING = "direction"

	t_sample : STRING = "sample"

	t_modules : STRING = "modules"

	v_input : STRING = "input"
	v_output: STRING = "output"
	v_input_output: STRING = "input-output"

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
