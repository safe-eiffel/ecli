note

	description:
	
			"Constants accepted by SQLGetFunctions;."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_FUNCTIONS_CONSTANTS

feature -- Access

	--  SQLGetFunctions() values to identify ODBC APIs 
	Sql_api_sqlallocconnect	:	INTEGER =	1
	Sql_api_sqlallocenv	:	INTEGER =	2
	Sql_api_sqlallochandle	:	INTEGER =	1001 -- (ODBCVER >= 0x0300)
	Sql_api_sqlallocstmt	:	INTEGER =	3
	Sql_api_sqlbindcol	:	INTEGER =	4
	Sql_api_sqlbindparam	:	INTEGER =	1002 -- (ODBCVER >= 0x0300)
	Sql_api_sqlcancel	:	INTEGER =	5
	 -- IF (ODBCVER >= 0x0300)
	Sql_api_sqlclosecursor	:	INTEGER =	1003
	Sql_api_sqlcolattribute	:	INTEGER =	6
	 -- ENDIF
	Sql_api_sqlcolumns	:	INTEGER =	40
	Sql_api_sqlconnect	:	INTEGER =	7
	Sql_api_sqlcopydesc	:	INTEGER =	1004 -- (ODBCVER >= 0x0300)
	Sql_api_sqldatasources	:	INTEGER =	57
	Sql_api_sqldescribecol	:	INTEGER =	8
	Sql_api_sqldisconnect	:	INTEGER =	9
	Sql_api_sqlendtran	:	INTEGER =	1005 -- (ODBCVER >= 0x0300)
	Sql_api_sqlerror	:	INTEGER =	10
	Sql_api_sqlexecdirect	:	INTEGER =	11
	Sql_api_sqlexecute	:	INTEGER =	12
	Sql_api_sqlfetch	:	INTEGER =	13
	Sql_api_sqlfetchscroll	:	INTEGER =	1021 -- (ODBCVER >= 0x0300)
	Sql_api_sqlfreeconnect	:	INTEGER =	14
	Sql_api_sqlfreeenv	:	INTEGER =	15
	Sql_api_sqlfreehandle	:	INTEGER =	1006 -- (ODBCVER >= 0x0300)
	Sql_api_sqlfreestmt	:	INTEGER =	16
	Sql_api_sqlgetconnectattr	:	INTEGER =	1007 -- (ODBCVER >= 0x0300)
	Sql_api_sqlgetconnectoption	:	INTEGER =	42
	Sql_api_sqlgetcursorname	:	INTEGER =	17
	Sql_api_sqlgetdata	:	INTEGER =	43
	 -- IF (ODBCVER >= 0x0300)
	Sql_api_sqlgetdescfield	:	INTEGER =	1008
	Sql_api_sqlgetdescrec	:	INTEGER =	1009
	Sql_api_sqlgetdiagfield	:	INTEGER =	1010
	Sql_api_sqlgetdiagrec	:	INTEGER =	1011
	Sql_api_sqlgetenvattr	:	INTEGER =	1012
	 -- ENDIF
	Sql_api_sqlgetfunctions	:	INTEGER =	44
	Sql_api_sqlgetinfo	:	INTEGER =	45
	Sql_api_sqlgetstmtattr	:	INTEGER =	1014 -- (ODBCVER >= 0x0300)
	Sql_api_sqlgetstmtoption	:	INTEGER =	46
	Sql_api_sqlgettypeinfo	:	INTEGER =	47
	Sql_api_sqlnumresultcols	:	INTEGER =	18
	Sql_api_sqlparamdata	:	INTEGER =	48
	Sql_api_sqlprepare	:	INTEGER =	19
	Sql_api_sqlputdata	:	INTEGER =	49
	Sql_api_sqlrowcount	:	INTEGER =	20
	Sql_api_sqlsetconnectattr	:	INTEGER =	1016 -- (ODBCVER >= 0x0300)
	Sql_api_sqlsetconnectoption	:	INTEGER =	50
	Sql_api_sqlsetcursorname	:	INTEGER =	21
	 -- IF (ODBCVER >= 0x0300)
	Sql_api_sqlsetdescfield	:	INTEGER =	1017
	Sql_api_sqlsetdescrec	:	INTEGER =	1018
	Sql_api_sqlsetenvattr	:	INTEGER =	1019
	 -- ENDIF
	Sql_api_sqlsetparam	:	INTEGER =	22
	Sql_api_sqlsetstmtattr	:	INTEGER =	1020 -- (ODBCVER >= 0x0300)
	Sql_api_sqlsetstmtoption	:	INTEGER =	51
	Sql_api_sqlspecialcolumns	:	INTEGER =	52
	Sql_api_sqlstatistics	:	INTEGER =	53
	Sql_api_sqltables	:	INTEGER =	54
	Sql_api_sqltransact	:	INTEGER =	23
	
	--  SQLGetFunctions: additional values for   
	--  fFunction to represent functions that	
	--  are not in the X/Open spec.				
	
	 -- IF (ODBCVER >= 0x0300)
	Sql_api_sqlallochandlestd	:	INTEGER =	73
	Sql_api_sqlbulkoperations	:	INTEGER =	24
	 -- ENDIF  --  ODBCVER >= 0x0300 
	Sql_api_sqlbindparameter	:	INTEGER =	72
	Sql_api_sqlbrowseconnect	:	INTEGER =	55
	Sql_api_sqlcolattributes	:	INTEGER =	6
	Sql_api_sqlcolumnprivileges	:	INTEGER =	56
	Sql_api_sqldescribeparam	:	INTEGER =	58
	Sql_api_sqldriverconnect	:	INTEGER =	41
	Sql_api_sqldrivers	:	INTEGER =	71
	Sql_api_sqlextendedfetch	:	INTEGER =	59
	Sql_api_sqlforeignkeys	:	INTEGER =	60
	Sql_api_sqlmoreresults	:	INTEGER =	61
	Sql_api_sqlnativesql	:	INTEGER =	62
	Sql_api_sqlnumparams	:	INTEGER =	63
	Sql_api_sqlparamoptions	:	INTEGER =	64
	Sql_api_sqlprimarykeys	:	INTEGER =	65
	Sql_api_sqlprocedurecolumns	:	INTEGER =	66
	Sql_api_sqlprocedures	:	INTEGER =	67
	Sql_api_sqlsetpos	:	INTEGER =	68
	Sql_api_sqlsetscrolloptions	:	INTEGER =	69
	Sql_api_sqltableprivileges	:	INTEGER =	70

end
