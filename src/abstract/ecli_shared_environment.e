indexing
	description: "Shared CLI environment"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_SHARED_ENVIRONMENT

feature -- Access

	shared_environment : ECLI_ENVIRONMENT is
		once
			!!Result.make
		end

end -- class ECLI_SHARED_ENVIRONMENT
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
