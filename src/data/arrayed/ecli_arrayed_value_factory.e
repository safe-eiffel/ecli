indexing
	description: "Factory of ECLI_ARRAYED_VALUE descendant instances"
	
	note: "Supported SQL data types currently are : sql_char, sql_decimal, sql_double, sql_float, sql_integer, sql_longvarchar, sql_numeric, sql_real, sql_smallint, sql_type_date, sql_type_time, sql_type_timestamp,	sql_varchar"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ARRAYED_VALUE_FACTORY

inherit

	ECLI_ABSTRACT_VALUE_FACTORY [ECLI_ARRAYED_VALUE]
			
creation
	make

feature {NONE} -- Initialization

	make (a_row_count : INTEGER) is
		do
			row_count := a_row_count
		ensure
			row_count_set: row_count = a_row_count
		end

feature -- Measurement

	row_count : INTEGER
			-- default capacity of arrayed values
	
feature -- Status report

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	create_double_value is
		do
			!ECLI_ARRAYED_DOUBLE!last_result.make (row_count)
		end

	create_real_value is
		do
			!ECLI_ARRAYED_REAL!last_result.make (row_count)
		end

	create_integer_value is
		do
			!ECLI_ARRAYED_INTEGER!last_result.make (row_count)
		end

	create_char_value (column_precision : INTEGER) is
		do
			!ECLI_ARRAYED_CHAR!last_result.make (column_precision,row_count)
		end

	create_varchar_value (column_precision : INTEGER) is
		do
			if column_precision > 254 then
				!ECLI_ARRAYED_LONGVARCHAR!last_result.make (column_precision,row_count)
			else
				!ECLI_ARRAYED_VARCHAR!last_result.make (column_precision, row_count)
			end
		end

	create_date_value is
		do
			!ECLI_ARRAYED_DATE!last_result.make (row_count)
		end

	create_timestamp_value is
		do
			!ECLI_ARRAYED_TIMESTAMP!last_result.make (row_count)
		end
		
	create_time_value is
		do
			!ECLI_ARRAYED_TIME!last_result.make (row_count)
		end


invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_ARRAYED_VALUE_FACTORY
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
