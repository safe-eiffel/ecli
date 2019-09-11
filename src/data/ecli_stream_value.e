note
	description: "Values whose length is known at run-time.."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ECLI_STREAM_VALUE

inherit

	ECLI_VALUE
		redefine
			read_result,
			put_parameter,
			bind_as_parameter,
			is_buffer_too_small
		end

feature -- Access

feature -- Measurement

	input_count : INTEGER
			-- Count as input parameter
		deferred
		end

	capacity : INTEGER
		deferred
		end

feature -- Status report

	is_buffer_too_small : BOOLEAN
			-- <Precursor>
		do
			Result := input_count > capacity
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature {ECLI_STATEMENT} -- Basic operations

	bind_as_parameter (stmt: ECLI_STATEMENT; index: INTEGER_32)
			-- <Precursor>
		local
			length_at_execution : XS_C_INT64 --FIXME 64/32 bits
			parameter_rank : XS_C_INT32
		do
			-- If buffer is large enough, transfer in one piece
			if not is_buffer_too_small then
				if not is_null then
					ecli_c_value_set_length_indicator (buffer, input_count)
				end
				Precursor (stmt, index)
			else
				-- Transfer in multiple pieces with parameters at execution.
				create parameter_rank.make
				create length_at_execution.make
				parameter_rank.put (index)
				if attached stmt.info as info and then info.need_long_data_len then
					length_at_execution.put (ecli_c_len_data_at_exe (input_count))
				else
					length_at_execution.put (sql_data_at_exec)
				end
				stmt.set_status ("ecli_c_bind_parameter", ecli_c_bind_parameter (stmt.handle,
					index,
					Parameter_directions.Sql_param_input,
					c_type_code,
					sql_type_code,
					input_count,
					0,
					parameter_rank.as_pointer,
					capacity,
					length_at_execution.handle))
			end
		end

	put_parameter (stmt: ECLI_STATEMENT; index: INTEGER_32)
			-- <Precursor>
		do
			if not is_null then
				from
					put_parameter_start
				until
					put_parameter_off or else stmt.is_error
				loop
					copy_item_chunck_to_buffer (parameter_count_to_transfer)
					-- Actual transfer
					stmt.set_status ("ecli_c_put_data", ecli_c_put_data (stmt.handle, to_external, parameter_count_to_transfer))
					put_parameter_forth
				end
				if not stmt.is_error then
					put_parameter_finish
				end
			else
				stmt.set_status ("ecli_c_put_data", ecli_c_put_data (stmt.handle, to_external, ecli_c_value_get_length_indicator (buffer)))
			end
		end

	read_result (stmt: ECLI_STATEMENT; index: INTEGER_32)
			-- <Precursor>
		do
			from
				read_result_start
				--
				stmt.set_status ("ecli_c_get_data", ecli_c_get_data (
					stmt.handle,
					index,
					c_type_code,
					to_external,
					Transfer_octet_length,
					ecli_c_value_get_length_indicator_pointer (buffer)))
			until
				-- read_result_off
				is_null or else
				stmt.status = {ECLI_STATUS_CONSTANTS}.sql_success or else
				stmt.status = {ECLI_STATUS_CONSTANTS}.sql_no_data or else
				stmt.is_error
			loop
				copy_buffer_to_item (actual_transfer_length)
				--
				stmt.set_status ("ecli_c_get_data", ecli_c_get_data (
					stmt.handle,
					index,
					c_type_code,
					to_external,
					Transfer_octet_length,
					ecli_c_value_get_length_indicator_pointer (buffer)))
			end
			if stmt.status = {ECLI_STATUS_CONSTANTS}.sql_success and then not is_null then
				-- copy_buffer_to_item (actual_transfer_length)
				copy_buffer_to_item (actual_transfer_length)
			end
			read_result_finish
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

feature {NONE} -- Implementation

	actual_transfer_length : INTEGER
			-- <Precursor>
		local
			l_res : INTEGER_64
		do
				l_res := ecli_c_value_get_length_indicator (buffer)
				if l_res = {ECLI_STATUS_CONSTANTS}.Sql_no_total or else l_res > transfer_octet_length then
					l_res := transfer_octet_length
				end
				Result := l_res.as_integer_32 -- FIXME 64/32 bits
		ensure
			actual_transfer_length_not_greater_transfert_octet_length: Result <= transfer_octet_length
		end

	put_parameter_start
			-- Start parameter transfer.
		deferred
		end

	put_parameter_off : BOOLEAN
			-- Is parameter transfer finished ?
		deferred
		end

	put_parameter_forth
			-- Parameter transfer forth.
		deferred
		end

	put_parameter_finish
			-- Finish parameter transfer.
		do
		end

	parameter_count_to_transfer : INTEGER
			-- Number of bytes to transfer the next roundtrip.
		deferred
		end

	read_result_start
			-- Start reading result.
		deferred
		end

	read_result_finish
			-- Finish reading result.
		deferred
		end

	copy_buffer_to_item (a_length : INTEGER_32)
			-- Copy internal buffer to `item' implementation.
		require
			length_not_greater_transfer_octet_length: a_length >= 0 and a_length <= transfer_octet_length
		deferred
		end

	copy_item_chunck_to_buffer (a_length : INTEGER)
			-- Copy current `item' chunck to internal buffer.
		deferred
		end

invariant
	invariant_clause: True -- Your invariant here

end
