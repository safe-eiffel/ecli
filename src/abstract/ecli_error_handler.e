indexing
	description: "Summary description for {ECLI_ERROR_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
		do
			if info_file /= null_output_stream then
				report_info_message ("[ECLI-I-ROWSUCCESS]" + formatted_message (last_external_feature, native_code, cli_state, diagnostic_message))
			end
		end

	report_success_with_info (last_external_feature: STRING; native_code: INTEGER; cli_state : STRING; diagnostic_message: STRING)
		do
			if info_file /= null_output_stream then
				report_info_message ("[ECLI-I-SUCCESS]" + formatted_message (last_external_feature, native_code, cli_state, diagnostic_message))
			end
		end

	report_error (last_external_feature: STRING; native_code: INTEGER; cli_state : STRING; diagnostic_message: STRING)
		do
			if error_file /= null_output_stream then
				report_error_message ("[ECLI-E-ERROR]" + formatted_message (last_external_feature, native_code, cli_state, diagnostic_message))
			end
		end

	report_diagnostics (status : INTEGER; external_feature, cli_state : STRING; native_code : INTEGER; diagnostic_message : STRING)
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
		end
end
