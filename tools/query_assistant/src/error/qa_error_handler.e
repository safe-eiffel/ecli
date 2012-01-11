indexing

	description:

		"Error handlers."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class QA_ERROR_HANDLER

inherit

	UT_ERROR_HANDLER
		export
			{NONE} report_error_message, report_info_message, report_warning_message,
				report_error, report_warning, report_info
		end

create
	make_standard, make_null

feature -- Status report

	has_missing_argument : BOOLEAN

feature -- Status setting

	disable_verbose is
		do
			info_file := Null_output_stream
		ensure
			not_verbose: not is_verbose
		end

feature -- Arguments

	report_missing_argument (argument_name, explanation: STRING) is
			-- Report missing `argument_name' using `explanation'.
		require
			argument_name_not_void: argument_name /= void
			explanation_not_void: explanation /= void
		local
			error : QA_ARGUMENTS_ERROR
		do
			create error.make_missing (argument_name, explanation)
			report_error (error)
			has_missing_argument := True
		ensure
			has_missing_argument: has_missing_argument
		end

	report_invalid_argument (argument_name, explanation: STRING) is
			-- Report invalid `argument_name' using `explanation'.
		require
			argument_name_not_void: argument_name /= void
			explanation_not_void: explanation /= void
		local
			error : QA_ARGUMENTS_ERROR
		do
			create error.make_invalid (argument_name, explanation)
			report_error (error)
		end

	report_default_argument (argument_name, value: STRING) is
			-- Report usage of default argument `value' for `argument_name'.
		require
			argument_name_not_void: argument_name /= void
			explanation_not_void: value /= void
		local
			error : QA_ARGUMENTS_ERROR
		do
			create error.make_default (argument_name, value)
			report_warning (error)
		end

feature -- File

	report_cannot_read_file (file_name : STRING) is
			-- Report file `file_name' cannot be read.
		require
			file_name_not_void: file_name /= Void
		local
			error : QA_FILE_ERROR
		do
			create error.make_cannot_read (file_name)
			report_error (error)
		end

	report_cannot_write_file (file_name : STRING) is
			-- Report file `file_name' cannot' be written.
		require
			file_name_not_void: file_name /= Void
		local
			error : QA_FILE_ERROR
		do
			create error.make_cannot_write (file_name)
			report_error (error)
		end

feature -- Database

	report_database_connection_failed (data_source_name: STRING) is
			-- Report connection failed on `data_source_name'.
		require
			data_source_name_not_void: data_source_name /= void
		local
			error : QA_DATABASE_ERROR
		do
			create error.make_connection_failed (data_source_name)
			report_error (error)
		end

	report_query_execution_failed (query, diagnostic, module_name: STRING) is
			-- Exectution of `query' failed with `diagnostic' for `module_name'.
		require
			query_not_void: query /= void
			diagnostic_not_void: diagnostic /= void
			module_name_not_void: module_name /= void
		local
			error : QA_DATABASE_ERROR
		do
			create error.make_query_failed (query, diagnostic, module_name)
			report_error (error)
		end

	report_prepare_query_failed (query, diagnostic, module_name: STRING) is
			-- Preparation of `query' failed with `diagnostic' for `module_name'.
		require
			query_not_void: query /= void
			diagnostic_not_void: diagnostic /= void
			module_name_not_void: module_name /= void
		local
			error : QA_DATABASE_ERROR
		do
			create error.make_prepare_failed (query, diagnostic, module_name)
			report_error (error)
		end

	report_query_only_prepared (module_name: STRING) is
			-- Query of `module_name' has been prepared.
		require
			module_name_not_void: module_name /= void
		local
			error : QA_DATABASE_ERROR
		do
			create error.make_warning_prepared (module_name)
			report_error (error)
		end

feature -- Information

	report_processing_file (in_filename : STRING) is
			-- Report that `in_filename' is being processed
		require
			in_filename_not_void: in_filename /= Void
		local
			error: QA_INFORMATION
		do
			create error.make_processing_file (in_filename)
			report_error (error)
		end


	report_copyright (author, period: STRING) is
			-- Report  copyright message with `author' for `period'.
		require
			author_not_void: author /= void
			period_not_void: period /= void
		local
			error : QA_INFORMATION
		do
			create error.make_copyright (author, period)
			report_info (error)
		end

	report_banner (version: STRING) is
			-- Report  banner `version'.
		require
			version_not_void: version /= void
		local
			error : QA_INFORMATION
		do
			create error.make_banner (version)
			report_error (error)
		end

	report_license (license_name, version: STRING) is
			-- Report  license message for `license_name', `version'.
		require
			license_name_not_void: license_name /= void
			version_not_void: version /= void
		local
			error : QA_INFORMATION
		do
			create error.make_license  (license_name, version)
			report_info (error)
		end

	report_start (process: STRING) is
			-- Report  information on starting `process'.
		require
			process_not_void: process /= void
		local
			error : QA_INFORMATION
		do
			create error.make_start (process)
			report_info (error)
		end

	report_generating (generated: STRING) is
			-- Report  information on starting `generated'.
		require
			generated_not_void: generated /= void
		local
			error : QA_INFORMATION
		do
			create error.make_generating (generated)
			report_info (error)
		end

	report_end (process: STRING; success: BOOLEAN) is
			-- Report  information on ending `process' with `success'.
		require
			process_not_void: process /= void
		local
			error : QA_INFORMATION
		do
			create error.make_end (process, success)
			report_info (error)
		end

feature -- Internal

	report_could_not_create_parameter (module, name, diagnostic : STRING) is
			-- Could not create parameter `name' in `module' because of `diagnostic'.
		require
			name_not_void: name /= void
			module_not_void: module /= Void
			diagnostic_not_void: diagnostic /= Void
		local
			error : QA_INTERNAL_ERROR
		do
			create error.make_could_not_create_parameter (module, name, diagnostic)
			report_error (error)
		end

	report_xml_parser_unavailable (name: STRING) is
			-- XML Parser `name' not available.
		require
			name_not_void: name /= void
		local
			error : QA_INTERNAL_ERROR
		do
			create error.make_xml_parser_unavailable (name)
			report_error (error)
		end

	report_column_length_too_large (module, column: STRING; length: INTEGER; parameter: BOOLEAN) is
			-- Length `length' of `column' `parameter/result' in `module' is too large.
		require
			module_not_void: module /= void
			column_not_void: column /= void
			length_strictly_positive: length > 0
		local
			error : QA_INTERNAL_ERROR
		do
			create error.make_column_length_too_large (module, column, length, parameter)
			report_error (error)
		end

	report_column_length_truncated (module, column: STRING; length: INTEGER; parameter: BOOLEAN) is
			-- Length of `column' `parameter/result' in `module' has been truncated to `length'.
		require
			module_not_void: module /= void
			column_not_void: column /= void
			length_strictly_positive: length > 0
		local
			error : QA_INTERNAL_ERROR
		do
			create error.make_column_length_truncated (module, column, length, parameter)
			report_error (error)
		end

feature -- Syntax

	report_duplicate_element (module, element, parent: STRING) is
			-- Report duplicate `element' in `parent' for `module'.
		require
			module_not_void: module /= void
			element_not_void: element /= void
			parent_not_void: parent /= void
		local
			error : QA_SYNTAX_ERROR
		do
			create error.make_duplicate_element (module, element, parent)
			report_error (error)
		end

report_exclusive_element (module, element_a, element_b, parent: STRING) is
			-- Report `element_a' exclusive of `element_b' in `parent' for `module'.
		require
			module_not_void: module /= void
			element_a_not_void: element_a /= void
			element_b_not_void: element_b /= void
			parent_not_void: parent /= void
		local
			error : QA_SYNTAX_ERROR
		do
			create error.make_exclusive_element (module, element_a, element_b, parent)
			report_error (error)
		end

	report_missing_element (module, element, parent: STRING) is
			-- Report missing `element' in `parent' for `module'.
		require
			module_not_void: module /= void
			element_not_void: element /= void
		local
			error : QA_SYNTAX_ERROR
		do
			create error.make_missing_element (module, element, parent)
			report_error (error)
		end

	report_missing_attribute (module, an_attribute, element: STRING) is
			-- Report missing `attribute' in `element' for `module'.
		require
			module_not_void: module /= void
			an_attribute_not_void: an_attribute /= void
			element_not_void: element /= void
		local
			error : QA_SYNTAX_ERROR
		do
			create error.make_missing_attribute (module, an_attribute, element)
			report_error (error)
		end

	report_parse_error (diagnostic: STRING) is
			-- Report XML parse error with `diagnostic'.
		require
			diagnostic_not_void: diagnostic /= void
		local
			error : QA_SYNTAX_ERROR
		do
			create error.make_parse_error (diagnostic)
			report_error (error)
		end

feature -- Usage

	report_usage (has_expat: BOOLEAN) is
		local
			error : QA_USAGE_MESSAGE
		do
			create error.make (has_expat)
			report_error (error)
		end

feature -- Validity

	report_already_exists (who, what, type: STRING) is
			-- Report  `who' already has an existing `what' of type `type'
		require
			who_not_void: who /= void
			what_not_void: what /= void
			type_not_void: type /= void
		local
			error : QA_VALIDITY_ERROR
		do
			create error.make_already_exists (who, what, type)
			report_error (error)
		end

	report_rejected (module_name : STRING) is
			-- Report `module_name' is rejected.
		require
			module_name_not_void: module_name /= Void
		local
			error : QA_VALIDITY_ERROR
		do
			create error.make_rejected (module_name)
			report_error (error)
		end

	report_invalid_reference_column (module, name, table, column: STRING) is
			-- Report  `name' in `module' has an invalid reference column as `table'.`column'.
		local
			error : QA_VALIDITY_ERROR
		do
			create error.make_invalid_reference_column (module, name, table, column)
			report_error (error)
		end

	report_parameter_not_described (module, name: STRING) is
			-- Report  missing description for parameter `name' in `module'.
		require
			module_not_void: module /= void
			name_not_void: name /= void
		local
			error : QA_VALIDITY_ERROR
		do
			create error.make_parameter_not_described (module, name)
			report_error (error)
		end

	report_parameter_already_defined (module, name, attribute_name : STRING) is
			-- Report parameter `name' in `module' has an already defined `attribute_name' attribute.
		require
			module_not_void: module /= void
			name_not_void: name /= Void
			attribute_name_not_void: name /= void
		local
			error : QA_VALIDITY_ERROR
		do
			create error.make_parameter_already_defined (module, name, attribute_name)
			report_error (error)
		end

	report_same_parameter_set_parent_name  (module, name, parent_name : STRING) is
			-- Report same parameter-set parent name `parent_name' as the parameter-set name `name' in `module'.
		require
			module_not_void: module /= void
			name_not_void: name /= Void
			parent_name_not_void: name /= void
		local
			error : QA_VALIDITY_ERROR
		do
			create error.make_parameter_set_parent_same_name (module, name, parent_name)
			report_error (error)
		end

	report_parameter_unknown (module, name : STRING) is
			-- Report parameter `name' in `module' is unknown but defined.
		require
			module_not_void: module /= Void
			name_not_void: name /= Void
		local
			error : QA_VALIDITY_ERROR
		do
			create error.make_parameter_unknown (module, name)
			report_error (error)
		end


	report_parameter_count_mismatch (module: STRING) is
			-- Report  parameter count mismatch in `module'.
		require
			module_not_void: module /= void
		local
			error : QA_VALIDITY_ERROR
		do
			create error.make_parameter_count_mismatch (module)
			report_error (error)
		end

	report_parent_class_empty (parent: STRING) is
			-- Report  warning `parent' class is empty.
		require
			parent_not_void: parent /= void
		local
			error : QA_VALIDITY_ERROR
		do
			create error.make_parent_class_empty (parent)
			report_error (error)
		end

end -- class QA_ERROR_HANDLER
