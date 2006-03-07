indexing

	description:
	
			"Objects that transfer large data from/into a file."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_FILE_VALUE

inherit

	ECLI_VALUE
		redefine
			read_result,
			put_parameter,
			bind_as_parameter
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

	make_input (an_input_file : like input_file) is
			-- make for reading from `an_input_file'
		require
			an_input_file_exists: an_input_file /= Void and then an_input_file.exists
			an_input_file_not_open: not an_input_file.is_open_read
		do
			set_input_file (an_input_file)
			internal_make
		ensure
			input_file_set: input_file = an_input_file
			size_set: size = input_file.count
		end
		
	make_output (an_output_file : like output_file) is
			-- make for writing to `an_output_file'
		require
			an_output_file_not_void: an_output_file /= Void
			an_output_file_not_open: not an_output_file.is_open_write
		do
			size := an_output_file.count
			output_file := an_output_file
			internal_make
		ensure
			output_file_set: output_file = an_output_file
			size_set: size = output_file.count
		end

feature -- Access

	input_file : KI_BINARY_INPUT_FILE
	
	output_file : KI_BINARY_OUTPUT_FILE

	c_type_code: INTEGER is
		do
			Result := sql_c_default
		end
	
feature -- Measurement

	decimal_digits: INTEGER
			-- number of decimal digits
			
	size: INTEGER
		
	display_size: INTEGER is
		do
			Result := size
		end
		
	transfer_octet_length: INTEGER is 4096
	

feature -- Status report

	is_input : BOOLEAN is
			-- Is Current a buffer for database input ?
		do
			Result := input_file /= Void
		ensure
			definition: Result = (input_file /= Void)
		end
		
	is_output : BOOLEAN is
			-- Is Current a buffer for database output ?
		do
			Result := output_file /= Void
		ensure
			definition: Result = (output_file /= Void)
		end
		
	convertible_as_boolean: BOOLEAN is do  end
	convertible_as_character: BOOLEAN is do  end
	convertible_as_date: BOOLEAN is do  end
	convertible_as_double: BOOLEAN is do  end
	convertible_as_integer: BOOLEAN is do  end
	convertible_as_real: BOOLEAN is do  end
	convertible_as_string: BOOLEAN is do  end
	convertible_as_time: BOOLEAN is do  end
	convertible_as_timestamp: BOOLEAN is do  end

	convertible_as_decimal : BOOLEAN is
			-- Is this value convertible to a decimal ?
		do
			Result := False
		end


feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_input_file (an_input_file : like input_file) is
			-- change `input_file' to `an_input_file'
		require
			not_is_output: not is_output
			an_input_file_exists: an_input_file /= Void and then an_input_file.exists
			an_input_file_not_open: not an_input_file.is_open_read
		do
			input_file := an_input_file
			size := an_input_file.count
		ensure
			input_file_set: input_file = an_input_file
			size_set: size = input_file.count
		end

	set_output_file (an_output_file : like output_file) is
			-- change `output_file' to `an_output_file'
		require
			not_is_input: not is_input
			an_output_file_exists: an_output_file /= Void and then an_output_file.exists
			an_output_file_not_open: not an_output_file.is_open_write
		do
			output_file := an_output_file
			size := an_output_file.count
		ensure
			output_file_set: output_file = an_output_file
			size_set: size = output_file.count
		end
		
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	trace (a_tracer: ECLI_TRACER) is
		do
			a_tracer.put_file (Current)
		end
		
	as_boolean: BOOLEAN is do  end
	as_character: CHARACTER is do  end
	as_date: DT_DATE is do  end
	as_double: DOUBLE is do  end
	as_decimal : MA_DECIMAL is do end
	as_integer: INTEGER is do  end
	as_real: REAL is do  end
	as_string: STRING is do  end
	as_time: DT_TIME is do  end
	as_timestamp: DT_DATE_TIME is do  end

feature -- Comparison

	is_equal (other : like Current) : BOOLEAN is
		do
			if input_file /= Void and then other.input_file /= Void then
				Result := input_file.name.is_equal (other.input_file.name)
			elseif output_file /= Void and then other.output_file /= Void then
				Result := output_file.name.is_equal (other.output_file.name)				
			end
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	bind_as_parameter (stmt: ECLI_STATEMENT; index: INTEGER) is
			-- bind as `index'-th parameter of `stmt'
		local
			length_at_execution : XS_C_INT32
			parameter_rank : XS_C_INT32
		do
			create parameter_rank.make
			create length_at_execution.make
			parameter_rank.put (index)
			if stmt.info.need_long_data_len then
				length_at_execution.put (ecli_c_len_data_at_exe (size))
			else
				length_at_execution.put (sql_data_at_exec)
			end
			stmt.set_status (ecli_c_bind_parameter (stmt.handle,
				index,
				Parameter_directions.Sql_param_input,
				c_type_code,
				sql_type_code,
				size,
				decimal_digits,
				parameter_rank.as_pointer,
				transfer_octet_length,
				length_at_execution.handle))
		end
		
	read_result (stmt: ECLI_STATEMENT; index: INTEGER) is
			-- read `index'-th result of `stmt', writing into `output_file'
		local
			transfer_string : STRING
			transfer_length : INTEGER
		do
			from
				output_file.open_write
				stmt.set_status (ecli_c_get_data (
					stmt.handle, 
					index, 
					c_type_code, 
					to_external, 
					Transfer_octet_length, 
					ecli_c_value_get_length_indicator_pointer (buffer)))
				create transfer_string.make (Transfer_octet_length)
			until
				is_null or else stmt.status = sql_no_data
			loop
				transfer_string.wipe_out
				transfer_length := get_transfer_length
				ext_item.append_substring_to (1, transfer_length, transfer_string)
				output_file.put_string (transfer_string) 
				stmt.set_status (ecli_c_get_data (
					stmt.handle, 
					index, 
					c_type_code, 
					to_external, 
					Transfer_octet_length, 
					ecli_c_value_get_length_indicator_pointer (buffer)))
			end
			output_file.close
		end
		
	put_parameter (stmt: ECLI_STATEMENT; index: INTEGER) is
			-- Put `index'-th parameter of `stmt' by reading data from `input_file'.
		local
			l_total, l_count : INTEGER
		do
			if not is_null then
				from
					input_file.open_read
					input_file.read_string (Transfer_octet_length)
				until
					input_file.end_of_input
				loop
					l_count := input_file.last_string.count
					l_total := l_total + l_count 
					ext_item.from_string (input_file.last_string)
					stmt.set_status (ecli_c_put_data (stmt.handle, to_external, l_count))
					input_file.read_string (Transfer_octet_length)
				end
				input_file.close
			else
				stmt.set_status (ecli_c_put_data (stmt.handle, to_external, ecli_c_value_get_length_indicator (buffer)))
			end
		end
		
feature {NONE} -- Implementation

	internal_make is
		do
			buffer := ecli_c_alloc_value (transfer_octet_length)
			create ext_item.make_shared_from_pointer (ecli_c_value_get_value (buffer), Transfer_octet_length)
		end
		
	ext_item : XS_C_STRING
			-- handle to buffer seen as a string
			
	get_transfer_length : INTEGER is
		do
				Result := ecli_c_value_get_length_indicator (buffer)
				if Result = Sql_no_total or else Result > Transfer_octet_length then
					Result := Transfer_octet_length
				end
		end
		
invariant

	ext_item_not_void: ext_item /= Void
	ext_item_shares_buffer: ext_item.to_external = ecli_c_value_get_value (buffer)
	input_xor_output: is_input xor is_output
	
end
