indexing
	description: "Transaction capability constants"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_TRANSACTION_CAPABILITY_CONSTANTS

inherit
	ECLI_EXTERNAL_API

feature -- Status Report

	tc_none: INTEGER is
		-- no transaction support
	once
		Result := ecli_c_tc_none
	end

	tc_dml: INTEGER is
		-- DML transaction support, DDL cause an error
	once
		Result := ecli_c_tc_dml
	end

	tc_ddl_commit: INTEGER is
		-- DML transaction support, DDL commits current transaction
	once
		Result := ecli_c_tc_ddl_commit
	end

	tc_ddl_ignore : INTEGER is
		-- DML transaction support, DDL statements are ignored
	once
		Result := ecli_c_tc_ddl_ignore
	end

	tc_all : INTEGER is
		-- DML and DDL statements are supported in transactions
	once
		Result := ecli_c_tc_all
	end

end -- class ECLI_TRANSACTION_CAPABILITY_CONSTANTS
