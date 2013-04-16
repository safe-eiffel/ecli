note
	description: "Maps of access module parameters, by name."
	author: "Paul G. Crismer"
	
	application: "Query Assistant"
	library: "ECLI"
	date: "$Date$"
	revision: "$Revision$"

class
	PARAMETER_MAP

inherit
	DS_HASH_TABLE [RDBMS_ACCESS_PARAMETER, STRING]
	
create
	make 
	
end -- class PARAMETER_MAP
