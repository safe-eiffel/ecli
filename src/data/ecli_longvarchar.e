indexing
	description: 
	
		"SQL LONGVARCHAR (n) values"
		
	author: "Paul-G.Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_LONGVARCHAR

inherit
	ECLI_GENERIC_VALUE [STRING]
		redefine
			item, set_item,
--			convertible_as_string, as_string, 
--			convertible_as_character, as_character,
--			convertible_as_integer, as_integer, 
--			convertible_as_double, as_double, 
			out, 
			impl_item
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
			check_valid
			create s.make (0)
			impl_item := s
			set_null
			create ext_item.make_shared_from_pointer (ecli_c_value_get_value (buffer), capacity)
		ensure
			is_null: is_null
			capacity: capacity = n
		end
		
feature -- Access

	item : STRING is
		do
			if is_null then
				Result := Void
			else
				ext_item.copy_to (impl_item)
				Result := impl_item
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

	c_type_code: INTEGER is
		once
			Result := sql_c_char
		end

	sql_type_code: INTEGER is
		once
			Result := sql_longvarchar
		end

feature -- Measurement
		
	size: INTEGER is
		do
			Result := display_size
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

feature -- Status report

	convertible_as_string : BOOLEAN is 
		do
			Result := True
		end

	convertible_as_integer : BOOLEAN is 
		do
			Result := not is_null and then item.is_integer
		end

	convertible_as_double : BOOLEAN is 
		do
			Result := not is_null and then item.is_double
		end

	convertible_as_character : BOOLEAN is
		do
			Result := count > 0
		end

	convertible_as_boolean : BOOLEAN is
			-- Is this value convertible to a boolean ?
		do
			Result := not is_null and then item.is_boolean
		end


	convertible_as_real : BOOLEAN is
			-- Is this value convertible to a real ?
		do
			Result := not is_null and then item.is_real
		end

	convertible_as_date : BOOLEAN is
			-- Is this value convertible to a date ?
		do
			Result := False
		end

	convertible_as_time : BOOLEAN is
			-- Is this value convertible to a time ?
		do
			Result := False
		end

	convertible_as_timestamp : BOOLEAN is
			-- Is this value convertible to a timestamp ?
		do
			Result := False
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
			ext_item.from_string (value)
			ecli_c_value_set_length_indicator (buffer, transfer_length)
		end
			
feature -- Conversion

	out : STRING is
		do
			if is_null then
				Result := out_null
			else
				Result := item
			end
		end

	as_string : STRING is
			-- Conversion to STRING value
		do
			Result := clone (item)
		end

	as_character : CHARACTER is
			-- Conversion to CHARACTER value
		do
			Result := item @ 1
		ensure then
			result_is_first_character: Result = item @ 1
		end

	as_integer : INTEGER is
			-- 
		do
			Result := item.to_integer
		end
		
	as_double : DOUBLE is
			-- 
		do
			Result := item.to_double
		end

	as_boolean : BOOLEAN is
			-- Current converted to BOOLEAN
		do
			Result := item.to_boolean
		end

	as_real : REAL is
			-- Current converted to REAL
		do
			Result := item.to_real
		end

	as_date : DT_DATE is
			-- Current converted to DATE
		do
		end

	as_time : DT_TIME is
			-- Current converted to DT_TIME
		do
		end

	as_timestamp : DT_DATE_TIME is
			-- Current converted to DT_DATE_TIME
		do
		end

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER) is
			-- trace content into `a_tracer'
		do
			a_tracer.put_string (Current)
		end

	append_substring_to (i_start, i_end : INTEGER; string : STRING) is
			-- append substring [i_start..i_end] to string
		require
			i_start_ok: i_start > 0 and i_start <= i_end
			i_end_ok: i_end > 0 and i_end <= count
			string_exists: string /= Void
			not_null: not is_null
		do
			ext_item.append_substring_to (i_start, i_end, string)
		ensure
			string_set: string.substring (
				(old (string.count)) + 1, 
				string.count).is_equal (item.substring (i_start, i_end))			
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	octet_size : INTEGER is do Result := transfer_octet_length end

	impl_item : STRING

	ext_item : XS_C_STRING
	
invariant
	ext_item_exists: ext_item /= Void
	impl_item_exists: impl_item /= Void
	
end -- class ECLI_LONGVARCHAR
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
