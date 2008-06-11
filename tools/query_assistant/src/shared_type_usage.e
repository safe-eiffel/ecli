indexing
	description: "Objects that hold shared information about ECLI_DECIMAL usage."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_TYPE_USAGE

feature -- Access


	use_integer_64 : BOOLEAN is
		do
			Result := use_integer_64_cell.item
		end


	use_decimal : BOOLEAN is
		do
			Result := use_decimal_cell.item
		end

	force_decimal : BOOLEAN is
		do
			Result := force_decimal_cell.item
		end

feature {ACCESS_GEN} -- Element change

	set_use_decimal (value : BOOLEAN) is
			-- Set `use_decimal' to `value'.
		do
			use_decimal_cell.put (value)
		end

	set_use_integer_64 (value : BOOLEAN) is
			-- Set `use_integer_64' to `value'.
		do
			use_integer_64_cell.put (value)
		end

	set_force_decimal (value : BOOLEAN) is
			-- Set `use_integer_64' to `value'.
		do
			use_integer_64_cell.put (value)
		end

feature {NONE} -- Implementation

	use_decimal_cell : DS_CELL [BOOLEAN] is
		once
			create Result.make (False)
		end

	use_integer_64_cell : DS_CELL [BOOLEAN] is
		once
			create Result.make (False)
		end

	force_decimal_cell : DS_CELL[BOOLEAN] is
		once
			create Result.make (False)
		end

invariant

	use_decimal_cell_not_void: use_decimal_cell /= Void

end -- class SHARED_USE_DECIMAL
