indexing

	description:
	
			"Login Strategies."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_LOGIN_STRATEGY

inherit
	
	ECLI_EXTERNAL_API
		export
			{NONE} all
		end
		
feature {ECLI_SESSION} -- Basic operations

	connect (session : ECLI_SESSION) is
			-- Connect `session' using current strategy.
		require
			session_not_void: session /= Void
		deferred
		end

end
