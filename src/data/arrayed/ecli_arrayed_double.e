indexing
	description: "CLI SQL DOUBLE arrayed value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ARRAYED_DOUBLE

inherit
	ECLI_ARRAYED_VALUE
		redefine
			item, out
			
		end

	ECLI_DOUBLE
		rename
			make as make_double
		undefine
			release_handle, length_indicator_pointer, to_external, 
			is_null, set_null, out, item, transfer_octet_length, set_item, to_string
		end
		
creation
	make

feature {NONE} -- Initialization

	make (a_capacity : INTEGER) is
		do
			buffer := ecli_c_alloc_array_value (8, a_capacity)
			capacity := a_capacity
			count := capacity
			set_all_null
		end
		
feature -- Access

	item : DOUBLE_REF is
		do
			Result := item_at (cursor_index)
		end

	item_at (index : INTEGER) : like item is
		do
			if is_null_at (index) then
				Result := Void
			else
				ecli_c_array_value_copy_value_at (buffer, $actual_value, index)
				!! Result
				Result.set_item (actual_value)
			end			
		end
		
feature -- Measurement

feature -- Status report

feature -- Status setting

	transfer_octet_length: INTEGER is
		do
			Result := ecli_c_array_value_get_length (buffer)
		end

feature -- Cursor movement

feature -- Element change

	set_item_at (value : like item; index : INTEGER) is
			-- set item to 'value', truncating if necessary
		do
			actual_value := value.item
			ecli_c_array_value_set_value_at (buffer, $actual_value, transfer_octet_length, index)
			ecli_c_array_value_set_length_indicator_at (buffer, transfer_octet_length, index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	out : STRING is
		local
			message_buffer : C_STRING
			i : INTEGER
		do
			from 
				i := 1
				!!Result.make (10)
				Result.append ("<<")
				create message_buffer.make (50)
			until i = count 
			loop
				if is_null_at (i) then
					Result.append ("NULL")
				else
					sprintf_double (message_buffer.handle, item_at (i).item)
					Result.append (pointer_to_string(message_buffer.handle))
				end
				if i < count then
					Result.append (",")					
				end
				i := i + 1
			end
			Result.append (">>")
		end

feature {NONE} -- Implementation
		
invariant
	invariant_clause: -- Your invariant here

end -- class ECLI_ARRAYED_DOUBLE
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
