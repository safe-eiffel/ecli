indexing
	description: "Objects that trace SQL execution on an output medium"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_TRACER

creation
	make
	
feature -- Initialization
	make (a_medium : IO_MEDIUM) is
			-- make tracer
		require
			medium_exists: a_medium /= Void
			medium_open_write: a_medium.is_open_write
		do
			medium := a_medium
		ensure
			medium: medium = a_medium
		end
		
feature -- Access

	medium : IO_MEDIUM

feature {ECLI_STATEMENT} -- Basic operations
	
	trace (a_sql : STRING; a_parameters : ARRAY[ECLI_VALUE]) is
			-- trace 'a_sql', substituting parameter markers by 'a_parameters'
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
		end
		
feature {ECLI_SESSION} -- Basic operations

	trace_begin is
			-- trace BEGIN TRANSACTION
		do
			medium.put_string ("BEGIN TRANSACTION;%N")
		end
		
	trace_commit is
			-- trace COMMIT TRANSACTION
		do
			medium.put_string ("COMMIT TRANSACTION;%N")
		end
		
	trace_rollback is
			-- trace ROLLBACK TRANSACTION
		do
			medium.put_string ("ROLLBACK TRANSACTION;%N")
		end
		
		
feature {ECLI_VALUE} -- Basic operations

	put_string (a_value : ECLI_LONGVARCHAR) is
			-- put 'a_value' as a string constant
		require
			a_value /= Void and then not a_value.is_null
		do
			medium.put_character ('%'')
			medium.put_string (a_value.out)
			medium.put_character ('%'')
		end
		
	put_date (a_date : ECLI_DATE) is
			-- put 'a_date' as a date constant
		require
			a_date /= Void and then not a_date.is_null
		do
			medium.put_string ("{d '")
			put_date_part (a_date)
			medium.put_string ("'}")
		end
		
	put_timestamp (a_date_time : ECLI_TIMESTAMP) is
			-- put 'a_timestamp' as a timestamp constant
		require
			a_date_time /= Void and then not a_date_time.is_null
		do
			medium.put_string ("{ts '")
			put_date_part (a_date_time)
			medium.put_integer (a_date_time.hour)
			medium.put_character (':')
			medium.put_integer (a_date_time.minute)
			medium.put_character (':')
			medium.put_integer (a_date_time.second)
			medium.put_character ('.')
			medium.put_integer (a_date_time.nanosecond)
			medium.put_string ("'}")
		end
		
	put_double (a_double : ECLI_DOUBLE) is
			-- put 'a_double' as a double constant
		require
			a_double /= Void and then not a_double.is_null
		do
			medium.put_string (a_double.out)
		end
		
	put_real (a_real : ECLI_REAL) is
			-- put 'a_real' as a real constant
		require
			a_real /= Void and then not a_real.is_null
		do
			medium.put_string (a_real.out)
		end
		
	put_float (a_float : ECLI_FLOAT) is
			-- put 'a_float' as a float constant
		require
			a_float /= Void and then not a_float.is_null
		do
			medium.put_string (a_float.out)
		end
		
	put_integer (a_integer : ECLI_INTEGER) is
			-- put 'a_integer' as an integer constant
		require
			a_integer /= Void and then not a_integer.is_null
		do
			medium.put_string (a_integer.out)
		end
		

feature {NONE} -- Implementation


	put_parameter_value (a_value : ECLI_VALUE) is
			-- put 'a_value' on 'medium'
		require
			value_ok: a_value /= Void
		do
			if a_value.is_null then
				medium.put_string ("NULL")
			else
				a_value.trace (Current)
			end
		end

	put_date_part (a_date : ECLI_DATE) is
			-- put 'date' as YYYY-MM-DD
		require
			a_date /= Void
		do
			medium.put_integer (a_date.year)
			medium.put_character ('-')
			medium.put_integer (a_date.month)
			medium.put_character ('-')
			medium.put_integer (a_date.day)
		end

	parameter_count : INTEGER
	
	state_sql, state_parameter, state_string_literal, state_literal_out : INTEGER is unique

	state, next_state : INTEGER
	
	is_quote (c : CHARACTER) : BOOLEAN is
			-- 
		do
			Result := (c = '%'')
		end
		
	is_parameter_marker (c : CHARACTER) : BOOLEAN is
			-- 
		do
			Result := (c = '?')
		end
		
	is_separator (c : CHARACTER) : BOOLEAN is
			-- 
		do
			Result := (c = ' ') or else (c = ',') or else (c = ')') or else (c = '%T') or else (c = '%N')
		end		
		
invariant

	medium_inv: medium /= Void and then medium.is_open_write

end -- class ECLI_TRACER
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
