indexing
	description: "CLI DB type codes.  Use this class as a mix-in."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_TYPE_CODES

inherit
	ECLI_EXTERNAL_API

feature {NONE} -- SQL data type indicators

	sql_char : INTEGER is
		-- CHAR
	once
		Result := ecli_c_sql_char
	end


	sql_numeric : INTEGER is
		-- NUMERIC
	once
		Result := ecli_c_sql_numeric
	end


	sql_decimal : INTEGER is
		-- DECIMAL
	once
		Result := ecli_c_sql_decimal
	end


	sql_integer : INTEGER is
		-- INTEGER
	once
		Result := ecli_c_sql_integer
	end


	sql_smallint : INTEGER is
		-- SMALLINT
	once
		Result := ecli_c_sql_smallint
	end


	sql_float : INTEGER is
		-- FLOAT
	once
		Result := ecli_c_sql_float
	end


	sql_real : INTEGER is
		-- REAL
	once
		Result := ecli_c_sql_real
	end


	sql_double : INTEGER is
		-- DOUBLE
	once
		Result := ecli_c_sql_double
	end

	sql_varchar : INTEGER is
		-- VARCHAR
	once
		Result := ecli_c_sql_varchar
	end

	sql_type_date : INTEGER is
		-- DATE
	once
		Result := ecli_c_sql_type_date
	end


	sql_type_time : INTEGER is
		-- TIME
	once
		Result := ecli_c_sql_type_time
	end

	sql_type_timestamp : INTEGER is
		-- TIMESTAMP
	once
		Result := ecli_c_sql_type_timestamp
	end


	sql_longvarchar : INTEGER is
		-- LONGVARCHAR
	once
		Result := ecli_c_sql_longvarchar
	end

feature {NONE} -- C data type indicators

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

end -- class ECLI_TYPE_CODES
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
