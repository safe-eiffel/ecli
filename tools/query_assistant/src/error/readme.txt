v arguments	e_argument_invalid - name, message
v arguments	e_argument_missing - name, description

v database	e_database_connection_failed
v database	e_module_check_could_not_execute_query - module, sql_error
v database	e_module_check_could_not_prepare - module, sql_error
v database	w_module_check_prepared_but_not_executed

file	e_ut_cannot_read_file_error - file_name

v information	i_application_copyright - author, dates
v information	i_application_identification - name, version
v information	i_application_license - Eiffel forum...
v information	i_process_begin - process
v information	i_process_end - process, failure/success

v internal	e_could_not_create_parameter - module, name
v internal	e_xml_parser_not_available - parser_name
v internal	w_column_length_too_large - module, name, length, parameter/result
v internal	w_column_length_truncated - module, name, length, parameter/result

v syntax	e_xml_duplicate_element - module, element (module already has a 'element' element)
v syntax	e_xml_exclusive_elements - module, element, element (cannot have 'e1' while having 'e2')
v syntax	e_xml_missing_element - module, element, parent
v syntax	e_xml_missing_element_attribute - element, attribute, parent
v syntax	e_xml_parse_error - message

usage	e_usage_message - ...

validity	e_already_exists - who, what, where | module, name, type {module, parameter_set, column, parameter}
validity	e_sql_invalid_reference_column - module, name, table, column
validity	e_sql_parameter_not_described - name, module
validity	e_sql_parameters_count_mismatch - module
validity	w_parent_class_empty
