indexing
	description: "Generated cursor 'PARTICIPANT_BY_ZIP' : DO NOT EDIT !"
	author: "QUERY_ASSISTANT"
	date: "$Date : $"
	revision: "$Revision : $"
	licensing: "See notice at end of class"
class

	PARTICIPANT_BY_ZIP

inherit

	ECLI_CURSOR

creation

	make

feature -- Basic Operations


	start (a_pzip : INTEGER) is
			-- position cursor at first position of result-set obtained
			-- by applying actual parameters to definition
		do
			pzip.set_item (a_pzip)
			implementation_start
		end


feature -- Access

	definition : STRING is
			-- SQL definition of Current
		once
			Result := "select * from PARTICIPANT where 	zip = ?pzip 	"
		end

feature -- Access (parameters)

	pzip	: ECLI_INTEGER

feature -- Access (results)

	identifier	: ECLI_INTEGER
	first_name	: ECLI_VARCHAR
	last_name	: ECLI_VARCHAR
	street	: ECLI_VARCHAR
	no	: ECLI_VARCHAR
	zip	: ECLI_INTEGER
	city	: ECLI_VARCHAR
	state	: ECLI_VARCHAR
	country	: ECLI_VARCHAR

feature {NONE} -- Implementation

	setup is
			-- setup all attribute objects
		do
			-- create cursor values array
			create cursor.make (1, 9)
			-- setup result value object and put them in 'cursor' 
			create identifier.make
			cursor.put (identifier, 1)
			create first_name.make (30)
			cursor.put (first_name, 2)
			create last_name.make (30)
			cursor.put (last_name, 3)
			create street.make (100)
			cursor.put (street, 4)
			create no.make (10)
			cursor.put (no, 5)
			create zip.make
			cursor.put (zip, 6)
			create city.make (50)
			cursor.put (city, 7)
			create state.make (20)
			cursor.put (state, 8)
			create country.make (20)
			cursor.put (country, 9)
			-- setup parameter value objects and put them, by name
			create pzip.make
			put_parameter (pzip, "pzip")
		end


end -- class PARTICIPANT_BY_ZIP
