indexing
	description: "Objects handle cpmmunication with external objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ECLI_EXTERNAL_TOOLS_COMMON

inherit
	MEMORY

feature -- Status report

	was_collecting : BOOLEAN
	
	is_protected : BOOLEAN

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
		
	protect is
			-- protect memory against moving GC
		do
			was_collecting := collecting
			collection_off
			is_protected := True
		end
		
	unprotect is
			-- unprotect memory
		do
			if was_collecting then
				collection_on
			end
			is_protected := False
		end

end -- class ECLI_EXTERNAL_TOOLS_COMMON
