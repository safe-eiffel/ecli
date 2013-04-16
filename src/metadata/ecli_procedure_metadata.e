note

	description:

			"Procedures metadata."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_PROCEDURE_METADATA

inherit

	ECLI_NAMED_METADATA
		rename
			make as make_metadata
		export {NONE} make_metadata
		redefine
			out
		end

	ECLI_API_CONSTANTS
		undefine
			out
		end

create

	make

feature {NONE} -- Initilization

	make (cursor : ECLI_PROCEDURES_CURSOR)
			--
		require
			cursor_valid: cursor /= Void and then not cursor.off
		do
			set_catalog (cursor.buffer_catalog_name)
			set_schema (cursor.buffer_schema_name)
			set_name (cursor.buffer_procedure_name)
			if not cursor.buffer_description.is_null then
				description := cursor.buffer_description.as_string
			end
			if not cursor.buffer_procedure_type.is_null then
				type := cursor.buffer_procedure_type.as_integer
			end
		end

feature -- Access

	description : STRING
			-- Description of procedure.

	type : INTEGER
			-- Type of procedure.

feature -- Measurement

feature -- Status report

	is_procedure :  BOOLEAN
			-- Is this a procedure ?
		do
			Result := type = sql_pt_procedure
		end

	is_function : BOOLEAN
			-- Is this a function (it has a return value) ?
		do
			Result := type = sql_pt_function
		end

feature -- Conversion

	out : STRING
			-- terse printable representation
		do
			Result :=  Precursor {ECLI_NAMED_METADATA}
			Result.append_string ("%T")
			append_to_string(Result, description); Result.append_string ("%T")
			if type = sql_pt_procedure then
				Result.append_string ("Procedure")
			elseif type = sql_pt_function then
				Result.append_string ("Function")
			else
				Result.append_string ("Unknown type")
			end
		end

end
