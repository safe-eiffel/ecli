note
	description: "Column sets (parameters or results) of an SQL access module."

	library: "Access_gen : Access Modules Generators utilities"

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COLUMN_SET[G->RDBMS_ACCESS_METADATA]

inherit
	DS_HASH_SET[G]
		rename
			make as make_set
		redefine
			same_equality_tester
		end

	RDBMS_ACCESS_ITEM
		undefine
			is_equal, copy
		end

feature {NONE}-- Initialization

	make (a_name : STRING)
			-- creation using `a_name'
		require
			a_name_not_void: a_name /= Void
		do
			name := a_name
			make_set (initial_size)
			set_equality_tester (create {KL_EQUALITY_TESTER [like item]})
			enable_generatable
		ensure
			name_set: name = a_name
			generatable: is_generatable
		end

	make_with_parent_name (a_name : STRING; a_parent_name : STRING)
			-- creation using `a_name' and `a_parent_name'
		require
			a_name_not_void: a_name /= Void
			a_parent_name_not_void: a_parent_name /= Void
			name_and_parent_name_different: a_name /~ a_parent_name
		do
			parent_name := a_parent_name
			make (a_name)
		ensure
			name_set: name = a_name
			parent_name_set: parent_name = a_parent_name
			generatable: is_generatable
		end

feature -- Access

	type : STRING
			--
		do
			if parent_name /= Void and then local_items /= Void and then local_items.count = 0 then
				Result := parent_name
			else
				Result := name
			end
		end

	name : STRING

	parent_name : STRING

	parent : PARENT_COLUMN_SET[G]

	local_items : DS_HASH_SET [G]
		-- local items : difference between Current and parent

	final_set_name : STRING
			--
		do
			if parent /= Void and then local_items /= Void and then local_items.count = 0 then
				Result := parent.name
			else
				Result := name
			end
		end

	eiffel_signature : STRING
			--
		local
			cursor : like new_cursor
		do
			create Result.make (count * 10)
			from
				cursor := new_cursor
				cursor.start
			until
				cursor.off
			loop
				Result.append_string (item_eiffel_name (cursor.item))
				Result.append_string (" : ")
				Result.append_string (item_eiffel_type (cursor.item))
				cursor.forth
				if not cursor.off then
					Result.append_string (";")
				end
			end
		end

	item_for_name (a_name : STRING) : G
			-- item whose name is `a_name'
		require
			a_name_not_void: a_name /= Void
		local
			c : like new_cursor
		do
			from
				c := new_cursor
				c.start
			until
				c.off or else c.item.name.is_equal (a_name)
			loop
				c.forth
			end
			if not c.off then
				Result := c.item
				c.finish
			end
		end

feature -- Status report

	is_generatable : BOOLEAN

	is_flattened : BOOLEAN

	same_equality_tester (other: DS_SEARCHABLE [G]) : BOOLEAN
		do
			Result := True
		end

feature -- Status setting

	enable_generatable
		do
			is_generatable := True
		end

	disable_generatable
		do
			is_generatable := False
		end

feature -- Element change

	set_parent (a_parent : like parent)
			-- set `parent' to `a_parent'
		require
			a_parent_not_void: a_parent /= Void
			no_parent_yet: parent = Void
			parent_name_equal: parent_name /= Void implies parent_name.is_equal(a_parent.name)
		do
			parent := a_parent
			if parent_name = Void then
				parent_name := parent.name
			end
		ensure
			parent_set : parent = a_parent
		end

	set_name (a_name : like name)
			-- set `name' to `a_name'
		require
			a_name_not_void: a_name /= Void
		do
			name := a_name
		ensure
			name_set: name = a_name
		end

	set_parent_name (a_parent_name : like parent_name)
			-- set `parent_name' to `a_parent_name'
		require
			a_parent_name_not_void: a_parent_name /= Void
		do
			parent_name := a_parent_name
		ensure
			parent_name_set: parent_name = a_parent_name
		end

feature -- Conversion

	as_set_name : DS_SET [STRING]
			-- Set constituted with the names of the parameters
		local
			cursor : DS_SET_CURSOR[G]
			equality : KL_EQUALITY_TESTER[STRING]
		do
			create equality
			create {DS_HASH_SET[STRING]}Result.make (count)
			Result.set_equality_tester (equality)
			from
				cursor := new_cursor
				cursor.start
			until
				cursor.off
			loop
				Result.put (cursor.item.name)
				cursor.forth
			end
		ensure
			result_not_void: Result /= Void
			same_count: Result.count = count
		end

feature -- Basic operations

	flatten
			-- flatten so that columns of parent set are included in current set
		do
			if not is_flattened then
				if parent /= Void then
					check
						parent_flattened: parent.is_flattened
					end --parent.flatten
					merge (parent)
					local_items := subtraction (parent)
				end
				is_flattened := True
			end
		ensure
			is_flattened: is_flattened
			local_items_when_parent_not_void: parent /= Void implies local_items /= Void
		end

feature {NONE} -- Implementation

	initial_size : INTEGER = 5

	item_eiffel_name (an_item : G) : STRING
			--
		require
			an_item_not_void: an_item /= Void
		deferred
		ensure
			result_not_void: Result /= Void
		end

	item_eiffel_type (an_item : G) : STRING
			--
		require
			an_item_not_void: an_item /= Void
		deferred
		ensure
			result_not_void: Result /= Void
		end

invariant

	name_not_void: name /= Void
	name_meaningful: name.count > 2

end -- class COLUMN_SET
--
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
