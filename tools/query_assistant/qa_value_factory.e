indexing
	description: "Objects that ..."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QA_VALUE_FACTORY

inherit
	ECLI_VALUE_FACTORY
		rename
		export
		undefine
		redefine
			create_double_value,
			create_real_value,
			create_integer_value,
			create_char_value,
			create_varchar_value,
			create_date_value,
			create_timestamp_value,
			last_result
		select
		end

creation
	make

feature -- Initialization

feature -- Access

	last_result : QA_VALUE

feature -- Measurement

feature -- Status report

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
			create {QA_DOUBLE}last_result.make
		end

	create_real_value is
		do
			create {QA_REAL}last_result.make
		end

	create_integer_value is
		do
			create {QA_INTEGER}last_result.make
		end

	create_char_value (column_precision : INTEGER) is
		do
			create {QA_CHAR}last_result.make (column_precision)
		end

	create_varchar_value (column_precision : INTEGER) is
		do
			if column_precision > 254 then
				create {QA_LONGVARCHAR} last_result.make (column_precision)
			else
				create {QA_VARCHAR}last_result.make (column_precision)
			end
		end

	create_date_value is
		do
			create {QA_DATE}last_result.make_first
		end

	create_timestamp_value is
		do
			create {QA_TIMESTAMP}last_result.make_first
		end

feature -- Basic operations
	code2eiffel_type (db_type_code : INTEGER) : STRING is
		do
			Result := c2e.item (db_type_code)
		end

	code2ecli_value (db_type_code : INTEGER) : STRING is
		do
			Result := c2v.item (db_type_code)
		end

	code2make_parameters (db_type_code : INTEGER; precision, digits : INTEGER) : STRING is
		do
			Result := clone ("")
			if db_type_code = sql_char or db_type_code = sql_varchar then
				Result.append (" ("); Result.append (precision.out); Result.append (")")
			end
		end

	c2e : DS_HASH_TABLE[STRING, INTEGER] is
		once
			create Result.make (12)
			Result.put("INTEGER", sql_integer)
			Result.put("INTEGER", sql_smallint)
			Result.put("STRING", sql_char)
			Result.put("STRING", sql_varchar)
			Result.put("ECLI_TIMESTAMP", sql_type_timestamp)
			Result.put("ECLI_DATE", sql_type_date)
			Result.put("ECLI_TIME", sql_type_time)
			Result.put("REAL", sql_real)
			Result.put("DOUBLE", sql_double)
			Result.put("DOUBLE", sql_float)
			Result.put("DOUBLE", sql_decimal)
			Result.put("DOUBLE", sql_numeric)

		end

	c2v : DS_HASH_TABLE[STRING, INTEGER] is
		once
			create Result.make (12)
			Result.put("ECLI_INTEGER", sql_integer)
			Result.put("ECLI_INTEGER", sql_smallint)
			Result.put("ECLI_CHAR", sql_char)
			Result.put("ECLI_VARCHAR", sql_varchar)
			Result.put("ECLI_TIMESTAMP", sql_type_timestamp)
			Result.put("ECLI_DATE", sql_type_date)
			Result.put("ECLI_TIME", sql_type_time)
			Result.put("ECLI_REAL", sql_real)
			Result.put("ECLI_DOUBLE", sql_double)
			Result.put("ECLI_FLOAT", sql_float)
			Result.put("ECLI_DOUBLE", sql_decimal)
			Result.put("ECLI_DOUBLE", sql_numeric)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: -- Your invariant here

end -- class QA_VALUE_FACTORY
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
