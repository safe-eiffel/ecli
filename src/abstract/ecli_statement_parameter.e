indexing

	description:
	
			"SQL statement parameters : value and direction."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_STATEMENT_PARAMETER

inherit

	DS_CELL[ECLI_VALUE]
		export
			{NONE} put,make
		end
	
feature -- Status report

	is_input : BOOLEAN is
			-- is this an input parameter? Transfer is from application to RDBMS.
		deferred
		end

	is_output : BOOLEAN is
			-- is this an output parameter? Transfer is from RDBMS to application.
		deferred
		end
		
	is_input_output : BOOLEAN is
			-- is this an input/output parameter? Transfer is from application to RDBMS and vice versa.
		deferred
		end
		
feature {ECLI_STATEMENT} -- Basic operations

	bind (statement : ECLI_STATEMENT; position : INTEGER) is
			-- Bind Current as `position'-th parameter in `statement'
		require
			statement_not_void: statement /= Void
			positive_position: position > 0
		deferred
		end
		
invariant
	exclusive_direction: is_input xor is_output xor is_input_output
	item_set: item /= Void
	
end
