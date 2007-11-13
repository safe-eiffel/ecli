indexing

	
			description: "Select participants count by remaining amount to pay"
		
	status: "Cursor/Query automatically generated for 'PARTICIPANTS_COUNT_BY_REMAINING'. DO NOT EDIT!"
	generated: "2006/03/21 14:12:57.046"

class PARTICIPANTS_COUNT_BY_REMAINING

inherit

	ECLI_CURSOR


creation

	make

feature  -- -- Access

	parameters_object: PARTICIPANTS_COUNT_BY_REMAINING_PARAMETERS

	item: PARTICIPANT_COUNT

feature  -- -- Element change

	set_parameters_object (a_parameters_object: PARTICIPANTS_COUNT_BY_REMAINING_PARAMETERS) is
			-- set `parameters_object' to `a_parameters_object'
		require
			a_parameters_object_not_void: a_parameters_object /= Void
		do
			parameters_object := a_parameters_object
			put_parameter (parameters_object.remaining_amount,"remaining_amount")
			bind_parameters
		ensure
			bound_parameters: bound_parameters
		end

feature  -- Constants

	definition: STRING is "%N%
%		select count (*) as count from PARTICIPANT p, REGISTRATION r where%N%
%			r.participant_id = p.identifier AND%N%
%			(r.fee - r.paid_amount) > ?remaining_amount%N%
%		"

feature {NONE} -- Implementation

	create_buffers is
			-- Creation of buffers
		local
			buffers: ARRAY[like value_anchor]
		do
			create item.make
			create buffers.make (1,1)
			buffers.put (item.count, 1)
			set_results (buffers)
		end

end -- class PARTICIPANTS_COUNT_BY_REMAINING
