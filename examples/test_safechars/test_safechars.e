note
	description: "[
			test_safechars sample application.
			
			Shows various topics :
			let
				m = size of data buffer
				db = size of data stored in db
			
			This application tests the following 
				Operation	|	m < db	|	m = db	|  n > db		| NULL
				=====================================================
				select		|  in_less	|  in_same	|  in_greater	|
				insert		|  out_less	|  out_same	|  out_greater	|
				param		|  p_less	|  p_same	|  p_greater	|


	]";

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2010, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"


class
	test_safechars

inherit

	ECLI_TYPE_CONSTANTS

	KL_SHARED_EXECUTION_ENVIRONMENT
	KL_SHARED_FILE_SYSTEM

	KL_SHARED_ARGUMENTS

	KL_IMPORTED_ARRAY_ROUTINES

create

	make

feature -- Initialization

	make
		local
			c : ECLI_CHAR
		do
			parse_arguments
			create error_handler.make_standard
			if arguments_ok then
				do_connect
				if session.is_connected then
					create_table
					create_buffers
					test_insert
					test_select
--					test_select_p
					print_diagnostics
					session.disconnect
				end
			end
		end


feature -- Access

	ecli_login : ECLI_SIMPLE_LOGIN

	in_less : ECLI_STRING

	in_same : ECLI_STRING

	in_greater : ECLI_STRING

	out_less : ECLI_STRING

	out_same : ECLI_STRING

	out_greater : ECLI_STRING

	p_less : ECLI_STRING

	p_same : ECLI_VARCHAR

	p_greater : ECLI_VARCHAR

	session : ECLI_SESSION

	selection : ECLI_STATEMENT
	insertion : ECLI_STATEMENT

	s_selection : STRING = "select a, b from TSTECLIDATA where a=?"
	s_insertion : STRING = "insert into TSTECLIDATA (a, b) values (?, ?)"
	s_param : STRING = "select a, b, c from TSTECLIDATA where c=?"
	s_create : STRING = "[
				create table TSTECLIDATA (a varchar (20), b varchar (20), c varchar (20))
]"
	s_delete_content : STRING = "delete from TSTECLIDATA";

	v_file : ECLI_FILE_LONGVARBINARY

	error_handler : ECLI_ERROR_HANDLER

feature -- Status Report

	arguments_ok : BOOLEAN

feature -- Measurement

	test_count : INTEGER
	pass_count : INTEGER

feature -- Basic operations

	do_connect
		local
			tracefile: KL_TEXT_OUTPUT_FILE
		do
			create session.make_default
			session.set_login_strategy (ecli_login)
			session.connect
			create tracefile.make ("sql_trace.log")
			tracefile.open_write
			session.set_tracer (create {ECLI_TRACER}.make(tracefile))
		end

	create_buffers
		do
			create in_less.make_longvarchar (10)
			create in_greater.make_longvarchar (30)
			create in_same.make_longvarchar (20)

			create out_less.make_longvarchar (15)
			create out_same.make_longvarchar (15)
			create out_greater.make_longvarchar (15)

			out_less.set_item    ("1234567890")
			out_same.set_item    ("12345678901234567890")
			out_greater.set_item ("1234567890ABCDEFGHIJKLMNOPQRSU")

			create p_less.make_longvarchar (10)
			create p_same.make (20)
			create p_greater.make (30)
		end

	create_table
		local
			table_create : ECLI_STATEMENT
			create_option : STRING
		do
			print ("create table%N")
			if arg_create_option.was_found then
				create_option := arg_create_option.parameter.twin
			else
				create_option := ""
			end
			create table_create.make (session)
			table_create.set_error_handler (error_handler)
			table_create.set_sql (s_create + create_option)
			table_create.execute
			if table_create.is_executed then
			else
				print ("deleting previous content%N")
				table_create.set_sql (s_delete_content)
				table_create.execute
			end
			print_ecli_diagnostic (table_create)
			table_create.close
		end

	test_insert
		local
			stmt : ECLI_STATEMENT
		do
			print ("** insert%N")
			create stmt.make (session)
			stmt.set_error_handler (error_handler)
			stmt.set_sql (s_insertion)
			test_insert_less (stmt)
			test_insert_same (stmt)
			test_insert_greater_buffer (stmt)
			test_insert_larger_column (stmt)
			test_insert_null (stmt)

			stmt.close
		end

	do_execute_with_parameters (stmt : ECLI_STATEMENT; parameters : ARRAY[ECLI_VALUE]; results : ARRAY[ECLI_VALUE])
		do
			if parameters /= Void then
				stmt.set_parameters (parameters)
				stmt.bind_parameters
			end
			stmt.execute
			if results /= Void then
				stmt.set_results (results)
			end
		end

	assert (tag : STRING; assertion : BOOLEAN; diagnostic : STRING)
		do
			test_count := test_count + 1
			if assertion then
				io.put_string ("PASS:")
				pass_count := pass_count + 1
			else
				io.put_string ("FAIL:")
			end
			io.put_string (tag)
			if not assertion then
				io.put_string ("%T")
				io.put_string (diagnostic)
			end
			io.put_new_line
		end

	test_insert_less (stmt : ECLI_STATEMENT)
		do
			do_execute_with_parameters (stmt, <<ecli_varchar (20, "I-LESS"), ecli_string_longvarchar_object (10, "1234567890")>>, Void)
			assert ("I-LESS-EXECUTED", stmt.is_executed, stmt.diagnostic_message)
		end

	test_insert_same (stmt : ECLI_STATEMENT)
		do
			do_execute_with_parameters (stmt, <<ecli_varchar (20, "I-SAME"), ecli_string_longvarchar_object (20, "12345678901234567890")>>, Void)
			assert ("I-SAME-EXECUTED", stmt.is_executed, stmt.diagnostic_message)
		end

	test_insert_greater_buffer (stmt : ECLI_STATEMENT)
		do
			do_execute_with_parameters (stmt, <<ecli_varchar (20, "I-GRTP"), ecli_string_longvarchar_object (10, "12345678901234567890")>>, Void)
			assert ("I-GRTP-EXECUTED", stmt.is_executed, stmt.diagnostic_message)
		end

	test_insert_larger_column (stmt : ECLI_STATEMENT)
		do
			do_execute_with_parameters (stmt, <<ecli_varchar (20, "I-GRTC"), ecli_string_longvarchar_object (20, "123456789012345678901234567890")>>, Void)
			assert ("I-GRTC-NOTEXCTD", not stmt.is_executed, stmt.diagnostic_message)
		end

	test_insert_null (stmt : ECLI_STATEMENT)
		do
			do_execute_with_parameters (stmt, <<ecli_varchar (20, "I-NULL"), ecli_string_longvarchar_object (20, Void)>>, Void)
			assert ("I-NULL-EXECUTED", stmt.is_executed, stmt.diagnostic_message)
		end

	test_select_less (stmt : ECLI_STATEMENT)
		do
			do_execute_with_parameters (stmt, <<ecli_varchar (20, "I-LESS")>>,<<ecli_varchar (20, Void),ecli_string_longvarchar_object (10, Void)>>)
			stmt.start
			assert ("S-LESS-EXECUTED", stmt.results[2].as_string ~ "1234567890", stmt.diagnostic_message)
		end

	test_select_same (stmt : ECLI_STATEMENT)
		do
			do_execute_with_parameters (stmt, <<ecli_varchar (20, "I-SAME")>>,<<ecli_varchar (20, Void),ecli_string_longvarchar_object (20, Void)>>)
			assert ("S-SAME-EXECUTED", stmt.is_executed, stmt.diagnostic_message)
			stmt.start
			assert ("S-SAME-RESOK", stmt.results[2].as_string ~ "12345678901234567890", stmt.diagnostic_message)
		end

	test_select_greater (stmt : ECLI_STATEMENT)
		do
			do_execute_with_parameters (stmt, <<ecli_varchar (20, "I-GRTP")>>,<<ecli_varchar (20, Void),ecli_string_longvarchar_object (10, Void)>>)
			assert ("S-GRTP-EXECUTED", stmt.is_executed, stmt.diagnostic_message)
			stmt.start
			assert ("S-GRTP-RESOK", stmt.results[2].as_string ~ "12345678901234567890", stmt.diagnostic_message)
		end

	test_select_null (stmt : ECLI_STATEMENT)
		do
			do_execute_with_parameters (stmt, <<ecli_varchar (20, "I-NULL")>>,<<ecli_varchar (20, Void),ecli_string_longvarchar_object (20, "Toto")>>)
			assert ("S-NULL-EXECUTED", stmt.is_executed, stmt.diagnostic_message)
			stmt.start
			assert ("S-NULL-RESOK", stmt.results[2].is_null, stmt.diagnostic_message)
		end

	test_select
		local
			stmt : ECLI_STATEMENT
		do
			print ("** select%N")
			create stmt.make (session)
			stmt.set_error_handler (error_handler)
			stmt.set_sql (s_selection)

			test_select_less (stmt)
			test_select_same (stmt)
			test_select_greater (stmt)
			test_select_null (stmt)

			stmt.close
		end


	ecli_string_longvarchar_object (n : INTEGER; value : STRING) : ECLI_STRING_LONGVARCHAR
		do
			create Result.make (n)
			if value /= Void then
				Result.set_item (value)
			end
		end

	ecli_varchar (n : INTEGER; value : STRING) : ECLI_VARCHAR
		do
			Create Result.make (n)
			if value /= Void then
				Result.set_item (value)
			end
		end

	do_insert (stmt : ECLI_STATEMENT; label : STRING; value : ECLI_STRING_LONGVARCHAR)
		do

		end

	do_select (stmt : ECLI_STATEMENT; label : STRING; value : ECLI_STRING_LONGVARCHAR)
		do

		end

	print_value (v : ECLI_VALUE)
		local
			l : STRING
		do
			if v.is_null then
				l := "NULL"
			else
				l := v.as_string.count.out
			end
			print ("["+v.generator+":"+v.size.out+"/"+l+"]")
			if not v.is_null then
				print (v.as_string)
			else
				print ("null")
			end
			print (",")
		end

	test_select_p
		local
			stmt : ECLI_STATEMENT
		do
			print ("select_p")
			create stmt.make (session)
			stmt.set_error_handler (error_handler)
			p_less.set_item (out_greater.item) --.substring (1, 20))
			stmt.set_sql (s_param)
			stmt.set_parameters (<<p_less>>)
			stmt.bind_parameters
			stmt.set_results (<<in_less, in_same, in_greater>>)
			stmt.execute
			print_ecli_diagnostic (stmt)
			stmt.start
			print_ecli_diagnostic (stmt)
			if not stmt.off then
				print (stmt.sql)
				print ("%N")
				stmt.results.do_all (agent print_value (?))
			end
			stmt.close
		end

	print_success_info (code : INTEGER; status : STRING; diagnostic : STRING)
		do
			print_info (code, status, diagnostic, False)
		end

	print_error_info (code : INTEGER; status : STRING; diagnostic : STRING)
		do
			print_info (code, status, diagnostic, True)
		end

	print_info (code : INTEGER; status : STRING; diagnostic : STRING; error : BOOLEAN)
		do
			if error then
				print ("ERROR%N")
			else
				print ("INFO%N")
			end
			print ("%TCODE    : ")
			print (code)
			print ("%N%TSTATUS: ")
			print (status)
			print ("%N%TMSG   : ")
			print (diagnostic)
			print ("%N")
		end

	print_ecli_diagnostic (s : ECLI_STATUS)
		do
			if s.is_error then
				io.put_string ("is_error%N")
				io.put_string (s.diagnostic_message)
				io.put_new_line
			end
		end
feature {} -- Implementation

	parse_arguments
		local
			b : BOOLEAN
		do
			create ap_parser.make
			create arg_datasource.make ('d', "dsn")
			create arg_username.make ('u', "user")
			create arg_password.make ('p', "password")
			create arg_create_option.make ('c', "create-option")
			--
			arg_datasource.set_description ("Datasource Name")
			arg_datasource.enable_mandatory
			arg_datasource.set_maximum_occurrences (1)
			arg_username.set_description ("User Name")
			arg_username.enable_mandatory
			arg_username.set_maximum_occurrences (1)
			arg_password.set_description ("Password")
			arg_password.enable_mandatory
			arg_password.set_maximum_occurrences (1)
			arg_create_option.set_description ("Option to Create table; will be appended to DDL")
			--
			ap_parser.options.force_last (arg_datasource)
			ap_parser.options.force_last (arg_username)
			ap_parser.options.force_last (arg_password)
			ap_parser.options.force_last (arg_create_option)
			ap_parser.parse_arguments
			if ap_parser.valid_options then
				create ecli_login.make (arg_datasource.parameter, arg_username.parameter, arg_password.parameter)
				arguments_ok := True
			else
				arguments_ok := False
			end

		end

	ap_parser : AP_PARSER
	arg_datasource : AP_STRING_OPTION
	arg_username : AP_STRING_OPTION
	arg_password: AP_STRING_OPTION
	arg_create_option: AP_STRING_OPTION


	print_diagnostics
		do
			io.put_string ("Total  Tests: "+test_count.out+"%N")
			io.put_string ("Passed Tests: "+pass_count.out+"%N")
			io.put_string ("Failed Tests: "+(test_count - pass_count).out+"%N")
		end

end -- class test_safechars
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
