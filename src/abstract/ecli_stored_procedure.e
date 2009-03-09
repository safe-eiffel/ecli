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
		rename
			put_parameter as put_input_parameter
		redefine
			create_parameters,
			put_single_parameter_with_hint,
			put_parameter_with_hint,
			bind_one_parameter,
			put_input_parameter

		end

create

	make

feature -- Access

	directed_parameter (name : STRING) : ECLI_STATEMENT_PARAMETER is
			-- parameter related to `key'.
		require
			name_not_void: name /= Void
			has_parameter_of_name: has_parameter (name)
		do
			Result := directed_parameters.item (parameter_positions (name).first)
		ensure
			result_not_void: Result /= Void
		end
		
feature -- Element change

	put_output_parameter (value: like parameter_anchor; key: STRING) is
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

	put_input_parameter (value : like parameter_anchor; key : STRING) is
			-- Put `value' as input parameter.
		local
			direction : ECLI_INPUT_PARAMETER
		do
			create direction.make (value)
			put_parameter_with_hint (value, key, direction)
		ensure then
			parameter_set: directed_parameter (key).item = value
			direction_set: directed_parameter (key).is_input
			not_bound: not bound_parameters
		end

	put_input_output_parameter (value: like parameter_anchor; key: STRING) is
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
			create directed_parameters.make (1, parameters_count)
		end

	put_parameter_with_hint (value : like parameter_anchor; key : STRING; hint : ECLI_STATEMENT_PARAMETER) is
		do
			Precursor (value, key, hint)
		end

	put_single_parameter_with_hint (value : like parameter_anchor; position : INTEGER; hint : ECLI_STATEMENT_PARAMETER) is
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

end
