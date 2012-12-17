note

	description:
		"[
			Cursors over SQL query result set.
			Feature `start' executes the query (`sql' synonym of `definition'), then fetches the first row if any
			Starting iteration creates `results' object through `create_buffers'.
		]"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_CURSOR

inherit

	ECLI_QUERY
		redefine
			real_execution,
			initialize
		end

feature -- Status report

	real_execution : BOOLEAN
		do
			Result := True
		end


feature -- Cursor movement

	start
			-- Start sweeping through cursor, after execution of `sql'
		require
			sql_set: sql /= Void --FIXME: VS-DEL
			parameters_set: parameters_count > 0 implies (parameters.count = parameters_count)
		local
			must_start: BOOLEAN
		do

			if not is_executed then
				if parameters_count > 0 and then not bound_parameters then
					bind_parameters
				end
				execute
				must_start := True
			else
				if not off then
					go_after
				end
				if after then
					if parameters_count > 0 and then not bound_parameters then
						bind_parameters
					end
					execute
					must_start := True
				else
					must_start := True
				end
			end
			if is_ok then
				if must_start and then has_result_set then
					create_buffers
					statement_start
				end
			end
		ensure
--FIXME			result_set_created_if_executed: (is_executed and then has_result_set) implies (results.count = result_columns_count and then not array_routines.has (results, Void))
			not_before_if_executed: (is_executed and then has_result_set) implies not before
--			is_executed_implies_is_ok: is_executed implies is_ok
---			consistent_cursor_state: is_executed implies ((has_result_set implies not before) or (not has_result_set implies after))
		end

feature {NONE} -- Implementation

	initialize
		do
--			create_buffers
		end

	create_buffers
			-- create all ECLI_VALUE objects
		deferred
		ensure
			results_set: results /= Void
		end

end

