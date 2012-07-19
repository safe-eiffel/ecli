indexing
	description: "Factories for access modules from an XML element."

	library: "Access_gen : Access Modules Generators utilities"

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	RDBMS_ACCESS_FACTORY

inherit
	ACCESS_MODULE_XML_CONSTANTS
	ECLI_SQL_PARSER_CALLBACK
	SHARED_MAXIMUM_LENGTH

create
	make

feature {NONE} -- Initialization

	make (a_error_handler : QA_ERROR_HANDLER) is
			-- creation using `a_error_handler'
		require
			a_error_handler_not_void: a_error_handler /= Void
		do
			error_handler := a_error_handler
			create parameter_names.make (10)
		ensure
			error_handler_set: error_handler = a_error_handler
		end

feature -- Access

	error_handler : QA_ERROR_HANDLER

	last_result_set : detachable RESULT_SET

	last_parameter_set: detachable PARAMETER_SET

	last_access : detachable RDBMS_ACCESS

	parameter_map : PARAMETER_MAP

feature {NONE} -- Access

	last_parameter : detachable RDBMS_ACCESS_PARAMETER

feature -- Status report

	is_error : BOOLEAN
		-- has the last creation resulted to an error ?

feature -- Basic operations

	create_access_module (element : XM_ELEMENT) is
			-- process `element' as access module
		require
			element_not_void: element /= Void
			element_name_access: element.name.string.is_equal (t_access)
		local
			name_att, type_att : detachable XM_ATTRIBUTE
			name : detachable STRING
			module_type : ACCESS_TYPE
		do
			is_error := False
			last_access := Void
			last_parameter_set := Void
			last_result_set := Void
			if element.has_attribute_by_name (t_name) then
				name_att := element.attribute_by_name (t_name)
			end
			if element.has_attribute_by_name (t_type) then
				type_att := element.attribute_by_name (t_type)
			end
			if name_att = Void then
				error_handler.report_missing_attribute ("?", "name", "access")
				is_error := True
			else
				name := name_att.value
--vs				type := type_att.value
				if name /= Void then --and type /= Void then
					if attached {XM_ELEMENT} element.element_by_name (t_sql) as query then
--vs						query := element.element_by_name (t_sql)
						create last_access.make (module_name (name), query.text.string)
						last_access.enable_generatable
						if attached element.element_by_name (t_description) as description then
--vs							description := element.element_by_name (t_description)
							last_access.set_description (description.text.string)
						end
						if element.has_element_by_name (t_parameter_set) then
							if attached element.element_by_name (t_parameter) as l_parameter then
								create_parameter_set (l_parameter, parameter_set_name (name))
							else
								error_handler.report_exclusive_element (name, "parameter", "parameter_set", "access")
								is_error := True
							end
						else
							create last_parameter_set.make (parameter_set_name (name))
							if element.has_element_by_name (T_parameter) then
								populate_parameter_set (element)
							end
						end
						if attached element.element_by_name (t_result_set) as l_result_set then
							create_result_set (l_result_set, result_set_name (name))
						end
						-- analyze SQL and infer parameter_set
						fill_parameter_set (last_access.query)
						if attached last_parameter_set as l_last_parameter_set then
							if l_last_parameter_set.is_generatable then
								last_access.set_parameters (l_last_parameter_set)
							else
								last_access.disable_generatable
							end
						end
						if attached last_result_set as l_last_result_set then
							if l_last_result_set.is_generatable then
								last_access.set_results (l_last_result_set)
							else
								last_access.disable_generatable
							end
						end
						if attached type_att as l_type_att then
							create module_type.make_from_string (l_type_att.value)
							last_access.set_type (module_type)
						end
					else
						error_handler.report_missing_element (name, "sql", "access")
						is_error := True
					end
				end
			end
		ensure
			last_module_not_void_if_no_error: not is_error implies last_access /= Void
		end

	create_parameter_set (element : XM_ELEMENT; default_name : STRING) is
			-- create parameter set from `element' into `last_parameter_set'
		require
			element_not_void: element /= Void
			element_name_parameter_set: element.name.string.is_equal (t_parameter_set)
			default_name_not_void: default_name /= Void
		local
			name, parent : STRING
		do
			name := ""
			parent := ""
			if element.has_attribute_by_name (t_name) then
				name := element.attribute_by_name (t_name).value.string
			end
			if name.is_empty then
				name := default_name
			end
			if element.has_attribute_by_name (t_extends) then
				parent := element.attribute_by_name (t_extends).value.string
				if parent.same_string (name) then
					-- error_handler
					error_handler.report_same_parameter_set_parent_name (last_access.name, name, parent)
					is_error := True
				else
					create last_parameter_set.make_with_parent_name (name, parent)
				end
			else
				create last_parameter_set.make (name)
			end
			if not is_error and then element.has_element_by_name (T_parameter) then
				populate_parameter_set (element)
			end
		end

	create_result_set (element : XM_ELEMENT; default_name : STRING) is
			-- create result set from `element' into `last_result_set'
		require
			element_not_void: element /= Void
			element_name_result_set: element.name.string.is_equal (t_result_set)
			default_name_not_void: default_name /= Void
		local
			name, parent : STRING
		do
			name := ""
			parent := ""
			if element.has_attribute_by_name (t_name) then
				name := element.attribute_by_name (t_name).value.string
			end
			if name.is_empty then
				name := default_name
			end
			if element.has_attribute_by_name (t_extends) then
				parent := element.attribute_by_name (t_extends).value.string
				create last_result_set.make_with_parent_name (name, parent)
			else
				create last_result_set.make (name)
			end
		end

	create_parameter_map (element : XM_ELEMENT) is
			-- create parameter map from `element'
		require
			element_not_void: element /= Void
		do
			create parameter_map.make (10)
			populate_parameter_map (element)
		ensure
			result_if_ok: not is_error implies parameter_map /= Void
		end

feature {NONE} -- Implementation

	module_name (a_name : STRING) : STRING is
			-- module name based on `a_name'
		do
			create Result.make_from_string (a_name)
			Result.to_upper
		end

	parameter_set_name (a_prefix : STRING) : STRING is
			-- parameter set name based on `a_prefix'
		do
			create Result.make_from_string (a_prefix)
			Result.append_string ("_PARAMETERS")
			Result.to_upper
		end

	result_set_name (a_prefix : STRING) : STRING is
			-- result set name based on `a_prefix'
		do
			create Result.make_from_string (a_prefix)
			Result.append_string ("_RESULTS")
			Result.to_upper
		end

	populate_parameter_set (element : XM_ELEMENT) is
			-- iterate over "parameter" elements in `element'
		require
			element_not_void: element /= Void
			element_has_parameter_element: element.has_element_by_name (t_parameter)
		local
 			parameter_cursor : DS_LINEAR_CURSOR [detachable XM_NODE]
--			parameter : XM_ELEMENT
		do
			from
				parameter_cursor := attached_ (element.new_cursor)
				parameter_cursor.start
			until
				parameter_cursor.off
			loop
--				parameter ?= parameter_cursor.item
				if attached {XM_ELEMENT}parameter_cursor.item as parameter and then parameter.name.string.is_equal (t_parameter) then
					create_parameter (parameter, False)
					if attached last_parameter as l_param then
						last_parameter_set.force (l_param)
					end
				end
				parameter_cursor.forth
			end
		end

	populate_parameter_map (element : XM_ELEMENT) is
			-- iterate over "parameter" elements in `element'
		require
			element_not_void: element /= Void
			element_has_parameter_element: element.has_element_by_name (t_parameter)
		local
 			parameter_cursor : DS_LINEAR_CURSOR [detachable XM_NODE]
--			parameter : XM_ELEMENT
		do
--			if attached element.new_cursor as parameter_cursor then
				from
					parameter_cursor := attached_ (element.new_cursor)
					parameter_cursor.start
				until
					parameter_cursor.off
				loop
--					parameter ?= parameter_cursor.item
					if attached {XM_ELEMENT} parameter_cursor.item as parameter and then parameter.name.string.is_equal (t_parameter) then
						create_parameter (parameter, True)
						if attached last_parameter as l_param then
							if parameter_map.has (l_param.name) then
								is_error := True
								error_handler.report_duplicate_element ("?", l_param.name, attached_ (element.name))
							else
								parameter_map.force (l_param, l_param.name)
							end
						end
					end
					parameter_cursor.forth
				end
--			end
		end

	attached_ (a : detachable ANY) : attached like a
		do
			check attached a as l_result then
				Result := l_result
			end
		end

	create_parameter (element : XM_ELEMENT; is_template : BOOLEAN) is
			-- create parameter based on `element'
		require
			element_not_void: element /= Void
			element_name_is_parameter: element.name.string.is_equal (t_parameter)
		local
			l_name, l_table, l_column : STRING
			l_reference : REFERENCE_COLUMN
			template : RDBMS_ACCESS_PARAMETER
		do
			is_error := False
			last_parameter := Void
			l_name := ""
			l_table := ""
			l_column := ""
			if element.has_attribute_by_name (t_name) then
				l_name := element.attribute_by_name (t_name).value.string
			else
				error_handler.report_missing_attribute (last_access.name, T_name, attached_ (element.name))
				is_error := True
			end
			if not is_error and then parameter_map /= Void and then parameter_map.has (l_name) then
				template := parameter_map.item (l_name)
				create_parameter_from_template (element, template)
			elseif not is_error then
				if element.has_attribute_by_name (t_table) then
					l_table := element.attribute_by_name (t_table).value.string
				else
					error_handler.report_missing_attribute (last_access.name, t_table, attached_ (element.name))
					is_error := True
				end
				if element.has_attribute_by_name (t_column) then
					l_column := element.attribute_by_name (t_column).value.string
				else
					error_handler.report_missing_attribute (last_access.name, T_column, attached_ (element.name))
					is_error := True
				end
				if l_name.count > 0 and then l_table.count > 0 and then l_column.count > 0 then
					create l_reference.make (l_table, l_column)
					create last_parameter.make (l_name, l_reference, maximum_length)
					if element.has_attribute_by_name (t_sample) then
						last_parameter.set_sample (element.attribute_by_name (t_sample).value.string)
					end
					if element.has_attribute_by_name (t_direction) then
						set_parameter_direction (last_parameter, element.attribute_by_name (t_direction).value.string)
					end
				end
			else
				-- impossible
				do_nothing
			end
		ensure
			last_parameter_not_void_if_no_error: not is_error implies last_parameter /= Void
		end

	create_parameter_from_template (element : XM_ELEMENT; template : RDBMS_ACCESS_PARAMETER) is
			-- create parameter from `element', using `template'
		require
			element_not_void: element /= Void
			template_not_void: template /= Void
			element_name_is_parameter: element.name.string.is_equal (t_parameter)
		local
			l_name, l_table, l_column : STRING
			l_reference : REFERENCE_COLUMN
		do
			is_error := False
			l_table := template.reference_column.table
			l_column := template.reference_column.column
			l_name := template.name
			if element.has_attribute_by_name (t_table) then
				error_handler.report_parameter_already_defined (last_access.name, template.name, t_table)
				is_error := True
			end
			if element.has_attribute_by_name (t_column) then
				error_handler.report_parameter_already_defined (last_access.name, template.name, T_column)
				is_error := True
			end
			if l_name /= Void and then l_table /= Void and then l_column /= Void then
				create l_reference.make (l_table, l_column)
				create last_parameter.make (l_name, l_reference, maximum_length)
				if element.has_attribute_by_name (t_sample) then
					last_parameter.set_sample (element.attribute_by_name (t_sample).value.string)
				elseif template.sample /= Void then
						last_parameter.set_sample (template.sample)
				end
			end
		ensure
			last_parameter_not_void_if_no_error: not is_error implies last_parameter /= Void
		end

	add_new_parameter (a_parameter_name : STRING; a_position : INTEGER) is
			-- add new parameter to parameter list
		do
			parameter_names.force (a_parameter_name)
		end

	on_table_literal (sql: STRING; i_begin, i_end: INTEGER) is
		do
		end

	on_parameter (sql: STRING; i_begin, i_end: INTEGER) is
		do
		end

	on_string_literal (sql: STRING; i_begin, i_end: INTEGER) is
		do
		end

	on_word (sql: STRING; i_begin, i_end: INTEGER) is
		do
		end

	on_parameter_marker (sql: STRING; index: INTEGER) is
		do
		end

	parameter_names	: DS_HASH_SET[STRING]

	is_valid : BOOLEAN is do Result := True end

	fill_parameter_set (sql : STRING) is
			--
		local
			sql_parser : ECLI_SQL_PARSER
--			cursor : DS_SET_CURSOR[RDBMS_ACCESS_PARAMETER]
		do
			create sql_parser.make
			parameter_names.wipe_out
			parameter_names.set_equality_tester (create {KL_EQUALITY_TESTER[STRING]})
			sql_parser.parse (sql, Current)
			if last_parameter_set /= Void and then last_parameter_set.count < parameter_names.count then
				-- remove parameter names that already exist
				if attached last_parameter_set.new_cursor as cursor then
					from
--						cursor := last_parameter_set.new_cursor
						cursor.start
					until
						cursor.off
					loop
						parameter_names.search (cursor.item.name)
						if parameter_names.found then
							parameter_names.remove_found_item
						end
						cursor.forth
					end
				end
				-- fill parameter names that could exist in the parameter_map
				from
					parameter_names.start
				until
					parameter_map = Void or else parameter_names.off
				loop
					parameter_map.search (parameter_names.item_for_iteration)
					if parameter_map.found then
						last_parameter_set.force_last (create {RDBMS_ACCESS_PARAMETER}.copy (parameter_map.found_item))
					end
					parameter_names.forth
				end
			end
		end

	set_parameter_direction (a_parameter : like last_parameter; a_value : STRING) is
		do
			if a_value.is_equal (v_input) then
				a_parameter.enable_input
			elseif a_value.is_equal (v_output) then
				a_parameter.enable_output
			elseif a_value.is_equal (v_input_output) then
				a_parameter.enable_input_output
			end
		end

invariant

end -- class ACCESS_MODULE_FACTORY
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
