indexing
	description: 
	
		"CLI SQL DOUBLE value"

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_DOUBLE

inherit
	ECLI_VALUE
		redefine
			item, set_item, out,
			to_double, convertible_to_double, to_integer, convertible_to_integer,
			to_real, convertible_to_real
		end

	KL_IMPORTED_STRING_ROUTINES
		undefine
			out
		end
	
	ECLI_EXTERNAL_TOOLS
		export
			{NONE} all
		undefine
			dispose, out
		end
	
creation
	make

feature -- Initialization

	make is
		do
			buffer := ecli_c_alloc_value (transfer_octet_length)
			create impl_item
		end
		
feature -- Access

	item : DOUBLE_REF is
		do
			if is_null then
				Result := Void
			else
				impl_item.set_item (to_double)
				Result := impl_item
			end
		end

feature -- Measurement

feature -- Status report

	convertible_to_double : BOOLEAN is
		do
			Result := True
		end

	convertible_to_integer : BOOLEAN is
		do
			Result := True
		end

	convertible_to_real : BOOLEAN is
		do
			Result := True
		end

feature -- Status setting


	c_type_code: INTEGER is
		once
			Result := sql_c_double
		end

	column_precision: INTEGER is
		do
			Result := 15
		end

	sql_type_code: INTEGER is
		once
			Result := sql_double
		end
	
	decimal_digits: INTEGER is
		do 
			Result := 0
		end

	display_size: INTEGER is
		do
			Result := 22
		end

	transfer_octet_length: INTEGER is
		do
			Result := 8
		end

feature -- Cursor movement

feature -- Element change

	set_item (value : like item) is
			-- set item to 'value', truncating if necessary
		do
			actual_value := value.item
			ecli_c_value_set_value (buffer, $actual_value, transfer_octet_length)
			ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	to_double : DOUBLE is
		do
			if not is_null then
				ecli_c_value_copy_value (buffer, $actual_value)
				Result := actual_value
			end
		end

	to_integer : INTEGER is
		do
			if not is_null then
				Result := to_double.truncated_to_integer
			end
		end

	to_real : REAL is
		do
			if not is_null then
				Result := to_double.truncated_to_real
			end
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_double (Current)
		end

	out : STRING is
		local
			message_buffer : C_STRING
		do
			if is_null then
				Result := "NULL"
			else
				create message_buffer.make (50)
				sprintf_double (message_buffer.handle, item.item)
				Result := pointer_to_string(message_buffer.handle)
			end
		end

feature {NONE} -- Implementation

	actual_value : DOUBLE
	
	sprintf_double (s : POINTER; d : DOUBLE) is
			-- 
		external "C" 
		alias "ecli_c_sprintf_double"
		end

end -- class ECLI_DOUBLE
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
