indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
				description := cursor.buffer_description.to_string
			end
			if not cursor.buffer_procedure_type.is_null then
				type := cursor.buffer_procedure_type.to_integer
			end
		end
		
feature -- Access
	
	description : STRING
	
	type : INTEGER
	
feature -- Measurement

feature -- Status report

	is_procedure :  BOOLEAN is
			-- 
		do
			Result := type = sql_pt_procedure
		end
		
	is_function : BOOLEAN is
			-- 
		do
			Result := type = sql_pt_function
		end
		
feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out : STRING is
			-- 
		do
			!!Result.make (0)
			Result.append ({ECLI_NAMED_METADATA}Precursor)
			Result.append ("%T")
			append_to_string(Result, description); Result.append ("%T")
			if type = sql_pt_procedure then
				Result.append ("Procedure")
			elseif type = sql_pt_function then
				Result.append ("Function")
			else
				Result.append ("Unknown type")
			end
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_PROCEDURE
