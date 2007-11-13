indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUI_QUERY_ASSISTANT

inherit

	ACCESS_GEN
		rename
			make as make_console
		redefine
			error_handler, parse_arguments, create_error_handler
		end

create

	make

feature {NONE} -- Initialization

	make (a_window : QUERY_ASSISTANT_WAIN_WINDOW) is
		do
			window := a_window
			window.set_assistant (Current)
		end

feature -- Access

	window : QUERY_ASSISTANT_WAIN_WINDOW

	error_handler : V2TEXT_ERROR_HANDLER

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_dsn (a_dsn : STRING) is
		require
			a_dsn_not_void: a_dsn /= Void
		do
			dsn := a_dsn
		ensure
			dsn_set: dsn = a_dsn
		end

	set_user (a_user : STRING) is
		require
			a_user_not_void: a_user /= Void
		do
			user := a_user
		ensure
			user_set: user = a_user
		end

	set_maximum_length_string (a_length : STRING) is
		require
			a_length_not_void: a_length /= Void
		do
			maximum_length_string := a_length
		ensure
			maximum_length_string_set: maximum_length_string = a_length
		end

	set_password (a_string : STRING) is
		require
			a_string_not_void: a_string /= Void
		do
			password := a_string
		ensure
			password_set: password = a_string
		end

	set_is_verbose (b : BOOLEAN) is
		do
			is_verbose := b
		ensure
			is_verbose_set: is_verbose = b
		end

	set_no_prototypes (b : BOOLEAN) is
		do
			no_prototypes := b
		ensure
			no_prototypes_set: no_prototypes = b
		end

	set_default_parent_modify (parent : STRING) is
		require
			parent_not_void: parent /= Void
		do
			default_parent_modify := parent
		ensure
			default_parent_modify_set: default_parent_modify = parent
		end

	set_default_schema (a_schema : STRING) is
		require
			a_schema_not_void: a_schema /= Void
		do
			default_schema := a_schema
		ensure
			default_schema_set: default_schema = a_schema
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	execute is
		do
			has_error := false
			is_verbose := false
			make_console
		end

	create_error_handler is
		do
			create error_handler.make (window.command_output)
		end

	parse_arguments is
		do
--				-input
					in_filename := window.input_file_name.text
--				-expat|-eiffel
				if window.is_use_expat.is_selected then
					if fact.is_expat_parser_available then
						event_parser := fact.new_expat_parser
					else
						error_handler.report_xml_parser_unavailable ("EXPAT")
						has_error := True
					end
				else
					create {XM_EIFFEL_PARSER} event_parser.make
				end
--				"-dsn"
					dsn := window.data_source_name.text
--				"-user"
					user := window.user_name.text
--				"-pwd"
					password := window.password.text
--				-output_dir"
					out_directory := window.output_directory_name.text
--				-schema"
					default_schema := window.schema_name.text
--				elseif key.is_equal ("-catalog")
--					default_catalog := value
--				-access_routines_prefix
					access_routines_prefix := window.access_routines_prefix.text
--				-parent_cursor"
					default_parent_cursor := window.parent_cursor.text
--				-parent_modify
					default_parent_modify := window.parent_modify.text
--				"-max_length"
					maximum_length_string := window.max_length.text
					if maximum_length_string.count = 0 then
						maximum_length_string := Void
					end
--				"-use_decimal"
					set_use_decimal (window.use_decimal.is_selected)
--				"-no_prototypes"
					no_prototypes := not window.use_function_prototypes.is_selected
				-- -verbose
				is_verbose := window.is_verbose.is_selected
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
