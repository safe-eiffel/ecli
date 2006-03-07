indexing

	description: 
		
		"Objects that test ECLI_VALUE descendants."
		
	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class
	DATA_TEST_VALUES
	
inherit
	DATA_TEST_HELPER
	
	KL_SHARED_PLATFORM
	
feature -- Access 

	string_foo : STRING is "Foo"
	
	string_long : STRING is "The quick brown fox jumps over the lazy dog. %
	% The quick brown fox jumps over the lazy dog.%
	% The quick brown fox jumps over the lazy dog.%
	% The quick brown fox jumps over the lazy dog."
		
	string_binary : STRING is "%/000/%/001/%/002/%/003/%/004/%/005/%/006/%/255/"
	
feature -- Basic operations

	test_char is
			-- test ECLI_CHAR
		local
			v, z : ECLI_CHAR
		do
			create v.make (10)
			assert ("is_null", v.is_null)
			assert_equal ("capacity", 10, v.capacity)
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item (string_foo)
			assert_char_equal ("set_item",string_foo,v.item)
			
			create z.make (10)
			z.copy (v)
			assert_equal("copy", v, z)
		end

	test_varchar is
			-- test ECLI_VARCHAR 
		local
			v, z : ECLI_VARCHAR
		do
			create v.make (10)
			assert ("is_null", v.is_null)
			assert_equal ("capacity", 10, v.capacity)
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item (string_foo)
			assert_equal ("set_item",string_foo,v.item)
			create z.make (10)
			z.copy (v)
			assert_equal("copy", v, z)
			v.set_item ("")
			assert_equal("empty_count", v.count, 0)
			assert_equal("empty_as_string", v.as_string, "")
		end

	test_longvarchar is
			-- test ECLI_LONGVARCHAR
		local
			v, z : ECLI_LONGVARCHAR
		do
			create v.make (10000)
			assert ("is_null", v.is_null)
			assert_equal ("capacity", 10000, v.capacity)
			v.set_item (string_foo)
			assert_equal ("set_item",string_foo,v.item)
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item (string_long)
			assert_equal ("set_item2",string_long,v.item)
			create z.make (v.capacity)
			z.copy (v)
			assert_equal("copy", v, z)
		end

	test_binary is
			-- test ECLI_BINARY
		local
			v, z : ECLI_BINARY
		do
			create v.make (8)
			assert ("is_null", v.is_null)
			assert_equal ("capacity", 8, v.capacity)
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item (string_binary)
			assert_char_equal ("set_item",string_binary,v.item)
			
			create z.make (8)
			z.copy (v)
			assert_equal("copy", v, z)
		end

	test_varbinary is
			-- test ECLI_VARBINARY 
		local
			v, z : ECLI_VARBINARY
		do
			create v.make (10)
			assert ("is_null", v.is_null)
			assert_equal ("capacity", 10, v.capacity)
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item (string_foo)
			assert_equal ("set_item",string_foo,v.item)
			create z.make (10)
			z.copy (v)
			assert_equal("copy", v, z)
		end

	test_longvarbinary is
			-- 
		local
			v, z : ECLI_LONGVARBINARY
		do
			create v.make (10000)
			assert ("is_null", v.is_null)
			assert_equal ("capacity", 10000, v.capacity)
			v.set_item (string_foo)
			assert_equal ("set_item",string_foo,v.item)
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item (string_long)
			assert_equal ("set_item2",string_long,v.item)
			create z.make (v.capacity)
			z.copy (v)
			assert_equal("copy", v, z)
		end

	test_date is
			-- test ECLI_DATE 
		local
			v, z : ECLI_DATE
			d : DT_DATE
		do
			create v.make_null
			assert ("is_null", v.is_null)
			create z.make_default
			create d.make (2002,12,10)
			v.set_item (d)
			assert_equal ("set_item",d,v.item)
			v.set_null
			assert ("set_null", v.is_null)
			create d.make (1889,12,10)
			v.set_item (d)
			assert_equal ("set_item2",d,v.item)
			create z.make_default
			z.copy (v)
			assert_equal("copy", v, z)
		end
		
	test_time is
			-- test ECLI_TIME
		local
			v, z : ECLI_TIME
			t : DT_TIME
		do
			create v.make_null
			assert ("is_null", v.is_null)
			create t.make (10,12,30)
			v.set_item (t)
			assert_equal ("set_item",t,v.item)
			v.set_null
			assert ("set_null", v.is_null)
			create t.make (1,1,0)
			v.set_item (t)
			assert_equal ("set_item2",t,v.item)
			create z.make_default
			z.copy (v)
			assert_equal("copy", v, z)			
		end
		
	test_timestamp is
			-- test ECLI_TIMESTAMP 
		local
			v, z : ECLI_TIMESTAMP
			d : DT_DATE_TIME
		do
			create v.make_null
			assert ("is_null", v.is_null)
			create d.make (2002,12,10, 10,12,30)
			v.set_item (d)
			assert_equal ("set_item",d,v.item)
			v.set_null
			assert ("set_null", v.is_null)
			create d.make (1889,12,10, 1,1,0)
			v.set_item (d)
			assert_equal ("set_item2",d,v.item)
			create z.make_default
			z.copy (v)
			assert_equal("copy", v, z)						
		end
	
	test_integer is
			-- test ECLI_INTEGER
		local
			v, z : ECLI_INTEGER
		do
			create v.make
			assert ("is_null", v.is_null)
			v.set_item (Platform.Minimum_integer)
			assert_equal ("set_item",Platform.Minimum_integer,v.item)
			v.set_null
			assert ("set_null", v.is_null)
			v.set_item (Platform.Maximum_integer)
			assert_equal ("set_item2",Platform.Maximum_integer,v.item)
			create z.make
			z.copy (v)
			assert_equal("copy", v, z)									
		end

	test_double is
			-- test ECLI_DOUBLE
		local
			v, z : ECLI_DOUBLE
			r : DOUBLE
		do
			create v.make
			assert ("is_null", v.is_null)
			r := 1.2345e-23 
			v.set_item (r)
			assert_double_equal ("set_item", r, v.item)
			v.set_null
			assert ("set_null", v.is_null)
			r := -1.2345e23
			v.set_item (r)
			assert_double_equal ("set_item2", r, v.item)
			create z.make
			z.copy (v)
			assert_double_equal ("copy", v.item, z.item)
		end

	test_decimal is
			-- test ECLI_DOUBLE
		local
			v, z : ECLI_DECIMAL
			r : MA_DECIMAL
			ctx : MA_DECIMAL_CONTEXT
		do
			create v.make (18, 4)
			assert ("is_null", v.is_null)
			create ctx.make_double_extended
			create r.make_from_string_ctx ("98765432101234.5678", ctx)
			v.set_item (r)
			assert_equal ("set_item", r, v.item)
			v.set_null
			assert ("set_null", v.is_null)
			r := -r
			v.set_item (r)
			assert_equal ("set_item2", r, v.item)
			create z.make (v.precision, v.decimal_digits)
			z.copy (v)
			assert_equal ("copy", v.item, z.item)
		end

	test_real is
			-- test ECLI_REAL
		local
			v, z : ECLI_REAL
			r : REAL
		do
			create v.make
			assert ("is_null", v.is_null)
			r := 1.2345e-23 
			v.set_item (r)
			assert_real_equal ("set_item", r, v.item)
			v.set_null
			assert ("set_null", v.is_null)
			r := -1.2345e23
			v.set_item (r)
			assert_real_equal ("set_item2", r, v.item)
			create z.make
			z.copy (v)
			assert_double_equal ("copy", v.item, z.item)
		end

	test_float is
			-- test ECLI_FLOAT
		local
			v, z : ECLI_FLOAT
			r : REAL
		do
			create v.make
			assert ("is_null", v.is_null)
			r := 1.2345e-23 
			v.set_item (r)
			assert_real_equal ("set_item", r, v.item)
			v.set_null
			assert ("set_null", v.is_null)
			r := -1.2345e23
			v.set_item (r)
			assert_real_equal ("set_item2", r, v.item)
			create z.make
			z.copy (v)
			assert_double_equal ("copy", v.item, z.item)
		end
	
end