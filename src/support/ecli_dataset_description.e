indexing
	description: "Summary description for {ECLI_DATASET_DESCRIPTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_DATASET_DESCRIPTION

create
	make_for_parameters,
	make_for_results

feature {NONE} -- Initialization

	make_for_parameters (a_stmt : ECLI_STATEMENT)
			-- Make for describing `a_stmt' parameters.
		require
			a_stmt_not_void: a_stmt /= Void
			a_stmt_prepared: a_stmt.is_prepared
		local
			names_cursor : DS_LIST_CURSOR [STRING]
			index_cursor : DS_LIST_CURSOR [INTEGER]
			l_parameter_name : STRING
			l_index : INTEGER
			l_description : like item
			l_name : STRING
		do
			create_implementation (a_stmt.parameters_count)
			a_stmt.describe_parameters
			-- Setup name for each index
			from
				names_cursor := a_stmt.parameter_names.new_cursor
				names_cursor.start
			until
				names_cursor.after
			loop
				l_parameter_name := names_cursor.item
				from
					index_cursor := a_stmt.parameter_positions (l_parameter_name).new_cursor
					index_cursor.start
				until
					index_cursor.after
				loop
					table_by_index.put (l_parameter_name, index_cursor.item)
					index_cursor.forth
				end
				names_cursor.forth
			end
			-- Setup parameter for each name.
			from
				l_index := a_stmt.parameters_description.lower

			until
				l_index > a_stmt.parameters_description.upper
			loop
				l_description := a_stmt.parameters_description.item (l_index)
				l_name := table_by_index.item (l_index)
				table_by_name.force (l_description, l_name)
				l_index := l_index + 1
			end
		end

	make_for_results (a_stmt : ECLI_STATEMENT)
		require
			a_stmt_not_void: a_stmt /= Void
			a_stmt_executed_or_prepared: a_stmt.is_prepared or else a_stmt.is_executed
			a_stmt_has_result_set: a_stmt.has_result_set
		local
			l_index: INTEGER
			l_name : STRING
			l_item : ECLI_COLUMN_DESCRIPTION
		do
			create_implementation (a_stmt.result_columns_count)
			a_stmt.describe_results
			from
				l_index := a_stmt.results_description.lower
			until
				l_index > a_stmt.results_description.upper
			loop
				l_item := a_stmt.results_description.item (l_index)
				l_name := l_item.name
				-- Associate index to name
				table_by_index.put (l_name, l_index)
				-- Associate item to name
				table_by_name.force (l_item, l_name)
				l_index := l_index + 1
			end
		end

feature -- Access

	name (an_index : INTEGER) : STRING
			-- name of column at `an_index'.
		require
			an_index_within_bounds: index_within_bounds (an_index)
		do
			Result := table_by_index.item (an_index)
		ensure
			name_not_void: Result /= Void
		end

	item (an_index : INTEGER) : ECLI_DATA_DESCRIPTION
			-- Description for `an_index'
		require
			an_index_within_bounds: index_within_bounds (an_index)
		do
			Result := table_by_name.item (name (an_index))
		ensure
			item_not_void: Result /= Void
		end

	item_by_name (a_name : STRING) : ECLI_DATA_DESCRIPTION
			-- Description for `a_name'.
		require
			a_name_not_void: a_name /= Void
			has_name: has_name (a_name)
		do
			Result := table_by_name.item (a_name)
		ensure
			item_by_name_not_void: Result /= Void
		end

feature -- Measurement

	count : INTEGER
			-- Number of columns.
		do
			Result := table_by_index.count
		end

	lower : INTEGER
		do
			Result := table_by_index.lower
		end

	upper : INTEGER
		do
			Result := table_by_index.upper
		end

feature -- Status report

	has_name (a_name : STRING) : BOOLEAN
			-- Has dataset a column with `a_name'?
		do

		end

	index_within_bounds (an_index : INTEGER) : BOOLEAN
			-- Is `an_index' within bounds?
		do
			Result := lower >= an_index and an_index <= upper
		end

feature {} -- Implementation

	create_implementation (n : INTEGER)
		do
			create table_by_name.make (n)
			create table_by_index.make (1,n)
		end

	table_by_name : DS_HASH_TABLE[like item, STRING]

	table_by_index: ARRAY[STRING]
			-- Names of parameter by index

end
