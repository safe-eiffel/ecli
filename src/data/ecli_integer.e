indexing
	description: 
	
		"SQL INTEGER values"
		
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_INTEGER

inherit
	ECLI_GENERIC_VALUE [INTEGER]
		redefine
			item, set_item, out,
			as_integer, convertible_as_integer,
			as_real, convertible_as_real,
			as_double, convertible_as_double
		end

	XS_C_MEMORY_ROUTINES
		undefine
			copy,out, is_equal
		end

creation
	make

feature -- Initialization

	make is
		do
			buffer := ecli_c_alloc_value (4)
			check_valid
			set_null
		ensure
			is_null: is_null
		end

feature -- Access

	item : INTEGER is
		do
			Result := c_memory_get_int32 (ecli_c_value_get_value (buffer))
		end

	c_type_code: INTEGER is
		once
			Result := sql_c_long
		end

	sql_type_code: INTEGER is
		once
			Result := sql_integer
		end

feature -- Measurement

	size : INTEGER is
		do
			Result := 10
		end

	decimal_digits: INTEGER is
		do
			Result := 0
		end

	display_size: INTEGER is
		do
			Result := 11
		end

	transfer_octet_length: INTEGER is
		do
			Result := 4
		ensure then
			integer_32: Result = 4
		end

feature -- Status report

	convertible_as_integer : BOOLEAN is
		do
			Result := True
		end

	convertible_as_double : BOOLEAN is
		do
			Result := True
		end

	convertible_as_real : BOOLEAN is
		do
			Result := True
		end

	convertible_as_string : BOOLEAN is
			-- Is this value convertible to a string ?
		do
			Result := True
		end

	convertible_as_character : BOOLEAN is
			-- Is this value convertible to a character ?
		do
			Result := False
		end

	convertible_as_boolean : BOOLEAN is
			-- Is this value convertible to a boolean ?
		do
			Result := False
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

feature -- Cursor movement

feature -- Element change

	set_item (value : INTEGER) is
			-- set item to 'value', truncating if necessary
		do
			--impl_item := value
			--ecli_c_value_set_value (buffer, $impl_item, transfer_octet_length)
			c_memory_put_int32 (ecli_c_value_get_value(buffer), value)
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	as_integer : INTEGER is
		do
			Result := item
		end

	as_real : REAL is
		do
			Result := item
		end

	as_double : DOUBLE is
		do
			Result := item
		end

	as_string : STRING is
			-- Current converted to STRING
		do
			Result := item.out
		end

	as_character : CHARACTER is
			-- Current converted to CHARACTER 
		do
		end

	as_boolean : BOOLEAN is
			-- Current converted to BOOLEAN
		do
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

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations


	out : STRING is
		do
			if is_null then
				Result := out_null
			else
				Result := item.out
			end
		end

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_integer (Current)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	octet_size : INTEGER is 
		do 
			Result := 4 
		ensure 
			result_is_4: Result = 4 
		end

end -- class ECLI_INTEGER
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
