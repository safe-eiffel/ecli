indexing
	description: "Factory of ECLI_VALUE descendant instances"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_VALUE_FACTORY

inherit

	ECLI_TYPE_CODES
		export {ANY}
			sql_char, sql_varchar,
			sql_type_timestamp, sql_type_date, sql_type_time,
			sql_real, sql_double, sql_smallint, sql_float, sql_decimal, sql_numeric
		end
			
creation
	make

feature -- Initialization

	make is
		do
		end

feature -- Access

	last_result : ECLI_VALUE

feature -- Measurement

feature -- Status report

	valid_type (type_code : INTEGER) : BOOLEAN is
		do
			Result := valid_types.has (type_code)
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

	create_double_value is
		do
			create {ECLI_DOUBLE}last_result.make
		end

	create_real_value is
		do
			create {ECLI_REAL}last_result.make
		end

	create_integer_value is
		do
			create {ECLI_INTEGER}last_result.make
		end

	create_char_value (column_precision : INTEGER) is
		do
			create {ECLI_CHAR}last_result.make (column_precision)
		end

	create_varchar_value (column_precision : INTEGER) is
		do
			create {ECLI_VARCHAR}last_result.make (column_precision)
		end

	create_date_value is
		do
			create {ECLI_DATE}last_result.make_first
		end

	create_timestamp_value is
		do
			create {ECLI_TIMESTAMP}last_result.make_first
		end

	create_time_value is
		do
		end

feature -- Basic operations

	create_instance (db_type, column_precision, decimal_digits : INTEGER)  is
			-- create instance of an ECLI_VALUE descendant
		require
			db_type_ok: valid_type (db_type)
		do
			if db_type = sql_char then
					create_char_value (column_precision)
			elseif db_type = sql_varchar then
					create_varchar_value (column_precision)
			elseif db_type = sql_integer or db_type = sql_smallint then
					create_integer_value
			elseif db_type = sql_real then
					create_real_value
			elseif db_type = sql_double then
					create_double_value
			elseif db_type = sql_numeric or db_type = sql_decimal or db_type = sql_float then
					if decimal_digits = 0 and column_precision <= 10 then
							create_integer_value
					else
						if column_precision <= 7 and decimal_digits <= 7 then
							create_real_value
						else
							create_double_value
						end
					end
			elseif db_type = sql_type_date then
					create_date_value
			elseif db_type = sql_type_timestamp then
					create_timestamp_value
			end					
		ensure
			last_result /= Void implies 
				(last_result.column_precision >= column_precision and last_result.decimal_digits >= decimal_digits)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	valid_types : ARRAY[INTEGER] is
		once
			Result := << sql_integer, sql_char, sql_varchar,
			sql_type_timestamp, sql_type_date, sql_type_time,
			sql_real, sql_double, sql_smallint, sql_float, sql_decimal, sql_numeric
			>>
		end

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_VALUE_FACTORY
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
