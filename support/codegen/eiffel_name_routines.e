indexing
	description: "Name routines that help follow the Eiffel style rules"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	EIFFEL_NAME_ROUTINES
	
inherit
	KL_IMPORTED_CHARACTER_ROUTINES
	KL_IMPORTED_STRING_ROUTINES

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

	camel_to_class_name (string : STRING) : STRING is
			-- convert `string' from camel case to an eiffel class name
		require
			string_exists: string /= Void
		do
			Result := camel_to_eiffel_words (string)
			Result.to_upper
		ensure
			result_exists: Result /= Void
		end
		
	camel_to_feature_name (string : STRING) : STRING is
			-- convert `string' from camel case to an eiffel feature name
		require
			string_exists: string /= Void
		do
			Result := camel_to_eiffel_words (string)
			Result.to_lower
		ensure
			result_exists: Result /= Void
		end
		
	camel_to_constant_name (string : STRING) : STRING is
			-- convert `string' from camel case to an eiffel constant name
		require
			string_exists: string /= Void
		do
			Result := camel_to_feature_name (string)
			Result.put (character_.as_upper (Result.item (1)), 1)
		ensure
			result_exists: Result /= Void
		end
 
		
feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	camel_to_eiffel_words (string : STRING)  : STRING is
			-- convert `string' from camel case to eiffel words separated by '_'
		require
			string_exists: string /= Void
		local
			last_upper, upper, changed : BOOLEAN
			index : INTEGER
			c, u : CHARACTER
		do
			if string.is_equal ("LastSituationWR") then
				do_nothing
			end
			create Result.make (string.count + 10)
			from
				index := 1
			until
				index > string.count
			loop
				c := string.item (index)
				upper := c.is_upper
				if Result.count = 0 then
					last_upper := upper
				end
				inspect c
				when 'A'..'Z' then
					if last_upper /= upper then
						if index < string.count and then string.item (index + 1).is_upper then
							Result.append_character ('_')
						end
						Result.append_character (c)
					else
						Result.append_character (c)
					end
				when 'a'..'z' then
					if last_upper /= upper then
						if Result.count >= 1 then
							if Result.count > 1 and Result.item (Result.count - 1) /= '_' then
								u := Result.item (Result.count)
								Result.put ('_', Result.count)
								Result.append_character (u)
							end
							Result.append_character (c)
						end
					else
						Result.append_character (c)
					end	
					last_upper := False
				else
					Result.append_character (c)
				end
				last_upper := upper
				index := index + 1
			end
		ensure
			result_exists: Result /= Void
		end

end -- class EIFFEL_NAME_ROUTINES
