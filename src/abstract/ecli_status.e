note

	description:

		"Objects that represent a CLI status, reflects its various values%
		% and associated information messages"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_STATUS

inherit

	KL_SHARED_EXCEPTIONS
		redefine
			default_create
		end

-- inherit {NONE}

	ECLI_EXTERNAL_API
		export {NONE}	all
		redefine
			default_create
		end

	ECLI_STATUS_CONSTANTS
		export {NONE} all
		redefine
			default_create
		end

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
				create impl_cli_state.make (6)
				create impl_error_buffer.make (512) -- SQL_MAX_MSG_LEN
				create impl_native_code.make
				create impl_buffer_length_indicator.make
				create impl_error_message.make(512)
				create last_external_feature.make (40)
				create error_handler.make_null
		end

	make_copy (other : ECLI_STATUS)
		do
			default_create
			--set_status (other.last_external_feature, other.status)
			last_external_feature := other.last_external_feature.twin
			status := other.status
			impl_error_message := other.diagnostic_message.twin
			need_diagnostics := False
			create impl_cli_state.make_from_string (other.cli_state)
			impl_native_code.put (other.native_code)
			error_handler := other.error_handler
		end

feature -- Access

	status : INTEGER
			-- Status code of last CLI operation

	diagnostic_message : STRING
			-- Message describing the current status
			-- Empty if status does not reflect an error or warning
		do
			get_diagnostics
			Result := impl_error_message
		end

	last_external_feature: STRING
			-- Name of the last called external feature

	cli_state : STRING
			-- Name of the internal CLI state
		do
			get_diagnostics
			Result := impl_cli_state.substring(1,5)
		end

	native_code : INTEGER
			-- Native error code
		do
			get_diagnostics
			Result := impl_native_code.item
		end

	error_handler : ECLI_ERROR_HANDLER

feature -- Status report

	has_information_message : BOOLEAN
			-- Is last CLI command successful, but with an information message ?
		do
			Result := status = sql_success_with_info
		ensure
			Result implies is_ok
		end

	is_ok : BOOLEAN
			-- Is last CLI command ok ?
		do
			Result := status = sql_success or else has_information_message
				or else  status = sql_no_data
					or else status = sql_need_data;
		end

	is_no_data : BOOLEAN
			-- Is last fetch indicating there is no data anymore ?
		do
			Result := status = sql_no_data;
		end

	is_error : BOOLEAN
			-- Is last CLI command in error ?
		do
			Result := status = sql_error
		end

	valid_status (code : INTEGER) : BOOLEAN
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

	raise_exception_on_error
			-- Enable exceptions for CLI operation failure
		do
			exception_on_error := True
		ensure
			exception_on_error: exception_on_error
		end

	disable_exception_on_error
			-- Disable exceptions for CLI operation failures
		do
			exception_on_error := False
		ensure
			continue_on_error: not exception_on_error
		end

	set_error_handler (an_error_handler : ECLI_ERROR_HANDLER)
			-- Set `error_handler' to `an_error_handler'.
		do
			error_handler := an_error_handler
		ensure
			error_handler_set: error_handler = an_error_handler
		end

feature {NONE} -- Implementation

	reset_status
			-- reset status to `is_ok'
		do
			set_status_without_report ("Sql_success", Sql_success)
		ensure
			is_ok: is_ok
		end

	set_status (an_external_feature: STRING; v : INTEGER)
		require
			an_external_feature_not_void: an_external_feature /= Void --FIXME: VS-DEL
			valid_status_v: valid_status (v)
		do
			set_status_internal (an_external_feature, v, True)
		end

	set_status_without_report (an_external_feature: STRING; v : INTEGER)
		require
			an_external_feature_not_void: an_external_feature /= Void --FIXME: VS-DEL
			valid_status_v: valid_status (v)
		do
			set_status_internal (an_external_feature, v, False)
		end

	set_status_internal (an_external_feature: STRING; v : INTEGER; do_report: BOOLEAN)
		require
			an_external_feature_not_void: an_external_feature /= Void --FIXME: VS-DEL
			valid_status_v: valid_status (v)
		do
			status := v
			need_diagnostics := do_report
			last_external_feature := an_external_feature
---
---			Get all diagnostics
---
			get_diagnostics
			if status = sql_invalid_handle then
				exceptions.raise ("[ECLI][Internal] Invalid Handle")
			elseif exception_on_error and then not is_ok then
				exceptions.raise (diagnostic_message)
			elseif status = sql_row_success_with_info then
				error_handler.report_row_success_with_info (last_external_feature, native_code, cli_state, diagnostic_message)
			elseif status = sql_success_with_info then
				error_handler.report_success_with_info (last_external_feature, native_code, cli_state, diagnostic_message)
			elseif status = sql_error then
				error_handler.report_error (last_external_feature, native_code, cli_state, diagnostic_message)
			end
		ensure
			last_external_feature_not_void: last_external_feature = an_external_feature
			status: status = v
		end

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER
			-- to be redefined in descendant classes
		deferred
		end

	get_diagnostics
			-- get error diagnostics for latest CLI command
		local
			count : INTEGER
			retcode : INTEGER
			saved_native_code : INTEGER
		do
			if need_diagnostics then
				--impl_cli_state := STRING_.make_buffer (6)
				impl_cli_state.wipe_out
				impl_error_buffer.wipe_out
				impl_error_message.wipe_out
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
					if retcode = sql_success or else retcode = sql_success_with_info then
							error_handler.report_diagnostics (status, last_external_feature,
								impl_cli_state.substring (1, 5),
								impl_native_code.item,
								impl_error_buffer.substring (1,impl_buffer_length_indicator.item))
					end
					if retcode = sql_success_with_info and then impl_buffer_length_indicator.item > impl_error_buffer.capacity then
						create impl_error_buffer.make (impl_buffer_length_indicator.item)
					elseif retcode = sql_success or else retcode = sql_success_with_info then
						impl_error_message.append_string (impl_error_buffer.as_string)
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
	impl_error_buffer : XS_C_STRING

	impl_cli_state : XS_C_STRING

	impl_error_message : STRING

	need_diagnostics : BOOLEAN

	impl_buffer_length_indicator : XS_C_INT32

invariant

	valid_status: valid_status (status)
	error_handler_not_void: error_handler /= Void --FIXME: VS-DEL

end
