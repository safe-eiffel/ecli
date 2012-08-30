note

	description:

			"Objects that parse SQL queries, searching for parameters."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_SQL_PARSER

create

	make

feature {NONE} -- Initialization

	make
			-- initialize
		do
			parameter_marker := cli_marker
			original_sql := ""
			parsed_sql := ""
		ensure
			parameter_marker_set: parameter_marker = '?'
		end

feature -- Access

	original_sql : STRING
			-- Original SQL.

	parsed_sql : STRING
			-- Parsed SQL.
			-- Same as original SQL, but with parameter names stripped and parameter_marker replaced by cli_marker.

	parameter_marker : CHARACTER
		-- parameter marker in input sql.

feature -- Measurement

	parameters_count : INTEGER

feature -- Status report

	escape : BOOLEAN

	is_separator (c : CHARACTER) : BOOLEAN
		do
			inspect c
			when ' ', '%T', '%N', '%R', ',', ';', '(', ')', '{', '}' then
				Result := True
			else

			end
		end

	is_parameter_marker (c : CHARACTER) : BOOLEAN
		do
			inspect c
			when '?',':' then
				Result := True
			else
				if c = parameter_marker then
					Result := True
				end
			end
		end

feature -- Element change

	set_parameter_marker (marker : CHARACTER)
			-- set `parameter_marker'
		require
			good_marker: allowed_parameter_markers.has (marker)
		do
			parameter_marker := marker
		ensure
			parameter_marker_set:	parameter_marker = marker
		end

feature -- Constants

	allowed_parameter_markers : STRING = ":?~°§"

feature -- Basic operations

	parse (sql : STRING; callback : ECLI_SQL_PARSER_CALLBACK)
			-- parse s, replacing every parameter by the ODBC/CLI marker '?'
		require
			sql_not_void: sql /= Void
			callback_not_void: callback /= Void
		local
			index, sql_count : INTEGER
			c, previous_c : CHARACTER
			parameter_begin, parameter_end : INTEGER
			string_begin, string_end : INTEGER
			table_begin, table_end : INTEGER
			word_begin, word_end : INTEGER
			parameter : STRING
		do
			from
				index := 1
				original_sql := sql
				sql_count := sql.count
				parameters_count := 0
				create parsed_sql.make (original_sql.count)
				state := State_sql
				word_begin := index
			until
				index > sql_count
			loop
				c := original_sql.item (index)
				if is_parameter_marker (c) then
					do_nothing
				end
				inspect state
				when State_sql then
					inspect c
					when single_quote then
						string_begin := index
						state := State_string_literal
						parsed_sql.append_character (c)
						previous_c := '%U'
					when double_quote then
						table_begin := index
						state := State_table_literal
						parsed_sql.append_character (c)
						previous_c := '%U'
					else
						if (is_separator (c) or is_parameter_marker (c)) and not is_separator (previous_c) and previous_c /= '%U' then
							word_end := (index - 1).max (1)
							if word_end >= word_begin then
								callback.on_word (sql, word_begin, word_end)
							end
						end
						if is_separator (previous_c) then
							word_begin := index.max (1)
						end
						if is_parameter_marker (c) then
							state := State_parameter
							callback.on_parameter_marker (sql, index)
							parameter_begin := index + 1
							parsed_sql.append_character (Cli_marker)
						else
							parsed_sql.append_character (c)
						end
						previous_c := c
					end
					index := index + 1
				when State_string_literal then
					inspect c
					when single_quote then
						if escape then
							escape := False
						else
							escape := True
						end
							parsed_sql.append_character (c)
						index := index + 1
					else
						if escape then
							string_end := index
							callback.on_string_literal (sql, string_begin, string_end)
							escape := False
							state := state_sql
							word_begin := index + 1
							string_begin := 0
							string_end := 0
						else
							parsed_sql.append_character (c)
							index := index + 1
						end
					end
				when State_table_literal then
					inspect c
					when double_quote then
						if escape then
							escape := False
						else
							escape := True
						end
						parsed_sql.append_character (c)
						index := index + 1
					else
						if escape then
							table_end := index
							callback.on_table_literal (sql, table_begin, table_end)
							escape := False
							state := state_sql
							word_begin := index + 1
							table_begin := 0
							table_end := 0
						else
							parsed_sql.append_character (c)
							index := index + 1
						end
					end
				when State_parameter then
					inspect c
					when 'a'..'z','A'..'Z','0'..'9','_' then
						index := index + 1
					else
						parameter_end := index - 1
						parameters_count := parameters_count + 1
						if parameter_begin > 0 and then parameter_begin <= parameter_end then
							parameter := original_sql.substring (parameter_begin, parameter_end)
							callback.add_new_parameter (parameter, parameters_count)
							callback.on_parameter (sql, parameter_begin, parameter_end)
							parameter_begin := 0
							parameter_end := 0
						end
						state := State_sql
						word_begin := index + 1
					end
				end
			end
			if state = State_parameter then
				parameter_end := index - 1
				parameters_count := parameters_count + 1
				if parameter_begin > 0 and then parameter_begin <= parameter_end then
					parameter := original_sql.substring (parameter_begin, parameter_end)
					callback.add_new_parameter (parameter, parameters_count)
					callback.on_parameter (sql, parameter_begin, parameter_end)
					parameter_begin := 0
					parameter_end := 0
				end
			end
			if escape and then state = state_string_literal or else state = state_table_literal then
				state := state_sql
				escape := False
			end
			check
				valid_final_state: state=state_sql or else state=state_parameter
			end
		ensure
			original_sql_set: original_sql = sql
			parsed_sql_set: parsed_sql /= Void -- and then parsed sql is equivalent to original sql
--			name_to_position_set: name_to_position /= Void
		end


feature {NONE} -- Implementation

	state : INTEGER

	State_sql : INTEGER = 101
	State_string_literal : INTEGER = 102
	State_table_literal : INTEGER = 103
	State_parameter : INTEGER = 104

	single_quote : CHARACTER = '%''
	double_quote : CHARACTER = '%"'

	cli_marker : CHARACTER = '?'

invariant
	good_parameter_marker: allowed_parameter_markers.has (parameter_marker)
	good_state: state = State_sql implies not escape

end
