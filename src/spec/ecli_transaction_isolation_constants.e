indexing
	description: "Transaction isolation constants - Used as bitmask in Sql_txn_isolation_option"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

	usage: "buy or inherit.  When inheriting,  export {NONE} all."
	
class
	ECLI_TRANSACTION_ISOLATION_CONSTANTS

feature -- Constants

	--  Sql_txn_isolation_option bitmasks 
	Sql_txn_read_uncommitted, 
	Sql_transaction_read_uncommitted :	INTEGER is	1

	Sql_txn_read_committed, 
	Sql_transaction_read_committed:		INTEGER is	2

	Sql_txn_repeatable_read,	
	Sql_transaction_repeatable_read :	INTEGER is	4

	Sql_txn_serializable, 
	Sql_transaction_serializable:		INTEGER is	8

end -- class ECLI_TRANSACTION_ISOLATION_CONSTANTS
