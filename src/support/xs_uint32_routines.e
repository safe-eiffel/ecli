indexing
	description: "C allocated 32 bits integer (short)."
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	XS_UINT32_ROUTINES
	
feature  -- Basic operations

	u_add32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_add32"
		end

	u_subtract32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_subtract32"
		end

	u_divide32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_divide32"
		end

	u_remainder32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_remainder32"
		end

	u_left_shift32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_left_shift32"
		end

	u_right_shift32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_right_shift32"
		end

	u_and32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_and32"
		end

	u_or32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_or32"
		end

	u_xor32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_xor32"
		end

	u_not32  (e1 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_not32"
		end

	u_lt32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_lt32"
		end

	u_eq32 (e1 : INTEGER; e2 : INTEGER)  : INTEGER is
		external "C"
		alias "c_u_eq32"
		end

end -- class XS_UINT32_ROUTINES
--
-- Copyright: 2003; Paul G. Crismer; <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
