indexing
	description: "ISO CLI LONGVARCHAR (n) values"
	author: "Paul-G.Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_LONGVARCHAR

inherit
	ECLI_GENERIC_VALUE [STRING]
		redefine
			item, set_item,convertible_to_string, to_string, out, convertible_to_character, to_character,
			convertible_to_integer, to_integer, convertible_to_double, to_double, impl_item
		end

creation
	make

feature {NONE} -- Initialization

	make (n : INTEGER) is
		require
			n > 0 and n <= max_capacity
		local
			s : STRING
		do
			buffer := ecli_c_alloc_value (n+1)
			create s.make (0)
			impl_item := s
		ensure
			capacity: capacity = n
		end
		
feature -- Access

	item : STRING is
		do
			if is_null then
				Result := Void
			else
				protect
				string_copy_from_pointer (impl_item,ecli_c_value_get_value (buffer))
				Result := impl_item
				unprotect
			end
		end

	max_capacity : INTEGER is
		do
			Result := 1_000_000
		end

	capacity : INTEGER is
		do
			Result := ecli_c_value_get_length (buffer) - 1
		end

	count : INTEGER is
			-- actual length of item
		do
			if not is_null then
				Result := ecli_c_value_get_length_indicator (buffer)
			end
		end

feature -- Measurement

feature -- Status report

	convertible_to_string : BOOLEAN is 
		do
			Result := True
		end

	convertible_to_integer : BOOLEAN is 
		do
			Result := not is_null and then item.is_integer
		end

	convertible_to_double : BOOLEAN is 
		do
			Result := not is_null and then item.is_double
		end

	convertible_to_character : BOOLEAN is
		do
			Result := count > 0
		end
		
	c_type_code: INTEGER is
		once
			Result := sql_c_char
		end

	column_precision: INTEGER is
		do
			Result := display_size
		end

	sql_type_code: INTEGER is
		once
			Result := sql_longvarchar
		end
	
	decimal_digits: INTEGER is
		do 
			Result := 0
		end

	display_size: INTEGER is
		do
			Result := transfer_octet_length - 1
		end

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_value_get_length (buffer)
		end

feature -- Element change

	set_item (value : STRING) is
			-- set item to 'value', truncating if necessary
		local
			actual_length, transfer_length : INTEGER
		do
			if value.count > capacity then
				actual_length := capacity
				transfer_length := capacity
			else
				actual_length := value.count + 1
				transfer_length := actual_length - 1
			end
			protect
			ecli_c_value_set_value (buffer, string_to_pointer (value), actual_length)
			ecli_c_value_set_length_indicator (buffer, transfer_length)
			unprotect
		ensure then
			item_set: equal (item, truncated (value))		
		end
			
feature -- Conversion

	to_string : STRING is
			-- Conversion to STRING value
		do
			Result := clone (item)
		end

	to_character : CHARACTER is
			-- Conversion to CHARACTER value
		do
			Result := item @ 1
		ensure then
			result_is_first_character: Result = item @ 1
		end

	to_integer : INTEGER is
			-- 
		do
			Result := item.to_integer
		end
		
	to_double : DOUBLE is
			-- 
		do
			Result := item.to_double
		end
		
feature -- Basic operations

	out : STRING is
		do
			if is_null then
				Result := "NULL"
			else
				Result := item
			end
		end

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_string (Current)
		end
		

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	octet_size : INTEGER is do Result := transfer_octet_length end

	impl_item : STRING
	
end -- class ECLI_LONGVARCHAR
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
