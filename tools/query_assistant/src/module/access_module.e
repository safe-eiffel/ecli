note
	description: "Classes that group persistency accesses for a single class/concept."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCESS_MODULE

create
	make, make_from_tables

feature {} -- Initialization

	make
		do
			create accesses.make (10)
			create parameter_sets.make (10)
			create result_sets.make (10)
			create parameter_map.make (10)
		end

	make_from_tables (the_accesses : DS_HASH_TABLE [RDBMS_ACCESS, STRING]; the_parameter_sets : DS_HASH_TABLE[PARAMETER_SET, STRING]; the_result_sets : DS_HASH_TABLE[RESULT_SET, STRING]; the_parameter_map : PARAMETER_MAP)
			-- create for `accesses', `the_parameter_sets', `the_result_sets', `the_parameter_map'.
		require
			the_accesses_not_void: the_accesses /= Void
			the_parameter_sets_not_void: the_parameter_sets /= Void
			the_result_sets_not_void: the_result_sets /= Void
		do
			accesses := the_accesses
			parameter_sets := the_parameter_sets
			result_sets := the_result_sets
			parameter_map := the_parameter_map
		ensure
			accesses_set: accesses = the_accesses
			parameter_sets_set: parameter_sets = the_parameter_sets
			result_sets_set: result_sets = the_result_sets
			parameter_map_set: parameter_map = the_parameter_map
		end

feature -- Access

	accesses : DS_HASH_TABLE [RDBMS_ACCESS, STRING]

	parameter_sets: DS_HASH_TABLE[PARAMETER_SET, STRING]

	result_sets : DS_HASH_TABLE[RESULT_SET, STRING]

	parameter_map : PARAMETER_MAP

feature -- Status report

	has (access_name : STRING) : BOOLEAN
			-- Does the module contain an access whose name is `access_name' ?
		require
			access_name_not_void: access_name /= Void
		do
			Result := accesses.has (access_name)
		end

	has_access (access : RDBMS_ACCESS) : BOOLEAN
			-- Does the module contain `access' ?
		require
			access_not_void: access /= Void
		do
			Result := accesses.has_item (access)
		end

feature -- Element change

	change_access_name (original_name, new_name : attached STRING)
			-- Change access from `original_name' to `new_name'
		require
			has_original_name: has (original_name)
		local
			l_access: RDBMS_ACCESS
		do
			l_access := accesses.item (original_name)
			l_access.set_name (new_name)
			accesses.remove (original_name)
			accesses.force (l_access, new_name)
		ensure
			same_module: accesses.item (new_name) = old (accesses.item (original_name))
			old_name_deleted: not has (original_name)
			new_name_inserted: has (new_name)
		end

	put (access : RDBMS_ACCESS)
			-- Put `access' into `accesses'.
		require
			access_not_void: access /= Void
			not_has_access_access: not has_access (access)
			not_has_access_name: not has (access.name)
		do
			accesses.put (access, access.name)
		ensure
			has_access_access: has_access (access)
			has_access_name: has (access.name)
			inserted: accesses.item (access.name) = access
		end

invariant

	accesses_not_void: accesses /= Void
	parameter_sets_not_void: parameter_sets /= Void
	result_sets_not_void: result_sets /= Void
	-- consistency 1: foreach p in parameter_sets, there_exist a in access_modules where a.parameter_set = p
	-- consistency 2: foreach r in result_sets, there_exist a in access_modules where a.result_set = r
end
