indexing
	description: 

		"Objects that represent a CLI status, reflects its various values%
		% and associated information messages"

	author: 	"Paul G. Crismer"
	date: 		"$Date$"
	revision: 	"$Revision$"
	licensing: 	"See notice at end of class"

deferred class
	ECLI_STATUS

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
	
feature -- Access

	status : INTEGER
			-- status code of last CLI operation

	diagnostic_message : STRING is
			-- Message describing the current status
			-- Empty if status does not reflect an error or warning
		do
			get_diagnostics
			Result := impl_error_message
		end

	cli_state : STRING is
			-- name of the internal CLI state
		do
			get_diagnostics
			Result := impl_cli_state.substring(1,5)
		end

	native_code : INTEGER is
			-- native error code
		do
			get_diagnostics
			Result := impl_native_code
		end

feature -- Status report

	has_information_message : BOOLEAN is
			-- Is the last CLI command ok, 
			-- but with an available information message ?
		do
			Result := status = sql_success_with_info
		ensure
			Result implies is_ok
		end

	is_ok : BOOLEAN is
			-- Is the last CLI command ok ?
		do
			Result := status = sql_success or else has_information_message 
				or else  status = sql_no_data 
			    	or else status = sql_need_data;
		end

	is_no_data : BOOLEAN is
		do
			Result := status = sql_no_data;
		end
		
	is_error : BOOLEAN is
			-- Is the last CLI command in error
		do
			Result := status = sql_error
		end

feature -- Status report

	exception_on_error : BOOLEAN
		-- When true, an exception is raised if not is_ok

feature -- Status setting

	raise_exception_on_error is
		do
			exception_on_error := True
		ensure
			exception_on_error: exception_on_error
		end
	
	disable_exception_on_error is
		do
			exception_on_error := False
		ensure
			continue_on_error: not exception_on_error
		end

feature {NONE} -- Implementation


	set_status (v : INTEGER) is
		do
			status := v
			need_diagnostics := True
			if status = sql_invalid_handle then
				raise ("[ECLI][Internal] Invalid Handle")
			elseif exception_on_error and then not is_ok then
				raise (diagnostic_message)
			end

		ensure
			status: status = v
		end

	get_error_diagnostic (record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER  is
			-- to be redefined in descendant classes
		deferred
		end

	get_diagnostics is
		local
			count : INTEGER
			tools : ECLI_EXTERNAL_TOOLS
			retcode : INTEGER
		do
			if need_diagnostics then
				impl_cli_state := STRING_.make_buffer (6)
				impl_error_buffer := STRING_.make_buffer (256)
				!!impl_error_message.make(0)
				from 
					count := 1
					retcode := sql_success
				until 
					retcode = sql_no_data or retcode = sql_invalid_handle or retcode = sql_error
				loop
					retcode := get_error_diagnostic (count, 
							tools.string_to_pointer (impl_cli_state),
							$impl_native_code, 
							tools.string_to_pointer (impl_error_buffer),
							255,
							$impl_buffer_length_indicator)
					if retcode = sql_success or else retcode = sql_success_with_info then	
						impl_error_message.append (
								tools.pointer_to_string (
									tools.string_to_pointer (impl_error_buffer)))
						impl_error_message.append ("%N")
					end	
					count := count + 1
				end
				need_diagnostics := False
			end
		end

	impl_native_code : INTEGER

	impl_cli_state : STRING

	impl_error_message : STRING

	impl_error_buffer : STRING

	need_diagnostics : BOOLEAN

	impl_buffer_length_indicator : INTEGER
	
invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_STATUS
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
