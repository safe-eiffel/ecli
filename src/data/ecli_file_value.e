indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class

	ECLI_FILE_VALUE

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
	
feature {NONE} -- Initialization

	make_input (an_input_file : like input_file) is
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
		require
			an_output_file_exists: an_output_file /= Void and then an_output_file.exists
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
	size: INTEGER
		
	display_size: INTEGER is
		do
			Result := size
		end
		
	transfer_octet_length: INTEGER is 1024

feature -- Status report

	is_input : BOOLEAN is
			-- Is Current an buffer for database input ?
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

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_input_file (an_input_file : like input_file) is
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
		local
			length_at_execution : XS_C_INT32
			parameter_rank : XS_C_INT32
		do
			create parameter_rank.make
			create length_at_execution.make
			parameter_rank.put (index)
			length_at_execution.put (ecli_c_len_data_at_exe (size))
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
		do
			if not is_null then
				from
					input_file.open_read
					input_file.read_string (Transfer_octet_length)
				until
					input_file.end_of_input
				loop
					ext_item.from_string (input_file.last_string)
					stmt.set_status (ecli_c_put_data (stmt.handle, to_external, input_file.last_string.count))
					input_file.read_string (Transfer_octet_length)
				end
				input_file.close
			else
					stmt.set_status (ecli_c_put_data (stmt.handle, to_external, ecli_c_value_get_length_indicator (buffer)))
			end
		end
		
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	internal_make is
		do
			buffer := ecli_c_alloc_value (transfer_octet_length)
			create ext_item.make_shared_from_pointer (ecli_c_value_get_value (buffer), Transfer_octet_length)
		end
		
	ext_item : XS_C_STRING

	get_transfer_length : INTEGER is
		do
				Result := ecli_c_value_get_length_indicator (buffer)
				if Result = Sql_no_total or else Result > Transfer_octet_length then
					Result := Transfer_octet_length
				end
		end
		
invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_FILE_VALUE
