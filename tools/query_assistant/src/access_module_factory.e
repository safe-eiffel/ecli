indexing
	description: "Factories for access modules from an XML element."

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCESS_MODULE_FACTORY

creation
	make
	
feature {NONE} -- Initialization

	make (a_error_handler : UT_ERROR_HANDLER) is
			-- creation using `a_error_handler'
		require
			a_error_handler_not_void: a_error_handler /= Void
		do
			error_handler := a_error_handler
		ensure
			error_handler_set: error_handler = a_error_handler
		end
		
feature -- Access

	error_handler : UT_ERROR_HANDLER
	
feature -- Measurement

feature -- Status report

	is_error : BOOLEAN
	
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

	create_parameter (element : XM_ELEMENT) is
			-- create parameter based on `element'
		local
			l_name, l_table, l_column : STRING
			l_reference : REFERENCE_COLUMN
		do
			is_error := False
			last_parameter := Void
			if element.has_attribute_by_name ("name") then
				l_name := element.attribute_by_name ("name").value.string
			else
				error_handler.report_error_message ("Parameter must have a 'name' attribute")
				is_error := True
			end
			if element.has_attribute_by_name ("table") then
				l_table := element.attribute_by_name ("table").value.string 
			else
				error_handler.report_error_message ("Parameter must have a 'table' attribute") 
				is_error := True
			end
			if element.has_attribute_by_name ("column") then
				l_column := element.attribute_by_name ("column").value.string
			else
				error_handler.report_error_message ("Parameter must have a 'column' attribute")
				is_error := True
			end
			if l_name /= Void and then l_table /= Void and then l_column /= Void then
				create l_reference.make (l_table, l_column)
				create last_parameter.make (l_name, l_reference)
			end
		ensure
			last_parameter_not_void_if_no_error: not is_error implies last_parameter /= Void
		end

	create_access_module (element : XM_ELEMENT) is
			-- process `element' as access module
		require
			element_not_void: element /= Void
			element_name_access: element.name.string.is_equal ("access")
		local
			name_att, type_att : XM_ATTRIBUTE
			name, type : STRING
			character_data : XM_CHARACTER_DATA
			parameter_cursor : DS_BILINEAR_CURSOR [XM_NODE]
			parameter, description, query : XM_ELEMENT
		do
			is_error := False
			last_module := Void
			if element.has_attribute_by_name ("name") then
				name_att := element.attribute_by_name ("name")
			end
			if element.has_attribute_by_name ("type") then
				type_att := element.attribute_by_name ("type")
			end
			if name_att = Void then
				error_handler.report_error_message ("Module should have a 'name' attribute")
				is_error := True
			else
				name := name_att.value
				type := type_att.value
				if name /= Void and type /= Void then
					if element.has_element_by_name ("sql") then
						query := element.element_by_name ("sql")
						create last_module.make (name, query.text.string)
						parameter_cursor := element.new_cursor
						if element.has_element_by_name ("description") then
							description := element.element_by_name ("description")
							last_module.set_description (description.text.string)
						end
						from
							parameter_cursor.start
						until
							parameter_cursor.off
						loop
							parameter ?= parameter_cursor.item
							if parameter /= Void and then parameter.name.string.is_equal ("parameter") then
								create_parameter (parameter)
								if last_parameter /= Void then
									last_module.add_parameter (last_parameter)
								end
							end
							parameter_cursor.forth
						end
					else
						error_handler.report_error_message ("Module '"+name+"' does not have any <sql> element")
						is_error := True
					end
				end
			end
		ensure
			last_module_not_void_if_no_error: not is_error implies last_module /= Void
		end

	last_parameter : MODULE_PARAMETER
	
	last_module : ACCESS_MODULE
	
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class ACCESS_MODULE_FACTORY
