indexing

	description: 
	
		"Objects that test ECLI_ARRAYED_VALUE descendants."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class
	DATA_TEST_ARRAYED_VALUES

inherit
	DATA_TEST_HELPER

	KL_SHARED_PLATFORM
		undefine
		end
		
feature -- Access 

	string_foo : STRING is "Foo"
	
	string_long : STRING is "The quick brown fox jumps over the lazy dog. %
	% The quick brown fox jumps over the lazy dog.%
	% The quick brown fox jumps over the lazy dog.%
	% The quick brown fox jumps over the lazy dog."
		
feature -- Basic operations

	test_arrayed_char is
			-- test ECLI_ARRAYED_CHAR
		local
			v, z : ECLI_ARRAYED_CHAR
		do
			create v.make (10,3)
			assert ("is_null", v.is_null)
			assert_equal ("content_capacity", 10, v.content_capacity)
			assert_equal ("capacity", 3, v.capacity)
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item_at (string_foo, 3)
			assert_char_equal ("set_item_at",string_foo,v.item_at (3))
			
			create z.make (10,3)
			z.copy (v)
			assert_equal("copy", v, z)
		end

	test_arrayed_varchar is
			-- test ECLI_ARRAYED_VARCHAR 
		local
			v, z : ECLI_ARRAYED_VARCHAR
		do
			create v.make (10,3)
			assert ("is_null", v.is_null)
			assert_equal ("content_capacity", 10, v.content_capacity)
			assert_equal ("capacity", 3, v.capacity)
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item_at (string_foo, 3)
			assert_equal ("set_item_at",string_foo,v.item_at (3))
			create z.make (10,3)
			z.copy (v)
			assert_equal("copy", v, z)
		end

	test_arrayed_longvarchar is
			-- test ECLI_ARRAYED_LONGVARCHAR
		local
			v, z : ECLI_ARRAYED_LONGVARCHAR
		do
			create v.make (string_long.count,3)
			assert ("is_null", v.is_null)
			assert_equal ("content_capacity", string_long.count, v.content_capacity)
			assert_equal ("capacity", 3, v.capacity)
			v.set_item_at (string_foo, 3)
			assert_equal ("set_item_at",string_foo,v.item_at (3))
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item_at (string_long, 3)
			assert_equal ("set_item_at2",string_long,v.item_at (3))
			create z.make (v.content_capacity,3)
			z.copy (v)
			assert_equal("copy", v, z)
		end

--	test_arrayed_longvarbinary is
--			-- 
--		local
--			v, z : ECLI_ARRAYED_LONGVARBINARY
--		do
--			create v.make (10000)
--			assert ("is_null", v.is_null)
--			assert_equal ("capacity", 10000, v.capacity)
--			v.set_item_at (string_foo, 3)
--			assert_equal ("set_item_at",string_foo,v.item_at (3))
--			v.set_null
--			assert ("set_null", v.is_null)
--			v.set_item_at (string_long, 3)
--			assert_equal ("set_item_at2",string_long,v.item_at (3))
--			create z.make (v.capacity)
--			z.copy (v)
--			assert_equal("copy", v, z)
--		end

	test_arrayed_date is
			-- test ECLI_ARRAYED_DATE 
		local
			v, z : ECLI_ARRAYED_DATE
			d : DT_DATE
		do
			create v.make (3)
			assert ("is_null", v.is_null)
			create d.make (2002,12,10)
			v.set_item_at (d, 3)
			assert_equal ("set_item_at",d,v.item_at (3))
			v.set_null
			assert ("set_null", v.is_null)
			create d.make (1889,12,10)
			v.set_item_at (d, 3)
			assert_equal ("set_item_at2",d,v.item_at (3))
			create z.make (3)
			z.copy (v)
			assert_equal("copy", v, z)
		end
		
	test_arrayed_time is
			-- test ECLI_ARRAYED_TIME
		local
			v, z : ECLI_ARRAYED_TIME
			t : DT_TIME
		do
			create v.make (3)
			assert ("is_null", v.is_null)
			create t.make (10,12,30)
			v.set_item_at (t, 3)
			assert_equal ("set_item_at",t,v.item_at (3))
			v.set_null
			assert ("set_null", v.is_null)
			create t.make (1,1,0)
			v.set_item_at (t, 3)
			assert_equal ("set_item_at2",t,v.item_at (3))
			create z.make (3)
			z.copy (v)
			assert_equal("copy", v, z)			
		end
		
	test_arrayed_timestamp is
			-- test ECLI_ARRAYED_TIMESTAMP 
		local
			v, z : ECLI_ARRAYED_TIMESTAMP
			d : DT_DATE_TIME
		do
			create v.make (3)
			assert ("is_null", v.is_null)
			create d.make (2002,12,10, 10,12,30)
			v.set_item_at (d, 3)
			assert_equal ("set_item_at",d,v.item_at (3))
			v.set_null
			assert ("set_null", v.is_null)
			create d.make (1889,12,10, 1,1,0)
			v.set_item_at (d, 3)
			assert_equal ("set_item_at2",d,v.item_at (3))
			create z.make (3)
			z.copy (v)
			assert_equal("copy", v, z)						
		end
	
	test_arrayed_integer is
			-- test ECLI_ARRAYED_INTEGER
		local
			v, z : ECLI_ARRAYED_INTEGER
		do
			create v.make (3)
			assert ("is_null", v.is_null)
			v.set_item_at (Platform.Minimum_integer, 3)
			assert_equal ("set_item_at",Platform.Minimum_integer,v.item_at (3))
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item_at (Platform.Maximum_integer, 3)
			assert_equal ("set_item_at2",Platform.Maximum_integer,v.item_at (3))
			create z.make (3)
			z.copy (v)
			assert_equal("copy", v, z)									
		end

	test_arrayed_double is
			-- test ECLI_ARRAYED_DOUBLE
		local
			v, z : ECLI_ARRAYED_DOUBLE
			r : DOUBLE
		do
			create v.make (3)
			assert ("is_null", v.is_null)
			r := 1.2345e-23 
			v.set_item_at (r, 3)
			assert_double_equal ("set_item_at", r, v.item_at (3))
			v.set_null
			assert ("set_null", v.is_null)
			r := -1.2345e23
			v.set_item_at (r, 3)
			assert_double_equal ("set_item_at2", r, v.item_at (3))
			create z.make (3)
			z.copy (v)
			assert_double_equal ("copy", v.item_at (3), z.item_at (3))
		end

	test_arrayed_real is
			-- test ECLI_ARRAYED_REAL
		local
			v, z : ECLI_ARRAYED_REAL
			r : REAL
		do
			create v.make (3)
			assert ("is_null", v.is_null)
			r := 1.2345e-23 
			v.set_item_at (r, 3)
			assert_real_equal ("set_item_at", r, v.item_at (3))
			v.set_null
			assert ("set_null", v.is_null)
			r := -1.2345e23
			v.set_item_at (r, 3)
			assert_real_equal ("set_item_at2", r, v.item_at (3))
			create z.make (3)
			z.copy (v)
			assert_double_equal ("copy", v.item_at (3), z.item_at (3))
		end

	test_arrayed_float is
			-- test ECLI_ARRAYED_FLOAT
		local
			v, z : ECLI_ARRAYED_FLOAT
			r : REAL
		do
			create v.make (3)
			assert ("is_null", v.is_null)
			r := 1.2345e-23 
			v.set_item_at (r, 3)
			assert_real_equal ("set_item_at", r, v.item_at (3))
			v.set_null
			assert ("set_null", v.is_null)
			r := -1.2345e23
			v.set_item_at (r, 3)
			assert_real_equal ("set_item_at2", r, v.item_at (3))
			create z.make (3)
			z.copy (v)
			assert_double_equal ("copy", v.item_at (3), z.item_at (3))
		end


	test_arrayed_decimal is
		local
			v, z : ECLI_ARRAYED_DECIMAL
			l_zero : MA_DECIMAL
			l_one: MA_DECIMAL
			l_pi : MA_DECIMAL
			l_ctx: MA_DECIMAL_CONTEXT
		do
			create l_ctx.make_double_extended
			create v.make_with_rounding (3, l_ctx.precision, 8, l_ctx.rounding_mode)
			create l_zero.make_zero
			create l_one.make_one
			create l_pi.make_from_string ("3.1415927")
			v.set_item_at (l_zero, 1)
			v.set_item_at (l_one, 2)
			v.set_item_at (l_pi, 3)
			create z.make_with_rounding (3, 18, 5, 0)
			z.copy (v)
			if v.is_equal (z) then
				print ("ADECIMAL: V=Z%N")
			end
			z.set_null_at (2)
		end

end
