indexing

	description: 
	
		"Tests for passing stored procedures parameters";

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class
	PROCEDURE_TEST_PARAMETERS
	
inherit

	PR_TEST_CASE
	

feature -- Basic operations

	test_input_parameter is
		local
			pin : ECLI_STORED_PROCEDURE
			input, res : ECLI_INTEGER
		do
			-- input parameter
			create pin.make (session)
			pin.set_sql ("{call test_proc_in (?in)}")
			create input.make
			create res.make
			input.set_item (33)
			pin.put_input_parameter (input, "in")
			pin.bind_parameters
			pin.execute
			if pin.is_ok then
				pin.set_results (<<res>>)
				pin.start
			end
			assert ("test_proc_in_executed", pin.is_ok)
			assert_equal ("test_proc_in_passed", input, res)
			pin.close
		end
		
	test_output_parameter is
		local
			pout : ECLI_STORED_PROCEDURE
			input, output : ECLI_INTEGER
		do
			create pout.make (session)
			pout.set_sql ("{call test_proc_out (?in, ?out)}")
			create input.make
			create output.make
			input.set_item (27)
			pout.put_input_parameter (input, "in")
			pout.put_output_parameter (output, "out")
			pout.bind_parameters
			pout.execute
			assert ("test_proc_out_executed", pout.is_ok)
			assert_equal ("test_proc_out_passed", input, output)
			pout.close
		end
		
	test_input_output_parameter is
		local
			pinout : ECLI_STORED_PROCEDURE
			input, output : ECLI_INTEGER
		do
			create pinout.make (session)
			pinout.set_sql ("{call test_proc_in_out (?in, ?out)}")
			create input.make
			create output.make
			input.set_item (27)
			output.set_item (33)
			pinout.put_input_output_parameter (input, "in")
			pinout.put_input_output_parameter (output, "out")
			pinout.bind_parameters
			pinout.execute
			assert ("test_proc_in_out_executed", pinout.is_ok)
			assert_equal ("test_proc_in_out_X1", input.as_integer, 33)
			assert_equal ("test_proc_in_out_X2", output.as_integer, 27)
			pinout.close
		end
		
	test_fun is
			-- test function
		local
			fun : ECLI_STORED_PROCEDURE
			input, res : ECLI_INTEGER
		do
			create fun.make (session)
			create input.make
			input.set_item (-23)
			create res.make
			fun.set_sql ("{?res=call test_fun (?in)}")
			fun.put_output_parameter (res, "res")
			fun.put_input_parameter (input, "in")
			fun.bind_parameters
			fun.execute
			assert ("test_fun_executed", fun.is_ok)
			assert_equal ("test_fun_ok", res, input)
			fun.close
		end
				
end -- class TEST1
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
