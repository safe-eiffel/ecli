note
	description: "Summary description for {ECLI_API_SQLLEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_API_SQLLEN

inherit
	XS_C_ITEM [INTEGER_64]

create
	make
	
feature -- Access

	item: INTEGER_64
		do
			Result := c_get_sqllen (handle)
		end

	item_size: INTEGER_32
		do
			Result := c_sizeof_sqllen
		end

feature -- Constants

	maximum_value: INTEGER_64
		do
			inspect item_size
			when 4 then
				Result := {INTEGER_32}.max_value
			when 8 then
				Result := {INTEGER_64}.max_value
			else
				do_nothing
			end
		end

	minimum_value: INTEGER_64
		do
			inspect item_size
			when 4 then
				Result := {INTEGER_32}.min_value
			when 8 then
				Result := {INTEGER_64}.min_value
			else
				do_nothing
			end
		end

feature -- Element change

	put (value: like item)
		do
			c_put_sqllen (value, handle)
		end

feature -- Implementation

	c_sizeof_sqllen : INTEGER_32
		external
			"C inline use <sql.h>"
		alias
			"[
				return (EIF_INTEGER_32) sizeof (SQLLEN);
			]"
		end

	c_put_sqllen (an_item : like item; a_destination: POINTER)
		external
			"C inline use <sql.h>"
		alias
			"[
				*((SQLLEN*)$a_destination) = (SQLLEN) $an_item;
			]"
		end

	c_get_sqllen (a_source : POINTER) : like item
		external
			"C inline use <sql.h>"
		alias
			"[
				return (EIF_INTEGER_64) *((SQLLEN*)$a_source);
			]"
		end

end
