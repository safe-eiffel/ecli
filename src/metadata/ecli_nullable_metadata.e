indexing
	description: "Objects that describe nullability metadata"
	author: "Paul G. Crismer"
	
	usage: "mix-in"
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
	
class
	ECLI_NULLABLE_METADATA

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

end -- class ECLI_NULLABLE_METADATA
--
-- Copyright: 2000-2003, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
