indexing
	description: "C allocated 32 bits unsigned integer."
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	XS_C_UINT32

inherit
	XS_C_INT32
		undefine
			is_equal
		end

	XS_UINT32_ROUTINES
		export
			{NONE} all
		undefine
			is_equal
		end
		
	COMPARABLE
		redefine
			is_equal
		end
		
creation
	make
					
feature -- Access

		
feature -- Measurement
	
	
feature -- Element change

feature -- Comparison

	is_equal (other : like Current) : BOOLEAN is
		do
			if other = Current then
				Result := True
			else
				Result := (u_eq32(item, other.item) /= 0)
			end
		end

	infix "<" (other : like Current) : BOOLEAN is
		do
			Result := (u_lt32 (item, other.item) /= 0)
		end
		
feature -- Basic operations

	infix "+" (other : like Current) : like Current is
		do
			create Result.make
			put (u_add32 (item, other.item))
		end
		
	infix "-" (other : like Current) : like Current is
		do
			create Result.make
			put (u_subtract32(item, other.item))
		end
		
	infix "//" (other : like Current) : like Current is
		do
			create Result.make
			put (u_divide32 (item, other.item))
		end
	
	infix "\\" (other :like Current) : like Current is
		do
			create Result.make
			put (u_remainder32 (item, other.item))
		end
		
	infix "@<<" (n : INTEGER) : like Current is
		require
			n_within_limits: n >= 0 and n <= 32
		do
			create Result.make
			put (u_left_shift32 (item, n))
		end

	infix "@>>" (n : INTEGER) : like Current is
		require
			n_within_limits: n >= 0 and n <= 32
		do
			create Result.make
			put (u_right_shift32 (item, n))
		end
		
	infix "@and" (other : like Current) : like Current is
		do
			create Result.make
			put (u_and32 (item, other.item))
		end
		
	infix "@or" (other : like Current) : like Current is
		do
			create Result.make
			put (u_or32 (item, other.item))
		end
		
	infix "@xor" (other : like Current) : like Current is
		do
			create Result.make
			put (u_xor32 (item, other.item))
		end
			
	prefix "@not" : like Current is
		do
			create Result.make
			put (u_not32 (item))
		end
		
end -- class XS_C_UINT32
--
-- Copyright: 2003; Paul G. Crismer; <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
