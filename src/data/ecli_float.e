indexing
	description: "CLI SQL FLOAT value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_FLOAT

inherit
	ECLI_VALUE
		redefine
			item, set_item, out,
			to_double, convertible_to_double
		end

creation
	make

feature -- Initialization

	make is
		do
			buffer := ecli_c_alloc_value (8)
		end
		
feature -- Access

	item : DOUBLE_REF is
		local
			tools : ECLI_EXTERNAL_TOOLS
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

	convertible_to_double : BOOLEAN is
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

	db_type_code: INTEGER is
		once
			Result := sql_float
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
			Result := ecli_c_value_get_length (buffer)
		end

feature -- Cursor movement

feature -- Element change

	set_item (value : like item) is
			-- set item to 'value', truncating if necessary
		local
			tools : ECLI_EXTERNAL_TOOLS
		do
			if value = Void then
				set_null
			else
				actual_value := value.item
				ecli_c_value_set_value (buffer, $actual_value, transfer_octet_length)
				ecli_c_value_set_length_indicator (buffer, transfer_octet_length)
			end
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	to_double : DOUBLE is
		do
			if not is_null then
				Result := item.item
			end
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_float (Current)
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
				sprintf_double (ext.string_to_pointer(message_buffer), item.item)
				Result := ext.pointer_to_string(ext.string_to_pointer (message_buffer))
			end
		end

feature {NONE} -- Implementation

	actual_value : DOUBLE
	
	sprintf_double (s : POINTER; d : DOUBLE) is
			-- 
		external "C" 
		alias "ecli_c_sprintf_double"
		end

end -- class ECLI_FLOAT
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
