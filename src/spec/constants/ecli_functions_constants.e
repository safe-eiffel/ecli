indexing

	description:
	
			"Constants accepted by SQLGetFunctions;."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_FUNCTIONS_CONSTANTS

feature -- Access

	--  SQLGetFunctions() values to identify ODBC APIs 
	Sql_api_sqlallocconnect	:	INTEGER is	1
	Sql_api_sqlallocenv	:	INTEGER is	2
	Sql_api_sqlallochandle	:	INTEGER is	1001 -- (ODBCVER >= 0x0300)
	Sql_api_sqlallocstmt	:	INTEGER is	3
	Sql_api_sqlbindcol	:	INTEGER is	4
	Sql_api_sqlbindparam	:	INTEGER is	1002 -- (ODBCVER >= 0x0300)
	Sql_api_sqlcancel	:	INTEGER is	5
	 -- IF (ODBCVER >= 0x0300)
	Sql_api_sqlclosecursor	:	INTEGER is	1003
	Sql_api_sqlcolattribute	:	INTEGER is	6
	 -- ENDIF
	Sql_api_sqlcolumns	:	INTEGER is	40
	Sql_api_sqlconnect	:	INTEGER is	7
	Sql_api_sqlcopydesc	:	INTEGER is	1004 -- (ODBCVER >= 0x0300)
	Sql_api_sqldatasources	:	INTEGER is	57
	Sql_api_sqldescribecol	:	INTEGER is	8
	Sql_api_sqldisconnect	:	INTEGER is	9
	Sql_api_sqlendtran	:	INTEGER is	1005 -- (ODBCVER >= 0x0300)
	Sql_api_sqlerror	:	INTEGER is	10
	Sql_api_sqlexecdirect	:	INTEGER is	11
	Sql_api_sqlexecute	:	INTEGER is	12
	Sql_api_sqlfetch	:	INTEGER is	13
	Sql_api_sqlfetchscroll	:	INTEGER is	1021 -- (ODBCVER >= 0x0300)
	Sql_api_sqlfreeconnect	:	INTEGER is	14
	Sql_api_sqlfreeenv	:	INTEGER is	15
	Sql_api_sqlfreehandle	:	INTEGER is	1006 -- (ODBCVER >= 0x0300)
	Sql_api_sqlfreestmt	:	INTEGER is	16
	Sql_api_sqlgetconnectattr	:	INTEGER is	1007 -- (ODBCVER >= 0x0300)
	Sql_api_sqlgetconnectoption	:	INTEGER is	42
	Sql_api_sqlgetcursorname	:	INTEGER is	17
	Sql_api_sqlgetdata	:	INTEGER is	43
	 -- IF (ODBCVER >= 0x0300)
	Sql_api_sqlgetdescfield	:	INTEGER is	1008
	Sql_api_sqlgetdescrec	:	INTEGER is	1009
	Sql_api_sqlgetdiagfield	:	INTEGER is	1010
	Sql_api_sqlgetdiagrec	:	INTEGER is	1011
	Sql_api_sqlgetenvattr	:	INTEGER is	1012
	 -- ENDIF
	Sql_api_sqlgetfunctions	:	INTEGER is	44
	Sql_api_sqlgetinfo	:	INTEGER is	45
	Sql_api_sqlgetstmtattr	:	INTEGER is	1014 -- (ODBCVER >= 0x0300)
	Sql_api_sqlgetstmtoption	:	INTEGER is	46
	Sql_api_sqlgettypeinfo	:	INTEGER is	47
	Sql_api_sqlnumresultcols	:	INTEGER is	18
	Sql_api_sqlparamdata	:	INTEGER is	48
	Sql_api_sqlprepare	:	INTEGER is	19
	Sql_api_sqlputdata	:	INTEGER is	49
	Sql_api_sqlrowcount	:	INTEGER is	20
	Sql_api_sqlsetconnectattr	:	INTEGER is	1016 -- (ODBCVER >= 0x0300)
	Sql_api_sqlsetconnectoption	:	INTEGER is	50
	Sql_api_sqlsetcursorname	:	INTEGER is	21
	 -- IF (ODBCVER >= 0x0300)
	Sql_api_sqlsetdescfield	:	INTEGER is	1017
	Sql_api_sqlsetdescrec	:	INTEGER is	1018
	Sql_api_sqlsetenvattr	:	INTEGER is	1019
	 -- ENDIF
	Sql_api_sqlsetparam	:	INTEGER is	22
	Sql_api_sqlsetstmtattr	:	INTEGER is	1020 -- (ODBCVER >= 0x0300)
	Sql_api_sqlsetstmtoption	:	INTEGER is	51
	Sql_api_sqlspecialcolumns	:	INTEGER is	52
	Sql_api_sqlstatistics	:	INTEGER is	53
	Sql_api_sqltables	:	INTEGER is	54
	Sql_api_sqltransact	:	INTEGER is	23
	
	--  SQLGetFunctions: additional values for   
	--  fFunction to represent functions that	
	--  are not in the X/Open spec.				
	
	 -- IF (ODBCVER >= 0x0300)
	Sql_api_sqlallochandlestd	:	INTEGER is	73
	Sql_api_sqlbulkoperations	:	INTEGER is	24
	 -- ENDIF  --  ODBCVER >= 0x0300 
	Sql_api_sqlbindparameter	:	INTEGER is	72
	Sql_api_sqlbrowseconnect	:	INTEGER is	55
	Sql_api_sqlcolattributes	:	INTEGER is	6
	Sql_api_sqlcolumnprivileges	:	INTEGER is	56
	Sql_api_sqldescribeparam	:	INTEGER is	58
	Sql_api_sqldriverconnect	:	INTEGER is	41
	Sql_api_sqldrivers	:	INTEGER is	71
	Sql_api_sqlextendedfetch	:	INTEGER is	59
	Sql_api_sqlforeignkeys	:	INTEGER is	60
	Sql_api_sqlmoreresults	:	INTEGER is	61
	Sql_api_sqlnativesql	:	INTEGER is	62
	Sql_api_sqlnumparams	:	INTEGER is	63
	Sql_api_sqlparamoptions	:	INTEGER is	64
	Sql_api_sqlprimarykeys	:	INTEGER is	65
	Sql_api_sqlprocedurecolumns	:	INTEGER is	66
	Sql_api_sqlprocedures	:	INTEGER is	67
	Sql_api_sqlsetpos	:	INTEGER is	68
	Sql_api_sqlsetscrolloptions	:	INTEGER is	69
	Sql_api_sqltableprivileges	:	INTEGER is	70

end
