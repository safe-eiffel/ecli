indexing
	description: "Objects that describe nullability metadata"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	usage: "mix-in"
	
class
	ECLI_NULLABLE_METADATA

	-- Replace ANY below by the name of parent class if any (adding more parents
	-- if necessary); otherwise you can remove inheritance clause altogether.
inherit
	ECLI_EXTERNAL_API

	ECLI_NULLABILITY_CONSTANTS
	
feature -- Status Report

	is_nullable : BOOLEAN is
		require
			known_nullability: is_known_nullability
		do
			Result := nullability = sql_nullable
		end

	is_not_nullable : BOOLEAN is
		require
			known_nullability: is_known_nullability
		do
			Result := nullability = sql_no_nulls
		end

	is_known_nullability : BOOLEAN is
		do
			Result := not (nullability = sql_nullable_unknown)
		end

feature {NONE}  -- Implementation

	nullability : INTEGER

invariant
	invariant_clause: True -- Your invariant here

end -- class ECLI_NULLABLE_METADATA
