indexing
	description: "Cursor class generators"

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ACCESS_MODULE_GENERATOR

inherit
	ECLI_TYPE_CONSTANTS

	KL_SHARED_FILE_SYSTEM
	
feature -- Access

	cursor_class : EIFFEL_CLASS
	
	parameters_class : EIFFEL_CLASS
	
	results_class : EIFFEL_CLASS

feature -- Basic operations

	write_class (a_class : EIFFEL_CLASS; a_target_directory : STRING) is
			-- write `a_class' as an eiffel file into `a_target_directory'
		require
			a_class_exists: a_class /= Void
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
			a_class.write (file)
			file.close
		end
		
	create_cursor_class (module : ACCESS_MODULE) is 
			-- create class from `module' and write it into `directory_name'
		require
			module_exists: module /= Void
		do
			create cursor_class.make (class_name (module))
			put_heading (module)
			put_visible_features (module)
			put_invisible_features (module)
		ensure
			cursor_class_exists: cursor_class /= Void and then cursor_class.name.is_equal (module.name)
		end

	create_parameters_class (parameter_set : COLUMN_SET[MODULE_PARAMETER]) is
			-- create class from `parameter_set' and write it into `directory_name'
		require
			parameter_set_exists: parameter_set /= Void
		do
			parameters_class := virtual_row_class (parameter_set)
		ensure
			parameter_class_exists: parameters_class /= Void and then parameters_class.name.is_equal (parameter_set.name)
		end
		

	create_results_class (result_set : COLUMN_SET[MODULE_RESULT]) is 
			-- create class from `result_set' and write it into `directory_name'
		require
			result_set_exists: result_set /= Void
		do
			results_class := virtual_row_class (result_set)
		ensure
			results_class_generated: results_class /= Void and then results_class.name.is_equal (result_set.name)
		end

feature {NONE} -- Basic operations

	virtual_row_class (column_set : COLUMN_SET[ACCESS_MODULE_METADATA]) : EIFFEL_CLASS is
			-- create virtual row class reflecting `column_set'
		require
			column_set_exists: column_set /= Void
		local
			routine : EIFFEL_ROUTINE
			attribute : EIFFEL_ATTRIBUTE
			feature_group : EIFFEL_FEATURE_GROUP
			line : STRING
			i : INTEGER
			c : DS_HASH_SET_CURSOR[ACCESS_MODULE_METADATA]
		do
			create Result.make (column_set.name)
			Result.add_indexing_clause ("description: %"Results objects %"")
			Result.add_indexing_clause ("status: %"Automatically generated.  DOT NOT MODIFY !%"")
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
			routine.set_comment ("-- Creation of buffers")
			
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
				create attribute.make (c.item.eiffel_name, c.item.ecli_type)
				feature_group.add_feature (attribute)
				c.forth
			end

			Result.add_feature_group (feature_group)
		ensure
			Result_generated: Result /= Void and then Result.name.is_equal (column_set.name)
		end

		
	put_visible_features(module : ACCESS_MODULE) is
			-- put visible features of `module' into `cursor_class'
		do
			put_access (module)
			put_element_change (module)
			put_definition (module)
		end

	put_access (module : ACCESS_MODULE) is
			-- put access features of `module' into `cursor_class'
		local
			feature_group : EIFFEL_FEATURE_GROUP
			a_feature : EIFFEL_ATTRIBUTE
		do
			create feature_group.make ("-- Access")
			
			create a_feature.make ("parameters_object", module.parameters.name)
			feature_group.add_feature (a_feature)
			
			if module.has_results then
				create a_feature.make ("item", module.results.name)
				feature_group.add_feature (a_feature)
			end			
			
			cursor_class.add_feature_group (feature_group) 
		end

	put_element_change (module : ACCESS_MODULE) is
			-- put element change  features of `module' into `cursor_class'
		local
			feature_group : EIFFEL_FEATURE_GROUP
			a_feature : EIFFEL_ROUTINE
			parameter, pre,post : DS_PAIR[STRING,STRING]
			cursor : DS_HASH_SET_CURSOR[MODULE_PARAMETER]
			pname : STRING
		do
			create feature_group.make ("-- Element change")
			
			create a_feature.make ("set_parameters_object")
			create parameter.make ("a_parameters_object", module.parameters.name)
			a_feature.set_comment ("set `parameters_object' to `a_parameters_object'")
			--| parameters
			create parameter.make ("a_parameters_object", module.parameters.name)
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
				pname := cursor.item.name				
				a_feature.add_body_line ("put_parameter (parameters_object." + pname + ",%"" + pname + "%")")
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

	put_invisible_features (module : ACCESS_MODULE) is
			-- put invisible  features of `module' into `cursor_class'
		do
			if module.has_results then
				put_create_buffers (module)
			end
		end
				
	put_heading (module : ACCESS_MODULE) is
			-- put indexing, class name, inheritance and creation
		local
			parent_clause : STRING
		do
			if module.description /= Void then
				cursor_class.add_indexing_clause (module.description)				
			end
			cursor_class.add_indexing_clause ("warning: %"Generated cursor '" +module.name +"' : DO NOT EDIT !%"")
			cursor_class.add_indexing_clause ("author: %"QUERY_ASSISTANT%"")
			cursor_class.add_indexing_clause ("date: %"$Date : $%"")
			cursor_class.add_indexing_clause ("revision: %"$Revision : $%"")
			cursor_class.add_indexing_clause ("licensing: %"See notice at end of class%"")

			create parent_clause.make (100)
			if module.has_results then
				parent_clause.append_string ("ECLI_CURSOR%N")
			else
				parent_clause.append_string ("ECLI_QUERY%N")
			end
			cursor_class.add_parent (parent_clause)
			
			cursor_class.add_creation_procedure_name ("make")
		end
		
	put_definition (module : ACCESS_MODULE) is
			-- put cursor definition  features of `module' into `cursor_class'
		local
			feature_group : EIFFEL_FEATURE_GROUP
			attribute : EIFFEL_ATTRIBUTE
			attribute_value : STRING
		do
			create feature_group.make ("Constants")
			create attribute.make ("definition", "STRING")
			if not module.query.has ('%N') then
				attribute.set_value ("%""+module.query+"%"")
			else
				create attribute_value.make_from_string ("%"[")
				if module.query.item(1) /= '%N' then
					attribute_value.append_character ('%N')
				end
				attribute_value.append_string (module.query)
				if module.query.item (module.query.count) /= '%N' then
					attribute_value.append_character ('%N')
				end
				attribute_value.append_string ("]%"")
				attribute.set_value (attribute_value)
			end
			
			feature_group.add_feature (attribute)
			cursor_class.add_feature_group (feature_group)
		end

	put_create_buffers (module : ACCESS_MODULE) is
			-- put `create_buffers'  features of `module' into `cursor_class'
		local
			i, count : INTEGER
			c : DS_HASH_SET_CURSOR [MODULE_RESULT]
			routine : EIFFEL_ROUTINE
			feature_group : EIFFEL_FEATURE_GROUP
			line : STRING
		do
			
			create feature_group.make ("Implementation")
			feature_group.add_export ("NONE")
			
			create routine.make ("create_buffers")
			routine.set_comment ("-- Creation of buffers")
			
			routine.add_body_line ("create item.make")
			routine.add_body_line ("create cursor.make (1,"+module.results.count.out+")")
			
			from
				count := module.results.count
				c := module.results.new_cursor
				c.start
				i := 1
			until
				c.off
			loop
				create line.make_from_string("cursor.put (item.")
				line.append_string (c.item.eiffel_name)
				line.append_string (", ")
				line.append_string (module.results.rank.item (c.item.name).out)
				line.append_string (")")
				routine.add_body_line (line)
				i := i + 1
				c.forth
			end

			feature_group.add_feature (routine)
			cursor_class.add_feature_group (feature_group) 
		end

feature {NONE} -- Implementation

	class_name (module : ACCESS_MODULE) : STRING is
		do
			Result := clone (module.name)
			Result.to_upper
		end

	as_lower (s : STRING) : STRING is
		do
			Result := clone (s)
			Result.to_lower
		end

invariant
	invariant_clause: -- Your invariant here

end -- class ACCESS_MODULE_GENERATOR
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
