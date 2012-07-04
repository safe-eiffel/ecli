indexing

	description:

			"Stored procedures."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_STORED_PROCEDURE

inherit

	ECLI_STATEMENT
--		rename
--			put_parameter as put_input_parameter
		redefine
			put_parameter,
			create_parameters,
			put_single_parameter_with_hint,
			put_parameter_with_hint,
			bind_one_parameter,
			default_create --,
--			put_input_parameter

		end

create

	make

feature {} -- Initialization

	default_create
		do
			Precursor
			create directed_parameters.make_empty
		end

feature -- Access

	directed_parameter (name : STRING) : ECLI_STATEMENT_PARAMETER is
			-- Parameter related to `key'.
		require
			name_not_void: name /= Void --FIXME: VS-DEL
			has_parameter_of_name: has_parameter (name)
		do
			Result := directed_parameters.item (parameter_positions (name).first)
		ensure
			result_not_void: Result /= Void --FIXME: VS-DEL
		end

feature -- Status report

	is_parameter_input (a_parameter_name : STRING) : BOOLEAN
			-- Is `a_parameter_name' parameter for input ?
		require
			a_parameter_name_not_void: a_parameter_name /= Void --FIXME: VS-DEL
			known_parameter: has_parameter (a_parameter_name)
		do
			Result := directed_parameter (a_parameter_name).is_input
		end

	is_parameter_output (a_parameter_name : STRING) : BOOLEAN
			-- Is `a_parameter_name' parameter for output?
		require
			a_parameter_name_not_void: a_parameter_name /= Void --FIXME: VS-DEL
			known_parameter: has_parameter (a_parameter_name)
		do
			Result := directed_parameter (a_parameter_name).is_output
		end

	is_parameter_input_output (a_parameter_name : STRING) : BOOLEAN
			-- Is `a_parameter_name' parameter for input/output ?
		require
			a_parameter_name_not_void: a_parameter_name /= Void --FIXME: VS-DEL
			known_parameter: has_parameter (a_parameter_name)
		do
			Result := directed_parameter (a_parameter_name).is_input_output
		end

feature -- Element change

	put_parameter (value: attached like parameter_anchor; key : STRING)
			-- <Precursor>
		do
			put_input_parameter (value, key)
		ensure then
			parameter_set: directed_parameter (key).item = value
			direction_set: directed_parameter (key).is_input
			not_bound: not bound_parameters
		end

	put_output_parameter (value: attached like parameter_anchor; key: STRING) is
			-- Put `value' as output parameter.
			-- Its value can be set by the procedure and be accessed after the procedure exits.
		require
			valid_statement: is_valid
			has_parameters: parameters_count > 0
			value_ok: value /= void
			key_ok: key /= void
			known_key: has_parameter (key)
		local
			direction : ECLI_OUTPUT_PARAMETER
		do
			create direction.make (value)
			put_parameter_with_hint (value, key, direction)
		ensure
			parameter_set: directed_parameter (key).item = value
			direction_set: directed_parameter (key).is_output
			not_bound: not bound_parameters
		end

	put_input_parameter (value : attached like parameter_anchor; key : STRING) is
			-- Put `value' as input parameter.
		local
			direction : ECLI_INPUT_PARAMETER
		do
			create direction.make (value)
			put_parameter_with_hint (value, key, direction)
		ensure
			parameter_set: directed_parameter (key).item = value
			direction_set: directed_parameter (key).is_input
			not_bound: not bound_parameters
		end

	put_input_output_parameter (value: attached like parameter_anchor; key: STRING) is
			-- Put `value' as input/output parameter.
		require
			valid_statement: is_valid
			has_parameters: parameters_count > 0
			value_ok: value /= void
			key_ok: key /= void
			known_key: has_parameter (key)
		local
			direction : ECLI_INPUT_OUTPUT_PARAMETER
		do
			create direction.make (value)
			put_parameter_with_hint (value, key, direction)
		ensure
			parameter_set: directed_parameter (key).item = value
			direction_set: directed_parameter (key).is_input_output
			not_bound: not bound_parameters
		end

feature {NONE} -- Implementation

	directed_parameters : ARRAY[ECLI_STATEMENT_PARAMETER]

	create_parameters is
			--
		do
			Precursor
			create directed_parameters.make_filled (default_directed_parameter, 1, parameters_count)
		end

	put_parameter_with_hint (value : attached like parameter_anchor; key : STRING; hint : ECLI_STATEMENT_PARAMETER) is
		do
			Precursor (value, key, hint)
		end

	put_single_parameter_with_hint (value : attached like parameter_anchor; position : INTEGER; hint : ECLI_STATEMENT_PARAMETER) is
			--
		do
			Precursor (value, position, hint)
			directed_parameters.put (hint, position)
		ensure then
			direction_set: directed_parameters.item (position) = hint
		end

	bind_one_parameter (i: INTEGER) is
			--
		do
			directed_parameters.item (i).bind (Current, i)
		end

feature {} -- Implementation / Auxiliary

	default_directed_parameter : ECLI_STATEMENT_PARAMETER
		do
			create {ECLI_INPUT_PARAMETER}Result.make (default_parameter)
		end


end
