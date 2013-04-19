note
	description: "Application that help migrate towards voidsafety.
class
	VSMIG_SUPPORT

inherit
	KL_SHARED_FILE_SYSTEM

create
	make

feature

	make is
		local
		do
			create fmti
			create fmtd
			create fmtts
			create fmtt
			fmt := fmtt
			create sql_p.make
			create str
--			create ds
			create_data
			create_arrayed_data
			create_session
			create_statement
			create_cursor
			create_rowset_cursor
			create_metadata_cursors
		end

	create_data
		local
			bif : detachable KI_BINARY_INPUT_FILE
			bof : detachable KI_BINARY_OUTPUT_FILE
		do
			create {KL_BINARY_INPUT_FILE}bif.make ("input")
			create {KL_BINARY_OUTPUT_FILE}bof.make ("output")
			create int.make
			create binary.make (20)
			create char.make (20)
			create datetime.make_default
			create decimal.make (10,2)
			create flvc.make_input (bif)
			create flvb.make_output (bof)
			create fvc.make_input (bif)
			create fvb.make_output (bof)
			create longvarbinary.make (2000)
			create longvarchar.make (2000)
			create slvb.make (2000)
			create slvc.make (2000)
			create vb.make (2000)
			create vc.make (2000)
			create vfact.make
			create bfact
		end

	create_arrayed_data
		local
			afact: ECLI_ARRAYED_BUFFER_FACTORY
			rsc : ECLI_ROW_STATUS_CONSTANTS
		do
			create afact.make (10)
			create ardt.make (10)
			create arfl.make (10)
			create rsc
		end

	create_session
		do
			create session.make_default
			create simple_login.make ("source", "toto", "lulu")
			session.set_login_strategy (simple_login)
			session.connect
		end

	create_statement
		do
			create statement.make (session)
			statement.set_sql ("select * from toto")
			statement.execute
			statement.describe_results
			rd := statement.results_description.item (1)
			create stored_procedure.make (session)
			create dscur.make_all
		end

	create_cursor
		do
			create cursor.make (session, "select * from toto")
		end

	create_rowset_cursor
		do
			create rowset_cursor.make (session, "select * from toto", 30)
		end

	create_metadata_cursors
		local
			md : ECLI_NAMED_METADATA
			stmt : ECLI_STATEMENT
		do
			create cols.make (statement, 1, 10)
			create drvs.make
			create drvl.make ("conn string")
			create md.make ("", "", "")
			create colcur.make (md, session)
			create fkcur.make (md, session)
			create pkcur.make (md, session)
			create proccur.make (md, session)
			create pcolcur.make (md,session)
			create typcur.make_all_types (session)
			create tabcur.make (md, session)
			create tycat.make (session)
			create rsmod.make (session, "insert into toto", 10)
			create stmt.make (session)
			create dsdesc.make_for_parameters (stmt)
		end

feature -- Access

	ardt : ECLI_ARRAYED_DATE_TIME
	arfl : ECLI_ARRAYED_FLOAT

	rsmod : ECLI_ROWSET_MODIFIER

	tycat : ECLI_TYPE_CATALOG
	tabcur : ECLI_TABLES_CURSOR
	typcur: ECLI_SQL_TYPES_CURSOR
	pcolcur : ECLI_PROCEDURE_COLUMNS_CURSOR

	colcur : ECLI_COLUMNS_CURSOR
	dscur : ECLI_DATA_SOURCES_CURSOR
	fkcur: ECLI_FOREIGN_KEYS_CURSOR
	pkcur : ECLI_PRIMARY_KEY_CURSOR
	proccur : ECLI_PROCEDURES_CURSOR

	binary : ECLI_BINARY
	char : ECLI_CHAR
	datetime : ECLI_DATE_TIME
	decimal : ECLI_DECIMAL
	longvarbinary : ECLI_LONGVARBINARY
	longvarchar : ECLI_LONGVARCHAR

	vb : ECLI_VARBINARY
	vc : ECLI_VARCHAR

	flvc : ECLI_FILE_LONGVARCHAR
	flvb : ECLI_FILE_LONGVARBINARY

	fvc : ECLI_FILE_VARCHAR
	fvb : ECLI_FILE_VARBINARY

	slvb : ECLI_STRING_LONGVARBINARY
	slvc : ECLI_STRING_LONGVARCHAR

	vfact : ECLI_VALUE_FACTORY
	bfact : ECLI_BUFFER_FACTORY

	fmti: ECLI_FORMAT_INTEGER
	fmt: ECLI_FORMAT[ANY]
	fmtd : ECLI_DATE_FORMAT
	fmtts : ECLI_TIMESTAMP_FORMAT
	fmtt : ECLI_TIME_FORMAT
	sql_p : ECLI_SQL_PARSER
	str : ECLI_STRING_ROUTINES


	int: ECLI_INTEGER

	session : ECLI_SESSION
	statement : ECLI_STATEMENT

	stored_procedure: ECLI_STORED_PROCEDURE

	simple_login : ECLI_SIMPLE_LOGIN

	rd : ECLI_DATA_DESCRIPTION

	cursor : ECLI_ROW_CURSOR

	rowset_cursor: ECLI_ROWSET_CURSOR

	cols : ECLI_COLUMN_DESCRIPTION
	drvs : ECLI_DRIVERS_CURSOR

	drvl : ECLI_DRIVER_LOGIN

	dsdesc : ECLI_DATASET_DESCRIPTION

end -- class VSMIG_SUPPORT

