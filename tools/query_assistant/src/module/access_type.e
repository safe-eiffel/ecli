indexing
	description: "Access type enumeration"
	author: "Paul G. Crismer & others."
	date: "$Date$"
	revision: "$Revision$"

class
	ACCESS_TYPE

creation
	make_from_string 

feature -- Initialization

	make_from_string (name : STRING) is
		require
			name_not_void: name /= Void
		do
			if name.is_equal ("read") then
				type := c_read
			elseif name.is_equal ("write") then
				type := c_write
			elseif name.is_equal ("update") then
				type := c_update
			elseif name.is_equal ("delete") then
				type := c_delete
			elseif name.is_equal ("exists") then
				type := c_exists
			else 
				type := c_extended
			end
		ensure
			invalid_type_is_extended: not valid_type (name) implies is_extended
		end
		
feature -- Access

	type : INTEGER
	
feature -- Measurement

feature -- Status report

	is_read : BOOLEAN is do Result := (type = c_read) end
	is_write : BOOLEAN is do Result := (type = c_write) end
	is_update : BOOLEAN is do Result := (type = c_update) end
	is_delete : BOOLEAN is do Result := (type = c_delete) end
	is_exists : BOOLEAN is do Result := (type = c_exists) end
	is_extended : BOOLEAN is do Result := (type = c_extended) end
	
	valid_type (name : STRING) : BOOLEAN is
		require
			name_not_void: name /= Void
		do
			if name.is_equal ("read") then
				Result := True
			elseif name.is_equal ("write") then
				Result := True
			elseif name.is_equal ("update") then
				Result := True
			elseif name.is_equal ("delete") then
				Result := True
			elseif name.is_equal ("exists") then
				Result := True
			elseif name.is_equal ("extended") then
				Result := True
			else 
				Result := False
			end
		end
		
feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- constants

	c_read, c_write, c_exists, c_update, c_delete, c_extended : INTEGER is unique

feature {NONE} -- Implementation

invariant
	type_valid: type >= c_read and type <= c_extended 

end -- class ACCESS_TYPE
