note
	description: "Sets of parameters of an access modules."

	library: "Access_gen : Access Modules Generators utilities"

	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	PARAMETER_SET

inherit
	COLUMN_SET[RDBMS_ACCESS_PARAMETER]
		redefine
			make
		end

create
	make, make_with_parent_name

feature {NONE} -- Initialization

	make (a_name: STRING)
		do
			Precursor (a_name)
--			set_equality_tester (create {KL_EQUALITY_TESTER [MODULE_PARAMETER]})
		end

feature -- Status report

	has_samples : BOOLEAN
			-- has this parameter set samples for all the parameters ?
		local
			sc : DS_SET_CURSOR[RDBMS_ACCESS_PARAMETER]
		do
			if count > 0 then
				from
					sc := new_cursor
					sc.start
					Result := True
				until
					sc.off
				loop
					Result := Result and sc.item.has_sample
					sc.forth
				end
			end
		end

	has_output : BOOLEAN
			-- has this parameter set output or input_output parameters ?
		local
			sc : DS_SET_CURSOR[RDBMS_ACCESS_PARAMETER]
		do
			if count > 0 then
				from
					sc := new_cursor
					sc.start
					Result := True
				until
					sc.off
				loop
					Result := Result and (sc.item.is_input or else sc.item.is_input_output)
					sc.forth
				end
			end
		end

feature {NONE} -- Implementation

	item_eiffel_type (an_item : like item) : STRING
		do
			Result := an_item.value_type
		end

	item_eiffel_name (an_item : like item) : STRING
			--
		do
			Result := an_item.eiffel_name
		end


end -- class PARAMETER_SET
--
-- Copyright (c) 2000-2012, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
