indexing

	description:
	
			"Supporting string routines."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

	usage: "mix-in, module-object"

class ECLI_STRING_ROUTINES

feature

	trimmed (s : STRING) : STRING is
			-- string made of 's' trimmed with beginning and trailing blanks
		require
			s /= Void and then not s.is_empty
		local
			begin_index, end_index : INTEGER
		do
			from end_index := s.count
			variant end_index
			until end_index < 1 or else s.item (end_index) /= ' '
			loop
				end_index := end_index - 1
			end			
			from begin_index := 1
			until begin_index > s.count or else s.item (begin_index) /= ' '
			loop
				begin_index := begin_index + 1
			end
			if 		begin_index <= s.count 
				and end_index >= 1
				and begin_index <= end_index 
			then
				Result := s.substring (begin_index, end_index)
			else
				Result := ""
			end
		ensure
			trimmed: not Result.is_empty implies (Result @ 1 /= ' ' and Result @ Result.count /= ' ')
		end
	
	pad (s : STRING; a_capacity : INTEGER) is
			-- pad 's' with blanks, until s.count = a_capacity
		require
			count_not_capacity: s.count <= a_capacity
		do
			from
			until
				s.count = a_capacity
			loop
				s.append_character (' ')
			end
		ensure
			s.count = a_capacity
		end
	
	padded (s : STRING; a_capacity : INTEGER) : STRING is
			-- copy of `s' padded with blanks
		do
			Result := clone (s)
			pad (Result, a_capacity)
		end
		
end
