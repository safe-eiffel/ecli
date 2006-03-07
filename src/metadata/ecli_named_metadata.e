indexing

	description:
	
			"Objects that are named metadata, i.e. with catalog, schema and name."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_NAMED_METADATA

inherit

	ANY
		redefine
			out
		end

creation

	make
	
feature {NONE} -- Initialization

	make (a_catalog, a_schema, a_name : STRING) is
			-- make for `a_catalog', `a_schema', `a_name'
		do
			catalog := a_catalog
			schema := a_schema
			name := a_name
		ensure
			catalog_assigned: catalog = a_catalog
			schema_assigned: schema = a_schema
			name_assigned: name = a_name
		end
		
feature -- Access

	catalog : STRING
			-- catalog name
	
	schema : STRING
			-- schema name
	
	name : STRING
			-- table, column, or procedure name

feature -- Element change

	set_catalog (value : ECLI_VARCHAR) is
			-- set `catalog' wit `value'
		require
			value: value /= Void
		do
			if not value.is_null then
				catalog := value.as_string
			else
				catalog := Void
			end
		ensure
			void_if_null_value: value.is_null implies catalog = Void
			assigned_if_not_null: not value.is_null implies catalog.is_equal (value.as_string)
		end

	set_schema (value : ECLI_VARCHAR) is
			-- set `schema' with `value'
		require
			value: value /= Void
		do
			if not value.is_null then
				schema := value.as_string			
			else
				schema := Void
			end
		ensure
			void_if_null_value: value.is_null implies schema = Void
			assigned_if_not_null: not value.is_null implies schema.is_equal (value.as_string)		
		end
		
	set_name (value : ECLI_VARCHAR) is
			-- set `name' with `value'
		require
			value: value /= Void and then not value.is_null
		do
			name := value.as_string
		ensure
			assigned: name.is_equal (value.as_string)		
		end

feature -- Conversion

	out : STRING is
			-- terse printable representation
		do
			!!Result.make (0)
			append_to_string (Result, catalog) Result.append_string ("%T")
			append_to_string (Result, schema) Result.append_string ("%T")
			append_to_string (Result, name)			
		end

feature {NONE} -- Implementation

	append_to_string (dest, src : STRING) is
			-- 
		do
			if src = Void then
				dest.append_string ("NULL")
			else
				dest.append_string (src)
			end
		end

end
