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

	ECLI_HANDLE
		rename
			handle as buffer
		export
			{NONE} release_handle
		end

	ECLI_EXTERNAL_API

feature -- Initialization

feature -- Access

	item : ANY is
			-- actual value : to be redefined in descendant classes
		require
			not_null: not is_null
		do
		end

feature -- Measurement

feature -- Status report

	is_null : BOOLEAN is
		do
			Result := ecli_c_value_get_length_indicator (buffer) = sql_null_data
		ensure
			Result implies item = Void
		end

	convertible_to_string : BOOLEAN is
			-- is this value convertible to a string ?
		do
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

feature {ECLI_VALUE, ECLI_STATEMENT} -- Status Report

	c_type_code : INTEGER is
			-- (redefine in descendant classes)
		deferred
		end

	db_type_code : INTEGER is
			-- (redefine in descendant classes)
		deferred
		end

	column_precision : INTEGER is
			-- maximum number of 'digits' used by the data type
			-- for character and binary data : number of bytes
			-- for numeric data : number of sigificant digits
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

	decimal_digits : INTEGER is
			-- decimal digits
			-- (redefine in descendant classes)
		deferred
		end

	to_external : POINTER is
			-- external 'C' address of value
		do
			Result := ecli_c_value_get_value (buffer)
		end

	length_indicator_pointer : POINTER is
			-- external 'C' address of length indicator
		do
			Result := ecli_c_value_get_length_indicator_pointer (buffer)
		end

	length_indicator : INTEGER is
		do
			Result := ecli_c_value_get_length_indicator (buffer)
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change


	set_item (value: like item) is
		do
		ensure
			null_value: is_null implies value = void;
			item_set: equal (item, value)
		end;


	set_null is
			-- set item to null
		do
			ecli_c_value_set_length_indicator (buffer, sql_null_data)
		ensure
			null_value: is_null 
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	to_string : STRING is
			-- ...
		require
			convertible: convertible_to_string
			not_null: not is_null
		do
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
			convertible: convertible_to_string
			not_null: not is_null
		do
		end

	to_date : ECLI_DATE is
			-- ...
		require
			convertible: convertible_to_date
			not_null: not is_null
		do
		end

	to_time : ECLI_TIME is
			-- ...
		require
			convertible: convertible_to_time
			not_null: not is_null
		do
		end

	to_timestamp : ECLI_TIMESTAMP is
			-- ...
		require
			convertible: convertible_to_timestamp
			not_null: not is_null
		do
		end


feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	release_handle is
		do
			-- | free associated C buffer memory
		end

feature {NONE} -- data type indicators

	sql_char : INTEGER is
		--
	once
		Result := ecli_c_sql_char
	end


	sql_numeric : INTEGER is
		--
	once
		Result := ecli_c_sql_numeric
	end


	sql_decimal : INTEGER is
		--
	once
		Result := ecli_c_sql_decimal
	end


	sql_integer : INTEGER is
		--
	once
		Result := ecli_c_sql_integer
	end


	sql_smallint : INTEGER is
		--
	once
		Result := ecli_c_sql_smallint
	end


	sql_float : INTEGER is
		--
	once
		Result := ecli_c_sql_float
	end


	sql_real : INTEGER is
		--
	once
		Result := ecli_c_sql_real
	end


	sql_double : INTEGER is
		--
	once
		Result := ecli_c_sql_double
	end

	sql_varchar : INTEGER is
		--
	once
		Result := ecli_c_sql_varchar
	end

	sql_type_date : INTEGER is
		--
	once
		Result := ecli_c_sql_type_date
	end


	sql_type_time : INTEGER is
		--
	once
		Result := ecli_c_sql_type_time
	end

	sql_type_timestamp : INTEGER is
		--
	once
		Result := ecli_c_sql_type_timestamp
	end


	sql_longvarchar : INTEGER is
		--
	once
		Result := ecli_c_sql_longvarchar
	end

	sql_c_char : INTEGER is
		--
	once
		Result := ecli_c_sql_c_char
	end


	sql_c_long : INTEGER is
		--
	once
		Result := ecli_c_sql_c_long
	end


	sql_c_short : INTEGER is
		--
	once
		Result := ecli_c_sql_c_short
	end


	sql_c_float : INTEGER is
		--
	once
		Result := ecli_c_sql_c_float
	end


	sql_c_double : INTEGER is
		--
	once
		Result := ecli_c_sql_c_double
	end


	sql_c_numeric : INTEGER is
		--
	once
		Result := ecli_c_sql_c_numeric
	end


	sql_c_default : INTEGER is
		--
	once
		Result := ecli_c_sql_c_default
	end

	sql_c_type_date : INTEGER is
		--
	once
		Result := ecli_c_sql_c_type_date
	end


	sql_c_type_time : INTEGER is
		--
	once
		Result := ecli_c_sql_c_type_time
	end


	sql_c_type_timestamp : INTEGER is
		--
	once
		Result := ecli_c_sql_c_type_timestamp
	end

feature {NONE} -- Implementation values
	
	sql_null_data : INTEGER is
		once
			Result := ecli_c_null_data
		end

invariant
	invariant_clause: is_valid

end -- class ECLI_VALUE
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
