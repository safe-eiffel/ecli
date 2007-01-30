indexing
	description	: "Access Modules generators"

	library: "Access_gen : Access Modules Generators utilities"

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"


class
	ACCESS_GEN

inherit

	KL_SHARED_ARGUMENTS
	KL_SHARED_STANDARD_FILES
	KL_SHARED_FILE_SYSTEM

	SHARED_CATALOG_NAME
	SHARED_SCHEMA_NAME
	SHARED_COLUMNS_REPOSITORY
	SHARED_MAXIMUM_LENGTH
	SHARED_USE_DECIMAL

	ACCESS_MODULE_XML_CONSTANTS

creation

	make

feature {NONE} -- Initialization

	make is
			-- generate access modules
		local
			t : ECLI_TYPE_CATALOG
		do
			Arguments.set_program_name ("query_assistant")
			create error_handler.make_standard
			print_prologue
			process_arguments
			if not has_error then
				if default_catalog /= Void then
					set_shared_catalog_name (default_catalog)
				end
				if default_schema /= Void then
					set_shared_schema_name (default_schema)
				end
				parse_xml_input_file
				if not has_error then
					process_document
					check_modules
					resolve_parent_classes
					generate_modules
				end
			end
		end

feature -- Access

	access_routines_prefix: STRING
			-- prefix for naming the access_routines class

feature -- Element change

	set_access_routines_prefix (a_access_routines_prefix: STRING) is
			-- Set `access_routines_prefix' to `a_access_routines_prefix'.
		do
			access_routines_prefix := a_access_routines_prefix
		ensure
			access_routines_prefix_assigned: access_routines_prefix = a_access_routines_prefix
		end

feature -- Access (Command line arguments)

	in_filename: STRING
			-- Name of the input file

	out_directory: STRING
			-- Name of the output file (see use_std_out)

	dsn : STRING
			-- data source name

	user : STRING
			-- user name

	password : STRING
			-- password

	class_filter : STRING
			-- class name to generate

	default_catalog : STRING
			-- default catalog for metadata queries

	default_schema : STRING
			-- default schema for metadata queries

	maximum_length_string : STRING
			-- maximum length for long data without length limit

	default_parent_cursor : STRING
			-- default parent class name for cursors.

	default_parent_modify : STRING
			-- default parent class name for modifiers.

feature -- Status report

	is_verbose : BOOLEAN

	no_prototypes : BOOLEAN
		-- Does Current not generate function prototypes in class skeletons?

feature -- Constants

	reasonable_maximum_length : INTEGER is 1_000_000

feature -- Access (generation)

	error_handler: QA_ERROR_HANDLER
			-- Error handler

	modules : DS_HASH_TABLE [ACCESS_MODULE, STRING]

	parameter_sets: DS_HASH_TABLE[PARAMETER_SET, STRING]

	result_sets : DS_HASH_TABLE[RESULT_SET, STRING]

	parent_parameter_sets : DS_HASH_TABLE[PARENT_COLUMN_SET[MODULE_PARAMETER], STRING]

	parent_result_sets : DS_HASH_TABLE[PARENT_COLUMN_SET[MODULE_RESULT],STRING]

	all_parents_set : DS_HASH_TABLE[PARENT_COLUMN_SET[ACCESS_MODULE_METADATA], STRING]

	all_sets : DS_HASH_TABLE[COLUMN_SET[ACCESS_MODULE_METADATA],STRING]

feature -- Status report

	has_error: BOOLEAN
			-- has an error occurred during processing?

feature -- Parser

	fact: XM_EXPAT_PARSER_FACTORY is
			-- Expat XML parser factory
		once
			!! Result
		ensure
			factory_not_void: Result /= Void
		end

	event_parser: XM_PARSER
			-- XML parser

	tree_pipe: XM_TREE_CALLBACKS_PIPE
			-- Tree generating callbacks

feature -- Basic operations

	print_prologue is
			-- print application prologue
		do
			error_handler.report_banner ("v1.0rc7")
			error_handler.report_copyright ("Paul G. Crismer and others", "2001-2006")
			error_handler.report_license ("Eiffel Forum", "2.0")
		end

	process_document is
			-- process XML document
		require
			parser_ok: event_parser.is_correct
			tree_pipe_ok: not tree_pipe.error.has_error
		local
			root : XM_DOCUMENT
			element : XM_ELEMENT
			a_cursor : DS_BILINEAR_CURSOR [XM_NODE]
			l_factory : ACCESS_MODULE_FACTORY
			l_module : ACCESS_MODULE
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
						l_module := l_factory.last_module
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

	parse_xml_input_file is
			-- Do the real work of parsing the XML
		require
			in_filename_not_void: in_filename /= Void
			parser_not_void: event_parser /= Void
			pipe_not_void: tree_pipe /= Void
		local
			in: KL_TEXT_INPUT_FILE
		do
			has_error := False
			error_handler.report_start ("Parsing XML file")
			!! in.make (in_filename)
			in.open_read
			if not in.is_open_read then
				error_handler.report_cannot_read_file (in_filename)
				has_error := True
			else
				event_parser.set_string_mode_mixed
				event_parser.parse_from_stream (in)
				in.close
				if tree_pipe.error.has_error then
					error_handler.report_parse_error (tree_pipe.last_error)
					has_error := True
				else
				end
			end
			error_handler.report_end ("Parsing XML file", not has_error)
		end

	process_arguments is
			-- Read and check command line arguments.
		do
			parse_arguments
			verify_arguments
		ensure
			in_filename_not_void: not has_error implies in_filename /= Void
			parser_not_void: not has_error implies event_parser /= Void
			pipe_not_void: not has_error implies tree_pipe /= Void
		end

	parse_arguments is
			-- Parse command line arguments.
		local
			key : STRING
			arg_index : INTEGER
			value : STRING
		do
			from
				arg_index := 1
			until
				arg_index > Arguments.argument_count
			loop
				key := Arguments.argument (arg_index)
				if arg_index + 1 <= Arguments.argument_count then
					value := clone (Arguments.argument (arg_index + 1))
				else
					value := Void
				end
				if key.is_equal ("-input") then
					in_filename := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-expat") then
					if fact.is_expat_parser_available then
						event_parser := fact.new_expat_parser
					else
						error_handler.report_xml_parser_unavailable ("EXPAT")
						has_error := True
					end
					arg_index := arg_index + 1
				elseif key.is_equal ("-eiffel") then
					create {XM_EIFFEL_PARSER} event_parser.make
					arg_index := arg_index + 1
				elseif key.is_equal ("-verbose") then
					is_verbose := True
					arg_index := arg_index + 1
				elseif key.is_equal ("-dsn") then
					dsn := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-user") then
					user := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-pwd") then
					password := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-output_dir") or else key.is_equal ("-output") then
					out_directory := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-class") then
					class_filter := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-schema") then
					default_schema := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-catalog") then
					default_catalog := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-access_routines_prefix") then
					access_routines_prefix := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-parent_cursor") then
					default_parent_cursor := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-parent_modify") then
					default_parent_modify := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-max_length") then
					maximum_length_string := value
					arg_index := arg_index + 2
				elseif key.is_equal ("-use_decimal") then
					set_use_decimal (True)
					arg_index := arg_index + 1
				elseif key.is_equal ("-no_prototypes") or else key.is_equal ("-no_prototype") then
					no_prototypes := True
					arg_index := arg_index + 1
				else
					arg_index := arg_index + 1
					error_handler.report_invalid_argument (key, "name unknown")
				end
			end
		end

	verify_arguments is
			-- Verify parsed arguments.
		local
			error_message : STRING
		do
			-- Create standard pipe holder and bind it to event parser.
			create error_message.make (0)
			if not has_error then
				if event_parser = Void then
					create {XM_EIFFEL_PARSER} event_parser.make
					error_handler.report_default_argument ("-eiffel|-expat", "Eiffel XML parser")
				end
				if event_parser /= Void then
					create tree_pipe.make
					event_parser.set_callbacks (tree_pipe.start)
				else
					has_error := True
					error_handler.report_missing_argument ("-eiffel' or '-expat'", "An XML parser must be specified")
				end
			end
			if user = Void then
				has_error := True
				error_handler.report_missing_argument ("-user", "a user name must be specified")
			end
			if password = Void then
				has_error := True
				error_handler.report_missing_argument ("-pwd", "a password must be specified")
			end
			if dsn = Void then
				has_error := True
				error_handler.report_missing_argument ("-dsn", "a data source name must be specified")
			end
			if in_filename = Void then
				has_error := True
				error_handler.report_missing_argument ("-input", "an input file name must be specified")
			elseif not File_system.file_exists (in_filename) then
				has_error := True
				error_handler.report_invalid_argument ("-input", "file '"+in_filename+"' does not exist")
			end
			if out_directory = Void then
				has_error := True
				error_handler.report_missing_argument ("-output", "an output directory must be specified")
			elseif not File_system.directory_exists (out_directory) then
				has_error := True
				error_handler.report_invalid_argument ("-output", "directory '"+out_directory+"' does not exist")

			end
			if dsn /= Void and then user /= Void and then password /= Void then
				create session.make (dsn, user,password)
					session.connect
					if session.is_connected then
						create repository.make (session)
						set_shared_columns_repository (repository)
					else
						error_handler.report_database_connection_failed (dsn)
						has_error := True
					end
			end
			if maximum_length_string /= Void then
				if not maximum_length_string.is_double or else maximum_length_string.to_double <= 0 then
					has_error := True
					error_handler.report_invalid_argument ("-maximum_length", "must be a strictly positive integer")
				else
					if maximum_length_string.to_double > reasonable_maximum_length then
						has_error := True
						error_handler.report_invalid_argument ("-maximum_length","Maximum length is not reasonable, the value provided is greater than "+reasonable_maximum_length.out)
					else
						set_maximum_length (maximum_length_string.to_integer)
					end
				end
			end
			if has_error then
				error_handler.report_usage (Fact.is_expat_parser_available)
			end
			if not is_verbose then
				error_handler.disable_verbose
			end
		end

feature {NONE} -- Implementation


	resolve_parent_classes is
			-- resolve parent classes for parameters and result sets
		do
--			resolve_parent_parameter_sets
--			resolve_parent_result_sets
			resolve_all_sets
		end

	resolve_parent_parameter_sets is
			-- resolve parent classes for parameter sets
		local
			resolver : REFERENCE_RESOLVER[MODULE_PARAMETER]
		do
			create resolver
			parent_parameter_sets := resolver.resolve_parents (parameter_sets, error_handler)
			resolver.resolve_descendants (parameter_sets)
		end

	resolve_parent_result_sets is
			-- resolve parent classes for parameter sets
		local
			resolver : REFERENCE_RESOLVER[MODULE_RESULT]
		do
			create resolver
			parent_result_sets := resolver.resolve_parents (result_sets, error_handler)
			resolver.resolve_descendants (result_sets)
		end

	resolve_all_sets is
			--
		local
			resolver : REFERENCE_RESOLVER[ACCESS_MODULE_METADATA]
			cursor : DS_HASH_TABLE_CURSOR[COLUMN_SET[ACCESS_MODULE_METADATA], STRING]
		do
			create all_sets.make (result_sets.count + parameter_sets.count)
			from
				cursor := result_sets.new_cursor
				cursor.start
			until
				cursor.off
			loop
				all_sets.force (cursor.item, cursor.key)
				cursor.forth
			end
			from
				cursor := parameter_sets.new_cursor
				cursor.start
			until
				cursor.off
			loop
				all_sets.force (cursor.item, cursor.key)
				cursor.forth
			end
			create resolver
			all_parents_set := resolver.resolve_parents (all_sets, error_handler)
			resolver.resolve_descendants (all_sets)
		end


	check_modules is
			-- check modules
		local
			cursor : DS_HASH_TABLE_CURSOR[ACCESS_MODULE,STRING]
			l_name : STRING
		do
			from
				cursor := modules.new_cursor
				cursor.start
			until
				cursor.off
			loop
				l_name := cursor.item.name
				if class_filter = Void or else class_filter.is_equal (cursor.item.name) then
					error_handler.report_start ("Analyzing "+cursor.item.name)
					cursor.item.check_validity (session, error_handler, Reasonable_maximum_length)
					if cursor.item.is_valid then
						error_handler.report_end ("Analyzing "+cursor.item.name,True)
						if cursor.item.has_result_set then
							result_sets.force (cursor.item.results, cursor.item.results.name)
						else
--							error_handler.report_rejected (cursor.item.name)
							do_nothing
						end
					else
						error_handler.report_end ("Analyzing "+cursor.item.name,False)
						--| report error
					end
				end
				cursor.forth
			end
			if session.is_connected then
				session.disconnect
			else
--				error_handler.report_d ("! Error : Datasource not connected " + session.diagnostic_message)
--				Must we do something here ?
			end
			session.close
		end

	generate_modules is
			-- generate modules
		local
			c : DS_HASH_TABLE_CURSOR[ACCESS_MODULE,STRING]
			p : DS_HASH_TABLE_CURSOR[PARENT_COLUMN_SET[MODULE_PARAMETER], STRING]
			r : DS_HASH_TABLE_CURSOR[PARENT_COLUMN_SET[MODULE_RESULT], STRING]
			s : DS_HASH_TABLE_CURSOR[PARENT_COLUMN_SET[ACCESS_MODULE_METADATA], STRING]
		do
			error_handler.report_start ("Class generation")
			--| classes for modules
			from
				c := modules.new_cursor
				c.start
			until
				c.off
			loop
				if c.item.is_valid then
					generate (c.item, error_handler)
				end
				c.forth
			end
			create gen.make (error_handler)
			--| classes for parent results
			from
				s := all_parents_set.new_cursor
				s.start
			until
				s.off
			loop
				error_handler.report_start ("Generating " + s.item.name)
				gen.create_set_class (s.item)
				gen.write_class (gen.set_class, out_directory)
				s.forth
			end
			if access_routines_prefix /= Void then
				--| generate access routines
				gen.create_access_routines_class (access_routines_prefix, modules, all_sets, no_prototypes)
				gen.write_class (gen.access_routines_class, out_directory)
			end
			--| FIXME : report if class generation has produced an error
			error_handler.report_end ("Class generation", True)
		end

	generate (module : ACCESS_MODULE;a_error_handler : QA_ERROR_HANDLER) is
			-- generate classes for `module', query + parameter_set + result_set classes
		require
			module_not_void: module /= Void
		local
			parent_class : STRING
		do
			create gen.make (a_error_handler)
			a_error_handler.report_generating (module.name)
			if module.has_result_set then
				parent_class := default_parent_cursor
			else
				parent_class := default_parent_modify
			end
			gen.create_cursor_class (module, parent_class)
			gen.write_class (gen.cursor_class,out_directory)
			if module.parameters.parent_name = Void or else module.parameters.local_items.count > 0 then
				if module.parameters.count > 0 then
					a_error_handler.report_generating (module.parameters.name)
					gen.create_parameters_class (module.parameters)
					gen.write_class (gen.parameters_class, out_directory)
				end
			end
			if module.has_result_set then
				if module.results.parent_name = Void or else module.results.local_items.count > 0 then
					a_error_handler.report_generating (module.results.name)
					gen.create_results_class (module.results)
					gen.write_class (gen.results_class, out_directory)
				end
			end
		end

	gen : ACCESS_MODULE_GENERATOR

	session : ECLI_SESSION
	repository : COLUMNS_REPOSITORY

invariant

	error_handler_not_void: error_handler /= Void


end -- class ACCESS_GEN
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
