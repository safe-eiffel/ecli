indexing
	description:

		"Objects that use an implementation (external) handle. This can be used %
	   % in any case where an allocate/free scheme is needed.%
	   % Safety  note: %NIn case of using this handle for storing externally allocated memory,%
	   % descendant classes should redefine 'release_handle',%
	   % in order to free externally allocated memory. `prepare_for_disposal' is executed before `release_handle'%
	   % and should also be redefined by descendant classes."

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

deferred class
	ECLI_HANDLE

inherit

	MEMORY
		redefine
			dispose
		end
		
	EXCEPTIONS
		export
			{NONE} all
		end

feature {ANY} -- Status report

	is_valid : BOOLEAN is
			-- Is the associated CLI handle valid ?
		do
			Result := handle /= default_pointer
		end

feature {ECLI_HANDLE} -- Status report

	handle : POINTER

	is_ready_for_disposal : BOOLEAN is
			-- is this object ready for disposal ?
		deferred
		end

	disposal_failure_reason : STRING is
			-- why is this object not ready_for_disposal
		deferred
		end

feature {NONE} -- Implementation

	set_handle (h : POINTER) is
		do
			handle := h
		ensure
			handle = h
		end

	dispose is
		do
			if is_valid then
				if not is_ready_for_disposal then
					debug ("ecli_check_closes")
						raise (disposal_failure_reason)					
					end
				end
				release_handle
			end
		end

	release_handle is
			-- release the CLI handle
		require
			ready_for_disposal: is_ready_for_disposal
		deferred
		ensure
			invalid:    not is_valid
		end
	
end -- class ECLI_HANDLE
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
