indexing
	description: "Procedures metadata."
	author: "Paul G. Crismer"
	
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_PROCEDURE

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

creation
	make

feature {NONE} -- Initilization

	make (cursor : ECLI_PROCEDURES_CURSOR) is
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
			-- description of procedure

	type : INTEGER
			-- type of procedure

feature -- Measurement

feature -- Status report

	is_procedure :  BOOLEAN is
			-- is this a procedure ?
		do
			Result := type = sql_pt_procedure
		end

	is_function : BOOLEAN is
			-- is this a function (it has a return value) ?
		do
			Result := type = sql_pt_function
		end

feature -- Conversion

	out : STRING is
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

end -- class ECLI_PROCEDURE
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
