indexing
	description: "Generated cursor 'toto' : DO NOT EDIT !"
	author: "QUERY_ASSISTANT"
	date: "$Date : $"
	revision: "$Revision : $"
	licensing: "See notice at end of class"
class

	TOTO

inherit

	ECLI_CURSOR

creation

	make

feature -- Basic Operations


	start (a_page : INTEGER) is
			-- position cursor at first position of result-set obtained
			-- by applying actual parameters to definition
		do
			page.set_item (a_page)
			implementation_start
		end


feature -- Access

	definition : STRING is
			-- SQL definition of Current
		once
			Result := "select * from toto where age=?page"
		end

feature -- Access (parameters)

	page	: ECLI_INTEGER

feature -- Access (results)

	nom	: ECLI_CHAR
	age	: ECLI_INTEGER
	adresse	: ECLI_VARCHAR

feature {NONE} -- Implementation

	setup is
			-- setup all attribute objects
		do
			-- create cursor values array
			create cursor.make (1, 3)
			-- setup result value object and put them in 'cursor' 
			create nom.make (20)
			cursor.put (nom, 1)
			create age.make
			cursor.put (age, 2)
			create adresse.make (30)
			cursor.put (adresse, 3)
			-- setup parameter value objects and put them, by name
			create page.make
			put_parameter (page, "page")
		end


end -- class TOTO
