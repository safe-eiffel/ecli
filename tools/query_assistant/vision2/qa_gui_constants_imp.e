indexing
	description: "[
			Objects that provide access to constants, possibly loaded from a files.
			Each constant is generated into two features: both a query and a storage
			feature. For example, for a STRING constant named `my_string', the following
			features are generated: my_string: STRING and my_string_cell: CELL [STRING].
			`my_string' simply returns the current item of `my_string_cell'. By seperating
			the constant access in this way, it is possible to change the constant's value
			by either redefining `my_string' in descendent classes or simply performing
			my_string_cell.put ("new_string") as required.
			If you are loading the constants from a file and you wish to reload a different set
			of constants for your interface (e.g. for multi-language support), you may perform
			this in the following way:
			
			set_file_name ("my_constants_file.text")
			reload_constants_from_file
			
			and then for each generated widget, call `set_all_attributes_using_constants' to reset
			the newly loaded constants into the attribute settings of each widget that relies on constants.
			
			Note that if you wish your constants file to be loaded from a specific location,
			you may redefine `initialize_constants' to handle the loading of the file from
			an alternative location.
			
			Note that if you have selected to load constants from a file, and the file cannot
			be loaded, you will get a precondition violation when attempting to access one
			of the constants that should have been loaded. Therefore, you must ensure that either the
			file is accessible or you do not specify to load from a file.
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	QA_GUI_CONSTANTS_IMP
	
feature {NONE} -- Initialization

	initialize_constants is
			-- Load all constants from file.
		local
			file: PLAIN_TEXT_FILE
		do
			if not constants_initialized then
				create file.make (file_name)
				if file.exists then
					file.open_read
					file.readstream (file.count)
					file.close
					parse_file_contents (file.laststring)
				end
				initialized_cell.put (True)
			end
		ensure
			initialized: constants_initialized
		end

feature -- Access

	reload_constants_from_file is
			-- Re-load all constants from file named `file_name'.
			-- When used in conjunction with `set_file_name', it enables
			-- you to load a fresh set of INTEGER and STRING constants
			-- from a constants file. If you then wish these to be applied
			-- to a current generated interface, call `set_all_attributes_using_constants'
			-- on that interface for the changed constants to be reflected in the attributes
			-- of your widgets.
		do
			initialized_cell.put (False)
			initialize_constants
			general_options_label_cell.put(string_constant_by_name ("general_options_label"))
			access_routines_prefix_label_cell.put(string_constant_by_name ("access_routines_prefix_label"))
			parent_cursor_label_cell.put(string_constant_by_name ("parent_cursor_label"))
			data_source_options_label_cell.put(string_constant_by_name ("data_source_options_label"))
			minimum_generation_label_cell.put(integer_constant_by_name ("minimum_generation_label"))
			user_name_label_cell.put(string_constant_by_name ("user_name_label"))
			password_label_cell.put(string_constant_by_name ("password_label"))
			generate_button_label_cell.put(string_constant_by_name ("generate_button_label"))
			function_prototype_label_cell.put(string_constant_by_name ("function_prototype_label"))
			output_directory_label_cell.put(string_constant_by_name ("output_directory_label"))
			data_source_schema_label_cell.put(string_constant_by_name ("data_source_schema_label"))
			menu_about_label_cell.put(string_constant_by_name ("menu_about_label"))
			menu_help_label_cell.put(string_constant_by_name ("menu_help_label"))
			catalog_name_label_cell.put(string_constant_by_name ("catalog_name_label"))
			use_decimal_label_cell.put(string_constant_by_name ("use_decimal_label"))
			input_file_label_cell.put(string_constant_by_name ("input_file_label"))
			parent_cursor_tooltip_cell.put(string_constant_by_name ("parent_cursor_tooltip"))
			parent_modify_tooltip_cell.put(string_constant_by_name ("parent_modify_tooltip"))
			max_length_tooltip_cell.put(string_constant_by_name ("max_length_tooltip"))
			xml_parser_label_cell.put(string_constant_by_name ("xml_parser_label"))
			generation_option_label_cell.put(string_constant_by_name ("generation_option_label"))
			find_button_ellipsis_cell.put(string_constant_by_name ("find_button_ellipsis"))
			input_output_label_cell.put(string_constant_by_name ("input_output_label"))
			xml_parser_tooltip_cell.put(string_constant_by_name ("xml_parser_tooltip"))
			data_source_name_label_cell.put(string_constant_by_name ("data_source_name_label"))
			minimum_file_name_width_cell.put(integer_constant_by_name ("minimum_file_name_width"))
			verbose_tooltip_cell.put(string_constant_by_name ("verbose_tooltip"))
			verbose_label_cell.put(string_constant_by_name ("verbose_label"))
			max_length_label_cell.put(string_constant_by_name ("max_length_label"))
			data_source_schema_tooltip_cell.put(string_constant_by_name ("data_source_schema_tooltip"))
			data_source_name_tooltip_cell.put(string_constant_by_name ("data_source_name_tooltip"))
			parent_modify_label_cell.put(string_constant_by_name ("parent_modify_label"))
		end

	general_options_label: STRING is
			-- `Result' is STRING constant named `general_options_label'.
		do
			Result := general_options_label_cell.item
		end

	general_options_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `general_options_label'.
		once
			create Result.put (string_constant_by_name ("general_options_label"))
		end

	access_routines_prefix_label: STRING is
			-- `Result' is STRING constant named `access_routines_prefix_label'.
		do
			Result := access_routines_prefix_label_cell.item
		end

	access_routines_prefix_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `access_routines_prefix_label'.
		once
			create Result.put (string_constant_by_name ("access_routines_prefix_label"))
		end

	parent_cursor_label: STRING is
			-- `Result' is STRING constant named `parent_cursor_label'.
		do
			Result := parent_cursor_label_cell.item
		end

	parent_cursor_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `parent_cursor_label'.
		once
			create Result.put (string_constant_by_name ("parent_cursor_label"))
		end

	data_source_options_label: STRING is
			-- `Result' is STRING constant named `data_source_options_label'.
		do
			Result := data_source_options_label_cell.item
		end

	data_source_options_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `data_source_options_label'.
		once
			create Result.put (string_constant_by_name ("data_source_options_label"))
		end

	minimum_generation_label: INTEGER is
			-- `Result' is INTEGER constant named `minimum_generation_label'.
		do
			Result := minimum_generation_label_cell.item
		end

	minimum_generation_label_cell: CELL [INTEGER] is
			--`Result' is once access to a cell holding vale of `minimum_generation_label'.
		once
			create Result.put (integer_constant_by_name ("minimum_generation_label"))
		end

	user_name_label: STRING is
			-- `Result' is STRING constant named `user_name_label'.
		do
			Result := user_name_label_cell.item
		end

	user_name_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `user_name_label'.
		once
			create Result.put (string_constant_by_name ("user_name_label"))
		end

	password_label: STRING is
			-- `Result' is STRING constant named `password_label'.
		do
			Result := password_label_cell.item
		end

	password_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `password_label'.
		once
			create Result.put (string_constant_by_name ("password_label"))
		end

	generate_button_label: STRING is
			-- `Result' is STRING constant named `generate_button_label'.
		do
			Result := generate_button_label_cell.item
		end

	generate_button_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `generate_button_label'.
		once
			create Result.put (string_constant_by_name ("generate_button_label"))
		end

	function_prototype_label: STRING is
			-- `Result' is STRING constant named `function_prototype_label'.
		do
			Result := function_prototype_label_cell.item
		end

	function_prototype_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `function_prototype_label'.
		once
			create Result.put (string_constant_by_name ("function_prototype_label"))
		end

	output_directory_label: STRING is
			-- `Result' is STRING constant named `output_directory_label'.
		do
			Result := output_directory_label_cell.item
		end

	output_directory_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `output_directory_label'.
		once
			create Result.put (string_constant_by_name ("output_directory_label"))
		end

	data_source_schema_label: STRING is
			-- `Result' is STRING constant named `data_source_schema_label'.
		do
			Result := data_source_schema_label_cell.item
		end

	data_source_schema_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `data_source_schema_label'.
		once
			create Result.put (string_constant_by_name ("data_source_schema_label"))
		end

	menu_about_label: STRING is
			-- `Result' is STRING constant named `menu_about_label'.
		do
			Result := menu_about_label_cell.item
		end

	menu_about_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `menu_about_label'.
		once
			create Result.put (string_constant_by_name ("menu_about_label"))
		end

	menu_help_label: STRING is
			-- `Result' is STRING constant named `menu_help_label'.
		do
			Result := menu_help_label_cell.item
		end

	menu_help_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `menu_help_label'.
		once
			create Result.put (string_constant_by_name ("menu_help_label"))
		end

	catalog_name_label: STRING is
			-- `Result' is STRING constant named `catalog_name_label'.
		do
			Result := catalog_name_label_cell.item
		end

	catalog_name_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `catalog_name_label'.
		once
			create Result.put (string_constant_by_name ("catalog_name_label"))
		end

	use_decimal_label: STRING is
			-- `Result' is STRING constant named `use_decimal_label'.
		do
			Result := use_decimal_label_cell.item
		end

	use_decimal_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `use_decimal_label'.
		once
			create Result.put (string_constant_by_name ("use_decimal_label"))
		end

	input_file_label: STRING is
			-- `Result' is STRING constant named `input_file_label'.
		do
			Result := input_file_label_cell.item
		end

	input_file_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `input_file_label'.
		once
			create Result.put (string_constant_by_name ("input_file_label"))
		end

	parent_cursor_tooltip: STRING is
			-- `Result' is STRING constant named `parent_cursor_tooltip'.
		do
			Result := parent_cursor_tooltip_cell.item
		end

	parent_cursor_tooltip_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `parent_cursor_tooltip'.
		once
			create Result.put (string_constant_by_name ("parent_cursor_tooltip"))
		end

	parent_modify_tooltip: STRING is
			-- `Result' is STRING constant named `parent_modify_tooltip'.
		do
			Result := parent_modify_tooltip_cell.item
		end

	parent_modify_tooltip_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `parent_modify_tooltip'.
		once
			create Result.put (string_constant_by_name ("parent_modify_tooltip"))
		end

	max_length_tooltip: STRING is
			-- `Result' is STRING constant named `max_length_tooltip'.
		do
			Result := max_length_tooltip_cell.item
		end

	max_length_tooltip_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `max_length_tooltip'.
		once
			create Result.put (string_constant_by_name ("max_length_tooltip"))
		end

	xml_parser_label: STRING is
			-- `Result' is STRING constant named `xml_parser_label'.
		do
			Result := xml_parser_label_cell.item
		end

	xml_parser_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `xml_parser_label'.
		once
			create Result.put (string_constant_by_name ("xml_parser_label"))
		end

	generation_option_label: STRING is
			-- `Result' is STRING constant named `generation_option_label'.
		do
			Result := generation_option_label_cell.item
		end

	generation_option_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `generation_option_label'.
		once
			create Result.put (string_constant_by_name ("generation_option_label"))
		end

	find_button_ellipsis: STRING is
			-- `Result' is STRING constant named `find_button_ellipsis'.
		do
			Result := find_button_ellipsis_cell.item
		end

	find_button_ellipsis_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `find_button_ellipsis'.
		once
			create Result.put (string_constant_by_name ("find_button_ellipsis"))
		end

	input_output_label: STRING is
			-- `Result' is STRING constant named `input_output_label'.
		do
			Result := input_output_label_cell.item
		end

	input_output_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `input_output_label'.
		once
			create Result.put (string_constant_by_name ("input_output_label"))
		end

	xml_parser_tooltip: STRING is
			-- `Result' is STRING constant named `xml_parser_tooltip'.
		do
			Result := xml_parser_tooltip_cell.item
		end

	xml_parser_tooltip_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `xml_parser_tooltip'.
		once
			create Result.put (string_constant_by_name ("xml_parser_tooltip"))
		end

	data_source_name_label: STRING is
			-- `Result' is STRING constant named `data_source_name_label'.
		do
			Result := data_source_name_label_cell.item
		end

	data_source_name_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `data_source_name_label'.
		once
			create Result.put (string_constant_by_name ("data_source_name_label"))
		end

	minimum_file_name_width: INTEGER is
			-- `Result' is INTEGER constant named `minimum_file_name_width'.
		do
			Result := minimum_file_name_width_cell.item
		end

	minimum_file_name_width_cell: CELL [INTEGER] is
			--`Result' is once access to a cell holding vale of `minimum_file_name_width'.
		once
			create Result.put (integer_constant_by_name ("minimum_file_name_width"))
		end

	verbose_tooltip: STRING is
			-- `Result' is STRING constant named `verbose_tooltip'.
		do
			Result := verbose_tooltip_cell.item
		end

	verbose_tooltip_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `verbose_tooltip'.
		once
			create Result.put (string_constant_by_name ("verbose_tooltip"))
		end

	verbose_label: STRING is
			-- `Result' is STRING constant named `verbose_label'.
		do
			Result := verbose_label_cell.item
		end

	verbose_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `verbose_label'.
		once
			create Result.put (string_constant_by_name ("verbose_label"))
		end

	max_length_label: STRING is
			-- `Result' is STRING constant named `max_length_label'.
		do
			Result := max_length_label_cell.item
		end

	max_length_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `max_length_label'.
		once
			create Result.put (string_constant_by_name ("max_length_label"))
		end

	data_source_schema_tooltip: STRING is
			-- `Result' is STRING constant named `data_source_schema_tooltip'.
		do
			Result := data_source_schema_tooltip_cell.item
		end

	data_source_schema_tooltip_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `data_source_schema_tooltip'.
		once
			create Result.put (string_constant_by_name ("data_source_schema_tooltip"))
		end

	data_source_name_tooltip: STRING is
			-- `Result' is STRING constant named `data_source_name_tooltip'.
		do
			Result := data_source_name_tooltip_cell.item
		end

	data_source_name_tooltip_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `data_source_name_tooltip'.
		once
			create Result.put (string_constant_by_name ("data_source_name_tooltip"))
		end

	parent_modify_label: STRING is
			-- `Result' is STRING constant named `parent_modify_label'.
		do
			Result := parent_modify_label_cell.item
		end

	parent_modify_label_cell: CELL [STRING] is
			--`Result' is once access to a cell holding vale of `parent_modify_label'.
		once
			create Result.put (string_constant_by_name ("parent_modify_label"))
		end

feature -- Access

--| FIXME `constant_by_name' and `has_constant' `constants_initialized' are only required until the complete change to
--| constants is complete. They are required for the pixmaps at the moment.

	constants_initialized: BOOLEAN is
			-- Have constants been initialized from file?
		do
			Result := initialized_cell.item
		end

	string_constant_by_name (a_name: STRING): STRING is
			-- `Result' is STRING 
		require
			initialized: constants_initialized
			name_valid: a_name /= Void and not a_name.is_empty
			has_constant (a_name)
		do
			Result := (all_constants.item (a_name)).twin
		ensure
			Result_not_void: Result /= Void
		end
		
	integer_constant_by_name (a_name: STRING): INTEGER is
			-- `Result' is STRING 
		require
			initialized: constants_initialized
			name_valid: a_name /= Void and not a_name.is_empty
			has_constant (a_name)
		local
			l_string: STRING
		do
			l_string := (all_constants.item (a_name)).twin
			check
				is_integer: l_string.is_integer
			end
			
			Result := l_string.to_integer
		end
		
	has_constant (a_name: STRING): BOOLEAN is
			-- Does constant `a_name' exist?
		require
			initialized: constants_initialized
			name_valid: a_name /= Void and not a_name.is_empty
		do
			Result := all_constants.item (a_name) /= Void
		end

feature {NONE} -- Implementation

	initialized_cell: CELL [BOOLEAN] is
			-- A cell to hold whether the constants have been loaded.
		once
			create Result
		end
		
	all_constants: HASH_TABLE [STRING, STRING] is
			-- All constants loaded from constants file.
		once
			create Result.make (4)
		end
		
	file_name: STRING is
			-- File name from which constants must be loaded.
		do
			Result := file_name_cell.item
		end
		
	file_name_cell: CELL [STRING] is
		once
			create Result
			Result.put ("constants.txt")
		end
		
	set_file_name (a_file_name: STRING) is
			-- Assign `a_file_name' to `file_name'.
		do
			file_name_cell.put (a_file_name)
		end
		
	String_constant: STRING is "STRING"
	
	Integer_constant: STRING is "INTEGER"
		
	parse_file_contents (content: STRING) is
			-- Parse contents of `content' into `all_constants'.
		local
			line_contents: STRING
			is_string: BOOLEAN
			is_integer: BOOLEAN
			start_quote1, end_quote1, start_quote2, end_quote2: INTEGER
			name, value: STRING
		do
			from
			until
				content.is_equal ("")
			loop
				line_contents := first_line (content)
				if line_contents.count /= 1 then
					is_string := line_contents.substring_index (String_constant, 1) /= 0
					is_integer := line_contents.substring_index (Integer_constant, 1) /= 0
					if is_string or is_integer then
						start_quote1 := line_contents.index_of ('"', 1)
						end_quote1 := line_contents.index_of ('"', start_quote1 + 1)
						start_quote2 := line_contents.index_of ('"', end_quote1 + 1)
						end_quote2 := line_contents.index_of ('"', start_quote2 + 1)
						name := line_contents.substring (start_quote1 + 1, end_quote1 - 1)
						value := line_contents.substring (start_quote2 + 1, end_quote2 - 1)
						all_constants.force (value, name)
					end
				end
			end
		end
		
	first_line (content: STRING): STRING is
			-- `Result' is first line of `Content',
			-- which will be stripped from `content'.
		require
			content_not_void: content /= Void
			content_not_empty: not content.is_empty
		local
			new_line_index: INTEGER		
		do
			new_line_index := content.index_of ('%N', 1)
			if new_line_index /= 0 then
				Result := content.substring (1, new_line_index)
				content.keep_tail (content.count - new_line_index)
			else
				Result := content.twin
				content.keep_head (0)
			end
		ensure
			Result_not_void: Result /= Void
			no_characters_lost: old content.count = Result.count + content.count
		end

	set_with_named_file (a_pixmap: EV_PIXMAP; a_file_name: STRING) is
			-- Set image of `a_pixmap' from file, `a_file_name'.
			-- If `a_file_name' does not exist, do nothing.
		require
			a_pixmap_not_void: a_pixmap /= Void
			a_file_name /= Void
		local
			l_file: RAW_FILE
		do
			create l_file.make (a_file_name)
			if l_file.exists then
				a_pixmap.set_with_named_file (a_file_name)
			end
		end

invariant
	all_constants_not_void: all_constants /= Void

end
