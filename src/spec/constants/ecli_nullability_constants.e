indexing

	description:
	
			"Nullable metadata constants."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_NULLABILITY_CONSTANTS

feature -- Status Report

	--  values of NULLABLE field in descriptor 
	Sql_no_nulls	:	INTEGER is	0
	Sql_nullable	:	INTEGER is	1

	-- Value returned by SQLGetTypeInfo() to denote that it is
	-- not known whether or not a data type supports null values.
	--
	Sql_nullable_unknown	:	INTEGER is	2

end
