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
	SHARED_MAXIMUM_LENGTH
	
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
		ensure
			name_assigned: name.is_equal (a_name)
			query_assigned: query.is_equal (a_query)
		end

feature -- Access

	description: STRING
			-- description of current module. Useful for documenting purposes
			
	parameters : PARAMETER_SET
			-- parameters metadata
	
	results : RESULT_SET
			-- results metadata
	
	query: STRING
			-- SQL query

	name: STRING
			-- Name of current acces module. Generated names shall include it
		
	type : ACCESS_TYPE
	
feature -- Status report

	is_prepared: BOOLEAN

	is_query_valid : BOOLEAN
			-- is query executable ?

	is_checked_query : BOOLEAN
			-- has the query been checked for validity?
	
	is_parameters_valid : BOOLEAN
			-- are the parameters valid ?

	is_results_valid : BOOLEAN
			-- are the results valid ?
	
	is_valid : BOOLEAN is
			-- is this query valid ?
		require
			is_checked_query: is_checked_query
		do
			Result := is_query_valid and then is_parameters_valid and then is_results_valid
		ensure
			definition: Result = (is_query_valid and then is_parameters_valid and then is_results_valid)
		end
		
	has_result_set : BOOLEAN is
			-- is this a query (if not, it is a command/modifying statement) ?
		require
			is_checked_query: is_checked_query
		do
			Result := results /= Void
		end
		
feature -- Status setting

	check_validity (a_session : ECLI_SESSION; a_error_handler : UT_ERROR_HANDLER; reasonable_maximum_size : INTEGER) is
			-- check if query is a valid sql, and if all parameters have a description
		require
			a_session_not_void: a_session /= Void
			a_session_connected: a_session.is_connected
		local
			query_statement : ECLI_STATEMENT
			query_session : ECLI_SESSION
		do
			create query_statement.make (a_session)
			query_session := a_session
			check_query (query_statement, a_session, a_error_handler)
			if is_query_valid then
				describe_result_set (query_statement, a_error_handler, reasonable_maximum_size) 
				check_parameters (query_statement, query_session, a_error_handler, reasonable_maximum_size)
			end
			query_statement.close
		ensure
			is_checked_query: is_checked_query
		end

feature -- Element change

	set_prepared is
			-- Set `is_prepared'
		do
			is_prepared := True
		ensure
			is_prepared: is_prepared
		end


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
		
	set_type (new_type : ACCESS_TYPE) is
		require
			new_type_not_void: new_type /= VOid
		do
			type := new_type
		ensure
			type_set: type = new_type
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

feature {NONE} -- Implementation

	statement : ECLI_STATEMENT

	describe_result_set (query_statement : ECLI_STATEMENT; a_error_handler : UT_ERROR_HANDLER; reasonable_maximum_size : INTEGER) is
			-- 
		require
			a_error_handler_not_void: a_error_handler /= Void
			checked_query: is_checked_query
			query_statement_valid: query_statement.is_valid
		local
			index : INTEGER
			current_result : MODULE_RESULT
			current_description : ECLI_COLUMN_DESCRIPTION
		do
			is_results_valid := True
			if query_statement.has_result_set then
				query_statement.describe_results
				if results = Void then 
					create results.make (name+"_RESULTS")
				end
				from
					index := query_statement.results_description.lower
				until
					not is_results_valid or else index > query_statement.results_description.upper
				loop
					--| FIXME: verify that a same column does not exist...
					current_description :=  query_statement.results_description.item (index)
					if current_description.size > reasonable_maximum_size then
						if  (maximum_length > 0 and then current_description.size > maximum_length) then
							a_error_handler.report_warning_message ("! [Warning] Result column "+current_description.name+" has been truncated from "+current_description.size.out+" to "+maximum_length.out+" bytes")
						else
							a_error_handler.report_warning_message ("![Warning] Is the lenght of result column '"+current_description.name+"' reasonable :"+current_description.size.out+" ?%N")
							a_error_handler.report_warning_message ("-> use command line parameter -max_length <length>%N")
						end
						create current_result.make(current_description, maximum_length)
					else
						create current_result.make(current_description, current_description.size)
					end
					if results.has (current_result) then
						a_error_handler.report_error_message ("! [Error] Result set '"+results.name+"' has two columns named '"+current_result.name+"'")
						is_results_valid := False
						results := Void
					else
						results.force (current_result, index)
					end
					index := index + 1
				end
			else
				results := Void
			end
		ensure
			results_count: results.count = query_statement.results_description.count
		end
		
	check_parameters (query_statement : ECLI_STATEMENT; query_session : ECLI_SESSION; a_error_handler : UT_ERROR_HANDLER; reasonable_maximum_size : INTEGER) is
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
					a_error_handler.report_error_message ("! [Error] In module '"+name+"'%NSQL parameter '"+parameters_cursor.item.name + "' is not defined in any <parameter> element")
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
						parameters_cursor.item.check_validity (l_catalog, l_schema, a_error_handler, reasonable_maximum_size)
						is_parameters_valid := is_parameters_valid and then parameters_cursor.item.is_valid
						if is_parameters_valid then
							parameters_cursor.forth
						end
					end
					if not is_parameters_valid then
						--| Error: invalid column reference
					a_error_handler.report_error_message ("! [Error] In module '"+ name +"'%NReference column for '"+
						parameters_cursor.item.name + "' not found => " + 
						parameters_cursor.item.reference_column.table + "." + parameters_cursor.item.reference_column.column
					)
					end
				end				
			else
				--| Error : number of declared parameters not the same as query parameters
					a_error_handler.report_error_message ("! [Error] In module '"+ name +
					"'%NNumber of declared parameters does not match number of SQL parameters")
			end
		end

	check_query (query_statement : ECLI_STATEMENT; session : ECLI_SESSION; a_error_handler : UT_ERROR_HANDLER) is
			-- 
		require
			query_statement_not_void: query_statement /= Void
			a_error_handler_not_void: a_error_handler /= Void
		local
			cs : DS_SET_CURSOR[MODULE_PARAMETER]
			factory : QA_VALUE_FACTORY
		do
			create factory.make
			is_query_valid := False
			query_statement.set_sql (query)
			query_statement.prepare
			if query_statement.is_ok then
				if parameters.count = 0 or else (parameters.count = query_statement.parameter_names.count and then parameters.has_samples) then
					if session.is_transaction_capable then
						-- create parameters
						from
							cs := parameters.new_cursor
							cs.start
						until
							cs.off
						loop
							-- créer paramètre
							factory.create_value_from_sample (cs.item.sample)
							query_statement.put_parameter (factory.last_result, cs.item.name)
							cs.forth
						end
						
						-- begin transaction
						session.begin_transaction
						-- try query
						if query_statement.parameters_count > 0 then
							query_statement.bind_parameters
						end
						query_statement.execute
						if query_statement.is_ok then
							is_query_valid := True
						else
							a_error_handler.report_error_message ("! [Error] "+query_statement.diagnostic_message)
						end
						-- rollback
						session.rollback
					end
				else
					is_query_valid := True
					a_error_handler.report_warning_message ("! [Warning] Statement '"+name+"' has been *prepared* successfully;%N   unfortunately statement preparation does not catch all SQL errors.")
				end
			else
				a_error_handler.report_error_message ("! [Error] SQL Statement not valid : %N" +
					query + "%N" + query_statement.diagnostic_message + "%N") 
			end
			is_checked_query := True
		ensure
			is_checked_query: is_checked_query
		end
	
--	query_statement : ECLI_STATEMENT
--	query_session : ECLI_SESSION

invariant
	name_not_void: name /= Void
	query_not_void: query /= Void
--	parameters_not_void: parameters /= Void

end -- class ACCESS_MODULE
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
