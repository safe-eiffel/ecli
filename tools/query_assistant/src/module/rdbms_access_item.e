note
	description: "Generatable items."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RDBMS_ACCESS_ITEM

feature -- Status report

	is_generatable : BOOLEAN
		deferred
		end

feature -- Status setting

	enable_generatable
		deferred
		ensure
			is_generatable: is_generatable
		end

	disable_generatable
		deferred
		ensure
			not_generatable: not is_generatable
		end

end
