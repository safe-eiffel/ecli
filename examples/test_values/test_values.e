class
	TEST_VALUES
	
creation
	make
	
feature 

	make is
		do
			io.put_string ("Hello !%N")
			do_tests
			do_arrayed_tests
		end

	string_foo : STRING is "Foo"
	
	string_long : STRING is "The quick brown fox jumps over the lazy dog. %
	% The quick brown fox jumps over the lazy dog.%
	% The quick brown fox jumps over the lazy dog.%
	% The quick brown fox jumps over the lazy dog."
	
	do_tests is
			-- run test on ECLI_VALUE descendants
		do
			test_char
			test_varchar
			test_longvarchar
			test_date
			test_time
			test_timestamp
			test_integer
			test_double
			test_real
			test_float
		end

	do_arrayed_tests is
			-- run test on ECLI_VALUE descendants
		do
			test_arrayed_char
			test_arrayed_varchar
			test_arrayed_longvarchar
			test_arrayed_date
			test_arrayed_time
			test_arrayed_timestamp
			test_arrayed_integer
			test_arrayed_double
			test_arrayed_real
			test_arrayed_float
		end

		
	test_char is
			-- 
		local
			v : ECLI_CHAR
		do
			create v.make (10)
			v.set_item (string_foo)
		end
	
	test_varchar is
			-- 
		local
			v : ECLI_VARCHAR
			b : BOOLEAN
		do
			create v.make (10)
			v.set_item (string_foo)
			b := v.item.is_equal (string_foo)
		end

	test_longvarchar is
			-- 
		local
			v : ECLI_LONGVARCHAR
		do
			create v.make (10000)
			v.set_item (string_foo)
			v.set_null
			v.set_item (string_long)
		end

	test_date is
			-- 
		local
			v : ECLI_DATE
			d : DT_DATE
		do
			create v.make_default
			create d.make (2002,12,10)
			v.set_item (d)
			v.set_null
			create d.make (1889,12,10)
			v.set_item (d)
		end
		
	test_time is
			-- 
		local
			v : ECLI_TIME
			t : DT_TIME
		do
			create v.make_default
			create t.make (10,12,30)
			v.set_item (t)
			v.set_null
			create t.make (1,1,0)
			v.set_item (t)
		end
		
	test_timestamp is
			-- 
		local
			v : ECLI_TIMESTAMP
			d : DT_DATE_TIME
		do
			create v.make_default
			create d.make (2002,12,10, 10,12,30)
			v.set_item (d)
			v.set_null
			create d.make (1889,12,10, 1,1,0)
			v.set_item (d)
		end
	
	test_integer is
			-- 
		local
			v : ECLI_INTEGER
		do
			create v.make
			v.set_item (2_124_123_432)
			v.set_null
			v.set_item (-2_124_123_432)
		end

	test_double is
			-- 
		local
			v : ECLI_DOUBLE
		do
			create v.make
			v.set_item (1.2345e-23)
			v.set_null
			v.set_item (-1.2345e23)			
		end

	test_real is
			-- 
		local
			v : ECLI_REAL
			r : REAL
		do
			create v.make
			r := 1.2345e-23 
			v.set_item (r)
			v.set_null
			r := -1.2345e23
			v.set_item (r)			
		end

	test_float is
			-- 
		local
			v : ECLI_FLOAT
		do
			create v.make
			v.set_item (1.2345e-23)
			v.set_null
			v.set_item (-1.2345e23)			
		end

	test_arrayed_char is
			-- 
		local
			v : ECLI_ARRAYED_CHAR
			b : BOOLEAN
		do
			create v.make (10, 3)
			v.set_item_at (string_foo, 1)
			b := v.item_at (1).is_equal (string_foo)
			v.set_item_at (string_foo, 2)
			v.set_item_at (string_foo, 3)
			v.set_null_at (2)
		end
	
	test_arrayed_varchar is
			-- 
		local
			v : ECLI_ARRAYED_VARCHAR
		do
			create v.make (10, 3)
			v.set_item_at (string_foo, 1)
			v.set_item_at (string_foo, 2)
			v.set_item_at (string_foo, 3)
			v.set_null_at (2)
		end

	test_arrayed_longvarchar is
			-- 
		local
			v : ECLI_ARRAYED_LONGVARCHAR
		do
			create v.make (10000, 3)
			v.set_item_at (string_foo, 1)
			v.set_item_at (string_foo, 2)
			v.set_item_at (string_foo, 3)
			v.set_null_at (2)
			v.set_item_at (string_long, 3)
		end

	test_arrayed_date is
			-- 
		local
			v : ECLI_ARRAYED_DATE
			d : DT_DATE
		do
			create v.make (3)
			create d.make (2002,12,10)
			v.set_item_at (d,1)
			v.set_item_at (d,2)
			v.set_item_at (d,3)
			v.set_null_at (2)
			create d.make (1889,12,10)
			v.set_item_at (d, 3)
		end
		
	test_arrayed_time is
			-- 
		local
			v : ECLI_ARRAYED_TIME
			t : DT_TIME
		do
			create v.make (3)
			create t.make (10,12,30)
			v.set_item_at (t,1)
			v.set_item_at (t,2)
			v.set_item_at (t,3)
			v.set_null_at (2)
			create t.make (1,1,0)
			v.set_item_at (t,3)
		end
		
	test_arrayed_timestamp is
			-- 
		local
			v : ECLI_ARRAYED_TIMESTAMP
			d : DT_DATE_TIME
		do
			create v.make (3)
			create d.make (2002,12,10, 10,12,30)
			v.set_item_at (d,1)
			v.set_item_at (d,2)
			v.set_item_at (d,3)
			v.set_null_at (2)
			create d.make (1889,12,10, 1,1,0)
			v.set_item_at (d,3)
		end
	
	test_arrayed_integer is
			-- 
		local
			v : ECLI_ARRAYED_INTEGER
		do
			create v.make (3)
			v.set_item_at (2_124_123_432, 1)
			v.set_null_at (2)
			v.set_item_at (-2_124_123_432, 3)
		end

	test_arrayed_double is
			-- 
		local
			v : ECLI_ARRAYED_DOUBLE
		do
			create v.make (3)
			v.set_item_at (1.2345e-23, 1)
			v.set_null_at (2)
			v.set_item_at (-1.2345e23, 3)			
		end

	test_arrayed_real is
			-- 
		local
			v : ECLI_ARRAYED_REAL
			r : REAL
		do
			create v.make (3)
			r := 1.2345e-23 
			v.set_item_at (r, 1)
			v.set_null_at (2)
			r := -1.2345e23
			v.set_item_at (r, 3)			
		end

	test_arrayed_float is
			-- 
		local
			v : ECLI_ARRAYED_FLOAT
		do
			create v.make (3)
			v.set_item_at (1.2345e-23, 1)
			v.set_null_at (2)
			v.set_item_at (-1.2345e23, 3)			
		end
		
end