indexing
	description: "Factory of ECLI_VALUE descendant instances."
	
	note: "Supported SQL data types currently are : sql_char, sql_decimal, sql_double, sql_float, sql_integer, sql_longvarchar, sql_numeric, sql_real, sql_smallint, sql_type_date, sql_type_time, sql_type_timestamp,	sql_varchar"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_VALUE_FACTORY

inherit

	ECLI_TYPE_CONSTANTS
		export {ANY}
			sql_char, sql_varchar, sql_longvarchar,
			sql_type_timestamp, sql_type_date, sql_type_time,
			sql_real, sql_double, sql_smallint, sql_float, sql_decimal, sql_numeric
		end

creation
	make

feature {NONE} -- Initialization

	make is
		do
		end

feature -- Access

	last_result : ECLI_VALUE
			-- last result of `create_instance'

feature -- Measurement

feature -- Status report

	valid_type (type_code : INTEGER) : BOOLEAN is
		do
			Result := array_routines.has(valid_types, type_code)
		end

feature {NONE} -- Miscellaneous

	create_double_value is
		do
			!ECLI_DOUBLE!last_result.make
		end

	create_real_value is
		do
			!ECLI_REAL!last_result.make
		end

	create_integer_value is
		do
			!ECLI_INTEGER!last_result.make
		end

	create_char_value (column_precision : INTEGER) is
		do
			!ECLI_CHAR!last_result.make (column_precision)
		end

	create_varchar_value (column_precision : INTEGER) is
		do
			if column_precision > 254 then
				!ECLI_LONGVARCHAR!last_result.make (column_precision)
			else
				!ECLI_VARCHAR!last_result.make (column_precision)
			end
		end

	create_date_value is
		do
			!ECLI_DATE!last_result.make_default
		end

	create_timestamp_value is
		do
			!ECLI_TIMESTAMP!last_result.make_default
		end

	create_time_value is
		do
			!ECLI_TIME!last_result.make_default
		end

feature -- Basic operations

	create_instance (db_type, column_precision, decimal_digits : INTEGER)  is
			-- create instance of an ECLI_VALUE descendant best matching `db_type', `column_precision', `decimal_digits'
		require
			db_type_ok: valid_type (db_type)
		do
			last_result := Void
			if db_type = sql_char then
					create_char_value (column_precision)
			elseif db_type = sql_varchar or else db_type = sql_longvarchar then
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
			else
				create_varchar_value (column_precision)
			end
		ensure
			not_void: last_result /= Void
			--	((db_type = sql_double or else db_type = sql_float or else db_type = sql_numeric or else db_type = sql_decimal or else last_result.column_precision >= column_precision) and then last_result.decimal_digits >= decimal_digits)
			-- condition is relaxed for sql_float.  Oracle's NUMBER is given as sql_float or sql_double with precision 38 !!!
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	valid_types : ARRAY[INTEGER] is
		once
			Result := << 
				sql_char, 
				sql_decimal, 
				sql_double, 
				sql_float, 
				sql_integer, 
				sql_longvarchar,
				sql_numeric,
				sql_real, 
				sql_smallint, 
				sql_type_date, 
				sql_type_time,
				sql_type_timestamp, 
				sql_varchar
			>>
		end

	array_routines : expanded KL_ARRAY_ROUTINES[INTEGER]

invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_VALUE_FACTORY
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
