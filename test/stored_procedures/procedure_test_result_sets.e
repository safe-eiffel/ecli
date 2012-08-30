note

	description: 
	
		"Tests for retrieving stored procedures result sets";

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class
	PROCEDURE_TEST_RESULT_SETS

inherit
	PR_TEST_CASE
	

feature -- Basic operations

	test_result_sets
		local
			mulres : ECLI_STORED_PROCEDURE
			input : ECLI_INTEGER
			res : ECLI_INTEGER
			output : ECLI_INTEGER
			res_count : INTEGER
			factory : ECLI_BUFFER_FACTORY
			row_count : INTEGER
		do
			
			create mulres.make (session)
			mulres.set_sql ("{call test_multiple_results}")
			mulres.execute
			mulres.raise_exception_on_error
			if mulres.is_ok then
				from
					mulres.describe_results
					create factory
					factory.create_buffers (mulres.results_description)
					mulres.set_results (factory.last_buffers)
					mulres.start
					row_count := 0
				until
					mulres.off
				loop
					row_count := row_count + 1
					mulres.forth
				end
				assert_equal ("result_set_1_count", row_count, 1)
				assert_equal ("result_set_1_width", mulres.result_columns_count, 3)
				assert ("has_another_result_set", mulres.has_another_result_set)
				mulres.forth_result_set
				mulres.describe_results
				create factory
				factory.create_buffers (mulres.results_description)
				mulres.set_results (factory.last_buffers)
				from
					mulres.start
					row_count := 0
				until
					mulres.off
				loop
					row_count := row_count + 1
					mulres.forth
				end
				assert_equal ("result_set_2_count", row_count, 2)
				assert_equal ("result_set_2_width", mulres.result_columns_count, 2)
				assert ("no_more_result_set", not mulres.has_another_result_set)
				mulres.close
			end
		end
				
end -- class TEST1
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
