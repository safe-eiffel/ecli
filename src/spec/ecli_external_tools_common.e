indexing

	description:
	
			"Objects handle cpmmunication with external objects"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_EXTERNAL_TOOLS_COMMON

inherit

	MEMORY

feature -- Status report

--	was_collecting : BOOLEAN
	
--	is_protected : BOOLEAN

feature -- Basic operations

	string_to_pointer (s : STRING) : POINTER is
			-- pointer to "C" version of 's'
		require
			good_string: s /= Void
		deferred
		end

	pointer_to_string (p : POINTER) : STRING is
		require
			good_pointer: p /= default_pointer
		deferred
		end

	string_copy_from_pointer (s : STRING; p : POINTER) is
			-- copy 'C' string at `p' into `s'
		require
			s_not_void: s /= Void
			p_not_default: p /= default_pointer
		deferred
		end
		
--	protect is
--			-- protect memory against moving GC
--		do
--			was_collecting := collecting
--			collection_off
--			is_protected := True
--		end
		
--	unprotect is
--			-- unprotect memory
--		do
--			if was_collecting then
--				collection_on
--			end
--			is_protected := False
--		end

end
