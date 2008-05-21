indexing

	description:
	
			"Objects that iterate over installed data sources."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DATA_SOURCES_CURSOR

inherit

	ECLI_SHARED_ENVIRONMENT

	ECLI_HANDLE

	ECLI_STATUS
		export
			{ANY} Sql_fetch_first, Sql_fetch_first_user, Sql_fetch_first_system
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
			-- is there no valid item at cursor position ?
		do
			Result := before or after
		end

	before : BOOLEAN
			-- is cursor before any valid item ?

	after : BOOLEAN
			-- is cursor after any valid item ?

	is_user_datasources : BOOLEAN
			-- is this a cursor on user datasources ?

	is_system_datasources : BOOLEAN
			-- is this a cursor on system datasources ?

	is_all_datasources : BOOLEAN
			-- is this a cursor on all datasources ?

feature -- Status setting

feature -- Cursor movement

	start is
			-- advance cursor on first position if any
		require
			is_off: off
		do
			before := False
			after := False
			create c_name.make (max_source_name_length + 1)
			create c_description.make (max_source_description_length + 1)
			create actual_name_length.make
			create actual_description_length.make
			item_ := Void
			do_fetch (fetch_first_operation)
		ensure
			not_before: not before
		end

	forth is
			-- advance cursor on the next position if any
		require
			not_off: not off
		do
			do_fetch (Sql_fetch_next)
		ensure
			off_is_after: off implies after
		end

feature -- Basic operations

	close is
			-- close cursor
		do
			--| do nothing; defined just to be consistent with other cursors
		end

feature {ECLI_DATA_SOURCE} -- Implementation

	name : STRING
	description : STRING
	
	c_name : XS_C_STRING
	c_description : XS_C_STRING

	actual_name_length : XS_C_INT32
	actual_description_length : XS_C_INT32

feature {NONE} -- Implementation

	release_handle is do end

	disposal_failure_reason : STRING is once Result := "" end

	is_ready_for_disposal : BOOLEAN is do Result := True end

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER  is
			-- to be redefined in descendant classes
		do
			Result := ecli_c_environment_error (Shared_environment.handle, record_index, state, native_error, message, buffer_length, length_indicator)
		end

	do_fetch (direction : INTEGER) is
			-- actual external query
		do
			set_status (ecli_c_get_datasources (Shared_environment.handle, direction, c_name.handle, max_source_name_length, actual_name_length.handle, c_description.handle, max_source_description_length, actual_description_length.handle))
			if is_ok and then not is_no_data then
				name := c_name.as_string
				description := c_description.as_string
				create item_.make (Current)
			else
				item_ := Void
				after := True
			end
		end

	item_ : ECLI_DATA_SOURCE

	max_source_name_length : INTEGER is 100
	max_source_description_length : INTEGER is 300

invariant
	invariant_clause: True -- Your invariant here

end
