indexing
	description: "Factories of ECLI_VALUEs that offer introspection/generation facilities."

	library: "Access_gen : Access Modules Generators utilities"
	
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
			create_time_value,
			last_result
		select
		end

creation
	make

feature -- Initialization

feature -- Access

	last_result : QA_VALUE

	last_error : STRING
	
feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	create_value_from_sample (sample : STRING) is
			-- create a value from `sample'; last_result is an instance of
			-- * ECLI_VARCHAR if sample is "NULL" or none of the following
			-- * ECLI_DATE if sample is a valid CLI date literal {t 'hh:mm:ss[.nnn ]'}
			-- * ECLI_TIME if sample is a valid CLI time literal {d 'yyyy-mm-dd'}
			-- * ECLI_TIMESTAMP if sample if a valid CLI timestamp literal {ts 'yyyy-mm-dd hh:mm:ss[.nnn ]'}
		require
			sample_not_void: sample /= Void
		local
			converted : BOOLEAN
			date_result : QA_DATE
			time_result : QA_TIME
			timestamp_result : QA_TIMESTAMP
			varchar_result : QA_VARCHAR
		do
			last_result := Void
			last_error := Void
			converted := False
			if sample.is_equal ("NULL") then
				create varchar_result.make (1)
				last_result := varchar_result
			else
				if sample.count > 3 then
					if sample.item (1) = '{' then
						if sample.item (2) = 't' then
							if sample.item (3) = 's' then
								if Fmt_timestamp.matching_string (sample) then
									Fmt_timestamp.create_from_string (sample)
									create timestamp_result.make_default
									timestamp_result.set_item (Fmt_timestamp.last_result)
									last_result := timestamp_result
									converted := True
								else
									last_error := "Invalid timestamp format"
								end
							elseif fmt_time.matching_string (sample) then
								fmt_time.create_from_string (sample)
								create time_result.make_default
								time_result.set_item (fmt_time.last_result)
								last_result := time_result
								converted := True
							else
								last_error := "Invalid time format"
							end
						elseif sample.item (2) = 'd' then
							if fmt_date.matching_string (sample) then
								fmt_date.create_from_string (sample)
								create date_result.make_default
								date_result.set_item (fmt_date.last_result)
								last_result := date_result
								converted := True
							else
								last_error := "Invalid date format"
							end
						else
							converted := False
							-- force conversion to varchar
						end
					end
				end
				if not converted and then last_result = Void then
					create varchar_result.make (sample.count)
					varchar_result.set_item (sample)
					last_result := varchar_result
				end
			end
		end
		
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
			create {QA_DATE}last_result.make_default
		end

	create_timestamp_value is
		do
			create {QA_TIMESTAMP}last_result.make_default
		end

	create_time_value is
		do
			create {QA_TIME}last_result.make_default
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

	fmt_date : ECLI_DATE_FORMAT is once create Result end
	fmt_time : ECLI_TIME_FORMAT is once create Result end
	fmt_timestamp : ECLI_TIMESTAMP_FORMAT is once create Result end
	
end -- class QA_VALUE_FACTORY
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
