indexing
	description: "Object that abstract a transaction isolation type"
	
	library: "ECLI"
	
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_TRANSACTION_ISOLATION

inherit
	
	ANY
		redefine
			is_equal
		end
			
	
	ECLI_TRANSACTION_ISOLATION_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal
		end
		
creation
	make, set_read_committed, set_read_uncommitted, set_repeatable_read, set_serializable
	
feature {NONE} -- Initialization

	make (a_value : INTEGER) is
			--
		require
			a_value_valid: is_valid_transaction_isolation_option (a_value)
		do
			value := a_value
		end
			
feature -- Access

	value : INTEGER

feature -- Status report

	is_read_uncommitted : BOOLEAN is
			-- 
		do
			Result := (value = Sql_transaction_read_uncommitted )
		end

	is_read_committed : BOOLEAN is
			-- 
		do
			Result := (value = Sql_transaction_read_committed )
		end

	is_repeatable_read : BOOLEAN is
			-- 
		do
			Result := (value = Sql_transaction_repeatable_read )
		end

	is_serializable : BOOLEAN is
			-- 
		do
			Result := (value = Sql_transaction_serializable )
		end
		
feature -- Status setting

	set_read_uncommitted is
		do
			value := Sql_transaction_read_uncommitted
		ensure
			definition: is_read_uncommitted
		end

	set_read_committed is
		do
			value := Sql_transaction_read_committed 
		ensure
			definition: is_read_committed
		end

	set_repeatable_read is
		do
			value := Sql_transaction_repeatable_read 
		ensure
			definition: is_repeatable_read
		end

	set_serializable is
		do
			value := Sql_transaction_serializable 
		ensure
			definition: is_serializable
		end

feature -- Comparison

	is_equal (other : like Current) : BOOLEAN is
			-- 
		do
			Result := (value = other.value)
		end
		
invariant
	exclusive: is_read_uncommitted xor is_read_committed xor is_repeatable_read xor is_serializable

end -- class ECLI_TRANSACTION_ISOLATION
