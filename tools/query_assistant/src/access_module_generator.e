indexing
	description: "Cursor class generator"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ACCESS_MODULE_GENERATOR

inherit
	ECLI_TYPE_CONSTANTS

	KL_SHARED_FILE_SYSTEM
	
feature -- Initialization

--	execute (a_cursor : QA_CURSOR; a_directory_name : STRING; a_description : STRING) is -- a_file : KL_TEXT_OUTPUT_FILE) is
--		require
--			cursor: a_cursor /= Void and then a_cursor.name /= Void
--			cursor_executed: a_cursor.is_executed
--			a_directory_name_not_void: a_directory_name /= Void
--		do
--			current_cursor := a_cursor
--			current_description := a_description
--			create cursor_class.make (class_name)
--			create parameters_class.make (parameters_class_name (class_name))
--			create results_class.make (results_class_name (class_name))
--			create_cursor_class
--			create_parameters_class
--			if current_cursor.has_results then
--				create_results_class
--			end
--			--
--			write_class (cursor_class, a_directory_name)
--			write_class (parameters_class, a_directory_name)
--			if current_cursor.has_results then
--				write_class (results_class, a_directory_name)
--			end
--		end
	
	write_class (a_class : EIFFEL_CLASS; a_target_directory : STRING) is
			-- 
		local
			file_name : STRING
			file : KI_TEXT_OUTPUT_FILE
		do
			file_name := to_lower (a_class.name)
			file_name.append_string (".e")
			file_name := File_system.pathname (a_target_directory,file_name) 
			file := File_system.new_output_file (file_name)
			file.open_write
			a_class.write (file)
			file.close
		end
		
	create_cursor_class (module : ACCESS_MODULE; directory_name : STRING) is
			-- 
		require
		do
			create cursor_class.make (class_name (module))
			put_heading (module)
			put_visible_features (module)
			put_invisible_features (module)
			put_closing (module)
			write_class (cursor_class, directory_name)
		end

	create_parameters_class (parameter_set : COLUMN_SET[MODULE_PARAMETER]; directory_name : STRING)is
			-- 
		local
			routine : EIFFEL_ROUTINE
			attribute : EIFFEL_ATTRIBUTE
			feature_group : EIFFEL_FEATURE_GROUP
			c : DS_HASH_SET_CURSOR [MODULE_PARAMETER]
			a_qa_value : QA_VALUE
			a_call, line, vname : STRING
			i : INTEGER
		do
			create parameters_class.make (parameter_set.name)
			parameters_class.add_indexing_clause ("description: %"Parameters objects %"")
			parameters_class.add_indexing_clause ("status: %"Automatically generated.  DOT NOT MODIFY !%"")
			if parameter_set.parent /= Void then
				parameters_class.add_parent (parameter_set.parent.name)	
			end
			--| creation
			parameters_class.add_creation_procedure_name ("make")
			--| make
			create feature_group.make ("Initialization")
			feature_group.add_export ("NONE")
			
			create routine.make ("make")
			routine.set_comment ("-- Creation of buffers")
			
			
				from
					if parameter_set.parent = Void then
						c := parameter_set.new_cursor
					else
						c := parameter_set.local_items.new_cursor
						routine.add_body_line ("Precursor")
					end
					c.start
				until
					c.off
				loop
					a_qa_value := c.item.implementation
					a_call := a_qa_value.creation_call
					--begin_line ("create "); put (parameter_feature_name (c.item)); put ("."); put (a_qa_value.creation_call)
					create line.make_from_string ("create ")
					line.append_string (to_lower (c.item.name))
					line.append_string (".")
					line.append_string (a_qa_value.creation_call)
					
					routine.add_body_line (line) 
					c.forth
				end

			feature_group.add_feature (routine)
			
			parameters_class.add_feature_group (feature_group) 
			
			--| Access
			create feature_group.make ("Access")

				from
					c := parameter_set.new_cursor
					c.start
				until
					c.off
				loop
					a_qa_value := c.item.implementation
					vname := c.item.name
					create attribute.make (to_lower (vname), a_qa_value.ecli_type)
					feature_group.add_feature (attribute)
					i := i + 1
					c.forth
				end
			parameters_class.add_feature_group (feature_group)
			write_class (parameters_class, directory_name)			
		end
		

	create_results_class (result_set : COLUMN_SET[MODULE_RESULT]; directory_name : STRING) is
			-- 
		local
			routine : EIFFEL_ROUTINE
			attribute : EIFFEL_ATTRIBUTE
			feature_group : EIFFEL_FEATURE_GROUP
			line : STRING
			i, count : INTEGER
			a_qa_value : QA_VALUE
			a_call, vname : STRING
			cd, vdescription : ECLI_COLUMN_DESCRIPTION
			c : DS_HASH_SET_CURSOR[MODULE_RESULT]
		do
			create results_class.make (result_set.name)
			results_class.add_indexing_clause ("description: %"Results objects %"")
			results_class.add_indexing_clause ("status: %"Automatically generated.  DOT NOT MODIFY !%"")
			if result_set.parent /= Void then
				results_class.add_parent (result_set.parent.name)				
			end
			--| creation
			results_class.add_creation_procedure_name ("make")
			
			--| Initialization	
			--| 	make
			create feature_group.make ("Initialization")
			feature_group.add_export ("NONE")
			
			create routine.make ("make")
			routine.set_comment ("-- Creation of buffers")
			
			from
				i := 1
				if result_set.parent = Void then
					c := result_set.new_cursor
				else
					c := result_set.local_items.new_cursor
					routine.add_body_line ("Precursor")
				end
				c.start
			until
				c.off
			loop
				a_qa_value := c.item.implementation
				a_call := a_qa_value.creation_call
				cd := c.item.metadata
--					begin_line ("create "); put (to_lower (cd.name)); put ("."); put (a_call)
				create line.make_from_string ("create ")
				line.append_string (to_lower (cd.name))
				line.append_string (".")
				line.append_string (a_call)
				
				routine.add_body_line (line)
				c.forth
			end
			
			feature_group.add_feature (routine)
			
			results_class.add_feature_group (feature_group) 
			
			--| Access
			create feature_group.make ("Access")

			from
				i := 1
				if result_set.parent /= Void then
					c := result_set.local_items.new_cursor
				else
					c := result_set.new_cursor
				end
				c.start
			until
				c.off
			loop
				vname := c.item.metadata.name
				vdescription := c.item.metadata
				
				--
				create attribute.make (to_lower (vname),c.item.implementation.ecli_type)
				feature_group.add_feature (attribute)
				c.forth
			end

			results_class.add_feature_group (feature_group)
			write_class (results_class, directory_name)
		end
		
feature -- Access

	current_description : STRING
	
--	current_cursor : QA_CURSOR
	
	current_file : KL_TEXT_OUTPUT_FILE

	cursor_class : EIFFEL_CLASS
	
	parameters_class : EIFFEL_CLASS
	
	results_class : EIFFEL_CLASS
	
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

	put_visible_features(module : ACCESS_MODULE) is
		do
			put_make (module)
			put_access (module)
			put_element_change (module)
			put_definition (module)
		end

	put_access (module : ACCESS_MODULE) is
			-- 
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
			-- 
		local
			feature_group : EIFFEL_FEATURE_GROUP
			a_feature : EIFFEL_ROUTINE
			parameter, a_local, pre,post : DS_PAIR[STRING,STRING]
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
	
	parameters_class_name (a_name : STRING) : STRING is
			-- 
		do
			create Result.make_from_string (a_name)
			Result.to_upper
			Result.append_string ("_PARAMETERS")
		end

	results_class_name (a_name : STRING) : STRING is
			-- 
		do
			create Result.make_from_string (a_name)
			Result.to_upper
			Result.append_string ("_RESULTS")
		end
		
	put_invisible_features (module : ACCESS_MODULE) is
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

	put_make (module : ACCESS_MODULE) is
			-- 
		do
--			create feature_group.make ("Initialization")
--			feature_group.add_export ("NONE")
--			
--			create creation_routine.make ("make")
--			create parameter.make ("a_session", "ECLI_SESSION")
--			creation_routine.add_param (parameter)
--			creation_routine.set_comment ("-- initialize")			
--			creation_routine.add_body_line ("Precursor (a_session)")			
--			feature_group.add_feature (creation_routine)
--			cursor_class.add_feature_group (feature_group)
		end
		
	put_definition (module : ACCESS_MODULE) is
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

	put_start is
			-- put start operation
		do
--			indent
--			-- feature signature
--			put_new_line
--			put (indentation)
--			put ("start ")
--			-- parameter list
--			from
--				i := 0
--				list_cursor := current_cursor.parameter_names.new_cursor
--				list_cursor.start
--				put ("(")
--			until
--				list_cursor.off
--			loop
--				i := i + 1
--				pname := list_cursor.item
--				pvalue := current_cursor.parameter(pname)
--				if i >= 2 then
--					put ("; ")
--				end
--				put ("a_")
--				put (pname)
--				put (" : ")
--				put (pvalue.value_type)
--				list_cursor.forth
--			end
--			if i > 0 then
--				put (") ")
--			end			
--			put ("is")
--			indent
--			-- feature comment
--			indent
--			begin_line ("-- position cursor at first position of result-set obtained")
--			begin_line ("-- by applying actual parameters to definition")
--			exdent
--			-- feature body
--			begin_line ("do")
--			indent
--			-- set parameters with their value
--			from
--				i := 0
--				list_cursor := current_cursor.parameter_names.new_cursor
--				list_cursor.start
--			until
--				list_cursor.off
--			loop
--				pname := list_cursor.item
--				begin_line (parameter_feature_name (pname))
--				put (".set_item (a_")
--				put (pname)
--				put (")")
--				list_cursor.forth
--			end
--			-- execute and 'start'
--			begin_line ("implementation_start")
--			exdent
--			begin_line ("end")
--			exdent
--			put_new_line
--			exdent
--			put_new_line
		end
						
	put_parameters is
			-- put visible representation of parameters
		local
			i, count : INTEGER
			list_cursor : DS_LIST_CURSOR[STRING]
			pname : STRING
			pdescription : ECLI_PARAMETER_DESCRIPTION
		do
--			indent
--			from
--				i := 1
--				list_cursor := current_cursor.parameter_names.new_cursor
--				list_cursor.start
--			until
--				list_cursor.off
--			loop
--				pname := list_cursor.item
--				-- p_<parameter_name> : type
--				begin_line (parameter_feature_name (pname) ); put ( "%T: " ); put ( current_cursor.parameter (pname).ecli_type)
--				i := i + 1
--				list_cursor.forth
--			end
--			exdent
--			put_new_line
		end
		
	put_results is
			-- put visible representation of results
		local
			i, count : INTEGER
			vname : STRING
			vdescription : ECLI_COLUMN_DESCRIPTION
		do
--			indent
--			from
--				i := 1
--				count := current_cursor.result_columns_count
--			until
--				i > count
--			loop
--				vname := current_cursor.cursor_description.item (i).name
--				vdescription := current_cursor.cursor_description.item (i)
--				begin_line (to_lower (vname))
--				put ("%T: ")
--				put (current_cursor.cursor.item (i).ecli_type )
--				i := i + 1
--			end
--			exdent
--			put_new_line
		end
		

	put_foo_create_buffers is
		do
--				indent
--				begin_line ("create_buffers is")
--				indent
--				indent
--				begin_line ("-- create all result attribute objects")
--				exdent
--				begin_line ("do")
--				begin_line ("end")
		end

	put_create_buffers (module : ACCESS_MODULE) is
		local
			i, count : INTEGER
			cd : ECLI_COLUMN_DESCRIPTION
			c : DS_HASH_SET_CURSOR [MODULE_RESULT]
			a_qa_value : QA_VALUE
			a_call : STRING
			routine : EIFFEL_ROUTINE
			attribute : EIFFEL_ATTRIBUTE
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
				a_qa_value :=c.item.implementation
				a_call := a_qa_value.creation_call
				cd := c.item.metadata				
				create line.make_from_string("cursor.put (item.")
				line.append_string (to_lower (cd.name))
				line.append_string (", ")
				line.append_integer (module.results.rank.item (c.item.metadata.name))
				line.append_string (")")
				routine.add_body_line (line)
				i := i + 1
				c.forth
			end

			feature_group.add_feature (routine)
			cursor_class.add_feature_group (feature_group) 
			
--				indent
--				begin_line ("create_buffers is")
--				indent
--				indent
--				begin_line ("-- create all result attribute objects")
--				exdent
--				begin_line ("do")
--				indent
--				-- create cursor.make (1, <result_count>)
--				begin_line ("-- create cursor values array")
--				begin_line ("create cursor.make (1, "); put (current_cursor.result_columns_count.out); 
--				put (")")
--
--				---- for each column in <column list>
--				-- create <column>.make <corresponding creation parameters>
--				-- cursor.put (<column>, rank)
--				put_new_line
--				begin_line ("-- setup result value object and put them in 'cursor' ")
--				from
--					i := 1
--					count := current_cursor.result_columns_count
--				until
--					i > count
--				loop
--					a_qa_value := current_cursor.cursor.item (i)
--					a_call := a_qa_value.creation_call
--					cd := current_cursor.cursor_description.item (i)
--					begin_line ("create "); put (to_lower (cd.name)); put ("."); put (a_call)
--					begin_line ("cursor.put ("); put (to_lower (cd.name)); put (", "); put (i.out); put (")")
--					i := i + 1
--				end
--				exdent
--				begin_line ("end")
--				exdent
--				put_new_line
--				exdent
		end

	put_create_parameter_buffers is
		local
			i, count : INTEGER
			cd : ECLI_COLUMN_DESCRIPTION
			c : DS_LIST_CURSOR [STRING]
			a_qa_value : QA_VALUE
			a_call : STRING
		do
--				indent
--				begin_line ("create_parameter_buffers is")
--				indent
--				indent
--				begin_line ("-- create all parameters attribute objects")
--				exdent
--				begin_line ("do")
--				indent
--				-- create cursor.make (1, <result_count>)
--				begin_line ("-- create cursor values array")
--				begin_line ("create cursor.make (1, "); put (current_cursor.result_column_count.out); 
--				put (")")
--				---- for each parameter in <parameter list>
--				-- create <parameter>.make <corresponding creation parameters>
--				-- put_parameter (<parameter>, "<parameter>")
--				put_new_line
--				begin_line ("-- setup parameter value objects and put them, by name")
--				from
--					c := current_cursor.parameter_names.new_cursor
--					c.start
--				until
--					c.off
--				loop
--					a_qa_value := current_cursor.parameter (c.item)
--					a_call := a_qa_value.creation_call
--					begin_line ("create "); put (parameter_feature_name (c.item)); put ("."); put (a_qa_value.creation_call)
--					begin_line ("put_parameter (") ; put (parameter_feature_name (c.item)); put (", %""); put (c.item) ; put ("%")" )
--					c.forth
--				end
--				--
--				exdent
--				begin_line ("end")
--				exdent
--				put_new_line
--				exdent
		end
		
	put_closing (module : ACCESS_MODULE) is
			-- put closing of class
		do
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	class_name (module : ACCESS_MODULE) : STRING is
		do
			Result := clone (module.name)
			Result.to_upper
		end

	to_lower (s : STRING) : STRING is
		do
			Result := clone (s)
			Result.to_lower
		end

	factory : QA_VALUE_FACTORY is
		once
			create Result.make
		end

	parameter_feature_name (a_name : STRING) : STRING is
			-- name of feature for parameter `a_name'
		require
			a_name_not_void: a_name /= Void
		do
			!!Result.make (a_name.count + 2)
			Result.append ("p_")
			Result.append (a_name)
			Result.to_lower
		end
		
invariant
	invariant_clause: -- Your invariant here

end -- class ACCESS_MODULE_GENERATOR
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
