note
	description:

		"Objects that report diagnostics on ECLI/ODBC operations."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_ERROR_HANDLER

inherit
	UT_ERROR_HANDLER
		rename
			report_error as old_report_error
		end

create
	make_standard, make_null

feature -- Basic operations

	report_row_success_with_info (last_external_feature: STRING; native_code: INTEGER; cli_state : STRING; diagnostic_message: STRING)
			-- Report row operation success with information.
		do
			if info_file /= null_output_stream then
				report_info_message ("[ECLI-I-ROWSUCCESS]" + formatted_message (last_external_feature, native_code, cli_state, diagnostic_message))
			end
		end

	report_success_with_info (last_external_feature: STRING; native_code: INTEGER; cli_state : STRING; diagnostic_message: STRING)
			-- Report success with information.
		do
			if info_file /= null_output_stream then
				report_info_message ("[ECLI-I-SUCCESS]" + formatted_message (last_external_feature, native_code, cli_state, diagnostic_message))
			end
		end

	report_error (last_external_feature: STRING; native_code: INTEGER; cli_state : STRING; diagnostic_message: STRING)
			-- Report error.
		do
			if error_file /= null_output_stream then
				report_error_message ("[ECLI-E-ERROR]" + formatted_message (last_external_feature, native_code, cli_state, diagnostic_message))
			end
		end

	report_diagnostics (status : INTEGER; last_external_feature, cli_state : STRING; native_code : INTEGER; diagnostic_message : STRING)
			-- Report status for internal ODBC operation.
			-- Extension point to catch precise diagnostics or database specific information.
		do
			do_nothing
		end

feature {} -- Implementation

	formatted_message (last_external_feature: STRING; native_code: INTEGER; cli_state : STRING; diagnostic_message: STRING) : STRING
		do
			create Result.make (100)
			Result.append_string ("calling '" + last_external_feature + "'%N")
			Result.append_string ("CODE  : ")
			Result.append_integer (native_code)
			Result.append_character ('%N')
			Result.append_string ("STATUS: ")
			Result.append_string (cli_state)
			Result.append_character ('%N')
			Result.append_string ("MSG   : ")
			Result.append_string (diagnostic_message)
			Result.append_string ("%N")
		end
end
