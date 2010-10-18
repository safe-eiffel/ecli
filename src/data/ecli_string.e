indexing
	description: 
	
		"Objects that map database character data to Eiffel STRING instances."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2010, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_STRING

inherit
	ECLI_STREAM_VALUE

	ECLI_STRING_VALUE
		undefine
			out,
			count,
			set_item,
			copy,
			read_result,
			put_parameter,
			bind_as_parameter,
			is_buffer_too_small
		redefine
			item
		end

create
	make_char,
	make_varchar,
	make_longvarchar

feature {NONE} -- Implementation

	make_char (n : INTEGER)
			-- Make as `CHAR' data, reserving a `n' bytes buffer.
		do
			sql_type_code_impl := sql_char
			make (n)
		end

	make_varchar (n : INTEGER)
			-- Make as `VARCHAR' data, reserving a `n' bytes buffer.
		do
			sql_type_code_impl := sql_varchar
			make (n)
		end

	make_longvarchar (n : INTEGER)
			-- Make as `LONGVARCHAR' data, reserving a `n' bytes buffer
		do
			sql_type_code_impl := sql_longvarchar
			make (n)
		end

feature -- Access

	item : STRING
			-- <Precursor>
		do
			if is_null then
				Result := ""
			else
				Result := impl_item.twin
			end
		end

	sql_type_code : INTEGER
			-- Type code for SQL exchange
		do
			Result := sql_type_code_impl
		end

feature -- Measurement

	count, input_count : INTEGER
			-- <Precursor>
		do
			Result := impl_item.count
		end

	default_maximum_capacity : INTEGER
		do
			Result := 4_000
		end

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_item (an_item : STRING)
			-- <Precursor>
		do
			impl_item.copy (an_item)
			if an_item.count <= capacity then
				ext_item.from_string (an_item)
			else
				ext_item.from_substring (an_item, 1, capacity)
			end
			ecli_c_value_set_length_indicator (buffer, capacity.min (an_item.count))
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	sql_type_code_impl : INTEGER

feature {} -- Implementation of ECLI_STREAM_VALUE deferred routines

	put_parameter_start
		do
			pp_count := input_count
			pp_transfer_count := capacity
			pp_remaining := pp_count
			pp_offset := 0
		end

	put_parameter_off : BOOLEAN
		do
			Result := pp_offset >= pp_count
		end

	put_parameter_forth
		do
			pp_remaining := pp_remaining - pp_transfer_count
			pp_offset := pp_offset + pp_transfer_count
		end

	parameter_count_to_transfer : INTEGER
		do
			pp_transfer_count := pp_transfer_count.min (pp_remaining)
			Result := pp_transfer_count
		end

	copy_item_chunck_to_buffer (a_length : INTEGER)
		do
			ext_item.from_substring (impl_item, pp_offset + 1, pp_offset + a_length)
		end

	pp_count : INTEGER
	pp_transfer_count : INTEGER
	pp_remaining : INTEGER
	pp_offset : INTEGER

	copy_buffer_to_item (a_length : INTEGER)
		do
			ext_item.append_substring_to (1, a_length.min (capacity), impl_item)
		end

	read_result_start
		do
			impl_item.wipe_out
		end

	read_result_finish
		do
		end

end

