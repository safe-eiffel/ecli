indexing

	description:

		"Objects that trace SQL execution on an output medium."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TRACER

inherit
	DT_SHARED_SYSTEM_CLOCK

create

	make

feature -- Initialization

	make (a_medium : like medium) is
			-- Make tracer
		require
			medium_not_void: a_medium /= Void
			medium_open_write: a_medium.is_open_write
		do
			medium := a_medium
		ensure
			medium: medium = a_medium
		end

feature -- Access

	medium : KI_CHARACTER_OUTPUT_STREAM

	execution_begin : DT_DATE_TIME

	execution_end : DT_DATE_TIME

feature -- Status report

	is_tracing_time : BOOLEAN
			-- Is time tracing enabled ?

feature -- Status change

	enable_time_tracing is
			-- Enable time tracing
		do
			is_tracing_time := True
		ensure
			is_tracing_time: is_tracing_time
		end

	disable_time_tracing is
			-- Disable time tracing
		do
			is_tracing_time := False
		ensure
			not_tracing_time: not is_tracing_time
		end

feature {ECLI_STATEMENT} -- Basic operations

	trace (a_sql : STRING; a_parameters : ARRAY[ECLI_VALUE]) is
			-- Trace 'a_sql', substituting parameter markers by 'a_parameters'
		local
			index : INTEGER
			c : CHARACTER
		do
			from
				index := 1
				state := state_sql
				parameter_count := 0
			until
				index > a_sql.count
			loop
				c := a_sql.item (index)
				if state = state_sql then
					if is_parameter_marker (c) then
						next_state := state_parameter
						parameter_count := parameter_count + 1
						put_parameter_value (a_parameters.item (parameter_count))
					elseif is_quote (c) then
						next_state := state_string_literal
						medium.put_character (c)
					else
						next_state := state
						medium.put_character (c)
					end
				elseif state = state_parameter then
					if is_separator (c) then
						next_state := state_sql
						medium.put_character (c)
					end
					-- do not output anything on medium : just eating up parameter name
				elseif state = state_string_literal then
					if is_quote (c) then
						next_state := state_literal_out
					end
					medium.put_character (c)
				elseif state = state_literal_out then
					if is_quote (c) then
						next_state := state_string_literal
					else
						next_state := state_sql
					end
					medium.put_character (c)
				end
				state := next_state
				index := index + 1
			end
			medium.put_string(";%N")
			medium.flush
		end

	begin_execution_timing is
			-- begin query execution
		do
			execution_begin := system_clock.date_time_now
		end

	end_execution_timing is
			-- end query execution
		require
			execution_begin_not_void: execution_begin /= Void
		local
			duration : DT_DATE_TIME_DURATION
		do
			execution_end := system_clock.date_time_now
			duration := execution_end - execution_begin
			medium.put_string ("-- ")
			medium.put_string (duration.to_canonical (execution_begin).out)
			medium.put_character ('%N')
		ensure
			execution_end_not_void: execution_end /= Void
		end

feature {ECLI_SESSION} -- Basic operations

	trace_begin is
			-- Trace BEGIN TRANSACTION
		do
			medium.put_string ("BEGIN TRANSACTION;%N")
		end

	trace_commit is
			-- Trace COMMIT TRANSACTION
		do
			medium.put_string ("COMMIT TRANSACTION;%N")
		end

	trace_rollback is
			-- Trace ROLLBACK TRANSACTION
		do
			medium.put_string ("ROLLBACK TRANSACTION;%N")
		end

feature {ECLI_VALUE} -- Basic operations

	put_decimal (a_decimal : ECLI_GENERIC_VALUE[MA_DECIMAL]) is
			-- Put `a_value' as a decimal constant.
		require
			a_decimal_not_void: a_decimal /= Void
			a_decimal_not_null: not a_decimal.is_null
		do
			medium.put_character ('%'')
			medium.put_string (a_decimal.out)
			medium.put_character ('%'')
		end

	put_string (a_value : ECLI_GENERIC_VALUE[STRING]) is
			-- Put 'a_value' as a string constant
		require
			a_value /= Void and then not a_value.is_null
		do
			medium.put_character ('%'')
			medium.put_string (a_value.out)
			medium.put_character ('%'')
		end

	put_date (a_date : ECLI_DATE) is
			-- Put 'a_date' as a date constant
		require
			a_date /= Void and then not a_date.is_null
		do
			medium.put_string ("{d '")
			medium.put_string (a_date.out)
			medium.put_string ("'}")
		end

	put_timestamp (a_date_time : ECLI_TIMESTAMP) is
			-- Put 'a_timestamp' as a timestamp constant
		require
			a_date_time /= Void and then not a_date_time.is_null
		do
			medium.put_string ("{ts '")
			medium.put_string (a_date_time.out)
			medium.put_string ("'}")
		end

	put_time (a_time : ECLI_TIME) is
			-- Put 'a_time' as a time constant
		require
			a_time /= Void and then not a_time.is_null
		do
			medium.put_string ("{t '")
			medium.put_string (a_time.out)
			medium.put_string ("'}")
		end

	put_double (a_double : ECLI_DOUBLE) is
			-- Put 'a_double' as a double constant
		require
			a_double /= Void and then not a_double.is_null
		do
			medium.put_string (a_double.out)
		end

	put_real (a_real : ECLI_REAL) is
			-- Put 'a_real' as a real constant
		require
			a_real /= Void and then not a_real.is_null
		do
			medium.put_string (a_real.out)
		end

	put_float (a_float : ECLI_FLOAT) is
			-- Put 'a_float' as a float constant
		require
			a_float /= Void and then not a_float.is_null
		do
			medium.put_string (a_float.out)
		end

	put_integer_16 (a_integer : ECLI_INTEGER_16) is
			-- Put 'a_integer' as an integer constant
		require
			a_integer /= Void and then not a_integer.is_null
		do
			medium.put_string (a_integer.out)
		end

	put_integer (a_integer : ECLI_INTEGER) is
			-- Put 'a_integer' as an integer constant
		require
			a_integer /= Void and then not a_integer.is_null
		do
			medium.put_string (a_integer.out)
		end

	put_integer_64 (a_integer_64 : ECLI_INTEGER_64) is
			-- Put 'a_a_integer_64' as an integer constant
		require
			a_integer_64 /= Void and then not a_integer_64.is_null
		do
			medium.put_string (a_integer_64.out)
		end

	put_binary (a_binary : ECLI_STRING_VALUE) is
			-- Put `a_binary' as binary value
		require
		do
			medium.put_character ('%'')
			medium.put_string (a_binary.out)
			medium.put_character ('%'')
		end

	put_file (a_file : ECLI_FILE_VALUE) is
			-- Put `a_file'
		require
		do
			medium.put_string ("file://")
			if a_file.input_file /= Void then
				medium.put_string (a_file.input_file.name)
			else
				medium.put_string (a_file.output_file.name)
			end
		end

feature {NONE} -- Implementation

	put_parameter_value (a_value : ECLI_VALUE) is
			-- Put 'a_value' on 'medium'
		require
			value_ok: a_value /= Void
		do
			if a_value.is_null then
				medium.put_string ("NULL")
			else
				a_value.trace (Current)
			end
		end

	parameter_count : INTEGER

	state_sql, state_parameter, state_string_literal, state_literal_out : INTEGER is unique

	state, next_state : INTEGER

	is_quote (c : CHARACTER) : BOOLEAN is
			-- Is `c' a quote ?
		do
			Result := (c = '%'')
		end

	is_parameter_marker (c : CHARACTER) : BOOLEAN is
			-- Is `c' a parameter marker ?
		do
			Result := (c = '?')
		end

	is_separator (c : CHARACTER) : BOOLEAN is
			-- Is `c' a separator ?
		do
			Result := (c = ' ') or else (c = ',') or else (c = ')') or else (c = '%T') or else (c = '%N')
		end

invariant

	medium_inv: medium /= Void and then medium.is_open_write

end
