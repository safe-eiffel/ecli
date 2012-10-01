note

	description: 
	
		"Objects that reflect status of rowset operations. They basically are an array of integer."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ROWSET_STATUS

inherit

	XS_C_ARRAY_INT16

	ECLI_EXTERNAL_API
		export 
			{NONE} all;
			{ANY} Sql_row_success, Sql_row_success_with_info, Sql_row_error,
				  Sql_row_deleted, Sql_row_updated,	Sql_row_norow, Sql_row_added
		end
	
create

	make

feature -- Status report

	is_ok (index : INTEGER) : BOOLEAN
			-- is `index'-th status ok?
		require
			valid_index: index >= 1 and index <= count
		do
			Result := (item (index) = Sql_row_success) or else (item (index) = Sql_row_success_with_info)
		end

	is_error (index : INTEGER) : BOOLEAN
			-- is `index'-th status in error ?
		require
			valid_index: index >= 1 and index <= count
		do
			Result := (item (index) = Sql_row_error)
		end

end
