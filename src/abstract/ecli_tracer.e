note

	description:

		"Objects that trace SQL execution on an output medium."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TRACER

inherit
	DT_SHARED_SYSTEM_CLOCK

create

	make

feature -- Initialization

	make (a_medium : like medium)
			-- Make tracer
		require
			medium_not_void: a_medium /= Void --FIXME: VS-DEL
			medium_open_write: a_medium.is_open_write
		do
			medium := a_medium
		ensure
			medium: medium = a_medium
		end

feature -- Access

	medium : KI_CHARACTER_OUTPUT_STREAM

	execution_begin : detachable DT_DATE_TIME

	execution_end : detachable DT_DATE_TIME

feature -- Status report

	is_tracing_time : BOOLEAN
			-- Is time tracing enabled ?

feature -- Status change

	enable_time_tracing
			-- Enable time tracing
		do
			is_tracing_time := True
		ensure
			is_tracing_time: is_tracing_time
		end

	disable_time_tracing
			-- Disable time tracing
		do
			is_tracing_time := False
		ensure
			not_tracing_time: not is_tracing_time
		end

feature {ECLI_STATEMENT} -- Basic operations

	trace (a_sql : STRING; a_parameters : ARRAY[ECLI_VALUE])
			-- Trace 'a_sql', substituting parameter markers by 'a_parameters'
--FIXME: implement this feature using an sql_parser and by the tracer being a parser callback
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

	begin_execution_timing
			-- begin query execution
		do
			execution_begin := system_clock.date_time_now
		end

	end_execution_timing
			-- end query execution
		require
			execution_begin_attached: attached execution_begin
		local
			duration : detachable DT_DATE_TIME_DURATION
		do
			check attached execution_begin as l_begin and then attached system_clock.date_time_now as l_end then
				duration := l_end - l_begin
				if attached duration then
					medium.put_string ("-- ")
					medium.put_string (duration.to_canonical (l_begin).out)
					medium.put_character ('%N')
				end
				execution_end := l_end
			end
		ensure
			execution_end_not_void: execution_end /= Void
		end

feature {ECLI_SESSION} -- Basic operations

	trace_begin
			-- Trace BEGIN TRANSACTION
		do
			medium.put_string ("BEGIN TRANSACTION;%N")
		end

	trace_commit
			-- Trace COMMIT TRANSACTION
		do
			medium.put_string ("COMMIT TRANSACTION;%N")
		end

	trace_rollback
			-- Trace ROLLBACK TRANSACTION
		do
			medium.put_string ("ROLLBACK TRANSACTION;%N")
		end

feature {ECLI_VALUE} -- Basic operations

	put_boolean (a_value : ECLI_BOOLEAN)
			-- Put 'a_value' as a string constant
		require
			a_value /= Void and then not a_value.is_null
		do
			medium.put_string (a_value.out)
		end

	put_decimal (a_decimal : ECLI_GENERIC_VALUE[MA_DECIMAL])
			-- Put `a_value' as a decimal constant.
		require
			a_decimal_not_void: a_decimal /= Void --FIXME: VS-DEL
			a_decimal_not_null: not a_decimal.is_null
		do
			medium.put_character ('%'')
			medium.put_string (a_decimal.out)
			medium.put_character ('%'')
		end

	put_string (a_value : ECLI_GENERIC_VALUE[STRING])
			-- Put 'a_value' as a string constant
		require
			a_value_not_void: a_value /= Void  --FIXME: VS-DEL
			a_value_not_null: not a_value.is_null
		do
			medium.put_character ('%'')
			medium.put_string (a_value.out)
			medium.put_character ('%'')
		end

	put_date (a_date : ECLI_DATE)
			-- Put 'a_date' as a date constant
		require
			a_date_not_void: a_date /= Void  --FIXME: VS-DEL
			a_date_not_null: not a_date.is_null
		do
			medium.put_string ("{d '")
			medium.put_string (a_date.out)
			medium.put_string ("'}")
		end

	put_timestamp (a_date_time : ECLI_TIMESTAMP)
			-- Put 'a_timestamp' as a timestamp constant
		require
			a_date_time_not_void: a_date_time /= Void --FIXME: VS-DEL
			a_date_time_not_null: not a_date_time.is_null
		do
			medium.put_string ("{ts '")
			medium.put_string (a_date_time.out)
			medium.put_string ("'}")
		end

	put_time (a_time : ECLI_TIME)
			-- Put 'a_time' as a time constant
		require
			a_time_not_void: a_time /= Void  --FIXME: VS-DEL
			a_time_not_null: not a_time.is_null
		do
			medium.put_string ("{t '")
			medium.put_string (a_time.out)
			medium.put_string ("'}")
		end

	put_double (a_double : ECLI_DOUBLE)
			-- Put 'a_double' as a double constant
		require
			a_double_not_void: a_double /= Void  --FIXME: VS-DEL
			a_double_not_null: not a_double.is_null
		do
			medium.put_string (a_double.out)
		end

	put_real (a_real : ECLI_REAL)
			-- Put 'a_real' as a real constant
		require
			a_real_not_void: a_real /= Void --FIXME: VS-DEL
			a_real_not_null: not a_real.is_null
		do
			medium.put_string (a_real.out)
		end

	put_float (a_float : ECLI_FLOAT)
			-- Put 'a_float' as a float constant
		require
			a_float_not_void: a_float /= Void --FIXME: VS-DEL
			a_float_not_null: not a_float.is_null
		do
			medium.put_string (a_float.out)
		end

	put_integer_16 (a_integer : ECLI_INTEGER_16)
			-- Put 'a_integer' as an integer constant
		require
			a_integer_not_void: a_integer /= Void --FIXME: VS-DEL
			a_integer_not_null: not a_integer.is_null
		do
			medium.put_string (a_integer.out)
		end

	put_integer (a_integer : ECLI_INTEGER)
			-- Put 'a_integer' as an integer constant
		require
			a_integer_not_void: a_integer /= Void --FIXME: VS-DEL
			a_integer_not_null: not a_integer.is_null
		do
			medium.put_string (a_integer.out)
		end

	put_integer_64 (a_integer_64 : ECLI_INTEGER_64)
			-- Put 'a_a_integer_64' as an integer constant
		require
			a_integer_64_not_void: a_integer_64 /= Void --FIXME: VS-DEL
			a_integer_64_not_null: not a_integer_64.is_null
		do
			medium.put_string (a_integer_64.out)
		end

	put_binary (a_binary : ECLI_STRING_VALUE)
			-- Put `a_binary' as binary value
		require
			a_binary_not_void: a_binary /= Void --FIXME: VS-DEL
			a_binary_not_null: not a_binary.is_null
		do
			medium.put_character ('%'')
			medium.put_string (a_binary.out)
			medium.put_character ('%'')
		end

	put_file (a_file : ECLI_FILE_VALUE)
			-- Put `a_file'
		require
			a_file_not_void: a_file /= Void  --FIXME: VS-DEL
			a_file_not_null: not a_file.is_null
		do
			medium.put_string ("file://")
			if attached a_file.input_file as f then
				medium.put_string (f.name)
			elseif attached a_file.output_file as f then
				medium.put_string (f.name)
			end
		end

feature {NONE} -- Implementation

	put_parameter_value (a_value : ECLI_VALUE)
			-- Put 'a_value' on 'medium'
		require
			value_not_void: a_value /= Void --FIXME: VS-DEL
		do
			if a_value.is_null then
				medium.put_string ("NULL")
			else
				a_value.trace (Current)
			end
		end

	parameter_count : INTEGER

	state_sql, state_parameter, state_string_literal, state_literal_out : INTEGER = unique

	state, next_state : INTEGER

	is_quote (c : CHARACTER) : BOOLEAN
			-- Is `c' a quote ?
		do
			Result := (c = '%'')
		end

	is_parameter_marker (c : CHARACTER) : BOOLEAN
			-- Is `c' a parameter marker ?
		do
--FIXME
			Result := (c = '?')
		end

	is_separator (c : CHARACTER) : BOOLEAN
			-- Is `c' a separator ?
		do
			Result := (c = ' ') or else (c = ',') or else (c = ')') or else (c = '%T') or else (c = '%N')
		end

invariant

	medium_not_void: medium /= Void  --FIXME: VS-DEL
	medium_is_open_write: medium.is_open_write

end
