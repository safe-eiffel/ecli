indexing
	description: "Module parameter description by the user."

	library: "Access_gen : Access Modules Generators utilities"

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	RDBMS_ACCESS_PARAMETER

inherit
	RDBMS_ACCESS_METADATA
		redefine
			copy, is_equal
		end

	KL_IMPORTED_ANY_ROUTINES
		undefine
			is_equal, copy
		end

	HASHABLE
		undefine
			copy, is_equal
		end

	SHARED_COLUMNS_REPOSITORY
		undefine
			is_equal, copy
		end

create
	make, copy

feature {NONE} -- Initialization

	make (a_name: STRING; a_reference_column: REFERENCE_COLUMN; maximum_length : INTEGER) is
			-- Initialize `Current'.
		require
			a_name_not_void: a_name /= Void
			a_reference_column_not_void: a_reference_column /= Void
		do
			set_name (a_name)
			set_reference_column (a_reference_column)
			if maximum_length > 0 then
				maximum_length_impl := maximum_length
			end
		ensure
			name_assigned: name = a_name
			reference_column_assigned: reference_column = a_reference_column
			maximum_length_impl_assigned: maximum_length > 0 implies maximum_length_impl = maximum_length
			is_input: is_input
		end

feature -- Access

	reference_column: REFERENCE_COLUMN
			-- column with which 'Current' is related

	name: STRING

	metadata : ECLI_COLUMN

	sql_type_code : INTEGER is
			--
		do
			Result := metadata.type_code
		end

	size : INTEGER is
			--
		do
			if maximum_length_impl > 0 and then maximum_length_impl <= metadata.size then
				Result := maximum_length_impl
			else
				Result := metadata.size
			end
		end

	decimal_digits : INTEGER is
			--
		do
			Result := metadata.decimal_digits
		end

	sample : STRING

feature -- Measurement

feature -- Status report

	metadata_available : BOOLEAN is
			--
		do
			Result := metadata /= Void
		end

	is_valid : BOOLEAN

	has_sample : BOOLEAN is do Result := sample /= Void end

	is_input : BOOLEAN is
			-- Is this an input parameter?
		do
			Result:= direction = c_input_explicit or else direction = c_input_implicit
		end

	is_input_explicit : BOOLEAN
			-- Is this an explicit input parameter?
		do
			Result := direction = c_input_explicit
		end

	is_output : BOOLEAN is
			-- Is this an output parameter?
		do
			Result:= direction = c_output
		end

	is_input_output : BOOLEAN is
			-- Is this an input-output parameter?
		do
			Result:= direction = c_input_output
		end

feature -- Status setting

--	check_validity (a_session : ECLI_SESSION; a_catalog_name, a_schema_name : STRING) is
--				-- check validity of module wrt `a_session', using metadata in (`a_catalog_name', `a_schema_name')
--			require
--				a_session_not_void: a_session /= Void
--				a_session_connected: a_session.is_connected
--			local
--				cursor : ECLI_COLUMNS_CURSOR
--				nm : ECLI_NAMED_METADATA
--			do
--				create nm. make (a_catalog_name, a_schema_name, reference_column.table)
--				create cursor.make_query_column (nm,reference_column.column,a_session)
--				if cursor.is_ok then
--					cursor.start
--					if not cursor.off then
--						is_valid := True
--						metadata := cursor.item
--					else
--						is_valid := False
--						metadata := Void
--					end
--				else
--					is_valid := False
--					metadata := Void
--				end
--				cursor.close
--			ensure
--				valid_and_metadata: is_valid implies metadata /= Void
--			end

	check_validity (a_catalog_name, a_schema_name : STRING; error_handler : QA_ERROR_HANDLER; reasonable_maximum_size : INTEGER) is
				-- check validity of module wrt (`a_catalog_name', `a_schema_name')
			local
			do
				shared_columns_repository.search (a_catalog_name, a_schema_name, reference_column.table, reference_column.column)
				if shared_columns_repository.found then
					metadata := shared_columns_repository.last_column
					if size > reasonable_maximum_size then
						error_handler.report_column_length_too_large (
							" ",
							name,
							size,
							True)
					end
					is_valid := True
				else
					metadata := Void
					is_valid := False
				end
			ensure
				valid_and_metadata: is_valid implies metadata /= Void
			end

	enable_input is
		do
			direction := c_input_explicit
		ensure
			is_input: is_input
			is_input_explicit: is_input_explicit
		end

	enable_output is
		do
			direction := c_output
		ensure
			is_output: is_output
		end

	enable_input_output is
		do
			direction := c_input_output
		ensure
			is_input_output: is_input_output
		end

feature -- Element change

	set_sample (s : STRING) is
			--
		require
			s_not_void: s /= Void
			s_not_empty: not s.is_empty
		do
			sample := s
		ensure
			sample_set: sample = s
		end

feature {EVTK_EDITOR} -- Element change

	set_reference_column (a_reference_column: REFERENCE_COLUMN) is
			-- Set `reference_column' to `a_reference_column'.
		require
			a_reference_column_not_void: a_reference_column /= Void
		do
			reference_column := a_reference_column
		ensure
			reference_column_assigned: reference_column = a_reference_column
		end

	set_name (a_name: STRING) is
			-- Set `name' to `a_name'.
		require
			a_name_not_void: a_name /= Void
		do
			name := a_name
		ensure
		end

feature -- Comparison

	is_equal (other : like Current) : BOOLEAN is
			-- is Current equal to `other' ?
		do
			if ANY_.same_types (Current, other) then
				Result := name.is_equal (other.name) and then reference_column.is_equal (other.reference_column)
			else
				Result := Precursor {RDBMS_ACCESS_METADATA} (other)
			end
		end

feature -- Duplication

	copy (other : like Current) is
			-- copy from `other'
		do
			create name.make_from_string (other.name)
			create reference_column.make (other.reference_column.table, other.reference_column.column)
			if other.metadata /= Void then
				metadata := other.metadata.twin
			end
			if other.sample /= Void then
				create sample.make_from_string (other.sample)
			end
		end

feature {NONE} -- Implementation

	maximum_length_impl : INTEGER

	direction : INTEGER

	c_input_implicit : INTEGER is 0
	c_input_explicit : INTEGER is 4
	c_output : INTEGER is 1
	c_input_output : INTEGER is 3

invariant
	name_not_void: name /= Void
	reference_column_not_void: reference_column /= Void

end -- class MODULE_PARAMETER
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
