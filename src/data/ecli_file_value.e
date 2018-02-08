note

	description:

			"Objects that transfer large data from/into a file."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_FILE_VALUE

inherit

	ECLI_STREAM_VALUE

		redefine
			put_parameter_finish
		end

	ECLI_STATUS_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal
		end

	KL_SHARED_FILE_SYSTEM
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_input (an_input_file : attached like input_file)
			-- make for reading from `an_input_file'
		require
			an_input_file_not_void: an_input_file /= Void --FIXME: VS-DEL
			an_input_file_exists: an_input_file.exists
			an_input_file_not_open: not an_input_file.is_open_read
		do
			set_input_file (an_input_file)
			internal_make
		ensure
			input_file_set: input_file = an_input_file
			size_set: attached input_file as f and then size = f.count
		end

	make_output (an_output_file : attached like output_file)
			-- make for writing to `an_output_file'
		require
			an_output_file_not_void: an_output_file /= Void --FIXME: VS-DEL
			an_output_file_not_open: not an_output_file.is_open_write
		do
			size := an_output_file.count
			output_file := an_output_file
			internal_make
		ensure
			output_file_set: output_file = an_output_file
			size_set: attached output_file as f and then size = f.count
		end

feature -- Access

	input_file : detachable KI_INPUT_FILE

	output_file : detachable KI_OUTPUT_FILE

	c_type_code: INTEGER
		do
			Result := sql_c_default
		end

feature -- Measurement

	decimal_digits: INTEGER
			-- number of decimal digits

	size: INTEGER_64

	display_size: INTEGER
		do
			Result := size.as_integer_32
		end

	transfer_octet_length: INTEGER_64 = 4096


feature -- Status report

	is_input : BOOLEAN
			-- Is Current a buffer for database input ?
		do
			Result := attached input_file
		ensure
			definition: Result = attached input_file
		end

	is_output : BOOLEAN
			-- Is Current a buffer for database output ?
		do
			Result := attached output_file
		ensure
			definition: Result = attached output_file
		end

	convertible_as_boolean: BOOLEAN
			-- Is this value convertible to a boolean ?
		do
			Result := False
		end

	convertible_as_character: BOOLEAN
			-- Is this value convertible to a character ?
		do
			Result := False
		end

	convertible_as_date: BOOLEAN
			-- Is this value convertible to a date ?
		do
			Result := False
		end

	convertible_as_double: BOOLEAN
			-- Is this value convertible to a double ?
		do
			Result := False
		end

	convertible_as_integer: BOOLEAN
			-- Is this value convertible to a integer ?
		do
			Result := False
		end

	convertible_as_real: BOOLEAN
			-- Is this value convertible to a real ?
		do
			Result := False
		end

	convertible_as_string: BOOLEAN
			-- Is this value convertible to a string ?
		do
			Result := False
		end

	convertible_as_time: BOOLEAN
			-- Is this value convertible to a time ?
		do
			Result := False
		end

	convertible_as_timestamp: BOOLEAN
			-- Is this value convertible to a timestamp ?
		do
			Result := False
		end

	convertible_as_integer_64 : BOOLEAN
			-- Is this value convertible to a INTEGER_64 ?
		do
			Result := False
		end


	convertible_as_decimal : BOOLEAN
			-- Is this value convertible to a decimal ?
		do
			Result := False
		end


feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_input_file (an_input_file : attached like input_file)
			-- change `input_file' to `an_input_file'
		require
			not_is_output: not is_output
			an_input_file_not_void: an_input_file /= Void
			an_input_file_exists: an_input_file.exists
			an_input_file_not_open: not an_input_file.is_open_read
		do
			input_file := an_input_file
			size := an_input_file.count
		ensure
			input_file_set: input_file = an_input_file
			size_set: attached input_file as f and then size = f.count
		end

	set_output_file (an_output_file : attached like output_file)
			-- change `output_file' to `an_output_file'
		require
			not_is_input: not is_input
			an_output_file_not_void: an_output_file /= Void
			an_output_fileexists: an_output_file.exists
			an_output_file_not_open: not an_output_file.is_open_write
		do
			output_file := an_output_file
			size := an_output_file.count
		ensure
			output_file_set: output_file = an_output_file
			size_set: attached output_file as f and then size = f.count
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	trace (a_tracer: ECLI_TRACER)
		do
			a_tracer.put_file (Current)
		end

	as_boolean: BOOLEAN do  end
	as_character: CHARACTER do  end
	as_date: DT_DATE do check False then create Result.make_from_day_count (0) end end
	as_double: DOUBLE do  end
	as_decimal : MA_DECIMAL do check False then create Result.make_zero end end
	as_integer: INTEGER do  end
	as_integer_64: INTEGER_64 do  end
	as_real: REAL do  end
	as_string: STRING do check False then create Result.make_empty end end
	as_time: DT_TIME do check False then create Result.make_from_second_count (0) end end
	as_timestamp: DT_DATE_TIME do check False then create Result.make_from_epoch (0) end end

feature -- Comparison

	is_equal (other : like Current) : BOOLEAN
		do
			if attached input_file as l_if and then attached other.input_file as o_if then
				if attached l_if.name as l_if_name and then attached o_if.name as l_oif_name then
					Result := l_if_name.is_equal (l_oif_name)
				end
			elseif attached output_file as l_of and then attached other.output_file as o_of then
				if attached l_of.name as l_of_name and then attached o_of.name as l_oof_name then
					Result := l_of_name.is_equal (l_oof_name)
				end
			end

--			if input_file /= Void and then other.input_file /= Void then
--				Result := input_file.name.is_equal (other.input_file.name)
--			elseif output_file /= Void and then other.output_file /= Void then
--				Result := output_file.name.is_equal (other.output_file.name)
--			end
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

--	bind_as_parameter (stmt: ECLI_STATEMENT; index: INTEGER) is
--			-- bind as `index'-th parameter of `stmt'
--		local
--			length_at_execution : XS_C_INT32
--			parameter_rank : XS_C_INT32
--		do
--			create parameter_rank.make
--			create length_at_execution.make
--			parameter_rank.put (index)
--			if stmt.info.need_long_data_len then
--				length_at_execution.put (ecli_c_len_data_at_exe (size))
--			else
--				length_at_execution.put (sql_data_at_exec)
--			end
--			stmt.set_status ("ecli_c_bind_parameter", ecli_c_bind_parameter (stmt.handle,
--				index,
--				Parameter_directions.Sql_param_input,
--				c_type_code,
--				sql_type_code,
--				size,
--				decimal_digits,
--				parameter_rank.as_pointer,
--				transfer_octet_length,
--				length_at_execution.handle))
--		end

--	read_result (stmt: ECLI_STATEMENT; index: INTEGER) is
--			-- read `index'-th result of `stmt', writing into `output_file'
--		local
--		do
--			from
--				stmt.set_status ("ecli_c_get_data", ecli_c_get_data (
--					stmt.handle,
--					index,
--					c_type_code,
--					to_external,
--					Transfer_octet_length,
--					ecli_c_value_get_length_indicator_pointer (buffer)))
--			until
--				is_null or else stmt.status = sql_no_data
--			loop
--				transfer_length := get_transfer_length
--				transfer_string.wipe_out
--				ext_item.append_substring_to (1, transfer_length, transfer_string)
--				output_file.put_string (transfer_string)
--				stmt.set_status ("ecli_c_get_data", ecli_c_get_data (
--					stmt.handle,
--					index,
--					c_type_code,
--					to_external,
--					Transfer_octet_length,
--					ecli_c_value_get_length_indicator_pointer (buffer)))
--			end
--			output_file.close
--		end

feature {NONE} -- Implementation

	internal_make
		do
			buffer := ecli_c_alloc_value (transfer_octet_length)
			create ext_item.make_shared_from_pointer (ecli_c_value_get_value (buffer), Transfer_octet_length.as_integer_32)
			create transfer_string.make_empty
		end

	ext_item : XS_C_STRING
			-- handle to buffer seen as a string

	transfer_string : STRING
	transfer_length : INTEGER

	put_parameter_off: BOOLEAN
		do
			if attached input_file as f then
				Result := f.end_of_input
			else
				Result := True
			end
		end

	put_parameter_forth
		do
			if attached input_file as f then
				f.read_string (Transfer_octet_length.as_integer_32)
			end
		end

	put_parameter_start
		do
			if attached input_file as f then
				f.open_read
				f.read_string (Transfer_octet_length.as_integer_32)
			end
		end

	put_parameter_finish
		do
			if attached input_file as f then
				f.close
			end
		end

	read_result_start
		do
			if attached output_file as f then
				f.open_write
			end
			create transfer_string.make (Transfer_octet_length.as_integer_32)
		end

	read_result_finish
		do
			if attached output_file as f then
				f.close
			end
		end

	copy_item_chunck_to_buffer (a_length: INTEGER_32)
		do
			if attached input_file as in and then attached in.last_string as ls then
				ext_item.from_string (ls)
			end
		end

	copy_buffer_to_item (a_length: INTEGER_32)
		do
			transfer_string.wipe_out
			ext_item.append_substring_to (1, a_length, transfer_string)
			if attached output_file as f then
				f.put_string (transfer_string)
			end
		end

	parameter_count_to_transfer: INTEGER_32
		do
			if attached input_file as f then
				Result := f.last_string.count
			end
		end

	capacity: INTEGER_32
			-- FIXME: 64 bits
		do
			Result := transfer_octet_length.as_integer_32
		end

	input_count: INTEGER_32
		do
			if attached input_file as f and then f.is_closed then
				input_count_impl := f.count
			else
				input_count_impl := 0
			end
			Result := input_count_impl
		end

--	length: INTEGER_32
--		do
--		end

	input_count_impl : INTEGER

invariant

	ext_item_not_void: ext_item /= Void
	ext_item_shares_buffer: ext_item.to_external = ecli_c_value_get_value (buffer)
	input_xor_output: is_input xor is_output

end
