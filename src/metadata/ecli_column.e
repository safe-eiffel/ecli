indexing
	description: "Objects that describe a SQL column in a table"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_COLUMN

inherit
	ECLI_NULLABLE_METADATA
		redefine
			out
		end

	ECLI_NAMED_METADATA
		undefine
			out
		end
	
creation
	make
	
feature -- Initialization

	make (cursor : ECLI_COLUMNS_CURSOR) is
			-- create from `cursor' current position
		require
			cursor_exists: cursor /= Void
			cursor_not_off: not cursor.off
		do
			set_catalog (cursor.buffer_table_cat)
			set_schema (cursor.buffer_table_schem )
			if cursor.buffer_table_name.is_null then
				
			else
				table := cursor.buffer_table_name.to_string
			end
			set_name (cursor.buffer_column_name)
			type_code := cursor.buffer_data_type.to_integer
			type_name := cursor.buffer_type_name.to_string
			if not cursor.buffer_column_size.is_null then
				size := cursor.buffer_column_size.to_integer
				is_size_applicable := True
			end
			if not cursor.buffer_buffer_length.is_null then
				transfer_length := cursor.buffer_buffer_length.to_integer
				is_transfer_length_applicable := True
			end
			if not cursor.buffer_decimal_digits.is_null then
				decimal_digits := cursor.buffer_decimal_digits.to_integer
				is_decimal_digits_applicable := True
			end
			if not cursor.buffer_num_prec_radix.is_null then
				precision_radix := cursor.buffer_num_prec_radix.to_integer
				is_precision_radix_applicable := True
			end
			nullability := cursor.buffer_nullable.to_integer
			if not cursor.buffer_remarks.is_null then
				description := cursor.buffer_remarks.to_string
			end
		end
		
feature -- Access

	table : STRING
	
--	name : STRING

	type_code : INTEGER

	type_name : STRING

	size : INTEGER
			-- size, display length, number of bits, ... depending on actual datatype 
		
	transfer_length : INTEGER
			-- maximum number of bytes to read for a transfer
		
	decimal_digits : INTEGER
			-- number of decimal digits if numeric type

	precision_radix : INTEGER
			-- 10 or 2 if numeric type
		
	description : STRING
			-- optional comments, remarks, or description regarding this column
	
feature -- Measurement

	is_size_applicable : BOOLEAN
	is_transfer_length_applicable : BOOLEAN
	is_decimal_digits_applicable : BOOLEAN
	is_precision_radix_applicable : BOOLEAN
	
feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out : STRING is
		do
			!!Result.make (0)
			Result.append  (name); Result.append  ("%T")
			Result.append  (type_code.out); Result.append  ("%T")
			Result.append  (type_name); Result.append  ("%T")
			if is_size_applicable then
				Result.append  ("(") Result.append  (size.out) Result.append  (")")
			end
			Result.append  ("%T")
			if is_transfer_length_applicable then
				Result.append  (transfer_length.out)
			end
			Result.append  ("%T")
			if is_decimal_digits_applicable then
				Result.append  (decimal_digits.out)
			end
			Result.append  ("%T")
			if is_known_nullability then
				if is_nullable then
					Result.append  ("NULLABLE")
				elseif is_not_nullable then
					Result.append  ("NOT NULL")
				end
			else
				Result.append  ("?NULLABLE?")
			end
			Result.append  ("%T")
			if is_precision_radix_applicable then
				Result.append  (precision_radix.out)
			end
			Result.append ("%T")
			if description /= Void then
				Result.append (description)
			end
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_COLUMN
