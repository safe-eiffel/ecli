indexing
	description: "Generated cursor 'PARTICIPANT_BY_REMAINING' : DO NOT EDIT !"
	author: "QUERY_ASSISTANT"
	date: "$Date : $"
	revision: "$Revision : $"
	licensing: "See notice at end of class"
class

	PARTICIPANT_BY_REMAINING_CURSOR

inherit

	ECLI_CURSOR

creation

	make

feature -- Basic Operations


	start (a_premaining : DOUBLE) is
			-- position cursor at first position of result-set obtained
			-- by applying actual parameters to definition
		do
			premaining.set_item (a_premaining)
			implementation_start
		end


feature -- Access

	definition : STRING is
			-- SQL definition of Current
		once
			Result := "select p.identifier, p.first_name, p.last_name, p.street, no as no, p.zip, p.city, p.state,  p.country, r.reg_time, (r.fee - r.paid_amount) as remaining from PARTICIPANT p, REGISTRATION r where 	r.participant_id = p.identifier AND 	(r.fee - r.paid_amount) > ?premaining"
		end

feature -- Access (parameters)

	premaining	: ECLI_DOUBLE

feature -- Access (results)

	identifier	: ECLI_INTEGER
	first_name	: ECLI_VARCHAR
	last_name	: ECLI_VARCHAR
	street	: ECLI_VARCHAR
	no	: ECLI_INTEGER
	zip	: ECLI_INTEGER
	city	: ECLI_VARCHAR
	state	: ECLI_VARCHAR
	country	: ECLI_VARCHAR
	reg_time	: ECLI_TIMESTAMP
	remaining	: ECLI_DOUBLE

feature {NONE} -- Implementation

	setup is
			-- setup all attribute objects
		do
			-- create cursor values array
			create cursor.make (1, 11)
			-- setup result value object and put them in 'cursor' 
			create identifier.make
			cursor.put (identifier, 1)
			create first_name.make (30)
			cursor.put (first_name, 2)
			create last_name.make (30)
			cursor.put (last_name, 3)
			create street.make (100)
			cursor.put (street, 4)
			create no.make
			cursor.put (no, 5)
			create zip.make
			cursor.put (zip, 6)
			create city.make (50)
			cursor.put (city, 7)
			create state.make (20)
			cursor.put (state, 8)
			create country.make (20)
			cursor.put (country, 9)
			create reg_time.make_first
			cursor.put (reg_time, 10)
			create remaining.make
			cursor.put (remaining, 11)
			-- setup parameter value objects and put them, by name
			create premaining.make
			put_parameter (premaining, "premaining")
		end


end -- class PARTICIPANT_BY_REMAINING_CURSOR
