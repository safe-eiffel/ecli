indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_TRANSACTION_ISOLATION

inherit
	
	ANY
	
	ECLI_TRANSACTION_ISOLATION_CONSTANTS
		export
			{NONE} all
		end
		
creation
	make
	
feature {NONE} -- Initialization

	make (a_value : INTEGER) is
			--
		require
			a_value_valid: is_valid_transaction_isolation_option (a_value)
		do
			value := a_value
		end
		
feature -- Access

feature -- Measurement

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

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	value : INTEGER
	
invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_TRANSACTION_ISOLATION
