indexing

	description:
	
			"Objects that describe nullability metadata."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

	usage: "mix-in"

class ECLI_NULLABLE_METADATA

inherit

	ECLI_EXTERNAL_API

	ECLI_NULLABILITY_CONSTANTS
	
feature -- Status Report

	is_nullable : BOOLEAN is
			-- is this not nullable data ?
		require
			known_nullability: is_known_nullability
		do
			Result := nullability = sql_nullable
		end

	is_not_nullable : BOOLEAN is
			-- is this nullable data ?
		require
			known_nullability: is_known_nullability
		do
			Result := nullability = sql_no_nulls
		end

	is_known_nullability : BOOLEAN is
			-- is it a 'known' nullability
		do
			Result := not (nullability = sql_nullable_unknown)
		end

feature {NONE}  -- Implementation

	nullability : INTEGER

end
