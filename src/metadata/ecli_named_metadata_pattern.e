note

	description:

			"Objects that describe a name pattern for metadata."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"


class
	ECLI_NAMED_METADATA_PATTERN

inherit

	ANY
		redefine
			out
		end

create

	make

feature {NONE} -- Initialization

	make (a_catalog, a_schema, a_name : detachable STRING)
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

	catalog : detachable STRING
			-- catalog name

	schema : detachable STRING
			-- schema name

	name : detachable STRING
			-- table, column, or procedure name

feature -- Conversion

	out : STRING
			-- terse printable representation
		do
			create Result.make (0)
			append_to_string (Result, catalog) Result.append_string ("%T")
			append_to_string (Result, schema) Result.append_string ("%T")
			append_to_string (Result, name)
		end

feature {NONE} -- Implementation

	append_to_string (dest : STRING; src : detachable STRING)
			--
		require
			dest_not_void: dest /= Void  --FIXME: VS-DEL
		do
			if src = Void then
				dest.append_string ("NULL")
			else
				dest.append_string (src)
			end
		end

end
