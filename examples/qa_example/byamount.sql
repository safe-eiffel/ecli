select * from PARTICIPANT p, REGISTRATION r where
	r.participant_id = p.identifier AND
	r.paid_amount > ?pzip