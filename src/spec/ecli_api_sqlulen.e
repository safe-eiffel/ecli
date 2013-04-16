note
	description: "Summary description for {ECLI_API_SQLULEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_API_SQLULEN

inherit
	XS_C_ITEM [NATURAL_64]

create
	make

feature -- Access

	item: NATURAL_64
		do
			Result := c_get_sqlulen (handle)
		end

	item_size: INTEGER_32
		do
			Result := c_sizeof_sqlulen
		end

feature -- Constants

	maximum_value: NATURAL_64
		do
			inspect item_size
			when 4 then
				Result := {NATURAL_32}.max_value
			when 8 then
				Result := {NATURAL_64}.max_value
			else
				do_nothing
			end
		end

	minimum_value: NATURAL_64
		do
			inspect item_size
			when 4 then
				Result := {NATURAL_32}.min_value
			when 8 then
				Result := {NATURAL_64}.min_value
			else
				do_nothing
			end
		end

feature -- Element change

	put (value: like item)
		do
			c_put_sqlulen (value, handle)
		end

feature -- Implementation

	c_sizeof_sqlulen : INTEGER_32
		external
			"C inline use <sql.h>"
		alias
			"[
				return (EIF_INTEGER_32) sizeof (SQLULEN);
			]"
		end

	c_put_sqlulen (an_item : like item; a_destination: POINTER)
		external
			"C inline use <sql.h>"
		alias
			"[
				*((SQLULEN*)$a_destination) = (SQLULEN) $an_item;
			]"
		end

	c_get_sqlulen (a_source : POINTER) : like item
		external
			"C inline use <sql.h>"
		alias
			"[
				return (EIF_NATURAL_64) *((SQLULEN*)$a_source);
			]"
		end

end
