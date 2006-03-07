indexing

	description:
	
			"Transaction capability constants."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_TRANSACTION_CAPABILITY_CONSTANTS

feature -- Status Report

	Sql_tc_none	:	INTEGER is	0
		-- no transaction support

	Sql_tc_dml	:	INTEGER is	1
		-- DML transaction support, DDL cause an error

	Sql_tc_all	:	INTEGER is	2
		-- DML and DDL statements are supported in transactions

	Sql_tc_ddl_commit	:	INTEGER is	3
		-- DML transaction support, DDL commits current transaction

	Sql_tc_ddl_ignore	:	INTEGER is	4
		-- DML transaction support, DDL statements are ignored

end
