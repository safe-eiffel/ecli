indexing
	description: "Objects that are named metadata, i.e. with catalog, schema and name."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_NAMED_METADATA

inherit
	
	ANY
		redefine
			out
		end

feature -- Access

	catalog : STRING
			-- catalog name
	
	schema : STRING
			-- schema name
	
	name : STRING
	
feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	set_catalog (value : ECLI_VARCHAR) is
			-- 
		require
			value: value /= Void
		do
			if not value.is_null then
				catalog := value.to_string
			else
				catalog := Void
			end
			
		end

	set_schema (value : ECLI_VARCHAR) is
			-- 
		require
			value: value /= Void
		do
			if not value.is_null then
				schema := value.to_string			
			else
				schema := Void
			end
		end
		
	set_name (value : ECLI_VARCHAR) is
			-- 
		require
			value: value /= Void and then not value.is_null
		do
			name := value.to_string
		end
		
feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	out : STRING is
			-- 
		do
			!!Result.make (0)
			append_to_string (Result, catalog) Result.append ("%T")
			append_to_string (Result, schema) Result.append ("%T")
			append_to_string (Result, name)			
		end
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	append_to_string (dest, src : STRING) is
			-- 
		do
			if src = Void then
				dest.append ("NULL")
			else
				dest.append (src)
			end
		end

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_NAMED_METADATA
