indexing
	description: "Objects that represent an Eiffel code class"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Eiffel Code Generator"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	EIFFEL_CLASS

inherit

	EIFFEL_CODE

creation

	make

feature -- Initialization

	make (class_name: like name) is
			-- Create new code class with 'name'
		require
			class_name_exists: class_name /= Void
		do
			set_name (class_name)
			create indexing_clauses.make			
			create parents.make
			create creation_procedure_names.make
			create feature_groups.make
			create invariants.make
		end

feature -- Access

	name: STRING
			-- Class name

	indexing_clauses: DS_LINKED_LIST [STRING]
			-- Indexing clauses
			
	parents: DS_LINKED_LIST [STRING]
			-- Class parents

	creation_procedure_names: DS_LINKED_LIST [STRING]
			-- Creation procedure names

	feature_groups: DS_LINKED_LIST [EIFFEL_FEATURE_GROUP]
			-- Feature groups

	invariants : DS_LINKED_LIST [DS_PAIR[STRING, STRING]]
	
feature -- Status report

	is_deferred : BOOLEAN
			-- is this a deferred class ?
			
feature -- Status setting

	set_name (new_name: like name) is
			-- Set the class name
		require
			new_name_exists: new_name /= Void
		do
			name := new_name
		end

	add_indexing_clause (new_indexing: STRING) is
			-- Add 'new_indexing' as an indexing clause for this class
		require
			new_clause_exists: new_indexing /= Void
		do
			indexing_clauses.force_last (new_indexing)
		end
	
	add_parent (new_parent: STRING) is
			-- Add 'new_parent' to parents
		require
			new_parent_exists: new_parent /= Void
		do
			parents.force_last (new_parent)
		end

	add_creation_procedure_name (new_name: STRING) is
			-- Add 'new_name' as the name of a creation procedure.
		require
			new_name_exists: new_name /= Void
		do
			creation_procedure_names.force_last (new_name)
		end

	add_feature_group (new_group: EIFFEL_FEATURE_GROUP) is
			-- Add 'new_group' to the feature groups of this class.
		require
			new_group_exists: new_group /= Void
		do
			feature_groups.force_last (new_group)
		end

	add_invariant (new_invariant_clause : DS_PAIR[STRING,STRING]) is
			-- Add `new_invariant_clause' to the invariants of this class.
		require
			new_invariant_clause_exists: new_invariant_clause /= Void
			invariant_parts_exist: new_invariant_clause.first /= Void and then new_invariant_clause.second /= Void
			invariant_parts_significatn: not (new_invariant_clause.first.is_empty or new_invariant_clause.second.is_empty)
		do
			invariants.put_last (new_invariant_clause)
		end
		
	set_deferred is
			-- set this a deferred class
		do
			is_deferred := True
		ensure
			is_deferred
		end
		
feature -- Basic operations

	write (output: KI_TEXT_OUTPUT_STREAM) is
			-- Print source code representation of this class
		do
			if not indexing_clauses.is_empty then
				write_indexing (output)			
			end
			write_header (output)
			if not parents.is_empty then	
				write_parents (output)
			end
			if not creation_procedure_names.is_empty then
				write_creation_names (output)
			end
			if not feature_groups.is_empty then
				write_feature_groups (output)
			end
			if not invariants.is_empty then
				write_invariants (output)
			end
			write_end (output)
		end

feature {NONE} -- Implementation

	write_indexing (output: KI_TEXT_OUTPUT_STREAM) is
		do
			output.put_string ("indexing")
			output.put_new_line
			output.put_new_line
			from
				indexing_clauses.start
			until
				indexing_clauses.off
			loop
				output.put_string ("%T" + indexing_clauses.item_for_iteration)
				output.put_new_line
				indexing_clauses.forth
			end
			output.put_new_line			
		end
	
	write_header (output: KI_TEXT_OUTPUT_STREAM) is
		do
			if is_deferred then
				output.put_string ("deferred ")
			end
			output.put_string ("class " + name)
			output.put_new_line
			output.put_new_line
		end

	write_parents (output: KI_TEXT_OUTPUT_STREAM) is
		do
			output.put_string ("inherit")
			output.put_new_line
			output.put_new_line
			from
				parents.start
			until
				parents.off
			loop
				output.put_string ("%T" + parents.item_for_iteration)
				output.put_new_line
				parents.forth
			end
			output.put_new_line
		end

	write_creation_names (output: KI_TEXT_OUTPUT_STREAM) is
		do
			output.put_string ("creation")
			output.put_new_line
			output.put_new_line
			from
				creation_procedure_names.start
			until
				creation_procedure_names.off
			loop
				output.put_string ("%T" + creation_procedure_names.item_for_iteration)
				if not creation_procedure_names.is_last then
					output.put_string (", ")
				else
					output.put_new_line
				end
				creation_procedure_names.forth
			end
			output.put_new_line
		end

	write_feature_groups (output: KI_TEXT_OUTPUT_STREAM) is
		do
			from
				feature_groups.start
			until
				feature_groups.off
			loop
				feature_groups.item_for_iteration.write (output)
				feature_groups.forth
			end
		end

	write_invariants (output: KI_TEXT_OUTPUT_STREAM) is
		do
			output.put_string ("invariant")
			output.put_new_line
			output.put_new_line
			from
				invariants.start
			until
				invariants.off
			loop
				output.put_string ("%T")
				output.put_string (invariants.item_for_iteration.first)
				output.put_string (": ")
				output.put_string (invariants.item_for_iteration.second)
				invariants.forth
				output.put_new_line
			end
			output.put_new_line
		end

	write_end (output: KI_TEXT_OUTPUT_STREAM) is
		do
			output.put_string ("end -- class " + name)
			output.put_new_line
		end

invariant

	name_exists: name /= Void
	parents_exists: parents /= Void
	creation_procedure_names_exists: creation_procedure_names /= Void
	feature_groups_exist: feature_groups /= Void

end -- class EIFFEL_CLASS
