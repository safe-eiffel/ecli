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


	start (a_pcchar20 : STRING) is
			-- position cursor at first position of result-set obtained
			-- by applying actual parameters to definition
		do
			pcchar20.set_item (a_pcchar20)
			implementation_start
		end


feature -- Access

	definition : STRING is
			-- SQL definition of Current
		once
			Result := "select * from qaessai where cchar20 = ?pcchar20"
		end

feature -- Access (parameters)

	pcchar20	: ECLI_CHAR

feature -- Access (results)

	cchar20	: ECLI_CHAR
	cvarchar30	: ECLI_VARCHAR
	cinteger	: ECLI_INTEGER
	ctimestamp	: ECLI_TIMESTAMP
	cdate	: ECLI_TIMESTAMP
	cdouble	: ECLI_DOUBLE
	cfloat	: ECLI_DOUBLE

feature {NONE} -- Implementation

	setup is
			-- setup all attribute objects
		do
			-- create cursor values array
			create cursor.make (1, 7)
			-- setup result value object and put them in 'cursor' 
			create cchar20.make (20)
			cursor.put (cchar20, 1)
			create cvarchar30.make (30)
			cursor.put (cvarchar30, 2)
			create cinteger.make
			cursor.put (cinteger, 3)
			create ctimestamp.make_first
			cursor.put (ctimestamp, 4)
			create cdate.make_first
			cursor.put (cdate, 5)
			create cdouble.make
			cursor.put (cdouble, 6)
			create cfloat.make
			cursor.put (cfloat, 7)
			-- setup parameter value objects and put them, by name
			create pcchar20.make (20)
			put_parameter (pcchar20, "pcchar20")
		end


end -- class TOTO
