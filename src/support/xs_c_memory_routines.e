indexing
	description: "Routines that give access to C memory."
	author: "Paul G. Crismer"
	
	library: "XS_C : eXternal Support C"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	XS_C_MEMORY_ROUTINES

feature {NONE} -- Implementation

	c_memory_put_int8 (pointer : POINTER; v : INTEGER)  is
		external "C"
		alias "c_memory_put_int8"
		end

	c_memory_put_int16 (pointer : POINTER; v : INTEGER) is
		external "C"
		alias "c_memory_put_int16"
		end

	c_memory_put_int32 (pointer : POINTER; v : INTEGER) is
		external "C"
		alias "c_memory_put_int32"
		end

	c_memory_put_real (pointer : POINTER; v : REAL)  is
		external "C"
		alias "c_memory_put_real"
		end

	c_memory_put_double (pointer : POINTER; v : DOUBLE) is
		external "C"
		alias "c_memory_put_double"
		end

	c_memory_put_pointer (pointer : POINTER; v : POINTER) is
		external "C"
		alias "c_memory_put_pointer"
		end

	c_memory_get_int8 (pointer : POINTER) : INTEGER is
		external "C"
		alias "c_memory_get_int8"
		end

	c_memory_get_int16 (pointer : POINTER) : INTEGER is
		external "C"
		alias "c_memory_get_int16"
		end

	c_memory_get_int32 (pointer : POINTER) : INTEGER is
		external "C"
		alias "c_memory_get_int32"
		end

	c_memory_get_real (pointer : POINTER) : REAL is
		external "C"
		alias "c_memory_get_real"
		end

	c_memory_get_double (pointer : POINTER) : DOUBLE is
		external "C"
		alias "c_memory_get_double"
		end

	c_memory_get_pointer (pointer : POINTER) : POINTER is
		external "C"
		alias "c_memory_get_pointer"
		end

end -- class XS_C_MEMORY_ROUTINES
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
