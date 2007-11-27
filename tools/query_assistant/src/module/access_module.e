indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCESS_MODULE

create
	make, make_from_tables

feature {} -- Initialization

	make is
		do
			create accesses.make (10)
			create parameter_sets.make (10)
			create result_sets.make (10)
		end

	make_from_tables (the_accesses : DS_HASH_TABLE [RDBMS_ACCESS, STRING]; the_parameter_sets : DS_HASH_TABLE[PARAMETER_SET, STRING]; the_result_sets : DS_HASH_TABLE[RESULT_SET, STRING]; map : PARAMETER_MAP) is
			-- create for `accesses', `the_parameter_sets', `the_result_sets'
		require
			the_accesses_not_void: the_accesses /= Void
			the_parameter_sets_not_void: the_parameter_sets /= Void
			the_result_sets_not_void: the_result_sets /= Void
		do
			accesses := the_accesses
			parameter_sets := the_parameter_sets
			result_sets := the_result_sets
			parameter_map := map
		ensure
			accesses_set: accesses = the_accesses
			parameter_sets_set: parameter_sets = the_parameter_sets
			result_sets_set: result_sets = the_result_sets
			parameter_map_set: parameter_map = map
		end

feature -- Access

	accesses : DS_HASH_TABLE [RDBMS_ACCESS, STRING]

	parameter_sets: DS_HASH_TABLE[PARAMETER_SET, STRING]

	result_sets : DS_HASH_TABLE[RESULT_SET, STRING]

	parameter_map : PARAMETER_MAP

invariant

	accesses_not_void: accesses /= Void
	parameter_sets_not_void: parameter_sets /= Void
	result_sets_not_void: result_sets /= Void

end
