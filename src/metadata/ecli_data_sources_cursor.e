indexing
	description: "Objects that iterate over data sources"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_DATA_SOURCES_CURSOR

inherit
	ECLI_SHARED_ENVIRONMENT

	ECLI_HANDLE

	ECLI_STATUS
		export
			{ANY} Sql_fetch_first, Sql_fetch_first_user, Sql_fetch_first_system
		undefine
			dispose
		end

	ECLI_EXTERNAL_TOOLS
		export
			{NONE} all
		undefine
			dispose
		end

	KL_IMPORTED_STRING_ROUTINES
	
creation
	make_all, make_user, make_system

feature {NONE} -- Initialization

	make_all is
			-- make cursor on 'all' datasources
		do
			fetch_first_operation := Sql_fetch_first
			is_all_datasources := True
			before := True
		ensure
			all_sources: is_all_datasources
			fetch_first: fetch_first_operation = Sql_fetch_first
			before: before
		end

	make_user is
			-- make cursor on 'user' datasources
		do
			fetch_first_operation := Sql_fetch_first_user
			is_user_datasources := True
			before := True
		ensure
			user_sources: is_user_datasources
			fetch_first: fetch_first_operation = Sql_fetch_first_user
			before: before
		end

	make_system is
			-- make cursor on 'system' datasources
		do
			fetch_first_operation := Sql_fetch_first_system
			is_system_datasources := True
			before := True
		ensure
			system_sources: is_system_datasources
			fetch_first: fetch_first_operation = Sql_fetch_first_system
			before: before
		end


feature -- Access

	item : ECLI_DATA_SOURCE is
			-- current item
		do
			Result := item_
		ensure
			definition: Result /= Void implies not off
		end

	fetch_first_operation : INTEGER
			-- operation code for fetching first source

feature -- Measurement

feature -- Status report

	off : BOOLEAN is
			--
		do
			Result := before or after
		end

	before : BOOLEAN

	after : BOOLEAN

	is_user_datasources : BOOLEAN

	is_system_datasources : BOOLEAN

	is_all_datasources : BOOLEAN

feature -- Status setting

feature -- Cursor movement

	start is
			--
		require
			is_off: off
		do
			before := False
			after := False
			name_buffer := STRING_.make (max_source_name_length + 1)
			description_buffer := STRING_.make (max_source_description_length + 1)
			item_ := Void
			do_fetch (fetch_first_operation)
		ensure
			not_before: not before
		end

	forth is
			--
		require
			not_off: not off
		do
			do_fetch (Sql_fetch_next)
		ensure
			off_is_after: off implies after
		end

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	close is
			-- close cursor
		do
			--| do nothing; defined just to be consistent with other cursors
		end

feature -- Obsolete

feature -- Inapplicable

feature {ECLI_DATA_SOURCE} -- Implementation

	name : STRING

	name_buffer : STRING
	description_buffer : STRING

	description : STRING

	actual_name_length : INTEGER

	actual_description_length : INTEGER

feature {NONE} -- Implementation

	release_handle is do end

	disposal_failure_reason : STRING is do Result :="" end

	is_ready_for_disposal : BOOLEAN is do Result := True end

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER  is
			-- to be redefined in descendant classes
		do
			set_status (ecli_c_environment_error (Shared_environment.handle, record_index, state, native_error, message, buffer_length, length_indicator))
		end

	do_fetch (direction : INTEGER) is
			--
		local
			c_name : C_STRING
			c_description : C_STRING
		do
			protect
			create c_name.make (max_source_name_length + 1)
			create c_description.make (max_source_description_length + 1)
			set_status (ecli_c_get_datasources (Shared_environment.handle, direction, c_name.handle, max_source_name_length, $actual_name_length, c_description.handle, max_source_description_length, $actual_description_length))
			if is_ok and then not is_no_data then
				name := pointer_to_string (c_name.handle)
				description := pointer_to_string (c_description.handle)
				!!item_.make (Current)
			else
				item_ := Void
				after := True
			end
			unprotect
		end

	item_ : ECLI_DATA_SOURCE

	max_source_name_length : INTEGER is 100
	max_source_description_length : INTEGER is 300

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_DATA_SOURCES_CURSOR
