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
			item, set_item,
			to_real, convertible_to_real
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

feature -- Status setting


	c_type_code: INTEGER is
		once
			Result := sql_c_float --  !!!
		end

	column_precision: INTEGER is
		do
			Result := 7
		end

	db_type_code: INTEGER is
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
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	actual_value : REAL
	
invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_REAL
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
