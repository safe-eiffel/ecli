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

	ready_for_disposal : BOOLEAN
			-- is this object ready for disposal ?

feature {NONE} -- Implementation

	set_handle (h : POINTER) is
		do
			handle := h
		ensure
			handle = h
		end

	dispose is
		do
			prepare_for_disposal
			if is_valid then
				release_handle
			end
		end

	release_handle is
			-- release the CLI handle
		deferred
		ensure
			invalid:    not is_valid
			disposable: ready_for_disposal
		end

	prepare_for_disposal is
			-- actions that must be performed before releasing the handle
			-- to be redefined in descendants
		do
		end

invariant

	valid_not_disposable: ready_for_disposal xor is_valid

end -- class ECLI_HANDLE
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
