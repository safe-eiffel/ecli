indexing

	description:

			"Objects that describe an SQL Table."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TABLE

inherit

	ECLI_NAMED_METADATA
		rename
			make as make_metadata
		export {NONE} make_metadata
		redefine
			out
		end

create

	make

feature {NONE} -- Initialization

	make (tables_cursor : ECLI_TABLES_CURSOR) is
			-- create table from `tables_cursor' item from `a_repository'
		require
			cursor_not_void: tables_cursor /= Void
			cursor_not_off:  not tables_cursor.off
		do
			set_catalog (tables_cursor.buffer_catalog_name)
			set_schema (tables_cursor.buffer_schema_name)
			set_name (tables_cursor.buffer_table_name)
			if not tables_cursor.buffer_table_type.is_null then
				 type := tables_cursor.buffer_table_type.as_string
			end
			if not tables_cursor.buffer_description.is_null then
				description := tables_cursor.buffer_description.as_string
			end
		end

feature -- Access

	type : STRING
			-- table type

	description : STRING
			-- description, comment or remarks

feature -- Conversion

	out : STRING is
			-- terse visual representation
		do
			create Result.make (128)
			Result.append_string (Precursor)
			Result.append_string ("%T")
			append_to_string (Result, type) Result.append_string ("%T")
			append_to_string (Result, description)
		end

end
