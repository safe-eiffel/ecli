note
	description: "Access type enumeration."
	author: "Paul G. Crismer & others."
	date: "$Date$"
	revision: "$Revision$"

class
	ACCESS_TYPE

create
	make_from_string

feature -- Initialization

	make_from_string (name : STRING)
		require
			name_not_void: name /= Void
		do
			if name.same_string (t_read) then
				type := c_read
			elseif name.same_string (t_write) then
				type := c_write
			elseif name.same_string (t_update) then
				type := c_update
			elseif name.same_string (t_delete) then
				type := c_delete
			elseif name.same_string (t_exists) then
				type := c_exists
			else
				type := c_extended
			end
		ensure
			invalid_type_is_extended: not valid_type (name) implies is_extended
		end

feature -- Access

	type : INTEGER

feature -- Conversion

	to_string : STRING
		do
			Result := types.item (type)
		end


feature -- Status report

	is_read : BOOLEAN do Result := (type = c_read) end
	is_write : BOOLEAN do Result := (type = c_write) end
	is_update : BOOLEAN do Result := (type = c_update) end
	is_delete : BOOLEAN do Result := (type = c_delete) end
	is_exists : BOOLEAN do Result := (type = c_exists) end
	is_extended : BOOLEAN do Result := (type = c_extended) end

	valid_type (name : STRING) : BOOLEAN
		require
			name_not_void: name /= Void
		do
			if name.same_string (t_read) then
				Result := True
			elseif name.same_string (t_write) then
				Result := True
			elseif name.same_string (t_update) then
				Result := True
			elseif name.same_string (t_delete) then
				Result := True
			elseif name.same_string (t_exists) then
				Result := True
			elseif name.same_string (t_extended) then
				Result := True
			else
				Result := False
			end
		end

feature -- constants

	c_read : INTEGER = 1
	c_write : INTEGER = 2
	c_exists : INTEGER = 3
	c_update : INTEGER = 4
	c_delete : INTEGER = 5
	c_extended : INTEGER = 6

	t_read : STRING = "read"
	t_write : STRING = "write"
	t_exists : STRING = "update"
	t_update : STRING = "delete"
	t_delete : STRING = "exists"
	t_extended : STRING = "extended"


feature {NONE} -- Implementation

	types : ARRAY[STRING]
		once
			create Result.make (1,6)
			Result.put (t_read, c_read)
			Result.put (t_write, c_write)
			Result.put (t_exists,c_exists)
			Result.put (t_update, c_update)
			Result.put (t_delete, c_delete)
			Result.put (t_extended, c_extended)
		end

invariant
	type_valid: type >= c_read and type <= c_extended

end -- class ACCESS_TYPE
