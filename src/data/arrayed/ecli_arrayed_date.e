note

	description:

			"SQL DATE arrayed buffers."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_ARRAYED_DATE

inherit

	ECLI_GENERIC_ARRAYED_VALUE [DT_DATE]
		undefine
			set_item, out_item_at
		redefine
		select
			is_equal, copy
		end

	ECLI_DATE
		rename
			make as make_single, make_default as make_default_single, set as set_date,
			is_equal as is_equal_item, copy as copy_item
		export
			{NONE} make_single, make_default_single
		undefine
			release_handle, length_indicator_pointer, to_external, is_null, set_null, out, set_item,
			as_string, year, month, day
		redefine
			item, trace, allocate_buffer
		end

	ECLI_ARRAYED_DATE_ROUTINES
		undefine
			is_equal, copy, out
		end

create

	make

feature {NONE} -- Initialization

	make (a_capacity : INTEGER)
			-- make array of null dates
		do
			capacity := a_capacity
			count := capacity
			allocate_buffer
			set_all_null
			create_impl_item
		end

feature -- Access

	item_at (index : INTEGER) : DT_DATE
		local
			save_index : INTEGER
		do
			save_index := cursor_index
			cursor_index := index
			Result := item
			cursor_index := save_index
		end

	item : DT_DATE
		do
			impl_item.set_year_month_day (year, month, day)
			Result := impl_item
		end


feature -- Element change

	set_item (other : DT_DATE)
		do
			set_item_at (other, cursor_index)
		end

	set_item_at (other : DT_DATE; index : INTEGER)
		do
			set_date_at (other.year, other.month, other.day, index)
		end

feature -- Basic operations

	trace (a_tracer : ECLI_TRACER)
		do
			a_tracer.put_date (Current)
		end

feature {NONE} -- Implementation

	allocate_buffer
		do
			if buffer = default_pointer then
				buffer := ecli_c_alloc_array_value (transfer_octet_length, capacity)
			end
		end

invariant

	valid_month:	(not is_null) implies (month >= 1 and month <= 12)
	valid_day:  	(not is_null) implies (day >= 1 and day <= days_in_month (month, year))

end
