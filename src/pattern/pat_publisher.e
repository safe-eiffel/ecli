indexing
	description: "Publisher part of the publish/subscribe pattern"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	PAT_PUBLISHER [G->PAT_SUBSCRIBER]


feature -- Initialization

feature -- Access

feature -- Measurement

feature -- Status report

	has_subscribed (subscriber : G) : BOOLEAN is
			-- has this 'subscriber' subscribed to this service ?
		require
			valid_subscriber: subscriber /= Void
		do
			Result := subscribers.has (subscriber)
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

	subscribe (subscriber : G) is
			-- subscribe statement 's'
		require
			valid_statement: subscriber /= Void
			not_subscribeed:  not has_subscribed (subscriber)
		do
			subscribers.put_last (subscriber)
		ensure
			subscribed: has_subscribed (subscriber)
		end

feature -- Removal

	unsubscribe (subscriber : G) is
			-- de-subscribe statement 's'
		require
			valid_statement: subscriber /= Void
			subscribeed: has_subscribed (subscriber)
		do
			subscribers.delete (subscriber)
		ensure
			not_subscribed: not has_subscribed (subscriber)
		end

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	subscribers : DS_LIST[G] is
		do
			if impl_subscribers = Void then
				create {DS_LINKED_LIST[G]} impl_subscribers.make
			end
			Result := impl_subscribers
		ensure
			Result /= Void
		end

	impl_subscribers : DS_LIST [G]


invariant
	invariant_clause: -- Your invariant here

end -- class PAT_PUBLISHER
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
