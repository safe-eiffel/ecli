indexing
	description: "CLI SQL INTEGER value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_INTEGER

inherit
	ECLI_VALUE
		redefine
			item, set_item, out,
			to_integer, convertible_to_integer
		end

creation
	make

feature -- Initialization

	make is
		do
			buffer := ecli_c_alloc_value (4)
		end

feature -- Access

	item : INTEGER_REF is
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

	convertible_to_integer : BOOLEAN is
		do
			Result := True
		end


feature -- Status setting


	c_type_code: INTEGER is
		once
			Result := sql_c_long
		end

	column_precision: INTEGER is
		do
			Result := 10
		end

	db_type_code: INTEGER is
		once
			Result := sql_integer
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

	to_integer : INTEGER is
		do
			if not is_null then
				Result := item.item
			end
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations


	out : STRING is
		do
			if is_null then
				Result := "NULL"
			else
				Result := item.item.out
			end
		end

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_integer (Current)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	actual_value : INTEGER

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_INTEGER
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
