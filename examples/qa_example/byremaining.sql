select p.identifier, p.first_name, p.last_name, p.street, no as no, p.zip, p.city, p.state,
 p.country, r.reg_time, (r.fee - r.paid_amount) as remaining from PARTICIPANT p, REGISTRATION r where
	r.participant_id = p.identifier AND
	(r.fee - r.paid_amount) > ?premaining

