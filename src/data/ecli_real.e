indexing
	description: "CLI SQL REAL value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_REAL

inherit
	ECLI_VALUE
		redefine
			item, set_item, out,
			to_real, convertible_to_real,
			to_integer, convertible_to_integer,
			to_double, convertible_to_double
		end

creation
	make

feature -- Initialization

	make is
		do
			buffer := ecli_c_alloc_value (4)
		end
		
feature -- Access

	item : REAL_REF is
		do
			if is_null then
				Result := Void
			else
				ecli_c_value_copy_value (buffer, $actual_value)
				!! Result
				Result.set_item (actual_value)
			end
		end

feature -- Measurement

feature -- Status report

	convertible_to_real : BOOLEAN is
		do
			Result := True
		end

	convertible_to_double : BOOLEAN is
		do
			Result := True
		end
	
	convertible_to_integer : BOOLEAN is
		do
			Result := True
		end
		
feature -- Status setting


	c_type_code: INTEGER is
		once
			Result := sql_c_float --  !!!
		end

	column_precision: INTEGER is
		do
			Result := 7
		end

	sql_type_code: INTEGER is
		once
			Result := sql_real
		end
	
	decimal_digits: INTEGER is
		do 
			Result := 0
		end

	display_size: INTEGER is
		do
			Result := 13
		end

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_value_get_length (buffer)
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

	to_real : REAL is
		do
			if not is_null then
				Result := item.item
			end
		end
	
	to_double : DOUBLE is
		do
			if not is_null then
				Result := item.item
			end
		end
		
	to_integer : INTEGER is
		do
			if not is_null then
				Result := item.truncated_to_integer
			end
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_real (Current)
		end

	out : STRING is
		local
			ext : expanded ECLI_EXTERNAL_TOOLS
			message_buffer : MESSAGE_BUFFER
		do
			if is_null then
				Result := "NULL"
			else
				!!message_buffer.make (50)
				message_buffer.fill_blank
				sprintf_real (ext.string_to_pointer(message_buffer), item.item)
				Result := ext.pointer_to_string(ext.string_to_pointer (message_buffer))
			end
		end

feature {NONE} -- Implementation

	actual_value : REAL
	

	sprintf_real (s : POINTER; r : REAL) is
			-- 
		external "C" 
		alias "ecli_c_sprintf_real"
		end

end -- class ECLI_REAL
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
