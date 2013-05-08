note

	
			description: "Select participants by amount already paid"
		
	status: "Cursor/Query automatically generated for 'PARTICIPANTS_BY_AMOUNT'. DO NOT EDIT!"
	generated: "2013/05/08 18:11:42.109"
	generator_version: "v1.7.2"
	source_filename: "access_modules.xml"

class PARTICIPANTS_BY_AMOUNT

inherit

	ECLI_CURSOR
		redefine
			initialize
		end


create

	make

feature  -- -- Access

	parameters_object: detachable PARTICIPANTS_BY_AMOUNT_PARAMETERS

	item: PARTICIPANTS_BY_AMOUNT_RESULTS

feature  -- -- Element change

	set_parameters_object (a_parameters_object: PARTICIPANTS_BY_AMOUNT_PARAMETERS)
			-- set `parameters_object' to `a_parameters_object'
		require
			a_parameters_object_not_void: a_parameters_object /= Void
		do
			parameters_object := a_parameters_object
			put_parameter (parameters_object.paid_amount,"paid_amount")
			bind_parameters
		ensure
			bound_parameters: bound_parameters
		end

feature  -- Constants

	definition: STRING = "[
select p.identifier, p.first_name, p.last_name, p.street, no as no, p.zip, p.city, p.state,
		 p.country, r.reg_time, r.paid_amount from PARTICIPANT p, REGISTRATION r where
			r.participant_id = p.identifier AND
			r.paid_amount = ?paid_amount
]"

feature {NONE} -- Implementation

	create_buffers
			-- Creation of buffers
		local
			buffers: like results
		do
			create buffers.make (1,0)
			buffers.force (item.identifier, 1)
			buffers.force (item.first_name, 2)
			buffers.force (item.last_name, 3)
			buffers.force (item.street, 4)
			buffers.force (item.no, 5)
			buffers.force (item.zip, 6)
			buffers.force (item.city, 7)
			buffers.force (item.state, 8)
			buffers.force (item.country, 9)
			buffers.force (item.reg_time, 10)
			buffers.force (item.paid_amount, 11)
			set_results (buffers)
		end

feature {NONE} -- Initialization

	initialize
			-- <Precursor>
		do
			Precursor
			create item.make
		end

end
