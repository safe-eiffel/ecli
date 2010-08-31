indexing

	description:

		"Objects that represent a CLI status, reflects its various values%
		% and associated information messages"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_STATUS

inherit

	ECLI_EXTERNAL_API
		export {NONE}	all
		end

	ECLI_STATUS_CONSTANTS
		export {NONE} all
		end

	EXCEPTIONS
		export {NONE} all
		end

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all
		end

	ANY

feature -- Access

	status : INTEGER
			-- Status code of last CLI operation

	diagnostic_message : STRING is
			-- Message describing the current status
			-- Empty if status does not reflect an error or warning
		do
			get_diagnostics
			Result := impl_error_message
		end

	cli_state : STRING is
			-- Name of the internal CLI state
		do
			get_diagnostics
			Result := impl_cli_state.as_string.substring(1,5)
		end

	native_code : INTEGER is
			-- Native error code
		do
			get_diagnostics
			Result := impl_native_code.item
		end

--	information_actions : ACTION_SEQUENCE[TUPLE[code: INTEGER;state : STRING;diagnostic: STRING]]

--	error_actions : ACTION_SEQUENCE[TUPLE[code: INTEGER;state : STRING;diagnostic: STRING]]

feature -- Status report

	has_information_message : BOOLEAN is
			-- Is last CLI command successful, but with an information message ?
		do
			Result := status = sql_success_with_info
		ensure
			Result implies is_ok
		end

	is_ok : BOOLEAN is
			-- Is last CLI command ok ?
		do
			Result := status = sql_success or else has_information_message
				or else  status = sql_no_data
			    	or else status = sql_need_data;
		end

	is_no_data : BOOLEAN is
			-- Is last fetch indicating there is no data anymore ?
		do
			Result := status = sql_no_data;
		end

	is_error : BOOLEAN is
			-- Is last CLI command in error ?
		do
			Result := status = sql_error
		end

	valid_status (code : INTEGER) : BOOLEAN is
			-- Is `code' a valid status ?
		do
			Result := True
			inspect code
			when Sql_success, Sql_success_with_info then
			when Sql_no_data, Sql_need_data, Sql_still_executing then
			when Sql_error, Sql_invalid_handle then
			else
				Result := False
			end
		end

feature -- Status report

	exception_on_error : BOOLEAN
		-- Is an exception raised when not `is_ok' ?

feature -- Status setting

	raise_exception_on_error is
			-- Enable exceptions for CLI operation failure
		do
			exception_on_error := True
		ensure
			exception_on_error: exception_on_error
		end

	disable_exception_on_error is
			-- Disable exceptions for CLI operation failures
		do
			exception_on_error := False
		ensure
			continue_on_error: not exception_on_error
		end

feature {NONE} -- Implementation

	reset_status is
			-- reset status to `is_ok'
		do
			set_status (Sql_success)
		ensure
			is_ok: is_ok
		end

	set_status (v : INTEGER) is
		require
			valid_status_v: valid_status (v)
		do
			status := v
			need_diagnostics := True
			if status = sql_invalid_handle then
				raise ("[ECLI][Internal] Invalid Handle")
			elseif exception_on_error and then not is_ok then
				raise (diagnostic_message)
			elseif status = sql_success_with_info or status = sql_row_success_with_info then
--				information_actions.call ([native_code, cli_state, diagnostic_message])
			elseif status = sql_error then
--				error_actions.call ([native_code, cli_state, diagnostic_message])
			end
		ensure
			status: status = v
		end

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER  is
			-- to be redefined in descendant classes
		deferred
		end

	get_diagnostics is
			-- get error diagnostics for latest CLI command
		local
			count : INTEGER
			retcode : INTEGER
			impl_error_buffer : XS_C_STRING
			saved_native_code : INTEGER
		do
			if need_diagnostics then
				--impl_cli_state := STRING_.make_buffer (6)
				if impl_cli_state = Void then
					create impl_cli_state.make (6)
				else
					impl_cli_state.wipe_out
				end
				if impl_error_buffer = Void then
					create impl_error_buffer.make (512) -- SQL_MAX_MSG_LEN
				else
					impl_error_buffer.wipe_out
				end
				if impl_native_code = Void then create impl_native_code.make end
				if impl_buffer_length_indicator = Void then create impl_buffer_length_indicator.make end
				create impl_error_message.make(0)
				from
					count := 1
					retcode := sql_success
				until
					retcode = sql_no_data or retcode = sql_invalid_handle or retcode = sql_error
				loop
					retcode := get_error_diagnostic (count,
							impl_cli_state.handle,
							impl_native_code.handle,
							impl_error_buffer.handle,
							impl_error_buffer.capacity,
							impl_buffer_length_indicator.handle)
					if retcode = sql_success_with_info and then impl_buffer_length_indicator.item > impl_error_buffer.capacity then
						create impl_error_buffer.make (impl_buffer_length_indicator.item)
					elseif retcode = sql_success or else retcode = sql_success_with_info then
						impl_error_message.append_string (
								impl_error_buffer.as_string)
						impl_error_message.append_string ("%N")
						saved_native_code := impl_native_code.item
						count := count + 1
					end
				end
				impl_native_code.put (saved_native_code)
				need_diagnostics := False
			end
		end

	impl_native_code : XS_C_INT32

	impl_cli_state : XS_C_STRING

	impl_error_message : STRING

	need_diagnostics : BOOLEAN

	impl_buffer_length_indicator : XS_C_INT32

invariant

	valid_status: valid_status (status)

end
