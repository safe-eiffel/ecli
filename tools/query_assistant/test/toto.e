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

	start (a_weight : INTEGER) is
			-- position cursor at first position of result-set obtained
			-- by applying actual parameters to definition
		do
			p_weight.set_item (a_weight)
			implementation_start
		end


feature -- Access

	definition : STRING is
			-- SQL definition of Current
		once
			Result := "select * from toto where weight = ?weight"
		end

feature -- Access (parameters)

	p_weight	: ECLI_INTEGER

feature -- Access (results)

	name	: ECLI_CHAR
	bdate	: ECLI_TIMESTAMP
	weight	: ECLI_INTEGER

feature {NONE} -- Implementation

	create_buffers is
			-- create all attribute objects
		do
			-- create cursor values array
			create cursor.make (1, 3)

			-- setup result value object and put them in 'cursor' 
			create name.make (20)
			cursor.put (name, 1)
			create bdate.make_first
			cursor.put (bdate, 2)
			create weight.make
			cursor.put (weight, 3)

			-- setup parameter value objects and put them, by name
			create p_weight.
			make
			put_parameter (weight, "weight")
		end


end -- class TOTO
