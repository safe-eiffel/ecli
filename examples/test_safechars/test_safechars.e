indexing
	description: "[
			test_safechars sample application.
			
			Shows various topics : 
			* create and drop tables (DDL)
			* table insertion (basic, parameterized)
			* selection
			* putting and getting long data (photos in this case).
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

	make is
		do
			parse_arguments
			create error_handler.make_standard
			do_connect
			create_table
			create_buffers
			test_insert
			test_select
			test_select_p
		end

--	sens	|	m < db	|	m = db	|	n > db
--	select		in_less		in_same		in_greater
--	insert		out_less	out_same	out_greater
--  param		p_less		p_same		p_greater

feature -- Access

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

	s_selection : STRING is "select a, b, c from toto"
	s_insertion : STRING is "insert into toto values (?, ?, ?)"
	s_param : STRING is "select a, b, c from toto where c=?"

	v_file : ECLI_FILE_LONGVARBINARY

	error_handler : ECLI_ERROR_HANDLER

feature -- Basic operations

	do_connect is
		do
			create session.make_default
			session.set_login_strategy (create {ECLI_SIMPLE_LOGIN}.make ("toto","toto","toto"))
			session.connect
		end

	create_buffers
		do
			create in_less.make_varchar (10)
			create in_greater.make_varchar (30)
			create in_same.make_varchar (20)

			create out_less.make_varchar (15)
			create out_same.make_varchar (15)
			create out_greater.make_varchar (15)

			out_less.set_item    ("1234567890")
			out_same.set_item    ("12345678901234567890")
			out_greater.set_item ("1234567890ABCDEFGHIJKLMNOPQRSU")

			create p_less.make_varchar (10)
			create p_same.make (20)
			create p_greater.make (30)
		end

	create_table
		local
			table_create : ECLI_STATEMENT
		do
			print ("create table%N")
			create table_create.make (session)
			table_create.set_error_handler (error_handler)
			table_create.set_sql (s_insertion)
			table_create.set_sql ("create table toto (a varchar (20), b varchar (20), c varchar (20))")
			table_create.execute
			table_create.close
		end

	test_insert
		local
			stmt : ECLI_STATEMENT
		do
			print ("insert%N")
			create stmt.make (session)
			stmt.set_error_handler (error_handler)
			stmt.set_sql (s_insertion)
			stmt.set_parameters (<<out_less, out_same, out_greater>>)
			stmt.bind_parameters
			stmt.execute
			stmt.close
		end

	test_select
		local
			stmt : ECLI_STATEMENT
		do
			print ("select%N")
			create stmt.make (session)
			stmt.set_error_handler (error_handler)
			stmt.set_sql (s_selection)
			stmt.set_results (<<in_less, in_same, in_greater>>)
			stmt.execute
			stmt.start
			print (stmt.sql)
			print ("%N")
			stmt.results.do_all (agent print_value (?))
			print ("%N")
			stmt.close
		end

	print_value (v : ECLI_VALUE)
		do
			print (v.as_string)
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
			stmt.start
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

end -- class test_safechars
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
