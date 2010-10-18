indexing
	description: "Name routines that help follow the Eiffel style rules."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	EIFFEL_NAME_ROUTINES

inherit
	KL_IMPORTED_CHARACTER_ROUTINES
	KL_IMPORTED_STRING_ROUTINES

feature -- Access

	reserved_words : ARRAY[STRING] is
		once
			Result := <<
				"agent","alias","all","and","as","assign", "attached", "attribute",
				"check","class","convert","create","Current",
				"debug","deferred","detachable","do",
				"else","elseif","end","ensure","expanded","export","external",
				"False","feature","from","frozen",
				"if","implies","inherit","indexing","inspect","invariant",
				"like","local","loop",
				"not","note",
				"obsolete","old","once","only","or",
				"Precursor","redefine","reference","rename","require","rescue","Result","retry",
				"select","separate",
				"then","True","TUPLE",
				"undefine","until",
				"variant","Void",
				"when",
				"xor"
			>>
			Result.compare_objects
		end

feature -- Status report

	is_reserved_word (a_word : STRING) : BOOLEAN is
			-- Case insensitive search of `a_word' into `reserved_words'.
		require
			a_word_not_void: a_word /= Void
		local
			i : INTEGER
		do
			from
				i := reserved_words.lower
			until
				i > reserved_words.upper or else Result
			loop
				Result := string_.same_case_insensitive (reserved_words.item (i), a_word)
				i := i + 1
			end
		end

feature -- Conversion

	canonical_class_name (string : STRING) : STRING is
			-- convert `string' to an eiffel canonical class name
		require
			string_not_void: string /= Void
		do
			create Result.make_from_string (string)
			Result.replace_substring_all (".", "_")
		end

	camel_to_class_name (string : STRING) : STRING is
			-- convert `string' from camel case to an eiffel class name
		require
			string_not_void: string /= Void
		do
			Result := camel_to_eiffel_words (string)
			Result.to_upper
		ensure
			result_not_void: Result /= Void
		end

	camel_to_feature_name (string : STRING) : STRING is
			-- convert `string' from camel case to an eiffel feature name
		require
			string_not_void: string /= Void
		do
			Result := camel_to_eiffel_words (string)
			Result.to_lower
			if is_reserved_word (Result) then
				Result.append_character ('_')
			end
		ensure
			result_not_void: Result /= Void
		end

	camel_to_constant_name (string : STRING) : STRING is
			-- convert `string' from camel case to an eiffel constant name
		require
			string_not_void: string /= Void
		do
			Result := camel_to_feature_name (string)
			Result.put (character_.as_upper (Result.item (1)), 1)
		ensure
			result_not_void: Result /= Void
		end

 	put_manifest_string_constant (stream : KI_CHARACTER_OUTPUT_STREAM; string : STRING) is
 		require
 			stream_not_void: stream /= Void
 			stream_open: stream.is_open_write
 			string_not_void: string /= Void
		local
			newlines, index : INTEGER
			c : CHARACTER
		do
			newlines := string.occurrences ('%N')
			from
				index := 1
				stream.put_character ('"')
			until
				index > string.count
			loop
				c := string.item (index)
				inspect c
				when '%N' then
					stream.put_string ("%%%N%%")
				else
					stream.put_character (c)
				end
				index := index + 1
			end
			stream.put_character ('"')
 		end

	manifest_string_constant (string : STRING) : STRING is
			-- Convert `string' to a manifest string constant.
		require
			string_not_void: string /= Void
		local
			newlines, index : INTEGER
			c : CHARACTER
		do
			newlines := string.occurrences ('%N')
			from
				index := 1
				create Result.make (string.count + newlines * 3 + 2)
				Result.append_character ('"')
			until
				index > string.count
			loop
				c := string.item (index)
				inspect c
				when '%N' then
					Result.append_string ("%%N%%%N%%")
				else
					Result.append_character (c)
				end
				index := index + 1
			end
			Result.append_character ('"')
		ensure
			result_not_void: Result /= Void
			manifest_string: Result.item (1) = '"' and Result.item (Result.count)= '"'
		end

	verbatim_string (string : STRING; left_adjusted : BOOLEAN; discriminant : STRING) : STRING is
			-- Convert `string' to a verbatim string, possibly `left_adjusted', with `discriminant' in the opener/closer.
		require
			string_not_void: string /= Void
			discriminant_not_void: discriminant /= Void
		local
			opener, closer : CHARACTER
		do
			create Result.make (string.count + 2 * discriminant.count + 8)
			if left_adjusted then
				opener := verbatim_left_adjusted_opener
				closer := verbatim_left_adjusted_closer
			else
				opener := verbatim_opener
				closer := verbatim_closer
			end
			Result.append_character ('"')
			Result.append_string (discriminant)
			Result.append_character (opener)
			if string.has ('%N') then
				if string.item(1) /= '%N' then
					Result.append_character ('%N')
				end
				Result.append_string (string)
				if string.item(string.count) /= '%N' then
					Result.append_character ('%N')
				end
			else
				Result.append_string (string)
			end
			Result.append_character (closer)
			Result.append_string (discriminant)
			Result.append_character ('"')
		ensure
			verbatim_string_not_void: Result /= Void
			verbatim_string_has_string: Result.has_substring (string)
		end

feature -- Constants

	verbatim_left_adjusted_opener : CHARACTER is '['
	verbatim_opener : CHARACTER is '{'
	verbatim_left_adjusted_closer : CHARACTER is ']'
	verbatim_closer : CHARACTER is '}'

feature {NONE} -- Implementation

	camel_to_eiffel_words (string : STRING)  : STRING is
			-- convert `string' from camel case to eiffel words separated by '_'
		require
			string_not_void: string /= Void
		local
			last_upper, upper : BOOLEAN
			index : INTEGER
			c, u : CHARACTER
		do
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
			result_not_void: Result /= Void
		end

end -- class EIFFEL_NAME_ROUTINES
