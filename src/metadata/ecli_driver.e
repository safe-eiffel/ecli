indexing

	description:

			"ODBC Drivers."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2006, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class
	ECLI_DRIVER

create

	make

feature {NONE} -- Initialization

	make (cursor : ECLI_DRIVERS_CURSOR) is
			-- create from current item in cursor
		require
			cursor_not_void: cursor /= Void  --FIXME: VS-DEL
			cursor_not_off: not cursor.off
			cursor_name_not_void: cursor.name /= Void  --FIXME: VS-DEL
		local
			index, sep : INTEGER
			start : INTEGER
			att, item, key : STRING
		do
			name := cursor.name.twin
			create attributes.make (10)
			att := cursor.attributes
			from
				start := 1
				index := cursor.attributes.index_of ('%U', start)
			until
				index < start
			loop
				att := cursor.attributes.substring (start, index-1)
				sep := att.index_of ('=', 1)
				if sep > 0 then
					item := att.substring (sep+1, att.count)
					key := att.substring (1,sep-1)
					attributes.put (item, key)
				end
				start := index + 1
				index := cursor.attributes.index_of ('%U', start)
			end
		end

feature -- Access

	name : STRING
			-- Name.

	attributes : DS_HASH_TABLE[STRING, STRING]
			-- Driver attribute values.

invariant
	name_not_void: name /= Void --FIXME: VS-DEL
	attributes_not_void: attributes /= Void --FIXME: VS-DEL

end -- class ECLI_DRIVER
