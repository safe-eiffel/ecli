indexing
	description: "Objects that parse SQL queries, searching for parameters."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_SQL_PARSER

creation
	make
	
feature {NONE} -- Initialization

	make is
			-- initialize
		do
			parameter_marker := '?'
		ensure
			parameter_marker_set: parameter_marker = '?'
		end
		
feature -- Access

	original_sql : STRING
	
	parsed_sql : STRING
	
	parameter_marker : CHARACTER
			-- parameter marker in input sql

	name_to_position : DS_HASH_TABLE [DS_LIST[INTEGER], STRING]
	
feature -- Measurement

	parameters_count : INTEGER
	
feature -- Status setting

	set_parameter_marker (marker : CHARACTER) is
			-- set `parameter_marker'
		require
			good_marker: (":?~°@§").has (marker)
		do
			parameter_marker := marker
		ensure
			parameter_marker_set:	parameter_marker = marker		
		end

feature -- Basic operations

			escape : BOOLEAN

	parse (sql : STRING; callback : ECLI_SQL_PARSER_CALLBACK) is
			-- parse s, replacing every parameter by the ODBC/CLI marker '?'
		local
			index, sql_count : INTEGER
			c, previous_c : CHARACTER
			parameter_begin, parameter_end : INTEGER
			parameter : STRING
		do
			from
				index := 1
				original_sql := sql
				sql_count := sql.count
				parameters_count := 0
				create parsed_sql.make (original_sql.count)
				state := State_sql
			until
				index > sql_count
			loop
				c := original_sql.item (index)
				if c= '?' then
					do_nothing
				end
				inspect state
				when State_sql then
					inspect c
					when single_quote then
						state := State_string_literal
						parsed_sql.append_character (c)
						previous_c := '%U'					
					when double_quote then
						state := State_table_literal
						parsed_sql.append_character (c)
						previous_c := '%U'					
					else
						if c = parameter_marker then
							state := State_parameter
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
							escape := False
							state := state_sql
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
							escape := False
							state := state_sql
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
							parameter_begin := 0
							parameter_end := 0
						end
						state := State_sql
					end	
				end
			end
			if state = State_parameter then
				parameter_end := index - 1
				parameters_count := parameters_count + 1
				if parameter_begin > 0 and then parameter_begin <= parameter_end then
					parameter := original_sql.substring (parameter_begin, parameter_end)
					callback.add_new_parameter (parameter, parameters_count)
					parameter_begin := 0
					parameter_end := 0
				end
			end
			check
				state=state_sql or else state=state_parameter
			end
		end
		
feature {NONE} -- Implementation

	state : INTEGER
	
	State_sql, State_string_literal, State_table_literal, State_parameter : INTEGER is unique
	
	single_quote : CHARACTER is '%''
	double_quote : CHARACTER is '%"'
	
	cli_marker : CHARACTER is '?'
	
invariant
	good_parameter_marker: (":?~°@§").has (parameter_marker)
	good_state: state = State_sql implies not escape
	
end -- class ECLI_SQL_PARSER
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
