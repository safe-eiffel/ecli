indexing
	description: 

		"Objects that use an implementation (external) handle. This can be used %
	   % in any case where an allocate/free scheme is needed.%
	   % Safety  note: %NIn case of using this handle for storing externally allocated memory,%
	   % descendant classes should also inherit from memory and redefine dispose so that they call 'release_handle',%
	   % in order to free externally allocated memory."

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

deferred class
	ECLI_HANDLE

inherit

	MEMORY
		export
			{NONE} all
		redefine
			dispose
		end


feature -- Status report

	is_valid : BOOLEAN is
			-- Is the associated CLI handle valid ?
		do
			Result := handle /= default_pointer
		end

	handle : POINTER

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
				release_handle
			end
		end

	release_handle is
			-- release the CLI handle
		deferred
		ensure
			not is_valid
		end

end -- class ECLI_HANDLE
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
