indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_PROCEDURES_CURSOR

inherit

	ECLI_CURSOR
		rename
			statement_start as start,
			close as cursor_close, statement_close as close
		export 
			{ANY} close
		redefine
			start, forth
		end
		
create
	make_all_procedures -- , make_by_type
	
feature {NONE} -- Initialization

	make_all_procedures (a_session : ECLI_SESSION) is
			-- make cursor for all types of session
		require
			session_opened: a_session /= Void and then a_session.is_connected
		do
			make (a_session)
			set_status (ecli_c_set_integer_statement_attribute (handle, sql_attr_metadata_id, sql_true))
			set_status (ecli_c_get_procedures ( handle, 
				default_pointer, 0, default_pointer, 0, default_pointer, 0))
			if is_ok then
				get_result_column_count
				is_executed := True
				if has_results then
					set_cursor_before
				else
					set_cursor_after
				end
	         else
	         	impl_result_column_count := 0
			end
			create_buffers
		ensure
			executed: is_ok implies is_executed
		end
	
feature -- Access

	item : ECLI_PROCEDURE is
			-- 
		do
			Result := impl_item
		end
		
	
feature -- Cursor Movement

	start is
		do
			if cursor  = Void then
				create_buffers
			end
			Precursor
--			if not off then
--				!!impl_item.make (Current)
--			end	
		end
		
	forth is
		do
			Precursor
--			if not off then
--				!!impl_item.make (Current)
--			else
--				impl_item := Void				
--			end
		end

feature {ECLI_PROCEDURE} -- Access

		buffer_catalog_name,
			buffer_schema_name,
			buffer_procedure_name,
			buffer_description, buffer_na1, buffer_na2, buffer_na3 : ECLI_VARCHAR
	
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
			
			set_cursor (<<
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
			-- 
		do
			if not off then
				!!impl_item.make (Current)
			else
				impl_item := Void
			end
		end
		
	impl_item : ECLI_PROCEDURE
	
	definition : STRING is once Result := "SQLProcedures" end

end -- class ECLI_PROCEDURES_CURSOR
