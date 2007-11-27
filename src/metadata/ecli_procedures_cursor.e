indexing

	description:

		"Cursor on procedures matching criteria. %
		%Search criterias are (1) catalog name, (2) schema name, (3) procedure name.%
		%A Void criteria is considered as a wildcard."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_PROCEDURES_CURSOR

inherit

	ECLI_METADATA_CURSOR
		rename
			queried_name as queried_procedure
		redefine
			item, impl_item
		end

creation

	make_all_procedures, make -- , make_by_type

feature {NONE} -- Initialization

	make_all_procedures (a_session : ECLI_SESSION) is
			-- make cursor for all types of session
		require
			session_opened: a_session /= Void and then a_session.is_connected
		local
			search_criteria : ECLI_NAMED_METADATA
		do
			!!search_criteria.make (Void, Void, Void)
			make (search_criteria, a_session)
		ensure
			executed: is_ok implies is_executed
		end

feature -- Access

	item : ECLI_PROCEDURE_METADATA is
			-- item at current cursor position
		do
			Result := impl_item
		end

feature -- Cursor Movement

feature {ECLI_PROCEDURE_METADATA} -- Access

	buffer_catalog_name : ECLI_VARCHAR
	buffer_schema_name : ECLI_VARCHAR
	buffer_procedure_name : ECLI_VARCHAR
	buffer_description : ECLI_VARCHAR
	buffer_na1 : ECLI_VARCHAR
	buffer_na2 : ECLI_VARCHAR
	buffer_na3 : ECLI_VARCHAR

	buffer_procedure_type : ECLI_INTEGER

feature {NONE} -- Implementation

	create_buffers is
			-- create buffers for cursor
		do
			create buffer_catalog_name.make (255)
			create buffer_schema_name.make (255)
			create buffer_procedure_name.make (255)
			create buffer_description.make (255)
			create buffer_na1.make (10)
			create buffer_na2.make (10)
			create buffer_na3.make (10)
			create buffer_procedure_type.make

			set_results (<<
					buffer_catalog_name,
					buffer_schema_name,
					buffer_procedure_name,
					buffer_na1,
					buffer_na2,
					buffer_na3,
					buffer_description,
					buffer_procedure_type
				>>)
		end

	create_item is
			-- create item at curren cursor position
		do
			if not off then
				!!impl_item.make (Current)
			else
				impl_item := Void
			end
		end

	impl_item : like item

	definition : STRING is once Result := "SQLProcedures" end

	do_query_metadata (l_catalog : POINTER; catalog_length : INTEGER;
		l_schema : POINTER; schema_length : INTEGER;
		l_name : POINTER; name_length : INTEGER) : INTEGER is
			-- actual external query
		do
			Result := ecli_c_get_procedures ( handle,
				l_catalog, catalog_length, l_schema, schema_length, l_name, name_length)
		end

end
