indexing
	description: "CLI SQL REAL arrayed value"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	ECLI_ARRAYED_REAL

inherit
	ECLI_ARRAYED_VALUE
		undefine
		redefine
			item,
			out_item_at
		end

	ECLI_REAL
		rename
			make as make_single
		undefine
			release_handle, length_indicator_pointer, to_external, 
			is_null, set_null, out, item, transfer_octet_length, set_item, to_string
		end
		
creation
	make

feature {NONE} -- Initialization

	make (a_capacity : INTEGER) is
		do
			buffer := ecli_c_alloc_array_value (4, a_capacity)
			capacity := a_capacity
			count := capacity
			set_all_null
		end
		
feature -- Access

	item_at (index : INTEGER) : like item is
			-- 
		do
			if is_null_at (index) then
				Result := Void
			else
				ecli_c_array_value_copy_value_at (buffer, $actual_value, index)
				!! Result
				Result.set_item (actual_value)
			end		
		end
	
	item : REAL_REF is
			-- 
		do
			Result := item_at (cursor_index)
		end
		
feature -- Measurement

feature -- Status report

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
			ecli_c_array_value_set_value_at (buffer, $actual_value, transfer_octet_length,index)
			ecli_c_array_value_set_length_indicator_at (buffer, transfer_octet_length,index)
		end

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

--	trace (a_tracer : ECLI_TRACER) is
--		do
--			a_tracer.put_real (Current)
--		end
--		
--	out : STRING is
--		local
--			ext : expanded ECLI_EXTERNAL_TOOLS
--			message_buffer : MESSAGE_BUFFER
--			i : INTEGER
--		do
--			from i := 1 
--			until i > count
--			loop
--				if is_null_at (i) then
--					Result := "NULL"
--				else
--					!!message_buffer.make (50)
--					message_buffer.fill_blank
--					sprintf_real (ext.string_to_pointer(message_buffer), item_at (i).item)
--					Result := ext.pointer_to_string(ext.string_to_pointer (message_buffer))
--				end
--				i := i + 1
--			end
--		end

	out_item_at (index : INTEGER) : STRING is
			-- 
		local
			message_buffer : MESSAGE_BUFFER
			ext : ECLI_EXTERNAL_TOOLS
		do
			!!ext
			!!message_buffer.make (50)
			message_buffer.fill_blank
			sprintf_real (ext.string_to_pointer(message_buffer), item_at (index).item)
			Result := ext.pointer_to_string(ext.string_to_pointer (message_buffer))
		end
		
feature {NONE} -- Implementation

end -- class ECLI_ARRAYED_REAL
--
-- Copyright: 2000, Paul G. Crismer, <pgcrism@attglobal.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
