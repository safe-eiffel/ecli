indexing
	description: "CLI C Interface"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_EXTERNAL_API

feature {NONE} -- Implementation

	ecli_c_allocate_environment (penv : POINTER) : INTEGER is
			-- allocate new environment handle
		external "C"
		end

	ecli_c_free_environment (env : POINTER) : INTEGER is
			-- free environment handle
		external "C"
		end

	ecli_c_allocate_connection (env : POINTER; pcon : POINTER) : INTEGER is
			-- allocate new connection handle
		external "C"
		end

	ecli_c_free_connection (con : POINTER) : INTEGER is
			-- free connection handle
		external "C"
		end

	ecli_c_allocate_statement (con : POINTER; pstmt : POINTER) : INTEGER is
			-- allocate statement handle
		external "C"
		end

	ecli_c_free_statement (stmt : POINTER) : INTEGER is
			-- free statement handle
		external "C"
		end

	ecli_c_connect (con : POINTER; data_source, user, password : POINTER) : INTEGER is
			-- connect 'con' on 'data_source' for 'user' with 'password'
		external "C"
		end

	ecli_c_disconnect (con : POINTER) : INTEGER is
			-- disconnect 'con'
		external "C"
		end

	ecli_c_set_manual_commit (con : POINTER; flag_manual : BOOLEAN) : INTEGER is
			-- set 'manual commit mode' to 'flag_manual'
		external "C"
		end

	ecli_c_is_manual_commit (con : POINTER; flag_manual : POINTER) : INTEGER is
			-- set 'flag_manual' to True if in manual commit mode
		external "C"
		end

	ecli_c_commit (con : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_rollback (con : POINTER) : INTEGER is
		external "C"
		end
	
	ecli_c_parameter_count (stmt : POINTER; count : POINTER) : INTEGER  is
		external "C"
		end

	ecli_c_result_column_count (stmt : POINTER; count : POINTER) : INTEGER  is
		external "C"
		end
	
	ecli_c_prepare (stmt : POINTER; sql : POINTER) : INTEGER is
		external "C"
		end
	
	ecli_c_execute_direct (stmt : POINTER; sql : POINTER) : INTEGER is
		external "C"
		end
	
	ecli_c_execute (stmt : POINTER) : INTEGER  is
		external "C"
		end
	
	ecli_c_bind_parameter (stmt : POINTER;
			index, c_type, sql_type, sql_size, sql_decimal_digits : INTEGER;
			value : POINTER; buffer_length : INTEGER; ptr_value_length : POINTER) : INTEGER  is
		external "C"
		end
	
	ecli_c_bind_result (stmt : POINTER; index, c_type : INTEGER; value : POINTER; buffer_length : INTEGER; len_indicator : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_describe_parameter (stmt : POINTER; index : INTEGER; sql_type, sql_size, sql_decimal_digits, sql_nullability : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_describe_column (stmt : POINTER; index : INTEGER; col_name : POINTER; max_name_length : INTEGER; actual_name_length : POINTER; sql_type, sql_size, sql_decimal_digits, sql_nullability : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_get_data (stmt : POINTER; column_number, c_type : INTEGER; target_pointer : POINTER; buffer_length : INTEGER; len_indicator_pointer : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_fetch (stmt : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_close_cursor (stmt : POINTER) : INTEGER is
		external "C"
		end
	
	ecli_c_environment_error (handle : POINTER; record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER is
		external "C"
		end
	
	ecli_c_session_error (handle : POINTER; record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER is
		external "C"
		end
	
	ecli_c_statement_error (handle : POINTER; record_index : INTEGER; state : POINTER; native_error : POINTER; message : POINTER; buffer_length : INTEGER; length_indicator : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_transaction_capable (handle : POINTER;  capable : POINTER) : INTEGER is
		external "C"
		end
		
feature {NONE} -- Value handling functions

	ecli_c_alloc_value (buffer_length : INTEGER) : POINTER is
		external "C"
		end

	ecli_c_free_value (pointer : POINTER) is
		external "C"
		end

	ecli_c_value_set_length_indicator (pointer : POINTER; length : INTEGER) is
		external "C"
		end

	ecli_c_value_get_length (pointer : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_value_get_length_indicator (pointer : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_value_get_length_indicator_pointer (pointer : POINTER) : POINTER is
		external "C"
		end

	ecli_c_value_set_value (pointer, new_value : POINTER; actual_length : INTEGER) is
		external "C"
		end

	ecli_c_value_get_value (pointer : POINTER) : POINTER is
		external "C"
		end

	ecli_c_value_copy_value (pointer, dest : POINTER) is
			-- copy value referred to by 'pointer' into 'dest',
			-- assuming that value->length octets have to be transferred
		external "C"
		end
	
feature {NONE} -- TIME, DATE, TIMESTAMP getter and setter functions

	ecli_c_date_get_year (dt : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_date_get_month (dt : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_date_get_day (dt : POINTER) : INTEGER is
		external "C"
		end


	 ecli_c_date_set_year (dt : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_date_set_month (dt : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_date_set_day (dt : POINTER; v : INTEGER) is
		external "C"
		end


	-- TIME getters and setters 
	ecli_c_time_get_hour (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_time_get_minute (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_time_get_second (tm : POINTER) : INTEGER is
		external "C"
		end


	 ecli_c_time_set_hour (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_time_set_minute (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_time_set_second (tm : POINTER; v : INTEGER) is
		external "C"
		end

	-- TIMESTAMP time getters and setters 
	ecli_c_timestamp_get_hour (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_timestamp_get_minute (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_timestamp_get_second (tm : POINTER) : INTEGER is
		external "C"
		end

	ecli_c_timestamp_get_fraction (tm : POINTER) : INTEGER is
		external "C"
		end


	 ecli_c_timestamp_set_hour (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_timestamp_set_minute (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_timestamp_set_second (tm : POINTER; v : INTEGER) is
		external "C"
		end

	 ecli_c_timestamp_set_fraction (tm : POINTER; v : INTEGER) is
		external "C"
		end


feature {NONE} -- Return codes

	ecli_c_ok : INTEGER is
		external "C"
		end
	
	ecli_c_ok_with_info : INTEGER is
		external "C"
		end
	
	ecli_c_no_data : INTEGER is
		external "C"
		end
	
	ecli_c_error : INTEGER is
		external "C"
		end
	
	ecli_c_invalid_handle : INTEGER is
		external "C"
		end
	
	ecli_c_need_data : INTEGER is
		external "C"
		end

	ecli_c_null_data : INTEGER is
		external "C"
		end

	ecli_c_no_total : INTEGER is
		external "C"
		end

	ecli_c_nullable_unknown : INTEGER is
		external "C"
		end

	ecli_c_nullable : INTEGER is
		external "C"
		end

	ecli_c_no_nulls : INTEGER is
		external "C"
		end
	
feature {NONE} -- Data type indicators

	 ecli_c_sql_char  : INTEGER is
	external "C"
	end


	 ecli_c_sql_numeric  : INTEGER is
	external "C"
	end


	 ecli_c_sql_decimal  : INTEGER is
	external "C"
	end


	 ecli_c_sql_integer  : INTEGER is
	external "C"
	end


	 ecli_c_sql_smallint  : INTEGER is
	external "C"
	end


	 ecli_c_sql_float  : INTEGER is
	external "C"
	end


	 ecli_c_sql_real  : INTEGER is
	external "C"
	end


	 ecli_c_sql_double  : INTEGER is
	external "C"
	end


	 ecli_c_sql_varchar  : INTEGER is
	external "C"
	end



	 ecli_c_sql_type_date  : INTEGER is
	external "C"
	end


	 ecli_c_sql_type_time  : INTEGER is
	external "C"
	end


	 ecli_c_sql_type_timestamp  : INTEGER is
	external "C"
	end


	 ecli_c_sql_longvarchar  : INTEGER is
	external "C"
	end

	 ecli_c_sql_c_char  : INTEGER is
	external "C"
	end


	 ecli_c_sql_c_long  : INTEGER is
	external "C"
	end


	 ecli_c_sql_c_short  : INTEGER is
	external "C"
	end


	 ecli_c_sql_c_float  : INTEGER is
	external "C"
	end


	 ecli_c_sql_c_double  : INTEGER is
	external "C"
	end


	 ecli_c_sql_c_numeric  : INTEGER is
	external "C"
	end


	 ecli_c_sql_c_default  : INTEGER is
	external "C"
	end



	 ecli_c_sql_c_type_date  : INTEGER is
	external "C"
	end


	 ecli_c_sql_c_type_time  : INTEGER is
	external "C"
	end


	 ecli_c_sql_c_type_timestamp  : INTEGER is
	external "C"
	end

feature {NONE} -- transaction capabilities

	ecli_c_tc_none: INTEGER is
	external "C"
	end

	ecli_c_tc_dml: INTEGER is
	external "C"
	end

	ecli_c_tc_ddl_commit: INTEGER is
	external "C"
	end

	ecli_c_tc_ddl_ignore : INTEGER is
	external "C"
	end

	ecli_c_tc_all : INTEGER is
	external "C"
	end

end -- class ECLI_EXTERNAL_API
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
