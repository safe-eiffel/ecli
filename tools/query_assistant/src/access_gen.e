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

	SHARED_CATALOG_NAME
	SHARED_SCHEMA_NAME
	
creation

	make

feature {NONE} -- Initialization

	make is
			-- generate access modules
		do
			Arguments.set_program_name ("query_assistant")
			!! error_handler.make_standard
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

--| FIXME: consider removing the filter option since parent classes for parameters
--| 	   or results could ne be properly handled

	class_filter : STRING
			-- class name to generate
			
	default_catalog : STRING
			-- default catalog for metadata queries
	
	default_schema : STRING
			-- default schema for metadata queries
	
	
feature -- Access (generation)

	error_handler: UT_ERROR_HANDLER
			-- Error handler
	
	modules : DS_HASH_TABLE [ACCESS_MODULE, STRING]

	parameter_sets: DS_HASH_TABLE[PARAMETER_SET, STRING]

	result_sets : DS_HASH_TABLE[RESULT_SET, STRING]
	
	parent_parameter_sets : DS_HASH_TABLE[PARENT_COLUMN_SET[MODULE_PARAMETER], STRING]

	parent_result_sets : DS_HASH_TABLE[PARENT_COLUMN_SET[MODULE_RESULT],STRING]

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
			error_handler.report_info_message ("** ECLI Query Assistant v1.0alpha**")
			error_handler.report_info_message ("*  Copyright (c) 2001-2003 Paul G. Crismer and others.")
			error_handler.report_info_message ("*  Released under the Eiffel Forum license version 1.%N")
		end

	process_document is
			-- process XML document
		require
			parser_ok: event_parser.is_correct
			tree_pipe_ok: not tree_pipe.error.has_error
		local
			root : XM_DOCUMENT
			access : XM_ELEMENT
			a_cursor : DS_BILINEAR_CURSOR [XM_NODE]
			l_factory : ACCESS_MODULE_FACTORY
			l_module : ACCESS_MODULE
		do
			create modules.make (10)
			create parameter_sets.make (10)
			create result_sets.make (10)
			
			from
				root := tree_pipe.document
				a_cursor := root.root_element.new_cursor
				a_cursor.start
				create l_factory.make (error_handler)
			until
				a_cursor.off
			loop
				access ?= a_cursor.item
				if access /= Void and then access.name.string.is_equal ("access") then
					l_factory.create_access_module (access)
					l_module := l_factory.last_module 
					if not l_factory.is_error and then l_module /= Void then
						modules.search (l_module.name)
						if modules.found then
							--| Error : module already exists
							error_handler.report_error_message ("! [Error] Module %'"+l_module.name+"%' already exists!%N")
						else
							modules.force (l_module, l_module.name) 
						parameter_sets.search (l_module.parameters.name)
						if parameter_sets.found then
							error_handler.report_error_message ("! [Error] Parameter set%'"+l_module.parameters.name+"%' already exists'%N" ) 
						else
							parameter_sets.force (l_module.parameters, l_module.parameters.name) 
						end
						end
					end
				end
				a_cursor.forth
			end
		ensure
			modules_exist: modules /= Void
			parameter_sets_exist: parameter_sets /= Void
			result_sets_exist: result_sets /= Void
		end
	
	parse_xml_input_file is
			-- Do the real work of parsing the XML
		require
			in_filename_not_void: in_filename /= Void
			parser_not_void: event_parser /= Void
			pipe_not_void: tree_pipe /= Void
		local
			in: KL_TEXT_INPUT_FILE
			cannot_read: UT_CANNOT_READ_FILE_ERROR
		do
			error_handler.report_info_message ("- parsing data...")
			!! in.make (in_filename)
			in.open_read
			if not in.is_open_read then
				!! cannot_read.make (in_filename)
				error_handler.report_error (cannot_read)
				has_error := True
			else
				event_parser.set_string_mode_mixed
				event_parser.parse_from_stream (in)
				in.close
				if tree_pipe.error.has_error then
					error_handler.report_error_message (tree_pipe.last_error)
					has_error := True
				else
				end
			end
			error_handler.report_info_message (". parsing done.")
		end

	process_arguments is
			-- Read command line arguments.
		local
			key : STRING
			arg_index : INTEGER
			value : STRING
			error_message : STRING
		do
			if Arguments.argument_count < 2 then
				error_handler.report_error (Usage_message)
				has_error := True
			else
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
							error_handler.report_error_message ("! [Error] : expat is not availabe, please choose other parser backend")
							has_error := True
						end
						arg_index := arg_index + 1
					elseif key.is_equal ("-eiffel") then
						!XM_EIFFEL_PARSER! event_parser.make
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
					elseif key.is_equal ("-output_dir") then
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
					else
						arg_index := arg_index + 1
						error_handler.report_error_message ("! [Error] Invalid argument name : "+key)
					end
				end
					-- Create standard pipe holder and bind it to event parser.
				create error_message.make (0)
				if not has_error then
					if event_parser /= Void then
						!! tree_pipe.make
						event_parser.set_callbacks (tree_pipe.start)
					else
						has_error := True
						error_message.append_string ("No XML parser specified.  Use option -expat or -eiffel.%N")
					end
				end
				if user = Void then
					has_error := True
					error_message.append_string ("No user name specified.  Use option -user.%N")
				end
				if password = Void then
					has_error := True
					error_message.append_string ("No password specified.  Use option -pwd.%N")
				end
				if dsn = Void then
					has_error := True
					error_message.append_string ("No data source name specified.  Use option -dsn.%N")
				end
				if in_filename = Void then
					has_error := True
					error_message.append_string ("No input filename specified.  Use option -input.%N")
				end
				if out_directory = Void then
					has_error := True
					error_message.append_string ("No output directory specified.  Use option -output_dir.%N")					
				end
				if has_error then
					error_handler.report_error_message (error_message)
					error_handler.report_error (Usage_message)
				end
			end
		ensure
			in_filename_not_void: not has_error implies in_filename /= Void
			parser_not_void: not has_error implies event_parser /= Void
			pipe_not_void: not has_error implies tree_pipe /= Void
		end

feature {NONE} -- Implementation

	Usage_message: UT_USAGE_MESSAGE is
			-- Usage message
		local
			a_message: STRING
		once
			a_message := clone ("(")
			if fact.is_expat_parser_available then
				a_message.append_string ("-expat|")
			end
			a_message.append_string ("-eiffel) -input <input-file> -output_dir <output-directory> %
			 % -dsn <data-source-name> -user <user-name> -pwd <password> -catalog <catalog> -schema <schema>")
			!! Result.make (a_message)
		ensure
			usage_message_not_void: Result /= Void
		end

	resolve_parent_classes is
			-- resolve parent classes for parameters and result sets
		do
			resolve_parent_parameter_sets
			resolve_parent_result_sets
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
	
	check_modules is
			-- check modules
		local
			cursor : DS_HASH_TABLE_CURSOR[ACCESS_MODULE,STRING]
			session : ECLI_SESSION
			l_name : STRING
		do
			from
				cursor := modules.new_cursor
				cursor.start
				create session.make (dsn, user,password)
				session.connect
			until
				not session.is_connected or else cursor.off
			loop
				l_name := cursor.item.name
				if class_filter = Void or else class_filter.is_equal (cursor.item.name) then
					error_handler.report_info_message ("- Analyzing "+cursor.item.name)
					cursor.item.check_validity (session, error_handler)
					if cursor.item.is_valid then
						error_handler.report_info_message (". OK")
						if cursor.item.has_results then
							result_sets.force (cursor.item.results, cursor.item.results.name)
						end
					else
						-- produce an error message						
					end
				end
				cursor.forth
			end
			if session.is_connected then
				session.disconnect
			else
				error_handler.report_error_message ("! Error : Datasource not connected " + session.diagnostic_message)
			end
			session.close
		end

	generate_modules is
			-- generate modules
		local
			c : DS_HASH_TABLE_CURSOR[ACCESS_MODULE,STRING]
			p : DS_HASH_TABLE_CURSOR[PARENT_COLUMN_SET[MODULE_PARAMETER], STRING]
			r : DS_HASH_TABLE_CURSOR[PARENT_COLUMN_SET[MODULE_RESULT], STRING]
		do
			error_handler.report_info_message ("- Generating classes ... ")
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
			create gen
			--| classes for parent parameters
			from
				p := parent_parameter_sets.new_cursor
				p.start
			until
				p.off
			loop
				error_handler.report_info_message (" + " + p.item.name)
				gen.create_parameters_class (p.item)
				gen.write_class (gen.parameters_class, out_directory)
				p.forth
			end
			--| classes for parent results
			from
				r := parent_result_sets.new_cursor
				r.start
			until
				r.off
			loop
				error_handler.report_info_message (" + " + r.item.name)
				gen.create_results_class (r.item)
				gen.write_class (gen.results_class, out_directory)
				r.forth
			end
		end
		
	generate (module : ACCESS_MODULE;a_error_handler : UT_ERROR_HANDLER) is
			-- generate classes for `module', query + parameter_set + result_set classes
		require
			module_not_void: module /= Void
		do
			create gen
			a_error_handler.report_info_message (" + " + module.name)
			gen.create_cursor_class (module)
			gen.write_class (gen.cursor_class,out_directory)
			a_error_handler.report_info_message (" + " + module.parameters.name)
			gen.create_parameters_class (module.parameters)
			gen.write_class (gen.parameters_class, out_directory)
			if module.has_results then
				a_error_handler.report_info_message (" + " + module.results.name)
				gen.create_results_class (module.results)
				gen.write_class (gen.results_class, out_directory)
			end
		end

	gen : ACCESS_MODULE_GENERATOR
	
invariant

	error_handler_not_void: error_handler /= Void


end -- class ACCESS_GEN
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
