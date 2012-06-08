indexing

	description:

			"Factory of ECLI_VALUE descendant instances."

	please_note: "Supported SQL data types currently are : sql_char, sql_decimal, sql_double, sql_float, sql_integer, sql_longvarchar, sql_numeric, sql_real, sql_smallint, sql_type_date, sql_type_time, sql_type_timestamp,	sql_varchar"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_VALUE_FACTORY

inherit

	ECLI_TYPE_CONSTANTS
		export {ANY}
			sql_char, sql_varchar, sql_longvarchar,
			sql_type_timestamp, sql_type_date, sql_type_time,
			sql_real, sql_double, sql_smallint, sql_float, sql_decimal, sql_numeric
		end

create

	make

feature {NONE} -- Initialization

	make is
		do
			create {ECLI_VARCHAR}last_result.make (100)
		end

feature -- Access

	last_result : ECLI_VALUE
			-- last result of `create_instance'

feature -- Status report


feature -- Status report

	valid_type (type_code : INTEGER) : BOOLEAN is
		do
			Result := valid_types.has (type_code)
		end

feature -- Status setting

feature {NONE} -- Miscellaneous

--			*	sql_binary,
--			*	sql_char,
--			*	sql_type_date,
--			*	sql_decimal,
--			*	sql_double,
--				sql_float,
--			*	sql_integer,
--			*	sql_bigint,
--			*	sql_longvarbinary,
--			*	sql_longvarchar,
--			*	sql_numeric,
--			*	sql_real,
--				sql_smallint,
--			*	sql_type_time,
--			*	sql_type_timestamp,
--			*	sql_varchar

	create_binary_value (column_precision : INTEGER)
		do
			create {ECLI_BINARY}last_result.make (column_precision)
		end

	create_char_value (column_precision : INTEGER) is
		do
			create {ECLI_CHAR}last_result.make (column_precision)
		end

	create_date_value is
		do
			create {ECLI_DATE}last_result.make_default
		end

	create_decimal_value (precision, decimal_digits : INTEGER) is
		do
			create {ECLI_DECIMAL}last_result.make (precision, decimal_digits)
		end

	create_double_value is
		do
			create {ECLI_DOUBLE}last_result.make
		end

	create_integer_value is
		do
			create {ECLI_INTEGER}last_result.make
		end

	create_integer_64_value is
		do
			create {ECLI_INTEGER_64}last_result.make
		end

	create_longvarbinary_value (precision : INTEGER)
		do
			create {ECLI_LONGVARBINARY}last_result.make (precision)
		end

	create_longvarchar_value (precision : INTEGER)
		do
			create {ECLI_LONGVARCHAR}last_result.make (precision)
		end

	create_numeric_value (precision, decimal_digits : INTEGER)
		do
			create {ECLI_DECIMAL}last_result.make (precision, decimal_digits)
		end

	create_real_value is
		do
			create {ECLI_REAL}last_result.make
		end

	create_varchar_value (column_precision : INTEGER) is
		do
			if column_precision > 254 then
				create_longvarchar_value (column_precision)
			else
				create {ECLI_VARCHAR}last_result.make (column_precision)
			end
		end

	create_time_value is
		do
			create {ECLI_TIME}last_result.make_default
		end

	create_timestamp_value is
		do
			create {ECLI_TIMESTAMP}last_result.make_default
		end

feature -- Basic operations

	create_instance (db_type, column_precision, decimal_digits : INTEGER)  is
			-- create instance of an ECLI_VALUE descendant best matching `db_type', `column_precision', `decimal_digits'
		require
			db_type_ok: valid_type (db_type)
		do
			inspect db_type
			when sql_binary then
					create_binary_value (column_precision)
			when sql_char then
					create_char_value (column_precision)
			when sql_decimal then
					create_decimal_value (column_precision, decimal_digits)
			when sql_double then
					create_double_value
			when sql_float then
					create_real_value
			when sql_longvarbinary then
					create_longvarbinary_value (column_precision)
			when sql_longvarchar then
					create_longvarchar_value (column_precision)
			when sql_integer, sql_smallint then
					create_integer_value
			when sql_numeric then
					create_numeric_value (column_precision, decimal_digits)
			when sql_real then
					create_real_value
			when sql_type_date then
					create_date_value
			when sql_type_timestamp then
					create_timestamp_value
			when Sql_type_time then
					create_time_value
			when sql_varchar then
					create_varchar_value (column_precision)
			else
				create_longvarchar_value (column_precision)
			end
		ensure
			not_void: last_result /= Void --FIXME: VS-DEL
			--	((db_type = sql_double or else db_type = sql_float or else db_type = sql_numeric or else db_type = sql_decimal or else last_result.column_precision >= column_precision) and then last_result.decimal_digits >= decimal_digits)
			-- condition is relaxed for sql_float.  Oracle's NUMBER is given as sql_float or sql_double with precision 38 !!!
			new_last_result: last_result /= old last_result
		end

feature {NONE} -- Implementation

	valid_types : ARRAY[INTEGER] is
		once
			Result := <<
				sql_binary,
				sql_char,
				sql_type_date,
				sql_decimal,
				sql_double,
				sql_float,
				sql_integer,
				sql_bigint,
				sql_longvarbinary,
				sql_longvarchar,
				sql_numeric,
				sql_real,
				sql_smallint,
				sql_type_time,
				sql_type_timestamp,
				sql_varchar
			>>
		end

end
