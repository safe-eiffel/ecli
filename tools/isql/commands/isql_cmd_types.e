note
	description: "Commands that list the available data types."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ISQL_CMD_TYPES

inherit
	ISQL_COMMAND

feature -- Access

	help_message : STRING
		do
			Result := padded ("ty[pes]", command_width)
			Result.append_string ("List all types supported by current connection.")
		end

	match_string : STRING = "ty"

feature -- Status report

	needs_session : BOOLEAN = True

	matches (text: STRING) : BOOLEAN
		do
			Result := matches_single_string (text, match_string)
		end

feature -- Basic operations

	execute (text : STRING; context : ISQL_CONTEXT)
			-- show current datasource supported SQL types
		do
			do_types (context)
		end

feature {NONE} -- Implementation

	do_types  (context : ISQL_CONTEXT)
			-- show types supported by current datasource
		local
			cursor : ECLI_SQL_TYPES_CURSOR
			type : ECLI_SQL_TYPE
		do
			check attached context.session as l_session then
				from
					create cursor.make_all_types (l_session)
					cursor.start
					context.filter.begin_heading
					context.filter.put_heading ("TYPE_NAME")
					context.filter.put_heading ("CODE")
					context.filter.put_heading ("SIZE")
					context.filter.put_heading ("LITERAL_PREFIX")
					context.filter.put_heading ("LITERAL_SUFFIX")
					context.filter.put_heading ("CREATE_PARAMETERS")
					context.filter.put_heading ("CASE_SENSITIVE")
					context.filter.put_heading ("AUTO_UNIQUE")
					context.filter.put_heading ("UNSIGNED")
					context.filter.end_heading
				until
					not cursor.is_ok or else cursor.off
				loop
					type := cursor.item
					context.filter.begin_row
					context.filter.put_column (type.name)
					context.filter.put_column (type.sql_type_code.out)
					context.filter.put_column (type.size.out)
					if type.is_literal_prefix_applicable then
						context.filter.put_column (type.literal_prefix)
					else
						context.filter.put_column ("NULL")
					end
					if type.is_literal_suffix_applicable then
						context.filter.put_column (type.literal_suffix)
					else
						context.filter.put_column ("NULL")
					end
					if type.is_create_params_applicable then
						context.filter.put_column (type.create_params)
					else
						context.filter.put_column ("NULL")
					end
					context.filter.put_column (type.is_case_sensitive.out)
					if type.is_auto_unique_value_applicable then
						context.filter.put_column(type.is_auto_unique_value.out)
					else
						context.filter.put_column ("NULL")
					end
					if type.is_unsigned_applicable then
						context.filter.put_column (type.is_unsigned.out)
					else
						context.filter.put_column ("NULL")
					end
					context.filter.end_row
					cursor.forth
				end
				cursor.close
			end
		end

end -- class ISQL_CMD_TYPES
