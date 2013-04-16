note

	description:
	
			"Login Strategies."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_LOGIN_STRATEGY

inherit
	
	ANY
	
	ECLI_EXTERNAL_API
		export
			{NONE} all
		end
		
feature {ECLI_SESSION} -- Basic operations

	connect (session : ECLI_SESSION)
			-- Connect `session' using current strategy.
		require
			session_not_void: session /= Void
		deferred
		end

end
