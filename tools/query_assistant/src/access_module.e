indexing
	description: "Access modules; Each module encapsulates one database query."

	library: "Access_gen : Access Modules Generators utilities"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCESS_MODULE

inherit
	SHARED_SCHEMA_NAME
	SHARED_CATALOG_NAME
	
create
	make

feature {NONE} -- Initialization

	make (a_name, a_query : STRING) is
			-- Initialize `Current'.
		require
			a_name_not_void: a_name /= Void
			a_query_not_void: a_query /= Void
		do
			set_name (a_name.string)
			set_query (a_query.string)
--			!DS_LINKED_LIST[MODULE_PARAMETER]!parameters.make
		ensure
			name_assigned: name = a_name
			query_assigned: query = a_query
		end

feature -- Access

	description: STRING
			-- description of current module. Useful for documenting purposes

--	parameters: DS_LIST [MODULE_PARAMETER]
			-- formal parameters of `query'

--	results: DS_LIST[ECLI_COLUMN_DESCRIPTION]

	parameters : PARAMETER_SET
	
	results : RESULT_SET
	
	query: STRING
			-- SQL query

	name: STRING
			-- Name of current acces module. Generated names shall include it

feature -- Measurement

feature -- Status report

	is_error : BOOLEAN
	
	is_query_valid : BOOLEAN

	is_checked_query : BOOLEAN
	
	is_parameters_valid : BOOLEAN

	query_statement : ECLI_STATEMENT
	query_session : ECLI_SESSION
	
feature -- Status setting

	check_validity (a_session : ECLI_SESSION; a_error_handler : UT_ERROR_HANDLER) is
			-- check is query is a valid sql, and if all parameters have a description
		require
			a_session_not_void: a_session /= Void
			a_session_connected: a_session.is_connected
		do
			create query_statement.make (a_session)
			query_session := a_session
			check_query (query_statement, a_error_handler)
			if is_query_valid then
				describe_result_set (a_error_handler) 
				check_parameters (a_error_handler)
			end
			query_statement.close
		end

	check_query (a_statement : ECLI_STATEMENT; a_error_handler : UT_ERROR_HANDLER) is
			-- 
		require
			a_statement_not_void: a_statement /= Void
			a_error_handler_not_void: a_error_handler /= Void
		do
			is_query_valid := False
			query_statement := a_statement
			query_statement.set_sql (query)
			query_statement.prepare
			if query_statement.is_ok then
				is_query_valid := True
			else
				a_error_handler.report_error_message ("Statement not valid : %N" +
					query + "%N" + query_statement.diagnostic_message + "%N") 
			end
			is_checked_query := True
		ensure
			query_statement_valid: query_statement /= Void and then query_statement.is_valid
			query_statement_set: query_statement = a_statement
		end

	describe_result_set (a_error_handler : UT_ERROR_HANDLER) is
			-- 
		require
			a_error_handler_not_void: a_error_handler /= Void
			checked_query: is_checked_query
			query_statement_valid: query_statement.is_valid
		local
			index : INTEGER
		do
			query_statement.describe_cursor
			create results.make (name+"_RESULTS")
			from
				index := query_statement.cursor_description.lower
			until
				index > query_statement.cursor_description.upper
			loop
				results.force (query_statement.cursor_description.item (index))
				index := index + 1
			end
		ensure
			results_count: results.count = query_statement.cursor_description.count
		end
		
	check_parameters (a_error_handler : UT_ERROR_HANDLER) is
			--| Check if declared parameters are the same as statement parameters
		require
			a_error_handler_not_void: a_error_handler /= Void
			checked_query: is_checked_query
			query_statement_valid: query_statement.is_valid
		local
			sql_parameters : DS_LIST[STRING]
			parameters_cursor : DS_SET_CURSOR[MODULE_PARAMETER]
			tester : KL_EQUALITY_TESTER [STRING]
			l_catalog, l_schema : STRING
		do
			--| same number
			is_parameters_valid := (query_statement.parameter_names.count = parameters.count)
			if is_parameters_valid then
				--| same names				
				sql_parameters := query_statement.parameter_names
				parameters_cursor := parameters.new_cursor
				from
					parameters_cursor.start
					create tester
					sql_parameters.set_equality_tester (tester)
				until
					not is_parameters_valid or else parameters_cursor.off
				loop
					is_parameters_valid := is_parameters_valid and sql_parameters.has (parameters_cursor.item.name)
					parameters_cursor.forth
				end
				if not is_parameters_valid then
					--| Error : parameters_cursor.item.name not in sql_parameters
					a_error_handler.report_error_message ("In module '"+name+"'%NSQL parameter '"+parameters_cursor.item.name + "' is not defined in any <parameter> element")
				else
					--| check for parameter reference columns
					from
						parameters_cursor.start
						create tester
						sql_parameters.set_equality_tester (tester)
					until
						not is_parameters_valid or else parameters_cursor.off
					loop
						if not shared_catalog_name.is_empty then
							l_catalog := shared_catalog_name
						end
						if not shared_schema_name.is_empty then
							l_schema := shared_schema_name
						end
						parameters_cursor.item.check_validity (query_session, l_catalog, l_schema)
						is_parameters_valid := is_parameters_valid and then parameters_cursor.item.is_valid
						if is_parameters_valid then
							parameters_cursor.forth
						end
					end
					if not is_parameters_valid then
						--| Error: invalid column reference
					a_error_handler.report_error_message ("In module '"+ name +"'%NReference column for '"+
						parameters_cursor.item.name + "' not found => " + 
						parameters_cursor.item.reference_column.table + "." + parameters_cursor.item.reference_column.column
					)
					end
				end				
			else
				--| Error : number of declared parameters not the same as query parameters
					a_error_handler.report_error_message ("In module '"+ name +
					"'%NNumber of declared parameters does not match number of SQL parameters")
			end
		end
		
feature -- Cursor movement

feature -- Element change

	set_description (a_description: STRING) is
			-- Set `description' to `a_description'.
		require
			a_description_not_void: a_description /= Void
		do
			description := a_description
		ensure
			description_assigned: description = a_description
		end

	set_parameters (a_parameters: PARAMETER_SET) is
			-- set `a_parameters' as `parameters'
		require
			a_parameters_not_void: a_parameters /= Void
		do
			parameters := a_parameters
		ensure
			parameters_set: parameters = a_parameters
		end

	set_results (a_results : RESULT_SET) is
			-- set `a_results' as `results'
		require
			a_results_not_void: a_results /= Void
		do
			results := a_results
		ensure
			result_set: results = a_results
		end
		
feature {NONE} -- Element change

	set_query (a_query: STRING) is
			-- Set `query' to `a_query'.
		require
			a_query_not_void: a_query /= Void
		do
			query := a_query
		ensure
			query_assigned: query = a_query
		end

	set_name (a_name: STRING) is
			-- Set `name' to `a_name'.
		require
			a_name_not_void: a_name /= Void
		do
			name := a_name
		ensure
			name_assigned: name = a_name
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	statement : ECLI_STATEMENT
	
invariant
	invariant_clause: True -- Your invariant here
	name_not_void: name /= Void
	query_not_void: query /= Void
	parameters_not_void: parameters /= Void

end -- class ACCESS_MODULE
