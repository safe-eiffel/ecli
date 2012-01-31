indexing
	description: "RDBMS Accesses: one access encapsulates one database DML query."

	library: "Access_gen : Access Modules Generators utilities"

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	RDBMS_ACCESS

inherit
	SHARED_SCHEMA_NAME
	SHARED_CATALOG_NAME
	SHARED_MAXIMUM_LENGTH

	RDBMS_ACCESS_ITEM

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
			create type.make_from_string ("extended")
		ensure
			name_assigned: name.is_equal (a_name)
			query_assigned: query.is_equal (a_query)
			type_extended: type.is_extended
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

	is_generatable : BOOLEAN

	is_prepared: BOOLEAN

	is_error : BOOLEAN

	is_validity_checked : BOOLEAN

	is_query_valid : BOOLEAN
			-- is query executable ?

	is_checked_query_trial : BOOLEAN
			-- has the query been tried for validity?

	is_checked_query_prepare : BOOLEAN
			-- has the query been checked for preparation ?

	is_parameters_valid : BOOLEAN
			-- are the parameters valid ?

	is_results_valid : BOOLEAN
			-- are the results valid ?

	is_valid : BOOLEAN is
			-- is this query valid ?
		require
			is_validity_checked: is_validity_checked
		do
			Result := is_query_valid and then is_parameters_valid and then is_results_valid
		ensure
			definition: Result = (is_query_valid and then is_parameters_valid and then is_results_valid)
		end

	has_result_set : BOOLEAN is
			-- is this a query (if not, it is a command/modifying statement) ?
		require
			is_query_valid: is_query_valid
		do
			Result := results /= Void
		end

feature -- Status setting

	check_validity (a_session : ECLI_SESSION; a_error_handler : QA_ERROR_HANDLER; reasonable_maximum_size : INTEGER) is
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
			is_query_valid := False
			query_statement.set_sql (query)
			prepare_query (query_statement, a_error_handler)
			if query_statement.is_ok then
				check_parameters (query_statement, query_session, a_error_handler, reasonable_maximum_size)
				if is_parameters_valid then -- and is_results_valid then
					try_query (query_statement, a_session, a_error_handler)
				end
				describe_result_set (query_statement, a_error_handler, reasonable_maximum_size)
			end
			is_validity_checked := True
			query_statement.close
		ensure
			is_validity_checked: is_validity_checked
		end

	enable_generatable
		do
			is_generatable := True
		end

	disable_generatable
		do
			is_generatable := False
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

	create_results is
		do
			create results.make (name+ default_name_prefix)
		ensure
			results_not_void: results /= Void
			results_name_definition: results.name.is_equal (name + default_name_prefix)
		end

feature -- Constants

	default_name_prefix : STRING is "_RESULTS"

feature {EVTK_EDITOR, ACCESS_MODULE} -- Element change

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

	describe_result_set (query_statement : ECLI_STATEMENT; a_error_handler : QA_ERROR_HANDLER; reasonable_maximum_size : INTEGER) is
			--
		require
			a_error_handler_not_void: a_error_handler /= Void
			checked_query_prepare: is_checked_query_prepare
			query_statement_valid: query_statement.is_valid
		local
			index : INTEGER
			current_result : RDBMS_ACCESS_RESULT
			current_description : ECLI_COLUMN_DESCRIPTION
		do
			is_results_valid := True
			if query_statement.has_result_set then
				query_statement.describe_results
				if results = Void then
					create_results
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
							a_error_handler.report_column_length_truncated (name, current_description.name, maximum_length, False)
						else
							a_error_handler.report_column_length_too_large (name, current_description.name, current_description.size, False)
						end
						create current_result.make(current_description, maximum_length)
					else
						create current_result.make(current_description, current_description.size)
					end
					if results.has (current_result) then
						a_error_handler.report_already_exists (results.name, current_result.name, "result column")
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
			results_void_if_no_result_set: results = Void implies not query_statement.has_result_set
			results_count: results /= Void implies results.count = query_statement.results_description.count
		end

	check_parameters (query_statement : ECLI_STATEMENT; query_session : ECLI_SESSION; a_error_handler : QA_ERROR_HANDLER; reasonable_maximum_size : INTEGER) is
			--| Check if declared parameters are the same as statement parameters
		require
			a_error_handler_not_void: a_error_handler /= Void
			checked_query_prepare: is_checked_query_prepare
			query_statement_valid: query_statement.is_valid
		local
			sql_parameters : DS_HASH_SET [STRING]
			symdif : DS_SET [STRING]
			parameter_set_names : DS_SET [STRING]
			undefined_parameters : DS_SET [STRING]
			unknown_parameters : DS_SET [STRING]
			cursor_string : DS_SET_CURSOR [STRING]
			parameters_cursor : DS_SET_CURSOR[RDBMS_ACCESS_PARAMETER]
			tester : KL_EQUALITY_TESTER [STRING]
			l_catalog, l_schema : STRING
			l_parameter_names : DS_LIST[STRING]
			new_parameters_capacity : INTEGER
		do
			create sql_parameters.make (10)
			sql_parameters.set_equality_tester (create {KL_EQUALITY_TESTER[STRING]})
			l_parameter_names := query_statement.parameter_names
			new_parameters_capacity := sql_parameters.count + l_parameter_names.count
			if sql_parameters.capacity < new_parameters_capacity then
				sql_parameters.resize (new_parameters_capacity)
			end
			sql_parameters.extend (l_parameter_names)
			parameter_set_names := parameters.as_set_name
			symdif := sql_parameters.symdifference (parameter_set_names)
			undefined_parameters := symdif.intersection (sql_parameters)
			unknown_parameters := symdif.intersection (parameter_set_names)
			--| same number
			is_parameters_valid := (query_statement.parameter_names.count = parameters.count)
			if not is_parameters_valid then
				--| Error : number of declared parameters not the same as query parameters
				a_error_handler.report_parameter_count_mismatch (name)
			else
				--| same names	?		
				is_parameters_valid := is_parameters_valid and undefined_parameters.count = 0
				if not is_parameters_valid then
					from
						cursor_string := undefined_parameters.new_cursor
						cursor_string.start
					until
						cursor_string.off
					loop
						a_error_handler.report_parameter_not_described (name, cursor_string.item)
						cursor_string.forth
					end
				else
					--| check for parameter reference columns
					from
						parameters_cursor := parameters.new_cursor
						parameters_cursor.start
						create tester
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
						a_error_handler.report_invalid_reference_column (name, parameters_cursor.item.name, parameters_cursor.item.reference_column.table, parameters_cursor.item.reference_column.column)
					end
				end
			end
			-- Report unknown parameters
			if unknown_parameters.count > 0 then
				from
					cursor_string := unknown_parameters.new_cursor
					cursor_string.start
				until
					cursor_string.off
				loop
					a_error_handler.report_parameter_unknown (name, cursor_string.item)
					cursor_string.forth
				end
			end
		end

	prepare_query (query_statement : ECLI_STATEMENT; a_error_handler : QA_ERROR_HANDLER) is
			-- prepare `query_statement'
		require
			query_statement_not_void: query_statement /= Void
			a_error_handler_not_void: a_error_handler /= Void
		do
			query_statement.prepare
			if not query_statement.is_ok then
				a_error_handler.report_prepare_query_failed (query_statement.sql, query_statement.diagnostic_message,name)
			end
			is_checked_query_prepare := True
		ensure
			is_checked_query_prepare: is_checked_query_prepare
		end

	try_query (query_statement : ECLI_STATEMENT; session : ECLI_SESSION; a_error_handler : QA_ERROR_HANDLER) is
			--
		require
			query_statement_not_void: query_statement /= Void
			a_error_handler_not_void: a_error_handler /= Void
		local
			cs : DS_SET_CURSOR[RDBMS_ACCESS_PARAMETER]
			factory : QA_VALUE_FACTORY
			parameters_put : INTEGER
			tracer : ECLI_TRACER
			sample_value : QA_VALUE
			paramet_metadata : RDBMS_ACCESS_PARAMETER
		do
			create tracer.make (a_error_handler.warning_file)
			create factory.make
			if query_statement.is_ok and then query_statement.is_prepared then
				if parameters.count = 0 or else (parameters.count = query_statement.parameter_names.count and then parameters.has_samples) then
					if session.is_transaction_capable then
						-- create parameters
						from
							cs := parameters.new_cursor
							cs.start
						until
							cs.off or else is_error
						loop
							if query_statement.has_parameter (cs.item.name) then
								-- créer paramètre
								factory.create_value_from_sample (cs.item.sample)
								if factory.last_error /= Void then
									is_error := True
									a_error_handler.report_could_not_create_parameter (name, cs.item.name, factory.last_error)
								else
									sample_value := factory.last_result
									parameter_metadata := cs.item
									check_sample_type (parameter_metadata, sample_value, a_error_handler)
									query_statement.put_parameter (factory.last_result, cs.item.name)
									parameters_put := parameters_put + 1
								end
							else
								is_error := True
								a_error_handler.report_parameter_unknown (name, cs.item.name)
							end
							cs.forth
						end
						if not is_error and then parameters_put = query_statement.parameter_names.count then
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
								a_error_handler.report_query_execution_failed (query_statement.sql, query_statement.diagnostic_message, name)
								query_statement.trace (tracer)
								is_error := True
							end
							-- rollback
							session.rollback
						end
					end
				else
					is_query_valid := True
					a_error_handler.report_query_only_prepared (name)
				end
			else
				a_error_handler.report_query_execution_failed (query_statement.sql, query_statement.diagnostic_message, name)
			end
			is_checked_query_trial := True
		ensure
			is_checked_query_trial: is_checked_query_trial
			error_or_success: is_error xor is_query_valid
		end

	check_sample_type (a_parameter : RDBMS_ACCESS_PARAMETER; sample_data : QA_VALUE; an_error_handler: QA_ERROR_HANDLER)
		local
			error : BOOLEAN
		do
			if a_parameter.metadata_available then
				inspect a_parameter.metadata.type_code
				when {ECLI_TYPE_CONSTANTS}.sql_type_date then
					if sample_data.sql_type_code /= {ECLI_TYPE_CONSTANTS}.sql_type_date then
					else
						error := True
					end
				when {ECLI_TYPE_CONSTANTS}.sql_type_time then
					if sample_data.sql_type_code = {ECLI_TYPE_CONSTANTS}.sql_type_time then
					else
						error := True
					end
				when {ECLI_TYPE_CONSTANTS}.sql_type_timestamp then
					if sample_data.sql_type_code = {ECLI_TYPE_CONSTANTS}.sql_type_date or else sample_data.sql_type_code = {ECLI_TYPE_CONSTANTS}.sql_type_timestamp then
					else
						error := True
					end
				else
				end
				if error then
					an_error_handler.report_parameter_type_mismatch (name, a_parameter.name, a_parameter.ecli_type, sample_data.ecli_type)
				end
			end
		end

invariant
	name_not_void: name /= Void
	query_not_void: query /= Void
--	parameters_not_void: parameters /= Void

end -- class ACCESS_MODULE
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
