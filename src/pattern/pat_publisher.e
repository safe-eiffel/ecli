indexing
	description: "Publisher part of the publish/subscribe pattern"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	PAT_PUBLISHER [G->PAT_SUBSCRIBER]

feature -- Status report

	has_subscribed (subscriber : G) : BOOLEAN is
			-- has this 'subscriber' subscribed to this service ?
		require
			valid_subscriber: subscriber /= Void
		do
			Result := subscribers.has (subscriber)
		end

	count : INTEGER
		-- count of subscribers
		
feature -- Element change

	subscribe (subscriber : G) is
			-- subscribe statement 's'
		require
			valid_statement: subscriber /= Void
			not_subscribeed:  not has_subscribed (subscriber)
		do
			subscribers.put_last (subscriber)
			count := count + 1
		ensure
			subscribed: has_subscribed (subscriber)
			one_more: count = old count + 1
		end

feature -- Removal

	unsubscribe (subscriber : G) is
			-- de-subscribe statement 's'
		require
			valid_statement: subscriber /= Void
			subscribed: has_subscribed (subscriber)
		do
			subscribers.delete (subscriber)
			count := count - 1
		ensure
			not_subscribed: not has_subscribed (subscriber)
			one_less: count = old count - 1
		end

feature {NONE} -- Implementation

	subscribers : DS_LIST[G] is
		do
			if impl_subscribers = Void then
				!DS_LINKED_LIST[G]! impl_subscribers.make
			end
			Result := impl_subscribers
		ensure
			Result /= Void
		end

	impl_subscribers : DS_LIST [G]

end -- class PAT_PUBLISHER
--
-- Copyright: 2000-2001, Paul G. Crismer, <pgcrism@pi.be>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
