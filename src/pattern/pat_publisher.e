note

	description:

			"Publisher part of the publish/subscribe pattern."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class PAT_PUBLISHER [G -> PAT_SUBSCRIBER[PAT_PUBLISHER[G]]]

inherit
	ANY
		redefine
			default_create
		end

feature {} -- Initialization

	default_create
		do
			create {DS_LINKED_LIST[G]}subscribers.make
		end

feature -- Status report

	has_subscribed (subscriber : G) : BOOLEAN
			-- has this 'subscriber' subscribed to this service ?
		require
			valid_subscriber: subscriber /= Void --FIXME: VS-DEL
		do
			Result := subscribers.has (subscriber)
		end

	count : INTEGER
		-- count of subscribers

feature -- Element change

	subscribe (subscriber : G)
			-- subscribe statement 's'
		require
			valid_subscriber: subscriber /= Void --FIXME: VS-DEL
			not_already_subscribed:  not has_subscribed (subscriber)
		do
			subscribers.put_last (subscriber)
			count := count + 1
		ensure
			subscribed: has_subscribed (subscriber)
			one_more: count = old count + 1
		end

feature -- Removal

	unsubscribe (subscriber : G)
			-- de-subscribe statement 's'
		require
			valid_subscriber: subscriber /= Void --FIXME: VS-DEL
			subscribed: has_subscribed (subscriber)
		do
			subscribers.delete (subscriber)
			count := count - 1
		ensure
			not_subscribed: not has_subscribed (subscriber)
			one_less: count = old count - 1
		end

feature {NONE} -- Implementation

	subscribers : DS_LIST[G]

end
