note

	description:

	"[
		SQL Queries, defined by a SQL text. 
		Heir for classes whose SQL definition remains constant, (static, not modifiable).
	]"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_QUERY

inherit

	ECLI_STORED_PROCEDURE
		rename
			start as statement_start
		export
			{NONE} all;
			{ANY}
				after,
				before, bind_parameters, bound_parameters,
				close, Cursor_after, Cursor_before, Cursor_in, cursor_status,
				diagnostic_message,
				exception_on_error, execute,
				forth,
				go_after,
				has_information_message, has_parameter, has_parameters, has_result_set,
				is_closed, is_error, is_executed, is_ok, is_parsed, is_prepared, is_prepared_execution_mode, is_valid,
				make,
				native_code,
				off,
				parameters, parameters_count, prepare, put_input_output_parameter, put_input_parameter, put_output_parameter, put_parameter,
				raise_exception_on_error, results,
				sql
		redefine
			make, execute
		end

	ANY
		undefine
			default_create
		end

feature -- Initialization

	make (a_session : ECLI_SESSION)
		do
			Precursor (a_session)
			set_sql (definition)
		end

	make_prepared (a_session : ECLI_SESSION)
		require
			a_session_not_void: a_session /= void
			a_session_connected: a_session.is_connected
			not_valid: not is_valid
		do
			make (a_session)
			prepare
		ensure
			session_ok: session = a_session and not is_closed
			registered: session.is_registered_statement (Current)
			same_exception_on_error: exception_on_error = session.exception_on_error
			valid: is_valid
			prepared: is_ok implies is_prepared
		end

feature -- Access

	definition : STRING
			-- Cursor definition (i.e. SQL text); remains constant.
		deferred
		end

feature -- Status report

	real_execution : BOOLEAN
			-- Is this statement really executed?
		do
			Result := True
			debug ("ecli_fake_execution")
				Result := False
			end
		end


feature -- Basic operations

	execute
		do
			if real_execution then
				Precursor
			else
				reset_status
				is_executed := True
				if attached session.tracer as l_tracer then
					trace (l_tracer)
				end
			end
		end

invariant
	definition_not_void: definition /= Void --FIXME: VS-DEL
	sql_not_void: sql /= Void --FIXME: VS-DEL
	sql_is_definition: sql.is_equal (definition)

end

