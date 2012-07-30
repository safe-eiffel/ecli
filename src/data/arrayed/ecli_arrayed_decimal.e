indexing

	description:

	    "DECIMAL (precision, decimal digits) arrayed values."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_ARRAYED_DECIMAL

inherit

	ECLI_GENERIC_ARRAYED_VALUE [MA_DECIMAL]
		rename
			make as make_arrayed
		undefine
			bind_as_parameter
		redefine
			set_item, out, copy
		select
			is_equal, copy
		end

	ECLI_DECIMAL
		rename
			make_with_rounding as make_single_with_rounding,
			make as make_single,
			is_equal as is_equal_item,
			copy as copy_item
--		export
--			{NONE} make_single
		undefine
			release_handle, length_indicator_pointer,
			to_external, is_null, set_null, set_item
----			, as_string
		redefine
			item, transfer_octet_length, out, trace
		end

create

	make,
	make_with_rounding

feature {NONE} -- Initialization

	make (a_capacity : INTEGER; new_precision, new_decimal_digits : INTEGER)
			-- Create with `a_capacity', `new_precision' and `new_decimal_digits'.
		require
			a_capacity_ge_1: a_capacity >= 1
			valid_new_precision: new_precision > 0
			valid_new_decimal_digits: new_decimal_digits >=0 and new_decimal_digits <= new_precision
		do
			make_with_rounding (a_capacity, new_precision, new_decimal_digits, default_rounding_mode)
		end

	make_with_rounding (a_capacity : INTEGER; new_precision, new_decimal_digits, new_rounding_mode : INTEGER) is
			-- Create with `new_precision' and `new_decimal_digits' and `new_rounding_mode'.
		require
			a_capacity_ge_1: a_capacity >= 1
			valid_new_precision: new_precision > 0
			valid_new_decimal_digits: new_decimal_digits >=0 and new_decimal_digits <= new_precision
			valid_rounding_mode: new_rounding_mode >= Round_up and then new_rounding_mode <= Round_unnecessary
		do
			precision := new_precision
			decimal_digits := new_decimal_digits
			capacity := a_capacity
			count := capacity
			create rounding_context.make (precision, new_rounding_mode)
			buffer := ecli_c_alloc_array_value (new_precision + 3, a_capacity)
			set_all_null
			create ext_item.make_shared_from_pointer (ecli_c_array_value_get_value_at (buffer, 1),
					transfer_octet_length)
		ensure
			is_null: is_null
			precision_set: precision = new_precision
			decimal_digits_set: decimal_digits = new_decimal_digits
			rounding_context_set: rounding_context /= Void and then rounding_context.digits = new_precision
			round_mode_set: rounding_context.rounding_mode = new_rounding_mode
		end

	make_arrayed (a_capacity : INTEGER) is
			-- dummy one
		do
		end

feature -- Access

	item : MA_DECIMAL is
		do
			Result := item_at (cursor_index)
		end

	item_at (index : INTEGER) : MA_DECIMAL is
			--
		do
			if is_null_at (index) then
				Result := Void
			else
				ext_item.make_shared_from_pointer (ecli_c_array_value_get_value_at (buffer, index),
					ecli_c_array_value_get_length_indicator_at(buffer,index).as_integer_32)
				create Result.make_from_string_ctx (ext_item.as_string, rounding_context)
			end
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_array_value_get_length (buffer).as_integer_32
		end

feature -- Cursor movement

feature -- Element change

	set_item (value : like item) is
			-- set item to 'value', truncating if necessary
		do
			set_item_at (value, cursor_index)
		end

	set_item_at (value : like item; index : INTEGER) is
		local
			l : MA_DECIMAL
			s : STRING
		do
			l := value.rescale (-decimal_digits, rounding_context)
			s := l.to_scientific_string
			if s.count <= transfer_octet_length then
				ext_item.make_shared_from_pointer (ecli_c_array_value_get_value_at (buffer, index), transfer_octet_length )
				ext_item.from_string (s)
			end
			ecli_c_array_value_set_length_indicator_at (buffer, s.count, index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	out : STRING is
		local
			i : INTEGER
		do
			from i := 1
				create Result.make (10)
				Result.append_string ("<<")
			until i > count
			loop
				if is_null_at (i) then
					Result.append_string (out_null)
				else
					Result.append_string (item_at (i).out)
				end
				i := i + 1
				if i <= count then
					Result.append_string (", ")
				end
			end
			Result.append_string (">>")
		end

	trace (a_tracer : ECLI_TRACER) is
		do
			a_tracer.put_decimal (Current)
		end

feature -- Element change

	copy (other: like Current)
		do
			precision := other.precision
			decimal_digits := other.decimal_digits
			rounding_context := other.rounding_context.twin
			copy_arrayed_items (other)
		ensure then
			precision_changed: precision = other.precision
			decimal_digits_changed: decimal_digits = other.decimal_digits
		end

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_ARRAYED_DECIMAL
