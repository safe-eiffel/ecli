indexing
	description: "Subscriber part of the publisher/subscriber pattern"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

deferred class
	PAT_SUBSCRIBER

feature -- Initialization

feature -- Access

	publisher : PAT_PUBLISHER [PAT_SUBSCRIBER] is
		deferred
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	published (a_publisher : like publisher) is
			-- called by publisher
			-- redefine in descendant classes
		do
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	has_publisher: publisher /= Void

end -- class PAT_SUBSCRIBER
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
