indexing
	description: 

		"Objects that represent typed values to be exchanged with the database"

	author: 	"Paul G. Crismer"
	date: 		"$Date$"
	revision: 	"$Revision$"
	licensing: 	"See notice at end of class"

deferred class
	ECLI_VALUE

inherit
	ECLI_TRACEABLE

	ECLI_HANDLE
		rename
			handle as buffer
		export
			{NONE} release_handle
		end

	ECLI_EXTERNAL_API

	ECLI_TYPE_CODES

	ECLI_DATA_DESCRIPTION
		export
			{ANY} all
		end
		
feature -- Access

	item : ANY is
			-- actual value : to be redefined in descendant classes
		require
			not_null: not is_null
		do
		end

feature -- Status report

	is_null : BOOLEAN is
			-- is this a NULL value (in RDBMS sense) ?
		do
			Result := ecli_c_value_get_length_indicator (buffer) = Sql_null_data
		end

	convertible_to_string : BOOLEAN is
			-- is this value convertible to a string ?
		do
			Result := True
		end

	convertible_to_character : BOOLEAN is
			-- is this value convertible to a character ?
		do
		end

	convertible_to_boolean : BOOLEAN is
			-- is this value convertible to a boolean ?
		do
		end

	convertible_to_integer : BOOLEAN is
			-- is this value convertible to an integer ?
		do
		end

	convertible_to_real : BOOLEAN is
			-- is this value convertible to a real ?
		do
		end

	convertible_to_double : BOOLEAN is
			-- is this value convertible to a double ?
		do
		end

	convertible_to_date : BOOLEAN is
			-- is this value convertible to a date ?
		do
		end

	convertible_to_time : BOOLEAN is
			-- is this value convertible to a time ?
		do
		end

	convertible_to_timestamp : BOOLEAN is
			-- is this value convertible to a timestamp ?
		do
		end

	can_trace : BOOLEAN is
		do
			Result := True
		ensure then
			ok: Result
		end
		
feature {ECLI_VALUE, ECLI_STATEMENT} -- Status Report

	c_type_code : INTEGER is
			-- (redefine in descendant classes)
		deferred
		end

	transfer_octet_length : INTEGER is
			-- actual transfer length in bytes
			-- (redefine in descendant classes)
		deferred
		end

	display_size : INTEGER is
			-- display size
			-- (redefine in descendant classes)
		deferred
		end

	length_indicator : INTEGER is
		do
			Result := ecli_c_value_get_length_indicator (buffer)
		end

feature -- Element change


	set_item (value: like item) is
		require
			value /= Void
		do
		ensure
			item_set: equal (item, truncated (value))
		end;


	set_null is
			-- set item to null
		do
			ecli_c_value_set_length_indicator (buffer, Sql_null_data)
		ensure
			null_value: is_null 
		end

feature -- Transformation

	truncated (v : like item) : like item is
			-- truncated 'v' according to 'column_precision'
			-- does nothing, except for fixed format types like CHAR
		do
			Result := v
		end
 
feature -- Conversion

	to_string : STRING is
			-- ...
		require
			convertible: convertible_to_string
			not_null: not is_null
		do
			Result := out
		end

	to_character : CHARACTER is
			-- ...
		require
			convertible: convertible_to_character
			not_null: not is_null
		do
		end

	to_boolean : BOOLEAN is
			-- ...
		require
			convertible: convertible_to_boolean
			not_null: not is_null
		do
		end

	to_integer : INTEGER is
			-- ...
		require
			convertible: convertible_to_integer
			not_null: not is_null
		do
		end

	to_real : REAL is
			-- ...
		require
			convertible: convertible_to_real
			not_null: not is_null
		do
		end

	to_double : DOUBLE is
			-- ...
		require
			convertible: convertible_to_double
			not_null: not is_null
		do
		end

	to_date : DT_DATE is
			-- ...
		require
			convertible: convertible_to_date
			not_null: not is_null
		do
		end

	to_time : DT_TIME is
			-- ...
		require
			convertible: convertible_to_time
			not_null: not is_null
		do
		end

	to_timestamp : DT_DATE_TIME is
			-- ...
		require
			convertible: convertible_to_timestamp
			not_null: not is_null
		do
		end

feature {NONE} -- Implementation

	release_handle is
		do
			ecli_c_free_value (buffer)
			buffer := default_pointer
		end

	to_external : POINTER is
			-- external 'C' address of value
		do
			Result := ecli_c_value_get_value (buffer)
		ensure
			not_null: Result /= default_pointer	
		end

	length_indicator_pointer : POINTER is
			-- external 'C' address of length indicator
		do
			Result := ecli_c_value_get_length_indicator_pointer (buffer)
		end

feature {ECLI_STATEMENT} -- Basic operations


	read_result (stmt : ECLI_STATEMENT; index : INTEGER) is
			-- read value from current result column 'index' of 'stmt'
		require
			stmt: stmt /= Void and then (stmt.is_executed and not stmt.off)
			positive_index: index > 0
		do
			stmt.set_status (ecli_c_get_data (
					stmt.handle,
					index,
					c_type_code,
					to_external,
					transfer_octet_length,
					length_indicator_pointer)
				)
		end

	bind_as_result  (stmt : ECLI_STATEMENT; index: INTEGER) is
		require
			stmt: stmt /= Void 
			positive_index: index > 0
		do
			stmt.set_status (ecli_c_bind_result (
					stmt.handle,
					index,
					c_type_code,
					to_external,
					transfer_octet_length,
					length_indicator_pointer)
				)
		end
		
	bind_as_parameter (stmt : ECLI_STATEMENT; index: INTEGER) is
			-- bind this value as parameter 'index' of 'stmt'
		require
			stmt: stmt /= Void and then stmt.parameters_count > 0
			positive_index: index > 0
		do
			stmt.set_status (ecli_c_bind_parameter (stmt.handle,
				index,
				c_type_code,
				sql_type_code,
				column_precision,
				decimal_digits,
				to_external,
				transfer_octet_length,
				length_indicator_pointer))
		end

	put_parameter (stmt : ECLI_STATEMENT; index : INTEGER) is
			-- put parameter 'index' data at execution of 'stmt'
			-- Redefine in descendant classes if needed
		require
			stmt: stmt /= Void
			positive_index: index > 0
		do
		end

feature {NONE} -- Implementation values
	
	Sql_null_data : INTEGER is
		once
			Result := ecli_c_null_data
		end

	is_ready_for_disposal : BOOLEAN is True
	
	disposal_failure_reason : STRING is do	end
	
invariant
	invariant_clause: is_valid

end -- class ECLI_VALUE
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
