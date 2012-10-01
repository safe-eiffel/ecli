note
	description: "Cursor class generators."

	library: "Access_gen : Access Modules Generators utilities"

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	RDBMS_ACCESS_GENERATOR

inherit
	ECLI_TYPE_CONSTANTS

	KL_SHARED_FILE_SYSTEM

	DT_SHARED_SYSTEM_CLOCK

	KL_IMPORTED_STRING_ROUTINES

create

	make

feature {NONE} -- Initialization

	make (an_error_handler : QA_ERROR_HANDLER; a_version : STRING; a_source_filename : STRING)
		require
			an_error_handler_not_void: an_error_handler /= Void
			a_version_attached: a_version /= Void
			a_source_filename_attached: a_source_filename /= Void
		do
			error_handler := an_error_handler
			version := a_version
			source_filename := a_source_filename
		ensure
			error_handler_set: error_handler = an_error_handler
			version_set: version = a_version
			source_filename_set: source_filename = a_source_filename
		end

feature -- Access

	version : STRING
		-- Generator Version

	source_filename : STRING
		-- Filename with the source text of a module

	error_handler : QA_ERROR_HANDLER

	cursor_class : EIFFEL_CLASS

	parameters_class : EIFFEL_CLASS

	results_class : EIFFEL_CLASS

	set_class : EIFFEL_CLASS

	access_routines_class : EIFFEL_CLASS

	all_sets : DS_HASH_TABLE[COLUMN_SET[RDBMS_ACCESS_METADATA],STRING]

feature -- Basic operations

	write_class (a_class : EIFFEL_CLASS; a_target_directory : STRING)
			-- write `a_class' as an eiffel file into `a_target_directory'
		require
			a_class_not_void: a_class /= Void
			a_target_directory_exists: a_target_directory /= Void and then File_system.directory_exists (a_target_directory)
		local
			file_name : STRING
			file : KI_TEXT_OUTPUT_FILE
		do
			file_name := as_lower (a_class.name)
			file_name.append_string (".e")
			file_name := File_system.pathname (a_target_directory,file_name)
			file := File_system.new_output_file (file_name)
			file.open_write
			if file.is_open_write then
				a_class.write (file)
				file.close
			else
				error_handler.report_cannot_write_file (file_name)
			end
		end

	create_cursor_class (module : RDBMS_ACCESS; parent_name : STRING)
			-- create class from `module' and write it into `directory_name'
		require
			module_not_void: module /= Void
		do
			create cursor_class.make (class_name (module))
			put_heading (module, parent_name)
			put_visible_features (module)
			put_invisible_features (module)
		ensure
			cursor_class_not_void: cursor_class /= Void
			cursor_class_and_module_have_same_name: cursor_class.name.is_equal (module.name)
		end

	create_parameters_class (parameter_set : PARAMETER_SET)
			-- create class from `parameter_set' and write it into `directory_name'
		require
			parameter_set_not_void: parameter_set /= Void
			parameter_set_generatable: parameter_set.is_generatable
		do
			parameters_class := virtual_row_class (parameter_set)
		ensure
			parameter_class_exists: parameters_class /= Void and then parameters_class.name.is_equal (parameter_set.name)
		end


	create_results_class (result_set : RESULT_SET)
			-- create class from `result_set' and write it into `directory_name'
		require
			result_set_not_void: result_set /= Void
			result_set_generatable: result_set.is_generatable
		do
			results_class := virtual_row_class (result_set)
		ensure
			results_class_generated: results_class /= Void and then results_class.name.is_equal (result_set.name)
		end

	create_set_class (set : COLUMN_SET[RDBMS_ACCESS_METADATA])
			-- create class from `result_set' and write it into `directory_name'
		require
			set_not_void: set /= Void
		do
			set_class := virtual_row_class (set)
		ensure
			set_class_generated: set_class /= Void and then set_class.name.is_equal (set.name)
		end

	create_access_routines_class (name_prefix : STRING; modules : DS_HASH_TABLE[RDBMS_ACCESS, STRING]; sets : like all_sets; without_prototypes : BOOLEAN)
			-- create deferred access routines helper class
		require
			prefix_not_void: name_prefix /= Void
			modules_not_void: modules /= Void
		local
			l_class_name : STRING
			cursor : DS_HASH_TABLE_CURSOR[RDBMS_ACCESS, STRING]
			basic_operations, implementation, status_report, access : EIFFEL_FEATURE_GROUP
			access_create_object_routine_names : DS_HASH_TABLE [BOOLEAN,STRING]
			routine : EIFFEL_ROUTINE
		do
			all_sets := sets
			create access_create_object_routine_names.make (modules.count)
			--| class name
			create l_class_name.make_from_string (name_prefix)
			l_class_name.append_string ("_ACCESS_ROUTINES")
			l_class_name.to_upper

			--| class object
			create access_routines_class.make (l_class_name)
			access_routines_class.set_deferred
			access_routines_class.add_parent ("PO_STATUS_USE")
			access_routines_class.add_parent ("PO_STATUS_MANAGEMENT")

			--| indexing
			put_indexing_clause (access_routines_class, "description:%"Generated access routines%"","Automatically generated.  DOT NOT MODIFY !")
			access_routines_class.add_indexing_clause ("usage: %"mix-in%"")

			--| feature groups
			create access.make ("Access")
			create status_report.make ("Status report")
			create basic_operations.make ("Basic operations")
			create implementation.make ("Implementation")
			implementation.add_export ("NONE")
			access_routines_class.add_feature_group (access)
			access_routines_class.add_feature_group (status_report)
			access_routines_class.add_feature_group (basic_operations)
			access_routines_class.add_feature_group (implementation)

			--| access
			create routine.make ("last_object")
			routine.set_type ("PO_PERSISTENT")
			access.add_feature (routine)
			create routine.make ("last_cursor")
			routine.set_type ("PO_CURSOR[like last_object]")
			access.add_feature (routine)
			--| status report
			create routine.make ("is_error")
			routine.set_type ("BOOLEAN")
			routine.set_comment ("Did last operation produce an error?")
			status_report.add_feature (routine)
			from
				cursor := modules.new_cursor
				cursor.start
			until
				cursor.off
			loop
				if cursor.item.type.is_extended and then cursor.item.is_valid and then cursor.item.has_result_set then
					if not without_prototypes then
						put_access_routine (cursor.item, basic_operations)
					end
					put_helper_access_routine (cursor.item, implementation)
					put_access_create_object (cursor.item, implementation, access_create_object_routine_names)
				end
				cursor.forth
			end
		end

feature {NONE} -- Basic operations

	virtual_row_class (column_set : COLUMN_SET[RDBMS_ACCESS_METADATA]) : EIFFEL_CLASS
			-- create virtual row class reflecting `column_set'
		require
			column_set_not_void: column_set /= Void
		local
			routine : EIFFEL_ROUTINE
			an_attribute : EIFFEL_ATTRIBUTE
			feature_group : EIFFEL_FEATURE_GROUP
			line : STRING
			i : INTEGER
			c : DS_HASH_SET_CURSOR[RDBMS_ACCESS_METADATA]
			assertion : DS_PAIR[STRING, STRING]
			assertion_tag, assertion_expression : STRING
		do
			create Result.make (column_set.name)
			put_indexing_clause (Result, "Buffer objects for database transfer.", "Automatically generated.  DOT NOT MODIFY !")
			if column_set.parent /= Void then
				create line.make_from_string (column_set.parent.name)
				line.append_string ("%N%T%Tredefine%N")
				line.append_string (  "%T%T%Tmake%N")
				line.append_string (  "%T%Tend")
				Result.add_parent (line)
			end
			--| creation
			Result.add_creation_procedure_name ("make")

			--| Initialization	
			--| 	make
			create feature_group.make ("Initialization")
			feature_group.add_export ("NONE")

			create routine.make ("make")
			routine.set_comment ("Creation of buffers")

			from
				i := 1
				if column_set.parent = Void then
					c := column_set.new_cursor
				else
					c := column_set.local_items.new_cursor
					routine.add_body_line ("Precursor")
				end
				check
					c /= Void
				end
				c.start
			until
				c.off
			loop
				create line.make_from_string ("create ")
				line.append_string (c.item.eiffel_name)
				line.append_string (".")
				line.append_string (c.item.creation_call)

				routine.add_body_line (line)

				create assertion_tag.make_from_string (c.item.eiffel_name)
				assertion_tag.append_string ("_is_null")
				create assertion_expression.make_from_string (c.item.eiffel_name)
				assertion_expression.append_string (".is_null")
				create assertion.make (assertion_tag, assertion_expression)
				if column_set.parent /= Void then
					routine.add_refined_postcondition (assertion)
				else
					routine.add_postcondition (assertion)
				end
				c.forth
			end

			feature_group.add_feature (routine)

			Result.add_feature_group (feature_group)

			--| Access
			create feature_group.make ("Access")

			from
				if column_set.parent /= Void then
					c := column_set.local_items.new_cursor
				else
					c := column_set.new_cursor
				end
				check
					c /= Void
				end
				c.start
			until
				c.off
			loop
				create an_attribute.make (c.item.eiffel_name, c.item.ecli_type)
				feature_group.add_feature (an_attribute)
				c.forth
			end

			Result.add_feature_group (feature_group)
		ensure
			Result_generated: Result /= Void and then Result.name.is_equal (column_set.name)
		end


	put_visible_features(module : RDBMS_ACCESS)
			-- put visible features of `module' into `cursor_class'
		do
			put_access (module)
			put_element_change (module)
			put_definition (module)
		end

	put_access (module : RDBMS_ACCESS)
			-- put access features of `module' into `cursor_class'
		local
			feature_group : EIFFEL_FEATURE_GROUP
			a_feature : EIFFEL_ATTRIBUTE
			parameters_class_name, results_class_name : STRING
		do
			create feature_group.make ("-- Access")

			if module.parameters.count > 0 then
	--			if module.parameters.parent_name /= Void and then
	--			   module.parameters.local_items.count = 0 then
				   	parameters_class_name := module.parameters.type
	--			else
	--				parameters_class_name := module.parameters.name
	--			end
				create a_feature.make ("parameters_object", parameters_class_name)
				feature_group.add_feature (a_feature)
			end

			if module.has_result_set then
--				if module.results.parent_name /= Void and then
--					module.results.local_items.count = 0 then
					  results_class_name := module.results.type
--				else
--					results_class_name := module.results.name
--				end
				create a_feature.make ("item", results_class_name)
				feature_group.add_feature (a_feature)
			end

			cursor_class.add_feature_group (feature_group)
		end

	put_indexing_clause (eiffel_class : EIFFEL_CLASS; description : STRING; status_message : STRING)
		require
			description_not_void: description /= Void
			status_message_not_void: status_message /= Void
		do
			if description.substring_index ("description:", 1) > 0 then
				eiffel_class.add_indexing_clause (description)
			else
				eiffel_class.add_indexing_clause ("description: %""+description+"%"")
			end
			eiffel_class.add_indexing_clause ("status: %""+status_message+"%"")
			eiffel_class.add_indexing_clause ("generated: %""+ system_clock.date_time_now.out +"%"")
			eiffel_class.add_indexing_clause ("generator_version: %""+version+"%"")
			eiffel_class.add_indexing_clause ("source_filename: %""+source_filename+"%"")
		end

	put_element_change (module : RDBMS_ACCESS)
			-- put element change  features of `module' into `cursor_class'
		local
			feature_group : EIFFEL_FEATURE_GROUP
			a_feature : EIFFEL_ROUTINE
			parameter, pre,post : DS_PAIR[STRING,STRING]
			cursor : DS_HASH_SET_CURSOR[RDBMS_ACCESS_PARAMETER]
			pname : STRING
			l_parameter : RDBMS_ACCESS_PARAMETER
			l_put_parameter_feature_call : STRING
		do
			if module.parameters.count > 0 then
				create feature_group.make ("-- Element change")

				create a_feature.make ("set_parameters_object")
				a_feature.set_comment ("set `parameters_object' to `a_parameters_object'")
				--| parameters
				create parameter.make ("a_parameters_object", module.parameters.type)
				a_feature.add_param (parameter)
				--| precondition
				create pre.make ("a_parameters_object_not_void","a_parameters_object /= Void")
				a_feature.add_precondition (pre)
				create pre.make ("has_parameters", "has_parameters")
				--| body
				a_feature.add_body_line ("parameters_object := a_parameters_object")
				--|   foreach item in parameters_object, put_parameter
				from
					cursor := module.parameters.new_cursor
					cursor.start
				until
					cursor.off
				loop
					l_parameter := cursor.item
					pname := cursor.item.name
					if l_parameter.is_input_explicit then
						l_put_parameter_feature_call := "put_input_parameter"
					elseif l_parameter.is_input then
						l_put_parameter_feature_call := "put_parameter"
					elseif l_parameter.is_output then
						l_put_parameter_feature_call := "put_output_parameter"
					else
						l_put_parameter_feature_call := "put_input_output_parameter"
					end
					a_feature.add_body_line (l_put_parameter_feature_call + " (parameters_object." + pname + ",%"" + pname + "%")")
					cursor.forth
				end
				--| bind parameters
				a_feature.add_body_line ("bind_parameters")
				--| ensure
				create post.make ("bound_parameters", "bound_parameters")
				a_feature.add_postcondition (post)

				feature_group.add_feature (a_feature)

				cursor_class.add_feature_group (feature_group)
			end
		end

	put_invisible_features (module : RDBMS_ACCESS)
			-- put invisible  features of `module' into `cursor_class'
		do
			if module.has_result_set then
				put_create_buffers (module)
			end
		end

	put_heading (module : RDBMS_ACCESS; parent_name : STRING)
			-- put indexing, class name, inheritance and creation
		local
			parent_clause : STRING
			description : STRING
		do
			if module.description /= Void then
				description := module.description
			else
				description := "Not available"
			end
			put_indexing_clause (cursor_class, description, "Cursor/Query automatically generated for '"+module.name+"'. DO NOT EDIT!")
			create parent_clause.make (100)
			if module.has_result_set then
				if parent_name /= Void then
					parent_clause.append_string (parent_name)
				else
					parent_clause.append_string (c_cursor_parent_name)
				end
			else
				if parent_name /= Void then
					parent_clause.append_string (parent_name)
				else
					parent_clause.append_string (c_query_parent_name)
				end
			end
			parent_clause.append_character ('%N')

			cursor_class.add_parent (parent_clause)

			cursor_class.add_creation_procedure_name ("make")
		end

	put_definition (module : RDBMS_ACCESS)
			-- put cursor definition  features of `module' into `cursor_class'
		local
			feature_group : EIFFEL_FEATURE_GROUP
			an_attribute : EIFFEL_ATTRIBUTE
			attribute_value : STRING
			eiffel_names : EIFFEL_NAME_ROUTINES
			sql_adjusted: STRING
		do
			create eiffel_names
			create feature_group.make ("Constants")
			create an_attribute.make ("definition", "STRING")
			sql_adjusted := module.query.twin
			STRING_.left_adjust (sql_adjusted)
			STRING_.right_adjust (sql_adjusted)
			if sql_adjusted.occurrences ('%N') = 0 then
				sql_adjusted.append_character ('%N')
			end
			create attribute_value.make_from_string (eiffel_names.verbatim_string (sql_adjusted, True, ""))
			an_attribute.set_value (attribute_value)
			feature_group.add_feature (an_attribute)
			cursor_class.add_feature_group (feature_group)
		end

	put_create_buffers (module : RDBMS_ACCESS)
			-- put `create_buffers'  features of `module' into `cursor_class'
		local
			i, count : INTEGER
			c : DS_HASH_SET_CURSOR [RDBMS_ACCESS_METADATA]
			routine : EIFFEL_ROUTINE
			feature_group : EIFFEL_FEATURE_GROUP
			line : STRING
			local_buffers : DS_PAIR[STRING,STRING]
		do

			create feature_group.make ("Implementation")
			feature_group.add_export ("NONE")

			create routine.make ("create_buffers")
			routine.set_comment ("Creation of buffers")

			create local_buffers.make ("buffers", "ARRAY[like value_anchor]")
			routine.add_local (local_buffers)
			routine.add_body_line ("create item.make")
			routine.add_body_line ("create buffers.make (1,"+module.results.count.out+")")

			from
				count := module.results.count
				c := module.results.new_cursor
				c.start
				i := 1
			until
				c.off
			loop
				create line.make_from_string("buffers.put (item.")
				line.append_string (c.item.eiffel_name)
				line.append_string (", ")
				line.append_string (module.results.rank.item (c.item.name).out)
				line.append_string (")")
				routine.add_body_line (line)
				i := i + 1
				c.forth
			end
			routine.add_body_line ("set_results (buffers)")
			feature_group.add_feature (routine)
			cursor_class.add_feature_group (feature_group)
		end

feature {NONE} -- Implementation

	c_cursor_parent_name : STRING = "ECLI_CURSOR"
	c_query_parent_name : STRING = "ECLI_QUERY"

feature {NONE} -- Implementation

	class_name (module : RDBMS_ACCESS) : STRING
		do
			Result := module.name.twin
			Result.to_upper
		end

	as_lower (s : STRING) : STRING
		require
			s_not_void: s /= Void
		do
			create Result.make_from_string (s)
			Result.to_lower
		ensure
			as_lower_not_void: Result /= Void
		end

	as_upper (s : STRING) : STRING
		require
			s_not_void: s /= Void
		do
			create Result.make_from_string (s)
			Result.to_upper
		ensure
			as_upper_not_void: Result /= Void
		end

	put_access_routine (module : RDBMS_ACCESS; group : EIFFEL_FEATURE_GROUP)
			-- put access routines for `module' into `group'
		require
			module_not_void: module /= Void
			group_not_void: group /= Void
		local
			eiffel_routine : EIFFEL_ROUTINE
			 routine_precondition : DS_PAIR [STRING, STRING]
			l_name : STRING
		do
			--| routine name: read_<access>
			create l_name.make_from_string (module.name)
			l_name.to_lower
			--| eiffel routine
			create eiffel_routine.make (l_name)
			--| routine signature : ([eiffel_signature (<parameter_set>)]) is
			put_signature_to_routine (module.parameters, eiffel_routine)
			create routine_precondition.make ("refine_in_descendants", "False")
			eiffel_routine.add_precondition (routine_precondition)
			group.add_feature (eiffel_routine)
		end

	put_helper_access_routine (module : RDBMS_ACCESS; group : EIFFEL_FEATURE_GROUP)
			-- put helper access routine for `module' into `group';
			-- the routine is named 'do_<module.name>'
		require
			module_not_void: module /= Void
			group_not_void: group /= Void
		local
			p_cursor : DS_SET_CURSOR[RDBMS_ACCESS_METADATA]
			eiffel_routine : EIFFEL_ROUTINE
			local_cursor, local_parameters, routine_precondition : DS_PAIR [STRING, STRING]
			l_name, parameter_setting_line : STRING
		do
			--| routine name: do_<access>
			create l_name.make_from_string ("do_")
			l_name.append_string (module.name)
			l_name.to_lower
			--| eiffel routine
			create eiffel_routine.make (l_name)
			eiffel_routine.set_comment ("helper implementation of access `"+module.name+"'")
			--| routine signature : (cursor : module_name; [eiffel_signature (<parameter_set>)]) is
			create local_cursor.make ("cursor", as_upper (module.name))
			eiffel_routine.add_param (local_cursor)

			put_signature_to_routine (module.parameters, eiffel_routine)

			--| precondition
			create routine_precondition.make ("cursor_not_void", "cursor /= Void")
			eiffel_routine.add_precondition (routine_precondition)
			create routine_precondition.make ("last_cursor_empty", "last_cursor /= Void and then last_cursor.is_empty")
			eiffel_routine.add_precondition (routine_precondition)

			--| locals
			if module.parameters.count > 0 then

				--	local
				--		parameters : <access_parameters>
				create local_parameters.make ("parameters",  as_upper (module.parameters.type))
				eiffel_routine.add_local (local_parameters)
			end
			--	do
			--		[fill_parameter_set (<parameter_set>, parameters)]
			if module.parameters.count > 0 then
				--		create parameters.make
				eiffel_routine.add_body_line ("create parameters.make")
				from
					p_cursor := module.parameters.new_cursor
					p_cursor.start
				until
					p_cursor.off
				loop
					create parameter_setting_line.make_from_string ("parameters.")
					parameter_setting_line.append_string (p_cursor.item.eiffel_name)
					parameter_setting_line.append_string (".set_item (")
					parameter_setting_line.append_string (p_cursor.item.eiffel_name)
					parameter_setting_line.append_string (")")
					eiffel_routine.add_body_line (parameter_setting_line)
					p_cursor.forth
				end
				--		cursor.set_parameters_object (parameters)
				eiffel_routine.add_body_line ("cursor.set_parameters_object (parameters)")
			end
			check
--				results_in_sets: all_sets.has_item (module.results)
				results_flattened: module.results.is_flattened
			end
			eiffel_routine.add_body_line ("from")
			eiffel_routine.add_body_line ("%Tcursor.start")
			eiffel_routine.add_body_line ("%Tstatus.reset")
			eiffel_routine.add_body_line ("until")
			eiffel_routine.add_body_line ("%Tstatus.is_error or else not cursor.is_ok or else cursor.off")
			eiffel_routine.add_body_line ("loop")
			eiffel_routine.add_body_line ("%Textend_cursor_from_"+as_lower (module.results.final_set_name)+" (cursor.item)")
			eiffel_routine.add_body_line ("%Tcursor.forth")
			eiffel_routine.add_body_line ("end")
			eiffel_routine.add_body_line ("if cursor.is_error then")
			eiffel_routine.add_body_line ("%Tstatus.set_datastore_error (cursor.native_code, cursor.diagnostic_message)")
			eiffel_routine.add_body_line ("elseif cursor.is_ok and cursor.has_information_message then")
			eiffel_routine.add_body_line ("%Tstatus.set_datastore_warning (cursor.native_code, cursor.diagnostic_message)")
			eiffel_routine.add_body_line ("end")
			group.add_feature (eiffel_routine)
		end

	put_access_create_object (module : RDBMS_ACCESS; group : EIFFEL_FEATURE_GROUP; access_create_object_routine_names : DS_HASH_TABLE[BOOLEAN,STRING])
			-- put `create_object_from_<module.results>' into `group'
		require
			module_not_void: module /= Void
			group_not_void: group /= Void
			access_create_object_routine_names_not_void: access_create_object_routine_names /= Void
		local
			routine_name : STRING
			routine_parameter, routine_precondition, routine_postcondition : DS_PAIR [STRING,STRING]
			eiffel_routine : EIFFEL_ROUTINE
		do
			--extend_cursor_from_<access_results> (row : <access_results>) is
			--	deferred
			--	end
			create routine_name.make_from_string ("extend_cursor_from_")
			routine_name.append_string (as_lower (module.results.final_set_name))

			if not access_create_object_routine_names.has (routine_name) then
				create eiffel_routine.make (routine_name)
				create routine_parameter.make ("row", as_upper (module.results.final_set_name))
				eiffel_routine.add_param (routine_parameter)
				create routine_precondition.make ("row_not_void", "row /= Void")
				eiffel_routine.add_precondition (routine_precondition)
				create routine_precondition.make ("last_cursor_not_void", "last_cursor /= Void")
				eiffel_routine.add_precondition (routine_precondition)
				create routine_postcondition.make ("last_cursor_extended", "not is_error implies (last_cursor.count = old (last_cursor.count) + 1)")
				eiffel_routine.add_postcondition (routine_postcondition)
				group.add_feature (eiffel_routine)
				access_create_object_routine_names.force (True, routine_name)
			end
		end

	put_signature_to_routine (set : COLUMN_SET[RDBMS_ACCESS_METADATA]; eiffel_routine : EIFFEL_ROUTINE)
			-- put signature representing `set' to `eiffel_routine'.
		local
			p_cursor : DS_SET_CURSOR[RDBMS_ACCESS_METADATA]
			new_parameter : DS_PAIR[STRING,STRING]
		do
			from
				p_cursor := set.new_cursor
				p_cursor.start
			until
				p_cursor.off
			loop
				create new_parameter.make (p_cursor.item.eiffel_name, p_cursor.item.value_type)
				eiffel_routine.add_param (new_parameter)
				p_cursor.forth
			end
		end

invariant
	invariant_clause: -- Your invariant here

end -- class ACCESS_MODULE_GENERATOR
--
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
