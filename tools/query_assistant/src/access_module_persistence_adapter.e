indexing
	description: "Adapters for Access modules."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCESS_MODULE_PERSISTENCE_ADAPTER

inherit
	ACCESS_MODULE_XML_CONSTANTS

create
	make

feature {} -- Initialization

	make (an_error_handler : QA_ERROR_HANDLER) is
			-- Make adapter using `an_error_handler'.
		require
			an_error_handler_not_void: an_error_handler /= Void
		do
			error_handler := an_error_handler
			create_event_parser
		ensure
			error_handler_set: error_handler = an_error_handler
		end

feature -- Access

	last_object: ACCESS_MODULE
			-- last object created.

	error_handler : QA_ERROR_HANDLER
			-- Error handler.

feature -- Measurement

feature -- Status Report

	has_error : BOOLEAN
			-- Has last operation caused an error?

feature -- Status setting

feature -- Basic operations

	read_from_file (a_file_name : STRING) is
			-- read access_module from `a_file_name'
		require
			a_file_name_not_void: a_file_name /= Void
		local
			in: KL_TEXT_INPUT_FILE
		do
			has_error := False
			error_handler.report_start (s_parsing_xml_file)
			create in.make (a_file_name)
			in.open_read
			if not in.is_open_read then
				error_handler.report_cannot_read_file (a_file_name)
				has_error := True
			else
				event_parser.set_string_mode_mixed
				event_parser.parse_from_stream (in)
				in.close
				if tree_pipe.error.has_error then
					error_handler.report_parse_error (tree_pipe.last_error)
					has_error := True
				else
					process_document
					create last_object.make_from_tables (modules, parameter_sets, result_sets, parameter_map)
				end
			end
			error_handler.report_end (s_parsing_xml_file, not has_error)

		end

	write_to_file (module : ACCESS_MODULE; a_file_name : STRING) is
			-- write `module' to file with name `a_file_name'.
		require
			a_file_name_not_void: a_file_name /= Void
		local
			file : KL_TEXT_OUTPUT_FILE
			filter : XM_INDENT_PRETTY_PRINT_FILTER
			processor : XM_TREE_TO_EVENTS
		do
			has_error := False
			create file.make (a_file_name)
			file.open_write
			if file.is_open_write then
				create filter.make_null
				filter.set_output_stream (file)
				filter.set_indent (filter.default_indent)
				put_document (module)
				create processor.make (filter)
				last_document.process (processor)
				file.close
			else
				error_handler.report_cannot_write_file (a_file_name)
			end
		end

feature {NONE} -- Implementation - Access


	tree_pipe: XM_TREE_CALLBACKS_PIPE
			-- Tree generating callbacks

	last_document : XM_DOCUMENT
			-- Last XML document

	event_parser : XM_EIFFEL_PARSER

	modules : DS_HASH_TABLE [RDBMS_ACCESS, STRING]

	parameter_sets: DS_HASH_TABLE[PARAMETER_SET, STRING]

	result_sets : DS_HASH_TABLE[RESULT_SET, STRING]

	parameter_map : PARAMETER_MAP


feature {NONE} -- Implementation - Constants

	s_parsing_xml_file: STRING = "Parsing XML file"

feature {NONE} -- Implementation - Operations


	create_event_parser is
			-- Create event parser.
		do
			create {XM_EIFFEL_PARSER} event_parser.make
			create tree_pipe.make
			event_parser.set_callbacks (tree_pipe.start)
		end

	process_document is
			-- Process XML document.
		require
			parser_ok: event_parser.is_correct
			tree_pipe_ok: not tree_pipe.error.has_error
		local
			root : XM_DOCUMENT
			element : XM_ELEMENT
			a_cursor : DS_BILINEAR_CURSOR [XM_NODE]
			l_factory : RDBMS_ACCESS_FACTORY
			l_module : RDBMS_ACCESS
			l_result_sets : like result_sets
			parameters_ok, results_ok : BOOLEAN
		do
			create modules.make (10)
			create parameter_sets.make (10)
			create l_result_sets.make (10)
			from
				root := tree_pipe.document
				a_cursor := root.root_element.new_cursor
				a_cursor.start
				create l_factory.make (error_handler)
			until
				a_cursor.off
			loop
				element ?= a_cursor.item
				if element /= Void then
					if element.name.string.is_equal (t_access) then
						l_factory.create_access_module (element)
						l_module := l_factory.last_access
						if not l_factory.is_error and then l_module /= Void then
							modules.search (l_module.name)
							if modules.found then
								--| Error : module already exists
								error_handler.report_already_exists (l_module.name, l_module.name, "Module")
							else
								parameters_ok := True
								results_ok := True
								parameter_sets.search (l_module.parameters.name)
								if parameter_sets.found then
									error_handler.report_already_exists (l_module.name, l_module.parameters.name, "Parameter set")
									parameters_ok := False
								end
								if l_module.results /= Void then
									l_result_sets.search (l_module.results.name)
									if l_result_sets.found  then
										error_handler.report_already_exists (l_module.name, l_module.results.name, "Result set")
										results_ok := False
									end
								end
								if parameters_ok and results_ok then
									modules.force (l_module, l_module.name)
									parameter_sets.force (l_module.parameters, l_module.parameters.name)
									if l_module.results /= Void then
										l_result_sets.force (l_module.results, l_module.results.name)
									end
								else
									error_handler.report_rejected (l_module.name)
								end
							end
						end
					elseif element.name.string.is_equal (t_parameter_map) then
						l_factory.create_parameter_map (element)
						if l_factory.parameter_map /= Void then
							parameter_map := l_factory.parameter_map
						end
					end
				end
				a_cursor.forth
			end
			create result_sets.make (10)
		ensure
			modules_not_void: modules /= Void
			parameter_sets_not_void: parameter_sets /= Void
			result_sets_not_void: result_sets /= Void
			result_sets_empty: result_sets.is_empty
		end

	put_document (module : ACCESS_MODULE) is
			-- Put `module' to last_document
		require
			module_not_void: module /= Void
		local
			processing : XM_PROCESSING_INSTRUCTION
			emodule : XM_ELEMENT
		do
			create last_document.make_with_root_named (t_modules, ns_empty)
			create processing.make (last_document, "xml", "version=%"1.0%" encoding=%"iso-8859-1%"")
			last_document.put_first (processing)
			create emodule.make_root (last_document, t_modules, ns_empty)
			if module.parameter_map /= Void then
				put_parameter_map (emodule, module.parameter_map)
			end
			module.accesses.do_all (agent put_access (emodule, ?))
		ensure
			last_document_created: last_document /= old last_document
		end

	put_parameter_map (parent : XM_ELEMENT; map : PARAMETER_MAP) is
		local
			element : XM_ELEMENT
		do
			create element.make_last (parent, t_parameter_map, ns_empty)
			map.do_all (agent put_parameter (element, ?))
		end

	put_parameter (parent : XM_ELEMENT; parameter : RDBMS_ACCESS_PARAMETER) is
		local
			element : XM_ELEMENT
		do
			create element.make_last (parent, t_parameter, ns_empty)
			element.add_attribute (t_name, ns_empty, parameter.name)
			element.add_attribute (t_table, ns_empty, parameter.reference_column.table)
			element.add_attribute (t_column, ns_empty, parameter.reference_column.column)
			if parameter.sample /= Void then
				element.add_attribute (t_sample, ns_empty, parameter.sample)
			end
			if parameter.is_input_explicit then
				element.add_attribute (t_direction, ns_empty, v_input)
			elseif parameter.is_output then
				element.add_attribute (t_direction, ns_empty, v_output)
			elseif parameter.is_input_output then
				element.add_attribute (t_direction, ns_empty, v_input_output)
			end
		end

	put_parameter_set (parent : XM_ELEMENT; parameter_set : PARAMETER_SET) is
		local
			element : XM_ELEMENT
		do
			create element.make_last (parent,t_parameter_set, ns_empty)
			element.add_attribute (t_name, ns_empty, parameter_set.name)
			if parameter_set.parent_name /= Void then
				element.add_attribute (t_extends, ns_empty, parameter_set.parent_name)
			end
			parameter_set.do_all (agent put_parameter (element, ?))
		end

	put_result_set (parent : XM_ELEMENT; result_set : RESULT_SET) is
		local
			element : XM_ELEMENT
		do
			create element.make_last (parent,t_result_set, ns_empty)
			element.add_attribute (t_name, ns_empty, result_set.name)
			if result_set.parent_name /= Void then
				element.add_attribute (t_extends, ns_empty, result_set.parent_name)
			end
		end

	put_access (parent : XM_ELEMENT; access : RDBMS_ACCESS) is
		local
			element, description, sql : XM_ELEMENT
			cdata : XM_CHARACTER_DATA
		do
			create element.make_last (parent,t_access, ns_empty)
			element.add_attribute (t_name, ns_empty, access.name)
			element.add_attribute (t_type, ns_empty, access.type.to_string)
			if access.description /= Void then
				create description.make_last (element, t_description, ns_empty)
				create cdata.make_last (description, access.description)
			end
			create sql.make_last (element, t_sql, ns_empty)
			create cdata.make_last (sql, access.query)
			put_parameter_set (element, access.parameters)
			if access.results /= Void then
				put_result_set (element, access.results)
			end
		end

	ns_empty : XM_NAMESPACE
			-- Empty namespace
		once
			create Result.make_default
		end

invariant

	error_handler_not_void: error_handler /= Void

end
