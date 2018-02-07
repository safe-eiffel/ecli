note

	description:

		"As ECLI_LONGVARCHAR but assumes data is in UTF8 so returns it in the correct format"

	library: "EJAX library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2010, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	ECLI_UTF8_STRING


inherit

	ECLI_LONGVARCHAR
		redefine
			default_maximum_capacity,
			set_item,
			formatted,
			item
		end

	UC_IMPORTED_UTF8_ROUTINES
		undefine
			is_equal,
			copy,
			out
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		undefine
			copy,
			is_equal,
			out
		end


create

	make, make_force_maximum_capacity


feature -- Element change

	set_item (value : STRING)
		do
			-- Unsolved: if `maximum_capacity' means string will be
			-- truncated, we should do so at the proper UTF-8
			-- boundary. How would that work?
			precursor (truncate_to_capacity (value))
		end


feature -- Access

	default_maximum_capacity : INTEGER
		do
			Result := 1_048_576
		end

	item: STRING
		do
			if is_null then
				create Result.make_empty
			else
				ext_item.copy_to (impl_item)
				-- How to handle invalid UTF8? Now we crash...
				-- We simply assume the database always returns valid
				-- utf8, which is not guaranteed, i.e. cast(blob as char)
				-- will return latin1 by default in mysql even when utf8 set
				debug
					if not utf8.valid_utf8 (impl_item) then
						print ("NOT UTF8: ")
						print (impl_item)
						print ("%N")
					end
				end
				create {UC_STRING} Result.make_from_utf8 (impl_item)
			end
		end


feature -- Conversion

	formatted (v: STRING): STRING
			-- 'v' formatted according to 'column_precision'
			-- does nothing, except for fixed format types like CHAR
			-- where values are either truncated or padded by blanks
			-- `v' must be UC_STRING/UC_UTF8_STRING or valid UTF8 encoded
		do
			create {UC_STRING} Result.make_from_utf8 (truncate_to_capacity (v))
		end


feature {NONE} -- Implementation

	truncate_to_capacity (s: STRING): STRING
		require
			s_not_void: s /= Void
		local
			c: INTEGER
		do
			-- We only support UTF8 here I think
			Result := STRING_.as_string (s)
			if Result.count > capacity then
				from
					c := capacity
					Result.keep_head (c)
				until
					utf8.valid_utf8 (s)
				loop
					c := c - 1
					Result.keep_head (c)
				variant
					Result.count + 1
				end
			end
		ensure
			not_void: Result /= Void
		end

end
