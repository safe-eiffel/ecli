indexing
	description: "Connection attribute constants : keys and values."
	author: "Paul G. Crismer"
	
	library: "ECLI"
	
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_CONNECTION_ATTRIBUTE_CONSTANTS

feature -- Keys

	--  connection attributes 
	Sql_access_mode	:	INTEGER is	101
	Sql_autocommit	:	INTEGER is	102
	Sql_login_timeout	:	INTEGER is	103
	Sql_opt_trace	:	INTEGER is	104
	Sql_opt_tracefile	:	INTEGER is	105
	Sql_translate_dll	:	INTEGER is	106
	Sql_translate_option	:	INTEGER is	107
	Sql_txn_isolation	:	INTEGER is	108
	Sql_current_qualifier	:	INTEGER is	109
	Sql_odbc_cursors	:	INTEGER is	110
	Sql_quiet_mode	:	INTEGER is	111
	Sql_packet_size	:	INTEGER is	112

	--  connection attributes with new names 
	 -- IF (ODBCVER >= 0x0300)
	Sql_attr_access_mode	:	INTEGER is 101
	Sql_attr_autocommit	:	INTEGER is 102
	Sql_attr_connection_timeout	:	INTEGER is	113
	Sql_attr_current_catalog	:	INTEGER is 109
	Sql_attr_disconnect_behavior	:	INTEGER is	114
	Sql_attr_enlist_in_dtc	:	INTEGER is	1207
	Sql_attr_enlist_in_xa	:	INTEGER is	1208
	Sql_attr_login_timeout	:	INTEGER is 103
	Sql_attr_odbc_cursors	:	INTEGER is 110
	Sql_attr_packet_size	:	INTEGER is 112
	Sql_attr_quiet_mode	:	INTEGER is 111
	Sql_attr_trace	:	INTEGER is 104
	Sql_attr_tracefile	:	INTEGER is 105
	Sql_attr_translate_lib	:	INTEGER is 106
	Sql_attr_translate_option	:	INTEGER is 107
	Sql_attr_txn_isolation	:	INTEGER is 108
	Sql_attr_connection_dead	:	INTEGER is	1209	 --  GetConnectAttr only 

feature -- Values

	--  Sql_access_mode options 
	Sql_mode_read_write	:	INTEGER is	0
	Sql_mode_read_only	:	INTEGER is	1
	Sql_mode_default	:	INTEGER is 0 -- Sql_mode_read_write

	--  Sql_autocommit options 
	Sql_autocommit_off	:	INTEGER is	0
	Sql_autocommit_on	:	INTEGER is	1
	Sql_autocommit_default	:	INTEGER is 1 -- Sql_autocommit_on

	--  Sql_login_timeout options 
	Sql_login_timeout_default	:	INTEGER is	15

	--  Sql_opt_trace options 
	Sql_opt_trace_off	:	INTEGER is	0
	Sql_opt_trace_on	:	INTEGER is	1
	Sql_opt_trace_default	:	INTEGER is 0 -- Sql_opt_trace_off
	Sql_opt_trace_file_default	:	STRING is	"\SQL.LOG"

	--  Sql_odbc_cursors options 
	Sql_cur_use_if_needed	:	INTEGER is	0
	Sql_cur_use_odbc	:	INTEGER is	1
	Sql_cur_use_driver	:	INTEGER is	2
	Sql_cur_default	:	INTEGER is 2 -- Sql_cur_use_driver

	 -- IF (ODBCVER >= 0x0300)
	--  values for Sql_attr_disconnect_behavior 
	Sql_db_return_to_pool	:	INTEGER is	0
	Sql_db_disconnect	:	INTEGER is	1
	Sql_db_default	:	INTEGER is 0 -- Sql_db_return_to_pool

	--  values for Sql_attr_enlist_in_dtc 
	Sql_dtc_done	:	INTEGER is	0
	 -- ENDIF   --  ODBCVER >= 0x0300 

	--  values for Sql_attr_connection_dead 
	Sql_cd_true	:	INTEGER is	1		 --  Connection is	closed/dead 
	Sql_cd_false	:	INTEGER is	0	 --  Connection is	open/available 

end -- class ECLI_CONNECTION_ATTRIBUTE_CONSTANTS
