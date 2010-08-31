indexing

	description:

		"Objects that iterate over installed ODBC drivers."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DRIVERS_CURSOR

inherit

	ECLI_SHARED_ENVIRONMENT

	ECLI_HANDLE

	ECLI_STATUS
		export
			{ANY} Sql_fetch_first
		end

	KL_IMPORTED_STRING_ROUTINES

create

	make

feature {NONE} -- Initialization

	make is
			-- Make cursor on drivers.
		do
			before := True
		ensure
			before: before
		end

feature -- Access

	item: ECLI_DRIVER is
			-- current item
		do
			Result := item_
		ensure
			definition: Result /= Void implies not off
		end

feature -- Measurement

feature -- Status report

	off: BOOLEAN is
			-- is there no valid item at cursor position ?
		do
			Result := before or
				after
		end

	before: BOOLEAN
			-- is cursor before any valid item ?

	after: BOOLEAN
			-- is cursor after any valid item ?

feature -- Cursor movement

	start is
			-- advance cursor on first position if any
		require
			is_off: off
		do
			before := False
			after := False
			create c_name.make (max_source_name_length + 1)
			create c_attributes.make (max_attributes_length + 1)
			create actual_name_length.make
			create actual_attributes_length.make
			item_ := Void
			do_fetch (sql_fetch_first)
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

feature {ECLI_DRIVER} -- Implementation

	name: STRING

	attributes: STRING

	c_name: XS_C_STRING

	c_attributes: XS_C_STRING

	actual_name_length: XS_C_INT16

	actual_attributes_length: XS_C_INT16

feature {NONE} -- Implementation

	release_handle is
		do
		end

	disposal_failure_reason: STRING is
		once
			Result := ""
		end

	is_ready_for_disposal: BOOLEAN is
		do
			Result := True
		end

	get_error_diagnostic (record_index: INTEGER; state: POINTER; native_error: POINTER;
		message: POINTER; buffer_length: INTEGER; length_indicator: POINTER): INTEGER is
			-- to be redefined in descendant classes
		do
			Result := ecli_c_environment_error (Shared_environment.handle, record_index, state,
				native_error, message, buffer_length, length_indicator)
		end

	do_fetch (direction: INTEGER) is
			-- actual external query
		do
			set_status ("ecli_c_sql_drivers", ecli_c_sql_drivers (Shared_environment.handle, direction, c_name.handle,
				max_source_name_length, actual_name_length.handle, c_attributes.handle,
				max_attributes_length, actual_attributes_length.handle))
			if is_ok and then not is_no_data then
				name := c_name.as_string
				attributes := c_attributes.substring (1, actual_attributes_length.item)
				create item_.make (Current)
			else
				item_ := Void
				after := True
			end
		end

	item_: ECLI_DRIVER

	max_source_name_length: INTEGER is 1024

	max_attributes_length: INTEGER is 16384

end -- class ECLI_DRIVERS_CURSOR

