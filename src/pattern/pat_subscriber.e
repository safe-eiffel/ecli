note

	description:

			"Subscriber part of the publisher/subscriber pattern."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class PAT_SUBSCRIBER [G -> PAT_PUBLISHER [PAT_SUBSCRIBER[G]]]

feature -- Initialization

feature -- Access

	publisher : detachable PAT_PUBLISHER [PAT_SUBSCRIBER[G]]

feature -- Status report

	unsubscribed : BOOLEAN
		do
			Result := not attached publisher
		ensure
			definition: Result = (publisher = Void)
		end

	has_publisher : BOOLEAN
		do
			Result := attached publisher
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
