indexing

	description:
	
			"Fixed length buffer, for external usage"

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class MESSAGE_BUFFER

inherit

	STRING
		redefine
			fill_blank
		end
creation

	make

feature

	clear_content is
			-- clear buffer content
		do
			count := 0
		ensure
			count = 0
		end

	fill_blank is
		local
			i : INTEGER
		do
			clear_content
			from 
				i := 1 
			until 
				i > capacity
			loop
				append_string (" ")	
				i := i + 1
			end
		end
		
end

