indexing
	description: "Cursor class generator"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_CURSOR_GENERATOR

inherit
	ECLI_TYPE_CONSTANTS

feature -- Initialization

	execute (a_cursor : QA_CURSOR; a_file : KL_TEXT_INPUT_FILE) is
		require
			cursor: a_cursor /= Void and then a_cursor.name /= Void
			cursor_executed: a_cursor.is_executed
			file: a_file /= Void and a_file.is_open_write
		do
			current_cursor := a_cursor
			current_file := a_file
			create indentation.make (10)
			put_heading
			put_visible_features
			put_invisible_features
			put_closing
		end


feature -- Access

	current_cursor : QA_CURSOR
	
	current_file : KL_TEXT_INPUT_FILE
	
feature -- Measurement

	indentation : STRING
	
	indent is
		do
			if indentation = Void then
				create indentation.make(10)
			end
			indentation.append_character ('%T')
		end
		
	exdent is
		require
			indentation /= Void
		do
			indentation.tail (indentation.count - 1)
		end
		
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

	put_visible_features is
		do
			begin_line ("feature {NONE} -- Initialization")
			put_make
			begin_line ("feature -- Basic Operations")
			put_new_line
			put_start
			begin_line ("feature -- Access")
			put_new_line
			put_definition
			begin_line ("feature -- Access (parameters)")
			put_new_line
			put_parameters
			if current_cursor.has_results then
				begin_line ("feature -- Access (results)")
				put_new_line
				put_results
			end
		end

	put_invisible_features is
		do
			begin_line ("feature {NONE} -- Implementation")
			if current_cursor.has_results then
				put_new_line
				put_create_buffers
			else
				put_new_line
				put_foo_create_buffers
			end
			put_new_line
			put_create_parameter_buffers
		end
				
	put_heading is
			-- put indexing, class name, inheritance and creation
		do
			put ("indexing")
			indent
			begin_line ("description: %"Generated cursor '"); put (current_cursor.name); put ("' : DO NOT EDIT !%"")
			begin_line ("author: %"QUERY_ASSISTANT%"")
			begin_line ("date: %"$Date : $%"")
			begin_line ("revision: %"$Revision : $%"")
			begin_line ("licensing: %"See notice at end of class%"")
			exdent
			begin_line ("class")
			put_new_line
			indent
			begin_line (class_name)
			exdent
			put_new_line
			begin_line ("inherit")
			put_new_line
			indent
			begin_line ("ECLI_CURSOR")
			indent
			begin_line ("redefine")
			indent
			begin_line ("make")
			exdent
			begin_line ("end")
			exdent
			put_new_line
			begin_line ("creation")
			put_new_line
			indent
			begin_line ("make")
			exdent
			put_new_line
		end

	put_make is
			-- 
		do
			indent
			begin_line ("make (a_session : ECLI_SESSION) is")
			indent
			begin_line ("-- initialize")
			exdent
			begin_line ("do")
			indent
			begin_line ("Precursor (a_session)")
			begin_line ("create_parameter_buffers")
			exdent
			begin_line ("end")
			exdent
			put_new_line
		end
		
	put_definition is
		do
			indent
			begin_line ("definition : STRING is")
			indent
			indent
			begin_line ("-- SQL definition of Current")
			exdent
			begin_line ("once")
			indent
			begin_line ("Result := %""); put (current_cursor.definition); put ("%"")
			exdent
			begin_line ("end")
			exdent
			exdent
			put_new_line
		end

	put_start is
			-- put start operation
		local
			i, count : INTEGER
			list_cursor : DS_LIST_CURSOR[STRING]
			pname : STRING
			pvalue : QA_VALUE
		do
			indent
			-- feature signature
			put_new_line
			put (indentation)
			put ("start ")
			-- parameter list
			from
				i := 0
				list_cursor := current_cursor.parameter_names.new_cursor
				list_cursor.start
				put ("(")
			until
				list_cursor.off
			loop
				i := i + 1
				pname := list_cursor.item
				pvalue := current_cursor.parameter(pname)
				if i >= 2 then
					put ("; ")
				end
				put ("a_")
				put (pname)
				put (" : ")
				put (pvalue.value_type)
				list_cursor.forth
			end
			if i > 0 then
				put (") ")
			end			
			put ("is")
			indent
			-- feature comment
			indent
			begin_line ("-- position cursor at first position of result-set obtained")
			begin_line ("-- by applying actual parameters to definition")
			exdent
			-- feature body
			begin_line ("do")
			indent
			-- set parameters with their value
			from
				i := 0
				list_cursor := current_cursor.parameter_names.new_cursor
				list_cursor.start
			until
				list_cursor.off
			loop
				pname := list_cursor.item
				begin_line (parameter_feature_name (pname))
				put (".set_item (a_")
				put (pname)
				put (")")
				list_cursor.forth
			end
			-- execute and 'start'
			begin_line ("implementation_start")
			exdent
			begin_line ("end")
			exdent
			put_new_line
			exdent
			put_new_line
		end
						
	put_parameters is
			-- put visible representation of parameters
		local
			i, count : INTEGER
			list_cursor : DS_LIST_CURSOR[STRING]
			pname : STRING
			pdescription : ECLI_PARAMETER_DESCRIPTION
		do
			indent
			from
				i := 1
				list_cursor := current_cursor.parameter_names.new_cursor
				list_cursor.start
			until
				list_cursor.off
			loop
				pname := list_cursor.item
				-- p_<parameter_name> : type
				begin_line (parameter_feature_name (pname) ); put ( "%T: " ); put ( current_cursor.parameter (pname).ecli_type)
				i := i + 1
				list_cursor.forth
			end
			exdent
			put_new_line
		end
		
	put_results is
			-- put visible representation of results
		local
			i, count : INTEGER
			vname : STRING
			vdescription : ECLI_COLUMN_DESCRIPTION
		do
			indent
			from
				i := 1
				count := current_cursor.result_columns_count
			until
				i > count
			loop
				vname := current_cursor.cursor_description.item (i).name
				vdescription := current_cursor.cursor_description.item (i)
				begin_line (to_lower (vname))
				put ("%T: ")
				put (current_cursor.cursor.item (i).ecli_type )
				i := i + 1
			end
			exdent
			put_new_line
		end
		

	put_foo_create_buffers is
		do
				indent
				begin_line ("create_buffers is")
				indent
				indent
				begin_line ("-- create all result attribute objects")
				exdent
				begin_line ("do")
				begin_line ("end")
		end

	put_create_buffers is
		local
			i, count : INTEGER
			cd : ECLI_COLUMN_DESCRIPTION
			c : DS_LIST_CURSOR [STRING]
			a_qa_value : QA_VALUE
			a_call : STRING
		do
				indent
				begin_line ("create_buffers is")
				indent
				indent
				begin_line ("-- create all result attribute objects")
				exdent
				begin_line ("do")
				indent
				-- create cursor.make (1, <result_count>)
				begin_line ("-- create cursor values array")
				begin_line ("create cursor.make (1, "); put (current_cursor.result_columns_count.out); 
				put (")")

				---- for each column in <column list>
				-- create <column>.make <corresponding creation parameters>
				-- cursor.put (<column>, rank)
				put_new_line
				begin_line ("-- setup result value object and put them in 'cursor' ")
				from
					i := 1
					count := current_cursor.result_columns_count
				until
					i > count
				loop
					a_qa_value := current_cursor.cursor.item (i)
					a_call := a_qa_value.creation_call
					cd := current_cursor.cursor_description.item (i)
					begin_line ("create "); put (to_lower (cd.name)); put ("."); put (a_call)
					begin_line ("cursor.put ("); put (to_lower (cd.name)); put (", "); put (i.out); put (")")
					i := i + 1
				end
				exdent
				begin_line ("end")
				exdent
				put_new_line
				exdent
		end

	put_create_parameter_buffers is
		local
			i, count : INTEGER
			cd : ECLI_COLUMN_DESCRIPTION
			c : DS_LIST_CURSOR [STRING]
			a_qa_value : QA_VALUE
			a_call : STRING
		do
				indent
				begin_line ("create_parameter_buffers is")
				indent
				indent
				begin_line ("-- create all parameters attribute objects")
				exdent
				begin_line ("do")
				indent
				-- create cursor.make (1, <result_count>)
				begin_line ("-- create cursor values array")
				begin_line ("create cursor.make (1, "); put (current_cursor.result_column_count.out); 
				put (")")
				---- for each parameter in <parameter list>
				-- create <parameter>.make <corresponding creation parameters>
				-- put_parameter (<parameter>, "<parameter>")
				put_new_line
				begin_line ("-- setup parameter value objects and put them, by name")
				from
					c := current_cursor.parameter_names.new_cursor
					c.start
				until
					c.off
				loop
					a_qa_value := current_cursor.parameter (c.item)
					a_call := a_qa_value.creation_call
					begin_line ("create "); put (parameter_feature_name (c.item)); put ("."); put (a_qa_value.creation_call)
					begin_line ("put_parameter (") ; put (parameter_feature_name (c.item)); put (", %""); put (c.item) ; put ("%")" )
					c.forth
				end
				--
				exdent
				begin_line ("end")
				exdent
				put_new_line
				exdent
		end
		
	put_closing is
			-- put closing of class
		do
			put_new_line
			begin_line ("end -- class ")
			put (class_name)
			put_new_line
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	class_name : STRING is
		do
			Result := clone (current_cursor.name)
			Result.to_upper
		end

	begin_line (s : STRING) is
			-- put indentation + line
		require
			s /= Void
		do
			put_new_line
			current_file.put_string (indentation)
			put (s)
		end

	put_line (s : STRING) is
			-- put indentation + line + new_line
		do
			begin_line (s)
			put_new_line
		end
		
	put (s : STRING) is
		require
			s /= Void
		do
			current_file.put_string (s)
		end

	put_new_line is
		do
			current_file.put_character ('%N')
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

end -- class QA_CURSOR_GENERATOR
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
