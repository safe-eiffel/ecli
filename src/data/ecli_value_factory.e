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

	ECLI_ABSTRACT_VALUE_FACTORY [ECLI_VALUE]

creation
	make

feature {NONE} -- Initialization

	make is do end

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

end -- class ECLI_VALUE_FACTORY
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
