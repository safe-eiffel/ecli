create table PARTICIPANT (
	identifier INTEGER not null,
	first_name VARCHAR (30) not null,
	last_name  VARCHAR (30) not null,
	street	VARCHAR (100) not null,
	no	VARCHAR (10),
	zip	INTEGER not null,
	city	VARCHAR (50) not null,
	state	VARCHAR (20),
	country VARCHAR (20)
)
;
create table REGISTRATION (
	identifier INTEGER not null,
	participant_id INTEGER not null,
	reg_time TIMESTAMP,
	fee	DOUBLE,
	paid_amount DOUBLE)
;
q
;
