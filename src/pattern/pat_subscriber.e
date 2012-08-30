note

	description:
	
			"Subscriber part of the publisher/subscriber pattern."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class PAT_SUBSCRIBER

feature -- Initialization

feature -- Access

	publisher : PAT_PUBLISHER [PAT_SUBSCRIBER]
		deferred
		end

feature -- Status report

	unsubscribed : BOOLEAN
		do
			Result := (publisher = Void)
		ensure
			definition: Result = (publisher = Void)
		end

	has_publisher : BOOLEAN
		do
			Result := (publisher /= Void)
		ensure
			definition: Result = (publisher /= Void)
		end

feature -- Basic operations

	published (a_publisher : like publisher)
			-- called by publisher
			-- redefine in descendant classes
		do
		end

invariant

	subscription: unsubscribed or else has_publisher

end
