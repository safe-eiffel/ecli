indexing

	description:
	
			"CLI DB type codes.  Use this class as a mix-in. Extracted from SQL.h, for ODBC ver >= 3.5	."

--SQL_CHAR
--SQL_VARCHAR
--SQL_LONGVARCHAR
--SQL_DECIMAL
--SQL_NUMERIC
--SQL_SMALLINT
--SQL_INTEGER
--SQL_REAL
--SQL_FLOAT
--SQL_DOUBLE
--SQL_BIT
--SQL_TINYINT
--SQL_BIGINT
--SQL_BINARY
--SQL_VARBINARY
--SQL_LONGVARBINARY
--SQL_TYPE_DATE
--SQL_TYPE_TIME
--SQL_TYPE_TIMESTAMP
--SQL_GUID
--unsupported* SQL_WCHAR
--unsupported* SQL_WVARCHAR
--unsupported* SQL_WLONGVARCHAR
--unsupported* SQL_INTERVAL_MONTH
--unsupported* SQL_INTERVAL_YEAR
--unsupported* SQL_INTERVAL_YEAR_TO_MONTH
--unsupported* SQL_INTERVAL_DAY
--unsupported* SQL_INTERVAL_HOUR
--unsupported* SQL_INTERVAL_MINUTE
--unsupported* SQL_INTERVAL_SECOND
--unsupported* SQL_INTERVAL_DAY_TO_HOUR
--unsupported* SQL_INTERVAL_DAY_TO_MINUTE
--unsupported* SQL_INTERVAL_DAY_TO_SECOND
--unsupported* SQL_INTERVAL_HOUR_TO_MINUTE
--unsupported* SQL_INTERVAL_HOUR_TO_SECOND
--unsupported* SQL_INTERVAL_MINUTE_TO_SECOND

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TYPE_CONSTANTS

feature {ANY} -- SQL data type indicators

	Sql_all_types	:	INTEGER is	0
		--  GetTypeInfo() request for all data types 

	Sql_unknown_type	:	INTEGER is	0

	Sql_char	:	INTEGER is	1
	Sql_numeric	:	INTEGER is	2
	Sql_decimal	:	INTEGER is	3
	Sql_integer	:	INTEGER is	4
	Sql_smallint	:	INTEGER is	5
	Sql_float	:	INTEGER is	6
	Sql_real	:	INTEGER is	7
	Sql_double	:	INTEGER is	8
	Sql_varchar	:	INTEGER is	12

	Sql_type_date	:	INTEGER is	91
	Sql_type_time	:	INTEGER is	92
	Sql_type_timestamp	:	INTEGER is	93

	Sql_interval	:	INTEGER is	10 
	Sql_longvarchar	:	INTEGER is	-1
	Sql_binary	:	INTEGER is	-2
	Sql_varbinary	:	INTEGER is	-3
	Sql_longvarbinary	:	INTEGER is	-4
	Sql_bigint	:	INTEGER is	-5
	Sql_tinyint	:	INTEGER is	-6
	Sql_bit	:	INTEGER is	-7
	Sql_guid	:	INTEGER is	-11 

feature {NONE} -- Not yet supported
	
	-- IF (ODBCVER >= 0x0300)
	--  interval code 
--	Sql_code_year	:	INTEGER is	1
--	Sql_code_month	:	INTEGER is	2
--	Sql_code_day	:	INTEGER is	3
--	Sql_code_hour	:	INTEGER is	4
--	Sql_code_minute	:	INTEGER is	5
--	Sql_code_second	:	INTEGER is	6
--	Sql_code_year_to_month	:	INTEGER is	7
--	Sql_code_day_to_hour	:	INTEGER is	8
----	Sql_code_day_to_minute	:	INTEGER is	9
--	Sql_code_day_to_second	:	INTEGER is	10
--	Sql_code_hour_to_minute	:	INTEGER is	11
--	Sql_code_hour_to_second	:	INTEGER is	12
--	Sql_code_minute_to_second	:	INTEGER is	13

--	Sql_interval_year	:	INTEGER is do Result := (100 + Sql_code_year) end
--	Sql_interval_month	:	INTEGER is do Result := (100 + Sql_code_month) end
--	Sql_interval_day	:	INTEGER is do Result := (100 + Sql_code_day) end
----	Sql_interval_hour	:	INTEGER is do Result := (100 + Sql_code_hour) end
--	Sql_interval_minute	:	INTEGER is do Result := (100 + Sql_code_minute) end
--	Sql_interval_second	:	INTEGER is do Result := (100 + Sql_code_second) end
----	Sql_interval_year_to_month	:	INTEGER is do Result := (100 + Sql_code_year_to_month) end
--	Sql_interval_day_to_hour	:	INTEGER is do Result := (100 + Sql_code_day_to_hour) end
--	Sql_interval_day_to_minute	:	INTEGER is do Result := (100 + Sql_code_day_to_minute) end
--	Sql_interval_day_to_second	:	INTEGER is do Result := (100 + Sql_code_day_to_second) end
--	Sql_interval_hour_to_minute	:	INTEGER is do Result := (100 + Sql_code_hour_to_minute) end
--	Sql_interval_hour_to_second	:	INTEGER is do Result := (100 + Sql_code_hour_to_second) end
--	Sql_interval_minute_to_second	:	INTEGER is do Result := (100 + Sql_code_minute_to_second) end

feature {NONE} -- C data type indicators

--SQL_C_CHAR
--* SQL_C_SSHORT
--* SQL_C_USHORT
--* SQL_C_SLONG
--* SQL_C_ULONG
--SQL_C_FLOAT
--SQL_C_DOUBLE
--SQL_C_BIT
--*SQL_C_STINYINT
--* SQL_C_UTINYINT
--* SQL_C_SBIGINT
--* SQL_C_UBIGINT
--SQL_C_BINARY
--* SQL_C_BOOKMARK
--* SQL_C_VARBOOKMARK
--SQL_C_TYPE_DATE
--SQL_C_TYPE_TIME
--SQL_C_TYPE_TIMESTAMP
--SQL_C_NUMERIC
--SQL_C_GUID

	Sql_c_char	:	INTEGER is do Result := Sql_char end			  --  CHAR, VARCHAR, DECIMAL, NUMERIC 
	Sql_c_long	:	INTEGER is do Result := Sql_integer end		   --  INTEGER					  
	Sql_c_short	:	INTEGER is do Result := Sql_smallint end		  --  SMALLINT					 
	Sql_c_float	:	INTEGER is do Result := Sql_real end			  --  REAL						 
	Sql_c_double	:	INTEGER is do Result := Sql_double end			--  FLOAT, DOUBLE				
	Sql_c_numeric	:	INTEGER is do Result := Sql_numeric end  
	Sql_c_default	:	INTEGER is	99

	Sql_signed_offset	:	INTEGER is	-20
	Sql_unsigned_offset	:	INTEGER is	-22

	Sql_c_type_date	:	INTEGER is do Result := Sql_type_date end
	Sql_c_type_time	:	INTEGER is do Result := Sql_type_time end
	Sql_c_type_timestamp	:	INTEGER is do Result := Sql_type_timestamp end

--	Sql_c_interval_year	:	INTEGER is do Result := Sql_interval_year end
--	Sql_c_interval_month	:	INTEGER is do Result := Sql_interval_month end
--	Sql_c_interval_day	:	INTEGER is do Result := Sql_interval_day end
--	Sql_c_interval_hour	:	INTEGER is do Result := Sql_interval_hour end
--	Sql_c_interval_minute	:	INTEGER is do Result := Sql_interval_minute end
--	Sql_c_interval_second	:	INTEGER is do Result := Sql_interval_second end
--	Sql_c_interval_year_to_month	:	INTEGER is do Result := Sql_interval_year_to_month end
--	Sql_c_interval_day_to_hour	:	INTEGER is do Result := Sql_interval_day_to_hour end
--	Sql_c_interval_day_to_minute	:	INTEGER is do Result := Sql_interval_day_to_minute end
--	Sql_c_interval_day_to_second	:	INTEGER is do Result := Sql_interval_day_to_second end
--	Sql_c_interval_hour_to_minute	:	INTEGER is do Result := Sql_interval_hour_to_minute end
--	Sql_c_interval_hour_to_second	:	INTEGER is do Result := Sql_interval_hour_to_second end
--	Sql_c_interval_minute_to_second	:	INTEGER is do Result := Sql_interval_minute_to_second end

	Sql_c_binary	:	INTEGER is do Result := Sql_binary end
	Sql_c_bit	:	INTEGER is do Result := Sql_bit end

	Sql_c_sbigint	:	INTEGER is do Result := (Sql_bigint+Sql_signed_offset) end		--  SIGNED BIGINT 
	Sql_c_ubigint	:	INTEGER is do Result := (Sql_bigint+Sql_unsigned_offset) end	--  UNSIGNED BIGINT 

	Sql_c_tinyint	:	INTEGER is do Result := Sql_tinyint end
	Sql_c_slong	:	INTEGER is do Result := (Sql_c_long+Sql_signed_offset) end	 --  SIGNED INTEGER  
	Sql_c_sshort	:	INTEGER is do Result := (Sql_c_short+Sql_signed_offset) end	--  SIGNED SMALLINT 
	Sql_c_stinyint	:	INTEGER is do Result := (Sql_tinyint+Sql_signed_offset) end	--  SIGNED TINYINT  

	Sql_c_ulong	:	INTEGER is do Result := (Sql_c_long+Sql_unsigned_offset) end   --  UNSIGNED INTEGER
	Sql_c_ushort	:	INTEGER is do Result := (Sql_c_short+Sql_unsigned_offset) end  --  UNSIGNED SMALLINT
	Sql_c_utinyint	:	INTEGER is do Result := (Sql_tinyint+Sql_unsigned_offset) end  --  UNSIGNED TINYINT

	Sql_c_bookmark	:	INTEGER is do Result := Sql_c_ulong end						--  BOOKMARK		
	Sql_c_varbookmark	:	INTEGER is do Result := Sql_c_binary end -- (ODBCVER >= 0x0300)   --  ODBCVER >= 0x0300 

	Sql_c_guid	:	INTEGER is do Result := Sql_guid end -- (ODBCVER >= 0x0350)   --  ODBCVER >= 0x0350 

	Sql_type_null	:	INTEGER is	0

end
