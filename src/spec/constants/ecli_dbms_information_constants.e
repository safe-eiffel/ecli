indexing

	description: "Constants related to SQLGetInfo."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	copyright: "Copyright (c) 2001-2005, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DBMS_INFORMATION_CONSTANTS

inherit
	ANY
	
	XS_UINT32_ROUTINES
		export {NONE} all
		end
		
feature -- Constants -- Info type 

	sql_max_driver_connections :  INTEGER  is 0
	sql_maximum_driver_connections : integer is do result := sql_max_driver_connections end 
	sql_max_concurrent_activities :  INTEGER  is 1
	sql_maximum_concurrent_activities : integer is do result := sql_max_concurrent_activities end 
	sql_data_source_name :  INTEGER  is 2
	sql_fetch_direction :  INTEGER  is 8
	sql_server_name :  INTEGER  is 13
	sql_search_pattern_escape :  INTEGER  is 14
	sql_dbms_name :  INTEGER  is 17
	sql_dbms_ver :  INTEGER  is 18
	sql_accessible_tables :  INTEGER  is 19
	sql_accessible_procedures :  INTEGER  is 20
	sql_cursor_commit_behavior :  INTEGER  is 23
	sql_data_source_read_only :  INTEGER  is 25
	sql_default_txn_isolation :  INTEGER  is 26
	sql_identifier_case :  INTEGER  is 28
	sql_identifier_quote_char :  INTEGER  is 29
	sql_max_column_name_len :  INTEGER  is 30
	sql_maximum_column_name_length : integer is do result := sql_max_column_name_len end 
	sql_max_cursor_name_len :  INTEGER  is 31
	sql_maximum_cursor_name_length : integer is do result := sql_max_cursor_name_len end 
	sql_max_schema_name_len :  INTEGER  is 32
	sql_maximum_schema_name_length : integer is do result := sql_max_schema_name_len end 
	sql_max_catalog_name_len :  INTEGER  is 34
	sql_maximum_catalog_name_length : integer is do result := sql_max_catalog_name_len end 
	sql_max_table_name_len :  INTEGER  is 35
	sql_scroll_concurrency :  INTEGER  is 43
	sql_txn_capable :  INTEGER  is 46
	sql_transaction_capable : integer is do result := sql_txn_capable end 
	sql_user_name :  INTEGER  is 47
	sql_txn_isolation_option :  INTEGER  is 72
	sql_transaction_isolation_option : integer is do result := sql_txn_isolation_option end 
	sql_integrity :  INTEGER  is 73
	sql_getdata_extensions :  INTEGER  is 81
	sql_null_collation :  INTEGER  is 85
	sql_alter_table :  INTEGER  is 86
	sql_order_by_columns_in_select :  INTEGER  is 90
	sql_special_characters :  INTEGER  is 94
	sql_max_columns_in_group_by :  INTEGER  is 97
	sql_maximum_columns_in_group_by : integer is do result := sql_max_columns_in_group_by end 
	sql_max_columns_in_index :  INTEGER  is 98
	sql_maximum_columns_in_index : integer is do result := sql_max_columns_in_index end 
	sql_max_columns_in_order_by :  INTEGER  is 99
	sql_maximum_columns_in_order_by : integer is do result := sql_max_columns_in_order_by end 
	sql_max_columns_in_select :  INTEGER  is 100
	sql_maximum_columns_in_select : integer is do result := sql_max_columns_in_select end 
	sql_max_columns_in_table :  INTEGER  is 101
	sql_max_index_size :  INTEGER  is 102
	sql_maximum_index_size : integer is do result := sql_max_index_size end 
	sql_max_row_size :  INTEGER  is 104
	sql_maximum_row_size : integer is do result := sql_max_row_size end 
	sql_max_statement_len :  INTEGER  is 105
	sql_maximum_statement_length : integer is do result := sql_max_statement_len end 
	sql_max_tables_in_select :  INTEGER  is 106
	sql_maximum_tables_in_select : integer is do result := sql_max_tables_in_select end 
	sql_max_user_name_len :  INTEGER  is 107
	sql_maximum_user_name_length : integer is do result := sql_max_user_name_len end 
	
	sql_oj_capabilities :  INTEGER  is 115
	sql_outer_join_capabilities : integer is do result := sql_oj_capabilities end 
	
	sql_xopen_cli_year :  INTEGER  is 10000
	sql_cursor_sensitivity :  INTEGER  is 10001
	sql_describe_parameter :  INTEGER  is 10002
	sql_catalog_name :  INTEGER  is 10003
	sql_collation_seq :  INTEGER  is 10004
	sql_max_identifier_len :  INTEGER  is 10005
	sql_maximum_identifier_length : integer is do result := sql_max_identifier_len end 

	sql_info_first :  INTEGER  is 0
	sql_active_connections :  INTEGER  is 0
	sql_active_statements :  INTEGER  is 1
	sql_driver_hdbc :  INTEGER  is 3
	sql_driver_henv :  INTEGER  is 4
	sql_driver_hstmt :  INTEGER  is 5
	sql_driver_name :  INTEGER  is 6
	sql_driver_ver :  INTEGER  is 7
	sql_odbc_api_conformance :  INTEGER  is 9
	sql_odbc_ver :  INTEGER  is 10
	sql_row_updates :  INTEGER  is 11
	sql_odbc_sag_cli_conformance :  INTEGER  is 12
	sql_odbc_sql_conformance :  INTEGER  is 15
	sql_procedures :  INTEGER  is 21
	sql_concat_null_behavior :  INTEGER  is 22
	sql_cursor_rollback_behavior :  INTEGER  is 24
	sql_expressions_in_orderby :  INTEGER  is 27
	sql_max_owner_name_len :  INTEGER  is 32
	sql_max_procedure_name_len :  INTEGER  is 33
	sql_max_qualifier_name_len :  INTEGER  is 34
	sql_mult_result_sets : INTEGER is 36
	sql_multiple_active_txn :  INTEGER  is 37
	sql_outer_joins :  INTEGER  is 38
	sql_owner_term :  INTEGER  is 39
	sql_procedure_term :  INTEGER  is 40
	sql_qualifier_name_separator :  INTEGER  is 41
	sql_qualifier_term :  INTEGER  is 42
	sql_scroll_options :  INTEGER  is 44
	sql_table_term :  INTEGER  is 45
	sql_convert_functions :  INTEGER  is 48
	sql_numeric_functions :  INTEGER  is 49
	sql_string_functions :  INTEGER  is 50
	sql_system_functions :  INTEGER  is 51
	sql_timedate_functions :  INTEGER  is 52
	sql_convert_bigint :  INTEGER  is 53
	sql_convert_binary :  INTEGER  is 54
	sql_convert_bit :  INTEGER  is 55
	sql_convert_char :  INTEGER  is 56
	sql_convert_date :  INTEGER  is 57
	sql_convert_decimal :  INTEGER  is 58
	sql_convert_double :  INTEGER  is 59
	sql_convert_float :  INTEGER  is 60
	sql_convert_integer :  INTEGER  is 61
	sql_convert_longvarchar :  INTEGER  is 62
	sql_convert_numeric :  INTEGER  is 63
	sql_convert_real :  INTEGER  is 64
	sql_convert_smallint :  INTEGER  is 65
	sql_convert_time :  INTEGER  is 66
	sql_convert_timestamp :  INTEGER  is 67
	sql_convert_tinyint :  INTEGER  is 68
	sql_convert_varbinary :  INTEGER  is 69
	sql_convert_varchar :  INTEGER  is 70
	sql_convert_longvarbinary :  INTEGER  is 71
	sql_odbc_sql_opt_ief :  INTEGER  is 73
	sql_correlation_name :  INTEGER  is 74
	sql_non_nullable_columns :  INTEGER  is 75
	sql_driver_hlib :  INTEGER  is 76
	sql_driver_odbc_ver :  INTEGER  is 77
	sql_lock_types :  INTEGER  is 78
	sql_pos_operations :  INTEGER  is 79
	sql_positioned_statements :  INTEGER  is 80
	sql_bookmark_persistence :  INTEGER  is 82
	sql_static_sensitivity :  INTEGER  is 83
	sql_file_usage :  INTEGER  is 84
	sql_column_alias :  INTEGER  is 87
	sql_group_by :  INTEGER  is 88
	sql_keywords :  INTEGER  is 89
	sql_owner_usage :  INTEGER  is 91
	sql_qualifier_usage :  INTEGER  is 92
	sql_quoted_identifier_case :  INTEGER  is 93
	sql_subqueries :  INTEGER  is 95
	sql_union :  INTEGER  is 96
	sql_max_row_size_includes_long :  INTEGER  is 103
	sql_max_char_literal_len :  INTEGER  is 108
	sql_timedate_add_intervals :  INTEGER  is 109
	sql_timedate_diff_intervals :  INTEGER  is 110
	sql_need_long_data_len : INTEGER is 111
	sql_max_binary_literal_len :  INTEGER  is 112
	sql_like_escape_clause :  INTEGER  is 113
	sql_qualifier_location :  INTEGER  is 114

feature -- Constants -- SQLGetInfo values not part of X/Open standard

	sql_active_environments :  INTEGER  is 116
	sql_alter_domain :  INTEGER  is 117
	
	sql_sql_conformance :  INTEGER  is 118
	sql_datetime_literals :  INTEGER  is 119
	
	sql_async_mode :  INTEGER  is 10021
	sql_batch_row_count :  INTEGER  is 120
	sql_batch_support :  INTEGER  is 121
	sql_catalog_location : integer is do result := sql_qualifier_location end 
	sql_catalog_name_separator	: INTEGER is do Result := sql_qualifier_name_separator end
	sql_catalog_term : INTEGER is do Result := sql_qualifier_term end
	sql_catalog_usage : INTEGER is do Result := sql_qualifier_usage end
	sql_convert_wchar :  INTEGER  is 122
	sql_convert_interval_day_time :  INTEGER  is 123
	sql_convert_interval_year_month :  INTEGER  is 124
	sql_convert_wlongvarchar :  INTEGER  is 125
	sql_convert_wvarchar :  INTEGER  is 126
	sql_create_assertion :  INTEGER  is 127
	sql_create_character_set :  INTEGER  is 128
	sql_create_collation :  INTEGER  is 129
	sql_create_domain :  INTEGER  is 130
	sql_create_schema :  INTEGER  is 131
	sql_create_table :  INTEGER  is 132
	sql_create_translation :  INTEGER  is 133
	sql_create_view :  INTEGER  is 134
	sql_driver_hdesc :  INTEGER  is 135
	sql_drop_assertion :  INTEGER  is 136
	sql_drop_character_set :  INTEGER  is 137
	sql_drop_collation :  INTEGER  is 138
	sql_drop_domain :  INTEGER  is 139
	sql_drop_schema :  INTEGER  is 140
	sql_drop_table :  INTEGER  is 141
	sql_drop_translation :  INTEGER  is 142
	sql_drop_view :  INTEGER  is 143
	sql_dynamic_cursor_attributes1 : INTEGER is	144
	sql_dynamic_cursor_attributes2 : INTEGER is	145
	sql_forward_only_cursor_attributes1 : INTEGER is	146	
	sql_forward_only_cursor_attributes2 : INTEGER is	147
	sql_index_keywords :  INTEGER  is 148
	sql_info_schema_views :  INTEGER  is 149
	sql_keyset_cursor_attributes1 : INTEGER is	150
	sql_keyset_cursor_attributes2 : INTEGER is	151
	sql_max_async_concurrent_statements :  INTEGER  is 10022
	sql_odbc_interface_conformance :  INTEGER  is 152
	sql_param_array_row_counts :  INTEGER  is 153
	sql_param_array_selects :  INTEGER  is 154
	sql_schema_term : INTEGER is	do Result := sql_owner_term end
	sql_schema_usage : INTEGER is	do Result := sql_owner_usage end
	sql_sql92_datetime_functions : INTEGER is	155
	sql_sql92_foreign_key_delete_rule : INTEGER is	156	
	sql_sql92_foreign_key_update_rule : INTEGER is	157	
	sql_sql92_grant : INTEGER is	158
	sql_sql92_numeric_value_functions : INTEGER is	159
	sql_sql92_predicates : INTEGER is	160
	sql_sql92_relational_join_operators : INTEGER is	161
	sql_sql92_revoke : INTEGER is	162
	sql_sql92_row_value_constructor : INTEGER is	163
	sql_sql92_string_functions : INTEGER is	164
	sql_sql92_value_expressions : INTEGER is	165
	sql_standard_cli_conformance :  INTEGER  is 166
	sql_static_cursor_attributes1 : INTEGER is	167	
	sql_static_cursor_attributes2 : INTEGER is	168
	
	sql_aggregate_functions :  INTEGER  is 169
	sql_ddl_index :  INTEGER  is 170
	sql_dm_ver :  INTEGER  is 171
	sql_insert_statement :  INTEGER  is 172
	sql_convert_guid :  INTEGER  is 173
	sql_union_statement : integer is do result := sql_union end 
	
	sql_dtc_transition_cost :  INTEGER  is 1750

feature -- Constants -- Alter table

	sql_at_add_column :  INTEGER  is 0x00000001
	sql_at_drop_column :  INTEGER  is 0x00000002
	sql_at_add_constraint :  INTEGER  is 0x00000008
	
	sql_at_add_column_single :  INTEGER  is 0x00000020
	sql_at_add_column_default :  INTEGER  is 0x00000040
	sql_at_add_column_collation :  INTEGER  is 0x00000080
	sql_at_set_column_default :  INTEGER  is 0x00000100
	sql_at_drop_column_default :  INTEGER  is 0x00000200
	sql_at_drop_column_cascade :  INTEGER  is 0x00000400
	sql_at_drop_column_restrict :  INTEGER  is 0x00000800
	sql_at_add_table_constraint :  INTEGER  is 0x00001000
	sql_at_drop_table_constraint_cascade :  INTEGER  is 0x00002000
	sql_at_drop_table_constraint_restrict :  INTEGER  is 0x00004000
	sql_at_constraint_name_definition :  INTEGER  is 0x00008000
	sql_at_constraint_initially_deferred :  INTEGER  is 0x00010000
	sql_at_constraint_initially_immediate :  INTEGER  is 0x00020000
	sql_at_constraint_deferrable :  INTEGER  is 0x00040000
	sql_at_constraint_non_deferrable :  INTEGER  is 0x00080000

feature -- Constants -- Cursor commit behavior

	sql_cb_delete :  INTEGER  is 0
	sql_cb_close :  INTEGER  is 1
	sql_cb_preserve :  INTEGER  is 2

feature -- Constants -- Fetch direction

	sql_fd_fetch_next :  INTEGER  is 0x00000001
	sql_fd_fetch_first :  INTEGER  is 0x00000002
	sql_fd_fetch_last :  INTEGER  is 0x00000004
	sql_fd_fetch_prior :  INTEGER  is 0x00000008
	sql_fd_fetch_absolute :  INTEGER  is 0x00000010
	sql_fd_fetch_relative :  INTEGER  is 0x00000020

feature -- Constants -- GetData extensions

	sql_gd_any_column :  INTEGER  is 0x00000001
	sql_gd_any_order :  INTEGER  is 0x00000002

feature -- Constants -- Identifier case

	sql_ic_upper :  INTEGER  is 1
	sql_ic_lower :  INTEGER  is 2
	sql_ic_sensitive :  INTEGER  is 3
	sql_ic_mixed :  INTEGER  is 4

feature -- Constants -- Null collation

	sql_nc_high :  INTEGER  is 0
	sql_nc_low :  INTEGER  is 1

feature -- Constants -- Outer joins

	sql_oj_left :  INTEGER  is 0x00000001
	sql_oj_right :  INTEGER  is 0x00000002
	sql_oj_full :  INTEGER  is 0x00000004
	sql_oj_nested :  INTEGER  is 0x00000008
	sql_oj_not_ordered :  INTEGER  is 0x00000010
	sql_oj_inner :  INTEGER  is 0x00000020
	sql_oj_all_comparison_ops :  INTEGER  is 0x00000040

feature -- Constants -- Scroll concurrency 

	sql_scco_read_only :  INTEGER  is 0x00000001
	sql_scco_lock :  INTEGER  is 0x00000002
	sql_scco_opt_rowver :  INTEGER  is 0x00000004
	sql_scco_opt_values :  INTEGER  is 0x00000008

feature -- Constants -- TXN capability

	sql_tc_none :  INTEGER  is 0
	sql_tc_dml :  INTEGER  is 1
	sql_tc_all :  INTEGER  is 2
	sql_tc_ddl_commit :  INTEGER  is 3
	sql_tc_ddl_ignore :  INTEGER  is 4

feature -- Constants -- Transaction isolation options

	sql_txn_read_uncommitted :  INTEGER  is 0x00000001
	sql_transaction_read_uncommitted : integer is do result := sql_txn_read_uncommitted end 
	sql_txn_read_committed :  INTEGER  is 0x00000002
	sql_transaction_read_committed : integer is do result := sql_txn_read_committed end 
	sql_txn_repeatable_read :  INTEGER  is 0x00000004
	sql_transaction_repeatable_read : integer is do result := sql_txn_repeatable_read end 
	sql_txn_serializable :  INTEGER  is 0x00000008
	sql_transaction_serializable : integer is do result := sql_txn_serializable end 

feature -- Constants -- conversion

	sql_cvt_char :  INTEGER  is 0x00000001
	sql_cvt_numeric :  INTEGER  is 0x00000002
	sql_cvt_decimal :  INTEGER  is 0x00000004
	sql_cvt_integer :  INTEGER  is 0x00000008
	sql_cvt_smallint :  INTEGER  is 0x00000010
	sql_cvt_float :  INTEGER  is 0x00000020
	sql_cvt_real :  INTEGER  is 0x00000040
	sql_cvt_double :  INTEGER  is 0x00000080
	sql_cvt_varchar :  INTEGER  is 0x00000100
	sql_cvt_longvarchar :  INTEGER  is 0x00000200
	sql_cvt_binary :  INTEGER  is 0x00000400
	sql_cvt_varbinary :  INTEGER  is 0x00000800
	sql_cvt_bit :  INTEGER  is 0x00001000
	sql_cvt_tinyint :  INTEGER  is 0x00002000
	sql_cvt_bigint :  INTEGER  is 0x00004000
	sql_cvt_date :  INTEGER  is 0x00008000
	sql_cvt_time :  INTEGER  is 0x00010000
	sql_cvt_timestamp :  INTEGER  is 0x00020000
	sql_cvt_longvarbinary :  INTEGER  is 0x00040000
	
	sql_cvt_interval_year_month :  INTEGER  is 0x00080000
	sql_cvt_interval_day_time :  INTEGER  is 0x00100000
	sql_cvt_wchar :  INTEGER  is 0x00200000
	sql_cvt_wlongvarchar :  INTEGER  is 0x00400000
	sql_cvt_wvarchar :  INTEGER  is 0x00800000
	sql_cvt_guid :  INTEGER  is 0x01000000
	
feature -- Constants -- Convert functions

	sql_fn_cvt_convert :  INTEGER  is 0x00000001
	sql_fn_cvt_cast :  INTEGER  is 0x00000002
	
feature -- Constants -- String functions

	sql_fn_str_concat :  INTEGER  is 0x00000001
	sql_fn_str_insert :  INTEGER  is 0x00000002
	sql_fn_str_left :  INTEGER  is 0x00000004
	sql_fn_str_ltrim :  INTEGER  is 0x00000008
	sql_fn_str_length :  INTEGER  is 0x00000010
	sql_fn_str_locate :  INTEGER  is 0x00000020
	sql_fn_str_lcase :  INTEGER  is 0x00000040
	sql_fn_str_repeat :  INTEGER  is 0x00000080
	sql_fn_str_replace :  INTEGER  is 0x00000100
	sql_fn_str_right :  INTEGER  is 0x00000200
	sql_fn_str_rtrim :  INTEGER  is 0x00000400
	sql_fn_str_substring :  INTEGER  is 0x00000800
	sql_fn_str_ucase :  INTEGER  is 0x00001000
	sql_fn_str_ascii :  INTEGER  is 0x00002000
	sql_fn_str_char :  INTEGER  is 0x00004000
	sql_fn_str_difference :  INTEGER  is 0x00008000
	sql_fn_str_locate_2 : integer is 0x00010000
	sql_fn_str_soundex :  INTEGER  is 0x00020000
	sql_fn_str_space :  INTEGER  is 0x00040000
	sql_fn_str_bit_length :  INTEGER  is 0x00080000
	sql_fn_str_char_length :  INTEGER  is 0x00100000
	sql_fn_str_character_length :  INTEGER  is 0x00200000
	sql_fn_str_octet_length :  INTEGER  is 0x00400000
	sql_fn_str_position :  INTEGER  is 0x00800000

feature -- Constants -- SQL92 String functions

	sql_ssf_convert :  INTEGER  is 0x00000001
	sql_ssf_lower :  INTEGER  is 0x00000002
	sql_ssf_upper :  INTEGER  is 0x00000004
	sql_ssf_substring :  INTEGER  is 0x00000008
	sql_ssf_translate :  INTEGER  is 0x00000010
	sql_ssf_trim_both :  INTEGER  is 0x00000020
	sql_ssf_trim_leading :  INTEGER  is 0x00000040
	sql_ssf_trim_trailing :  INTEGER  is 0x00000080

feature -- Constants -- SQL Numeric functions

	sql_fn_num_abs :  INTEGER  is 0x00000001
	sql_fn_num_acos :  INTEGER  is 0x00000002
	sql_fn_num_asin :  INTEGER  is 0x00000004
	sql_fn_num_atan :  INTEGER  is 0x00000008
	sql_fn_num_atan2 : integer is 0x00000010
	sql_fn_num_ceiling :  INTEGER  is 0x00000020
	sql_fn_num_cos :  INTEGER  is 0x00000040
	sql_fn_num_cot :  INTEGER  is 0x00000080
	sql_fn_num_exp :  INTEGER  is 0x00000100
	sql_fn_num_floor :  INTEGER  is 0x00000200
	sql_fn_num_log :  INTEGER  is 0x00000400
	sql_fn_num_mod :  INTEGER  is 0x00000800
	sql_fn_num_sign :  INTEGER  is 0x00001000
	sql_fn_num_sin :  INTEGER  is 0x00002000
	sql_fn_num_sqrt :  INTEGER  is 0x00004000
	sql_fn_num_tan :  INTEGER  is 0x00008000
	sql_fn_num_pi :  INTEGER  is 0x00010000
	sql_fn_num_rand :  INTEGER  is 0x00020000
	sql_fn_num_degrees :  INTEGER  is 0x00040000
	sql_fn_num_log10 : integer is 0x00080000
	sql_fn_num_power :  INTEGER  is 0x00100000
	sql_fn_num_radians :  INTEGER  is 0x00200000
	sql_fn_num_round :  INTEGER  is 0x00400000
	sql_fn_num_truncate :  INTEGER  is 0x00800000

feature -- Constants -- SQL92 Numeric value functions

	sql_snvf_bit_length :  INTEGER  is 0x00000001
	sql_snvf_char_length :  INTEGER  is 0x00000002
	sql_snvf_character_length :  INTEGER  is 0x00000004
	sql_snvf_extract :  INTEGER  is 0x00000008
	sql_snvf_octet_length :  INTEGER  is 0x00000010
	sql_snvf_position :  INTEGER  is 0x00000020

feature -- Constants -- TimeDate functions

	sql_fn_td_now :  INTEGER  is 0x00000001
	sql_fn_td_curdate :  INTEGER  is 0x00000002
	sql_fn_td_dayofmonth :  INTEGER  is 0x00000004
	sql_fn_td_dayofweek :  INTEGER  is 0x00000008
	sql_fn_td_dayofyear :  INTEGER  is 0x00000010
	sql_fn_td_month :  INTEGER  is 0x00000020
	sql_fn_td_quarter :  INTEGER  is 0x00000040
	sql_fn_td_week :  INTEGER  is 0x00000080
	sql_fn_td_year :  INTEGER  is 0x00000100
	sql_fn_td_curtime :  INTEGER  is 0x00000200
	sql_fn_td_hour :  INTEGER  is 0x00000400
	sql_fn_td_minute :  INTEGER  is 0x00000800
	sql_fn_td_second :  INTEGER  is 0x00001000
	sql_fn_td_timestampadd :  INTEGER  is 0x00002000
	sql_fn_td_timestampdiff :  INTEGER  is 0x00004000
	sql_fn_td_dayname :  INTEGER  is 0x00008000
	sql_fn_td_monthname :  INTEGER  is 0x00010000
	sql_fn_td_current_date :  INTEGER  is 0x00020000
	sql_fn_td_current_time :  INTEGER  is 0x00040000
	sql_fn_td_current_timestamp :  INTEGER  is 0x00080000
	sql_fn_td_extract :  INTEGER  is 0x00100000

feature -- Constants -- SQL92 DATETIME functions

	sql_sdf_current_date :  INTEGER  is 0x00000001
	sql_sdf_current_time :  INTEGER  is 0x00000002
	sql_sdf_current_timestamp :  INTEGER  is 0x00000004

feature -- Constants -- SQL System functions

	sql_fn_sys_username :  INTEGER  is 0x00000001
	sql_fn_sys_dbname :  INTEGER  is 0x00000002
	sql_fn_sys_ifnull :  INTEGER  is 0x00000004


feature -- Constants -- TIMEDATE Add/Diff functions

	sql_fn_tsi_frac_second :  INTEGER  is 0x00000001
	sql_fn_tsi_second :  INTEGER  is 0x00000002
	sql_fn_tsi_minute :  INTEGER  is 0x00000004
	sql_fn_tsi_hour :  INTEGER  is 0x00000008
	sql_fn_tsi_day :  INTEGER  is 0x00000010
	sql_fn_tsi_week :  INTEGER  is 0x00000020
	sql_fn_tsi_month :  INTEGER  is 0x00000040
	sql_fn_tsi_quarter :  INTEGER  is 0x00000080
	sql_fn_tsi_year :  INTEGER  is 0x00000100

feature -- Constants -- Cursor and keyset attribute values (SQL_DYNAMIC_CURSOR_ATTRIBUTES1, SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1, SQL_KEYSET_CURSOR_ATTRIBUTES1, and SQL_STATIC_CURSOR_ATTRIBUTES1 

	sql_ca1_next : integer is 0x00000001
	sql_ca1_absolute : integer is 0x00000002
	sql_ca1_relative : integer is 0x00000004
	sql_ca1_bookmark : integer is 0x00000008

--/* supported SQLSetPos LockType's 
	sql_ca1_lock_no_change : integer is 0x00000040
	sql_ca1_lock_exclusive : integer is 0x00000080
	sql_ca1_lock_unlock : integer is 0x00000100

--/* supported SQLSetPos Operations 
	sql_ca1_pos_position : integer is 0x00000200
	sql_ca1_pos_update : integer is 0x00000400
	sql_ca1_pos_delete : integer is 0x00000800
	sql_ca1_pos_refresh : integer is 0x00001000

--/* positioned updates and deletes 
	sql_ca1_positioned_update : integer is 0x00002000
	sql_ca1_positioned_delete : integer is 0x00004000
	sql_ca1_select_for_update : integer is 0x00008000

--/* supported SQLBulkOperations operations 
	sql_ca1_bulk_add : integer is 0x00010000
	sql_ca1_bulk_update_by_bookmark : integer is 0x00020000
	sql_ca1_bulk_delete_by_bookmark : integer is 0x00040000
	sql_ca1_bulk_fetch_by_bookmark : integer is 0x00080000

--/* bitmasks for SQL_DYNAMIC_CURSOR_ATTRIBUTES2,
-- * SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2, 
-- * SQL_KEYSET_CURSOR_ATTRIBUTES2, and SQL_STATIC_CURSOR_ATTRIBUTES2 
-- 
--#if (ODBCVER >= 0x0300)
--/* supported values for SQL_ATTR_SCROLL_CONCURRENCY 
	sql_ca2_read_only_concurrency : integer is 0x00000001
	sql_ca2_lock_concurrency : integer is 0x00000002
	sql_ca2_opt_rowver_concurrency : integer is 0x00000004
	sql_ca2_opt_values_concurrency : integer is 0x00000008

--/* sensitivity of the cursor to its own inserts, deletes, and updates 
	sql_ca2_sensitivity_additions : integer is 0x00000010
	sql_ca2_sensitivity_deletions : integer is 0x00000020
	sql_ca2_sensitivity_updates : integer is 0x00000040

--/* semantics of SQL_ATTR_MAX_ROWS 
	sql_ca2_max_rows_select : integer is 0x00000080
	sql_ca2_max_rows_insert : integer is 0x00000100
	sql_ca2_max_rows_delete : integer is 0x00000200
	sql_ca2_max_rows_update : integer is 0x00000400
	sql_ca2_max_rows_catalog : integer is 0x00000800
sql_ca2_max_rows_affects_all : INTEGER is do	
		Result := u_or (sql_ca2_max_rows_select,
				  u_or (sql_ca2_max_rows_insert,
				  u_or (sql_ca2_max_rows_delete,
				  u_or (sql_ca2_max_rows_update, sql_ca2_max_rows_catalog))))
		end
		
--/* semantics of SQL_DIAG_CURSOR_ROW_COUNT 
	sql_ca2_crc_exact : integer is 0x00001000
	sql_ca2_crc_approximate : integer is 0x00002000

--/* the kinds of positioned statements that can be simulated 
	sql_ca2_simulate_non_unique : integer is 0x00004000
	sql_ca2_simulate_try_unique : integer is 0x00008000
	sql_ca2_simulate_unique : integer is 0x00010000


feature -- Constants -- ODBC API Conformance values
	
	sql_oac_none :  INTEGER  is 0x0000
	sql_oac_level1 : integer is 0x0001
	sql_oac_level2 : integer is 0x0002
	
feature -- Constants -- SQL_ODBC_SAG_CLI_CONFORMANCE values 

	sql_oscc_not_compliant :  INTEGER  is 0x0000
	sql_oscc_compliant :  INTEGER  is 0x0001

feature -- Constants -- SQL_ODBC_SQL_CONFORMANCE values 

	sql_osc_minimum :  INTEGER  is 0x0000
	sql_osc_core :  INTEGER  is 0x0001
	sql_osc_extended :  INTEGER  is 0x0002


feature -- Constants -- SQL_CONCAT_NULL_BEHAVIOR values 

	sql_cb_null :  INTEGER  is 0x0000
	sql_cb_non_null :  INTEGER  is 0x0001

feature -- Constants -- SQL_SCROLL_OPTIONS masks

	sql_so_forward_only :  INTEGER  is 0x00000001
	sql_so_keyset_driven :  INTEGER  is 0x00000002
	sql_so_dynamic :  INTEGER  is 0x00000004
	sql_so_mixed :  INTEGER  is 0x00000008
	sql_so_static :  INTEGER  is 0x00000010

feature -- Constants -- SQL_FETCH_DIRECTION masks

--/* SQL_FETCH_RESUME is no longer supported
sql_fd_fetch_resume :  INTEGER  is 0x00000040
--
sql_fd_fetch_bookmark :  INTEGER  is 0x00000080

feature -- Constants -- SQL_TXN_ISOLATION_OPTION masks
--/* SQL_TXN_VERSIONING is no longer supported
sql_txn_versioning :  INTEGER  is 0x00000010
--

feature -- Constants -- SQL_CORRELATION_NAME values 

sql_cn_none :  INTEGER  is 0x0000
sql_cn_different :  INTEGER  is 0x0001
sql_cn_any :  INTEGER  is 0x0002

feature -- Constants -- SQL_NON_NULLABLE_COLUMNS values 

sql_nnc_null :  INTEGER  is 0x0000
sql_nnc_non_null :  INTEGER  is 0x0001

feature -- Constants -- SQL_NULL_COLLATION values 

sql_nc_start :  INTEGER  is 0x0002
sql_nc_end :  INTEGER  is 0x0004

feature -- Constants -- SQL_FILE_USAGE values 

sql_file_not_supported :  INTEGER  is 0x0000
sql_file_table :  INTEGER  is 0x0001
sql_file_qualifier :  INTEGER  is 0x0002
sql_file_catalog : integer is do result := sql_file_qualifier end


feature -- Constants -- SQL_GETDATA_EXTENSIONS values 

sql_gd_block :  INTEGER  is 0x00000004
sql_gd_bound :  INTEGER  is 0x00000008

feature -- Constants -- SQL_POSITIONED_STATEMENTS masks

sql_ps_positioned_delete :  INTEGER  is 0x00000001
sql_ps_positioned_update :  INTEGER  is 0x00000002
sql_ps_select_for_update :  INTEGER  is 0x00000004

feature -- Constants -- SQL_GROUP_BY values 

sql_gb_not_supported :  INTEGER  is 0x0000
sql_gb_group_by_equals_select :  INTEGER  is 0x0001
sql_gb_group_by_contains_select :  INTEGER  is 0x0002
sql_gb_no_relation :  INTEGER  is 0x0003
--#if (ODBCVER >= 0x0300)
sql_gb_collate :  INTEGER  is 0x0004

--#endif /* ODBCVER >= 0x0300 

feature -- Constants -- SQL_OWNER_USAGE masks

sql_ou_dml_statements :  INTEGER  is 0x00000001
sql_ou_procedure_invocation :  INTEGER  is 0x00000002
sql_ou_table_definition :  INTEGER  is 0x00000004
sql_ou_index_definition :  INTEGER  is 0x00000008
sql_ou_privilege_definition :  INTEGER  is 0x00000010

feature -- Constants -- SQL_SCHEMA_USAGE masks
--#if (ODBCVER >= 0x0300)
sql_su_dml_statements : integer is do result := sql_ou_dml_statements end  
sql_su_procedure_invocation : integer is do result := sql_ou_procedure_invocation end 
sql_su_table_definition : integer is do result := sql_ou_table_definition end 
sql_su_index_definition : integer is do result := sql_ou_index_definition end 
sql_su_privilege_definition : integer is do result := sql_ou_privilege_definition end 
--#endif /* ODBCVER >= 0x0300 

feature -- Constants -- SQL_QUALIFIER_USAGE masks

sql_qu_dml_statements :  INTEGER  is 0x00000001
sql_qu_procedure_invocation :  INTEGER  is 0x00000002
sql_qu_table_definition :  INTEGER  is 0x00000004
sql_qu_index_definition :  INTEGER  is 0x00000008
sql_qu_privilege_definition :  INTEGER  is 0x00000010

--#if (ODBCVER >= 0x0300)
feature -- Constants -- SQL_CATALOG_USAGE masks
sql_cu_dml_statements : integer is do result := sql_qu_dml_statements end 
sql_cu_procedure_invocation : integer is do result := sql_qu_procedure_invocation end  
sql_cu_table_definition : integer is do result := sql_qu_table_definition end 
sql_cu_index_definition : integer is do result := sql_qu_index_definition end  
sql_cu_privilege_definition : integer is do result := sql_qu_privilege_definition end  
--#endif /* ODBCVER >= 0x0300 

feature -- Constants -- SQL_SUBQUERIES masks

sql_sq_comparison :  INTEGER  is 0x00000001
sql_sq_exists :  INTEGER  is 0x00000002
sql_sq_in :  INTEGER  is 0x00000004
sql_sq_quantified :  INTEGER  is 0x00000008
sql_sq_correlated_subqueries :  INTEGER  is 0x00000010

feature -- Constants -- SQL_UNION masks

sql_u_union :  INTEGER  is 0x00000001
sql_u_union_all :  INTEGER  is 0x00000002

feature -- Constants -- SQL_BOOKMARK_PERSISTENCE values 

sql_bp_close :  INTEGER  is 0x00000001
sql_bp_delete :  INTEGER  is 0x00000002
sql_bp_drop :  INTEGER  is 0x00000004
sql_bp_transaction :  INTEGER  is 0x00000008
sql_bp_update :  INTEGER  is 0x00000010
sql_bp_other_hstmt :  INTEGER  is 0x00000020
sql_bp_scroll :  INTEGER  is 0x00000040

feature -- Constants -- SQL_STATIC_SENSITIVITY values 

sql_ss_additions :  INTEGER  is 0x00000001
sql_ss_deletions :  INTEGER  is 0x00000002
sql_ss_updates :  INTEGER  is 0x00000004

feature -- Constants -- SQL_VIEW values 
sql_cv_create_view :  INTEGER  is 0x00000001
sql_cv_check_option :  INTEGER  is 0x00000002
sql_cv_cascaded :  INTEGER  is 0x00000004
sql_cv_local :  INTEGER  is 0x00000008

feature -- Constants -- SQL_LOCK_TYPES masks

sql_lck_no_change :  INTEGER  is 0x00000001
sql_lck_exclusive :  INTEGER  is 0x00000002
sql_lck_unlock :  INTEGER  is 0x00000004

feature -- Constants -- SQL_POS_OPERATIONS masks

sql_pos_position :  INTEGER  is 0x00000001
sql_pos_refresh :  INTEGER  is 0x00000002
sql_pos_update :  INTEGER  is 0x00000004
sql_pos_delete :  INTEGER  is 0x00000008
sql_pos_add :  INTEGER  is 0x00000010

feature -- Constants -- SQL_QUALIFIER_LOCATION values 

sql_ql_start :  INTEGER  is 0x0001
sql_ql_end :  INTEGER  is 0x0002

--/* Here start return values for ODBC 3.0 SQLGetInfo 

--#if (ODBCVER >= 0x0300)
feature -- Constants -- SQL_AGGREGATE_FUNCTIONS bitmasks
sql_af_avg :  INTEGER  is 0x00000001
sql_af_count :  INTEGER  is 0x00000002
sql_af_max :  INTEGER  is 0x00000004
sql_af_min :  INTEGER  is 0x00000008
sql_af_sum :  INTEGER  is 0x00000010
sql_af_distinct :  INTEGER  is 0x00000020
sql_af_all :  INTEGER  is 0x00000040

feature -- Constants -- SQL_CONFORMANCE bit masks
sql_sc_sql92_entry : integer is 0x00000001
sql_sc_fips127_2_transitional : integer is 0x00000002
sql_sc_sql92_intermediate : integer is 0x00000004
sql_sc_sql92_full : integer is 0x00000008

feature -- Constants -- SQL_DATETIME_LITERALS masks
sql_dl_sql92_date : integer is 0x00000001
sql_dl_sql92_time : integer is 0x00000002
sql_dl_sql92_timestamp : integer is 0x00000004
sql_dl_sql92_interval_year : integer is 0x00000008
sql_dl_sql92_interval_month : integer is 0x00000010
sql_dl_sql92_interval_day : integer is 0x00000020
sql_dl_sql92_interval_hour : integer is 0x00000040
sql_dl_sql92_interval_minute : integer is 0x00000080
sql_dl_sql92_interval_second : integer is 0x00000100
sql_dl_sql92_interval_year_to_month : integer is 0x00000200
sql_dl_sql92_interval_day_to_hour : integer is 0x00000400
sql_dl_sql92_interval_day_to_minute : integer is 0x00000800
sql_dl_sql92_interval_day_to_second : integer is 0x00001000
sql_dl_sql92_interval_hour_to_minute : integer is 0x00002000
sql_dl_sql92_interval_hour_to_second : integer is 0x00004000
sql_dl_sql92_interval_minute_to_second : integer is 0x00008000

feature -- Constants -- SQL_CATALOG_LOCATION values 
sql_cl_start : integer is do result := sql_ql_start end 
sql_cl_end : integer is do result := sql_ql_end end 

feature -- Constants -- SQL_BATCH_ROW_COUNT 
sql_brc_procedures :  INTEGER  is 0x0000001
sql_brc_explicit :  INTEGER  is 0x0000002
sql_brc_rolled_up :  INTEGER  is 0x0000004

feature -- Constants -- SQL_BATCH_SUPPORT 
sql_bs_select_explicit :  INTEGER  is 0x00000001
sql_bs_row_count_explicit :  INTEGER  is 0x00000002
sql_bs_select_proc :  INTEGER  is 0x00000004
sql_bs_row_count_proc :  INTEGER  is 0x00000008

feature -- Constants -- SQL_PARAM_ARRAY_ROW_COUNTS getinfo 
sql_parc_batch :  INTEGER  is 1
sql_parc_no_batch :  INTEGER  is 2

feature -- Constants -- SQL_PARAM_ARRAY_SELECTS 
sql_pas_batch :  INTEGER  is 1
sql_pas_no_batch :  INTEGER  is 2
sql_pas_no_select :  INTEGER  is 3

feature -- Constants -- SQL_INDEX_KEYWORDS 
sql_ik_none :  INTEGER  is 0x00000000
sql_ik_asc :  INTEGER  is 0x00000001
sql_ik_desc :  INTEGER  is 0x00000002
--#define SQL_IK_ALL	(SQL_IK_ASC | SQL_IK_DESC)

feature -- Constants -- Bitmasks for SQL_INFO_SCHEMA_VIEWS

sql_isv_assertions :  INTEGER  is 0x00000001
sql_isv_character_sets :  INTEGER  is 0x00000002
sql_isv_check_constraints :  INTEGER  is 0x00000004
sql_isv_collations :  INTEGER  is 0x00000008
sql_isv_column_domain_usage :  INTEGER  is 0x00000010
sql_isv_column_privileges :  INTEGER  is 0x00000020
sql_isv_columns :  INTEGER  is 0x00000040
sql_isv_constraint_column_usage :  INTEGER  is 0x00000080
sql_isv_constraint_table_usage :  INTEGER  is 0x00000100
sql_isv_domain_constraints :  INTEGER  is 0x00000200
sql_isv_domains :  INTEGER  is 0x00000400
sql_isv_key_column_usage :  INTEGER  is 0x00000800
sql_isv_referential_constraints :  INTEGER  is 0x00001000
sql_isv_schemata :  INTEGER  is 0x00002000
sql_isv_sql_languages :  INTEGER  is 0x00004000
sql_isv_table_constraints :  INTEGER  is 0x00008000
sql_isv_table_privileges :  INTEGER  is 0x00010000
sql_isv_tables :  INTEGER  is 0x00020000
sql_isv_translations :  INTEGER  is 0x00040000
sql_isv_usage_privileges :  INTEGER  is 0x00080000
sql_isv_view_column_usage :  INTEGER  is 0x00100000
sql_isv_view_table_usage :  INTEGER  is 0x00200000
sql_isv_views :  INTEGER  is 0x00400000

feature -- Constants -- Bitmasks for SQL_ASYNC_MODE

sql_am_none :  INTEGER  is 0
sql_am_connection :  INTEGER  is 1
sql_am_statement :  INTEGER  is 2

feature -- Constants -- Bitmasks for SQL_ALTER_DOMAIN
sql_ad_constraint_name_definition :  INTEGER  is 0x00000001
sql_ad_add_domain_constraint :  INTEGER  is 0x00000002
sql_ad_drop_domain_constraint :  INTEGER  is 0x00000004
sql_ad_add_domain_default :  INTEGER  is 0x00000008
sql_ad_drop_domain_default :  INTEGER  is 0x00000010
sql_ad_add_constraint_initially_deferred :  INTEGER  is 0x00000020
sql_ad_add_constraint_initially_immediate :  INTEGER  is 0x00000040
sql_ad_add_constraint_deferrable :  INTEGER  is 0x00000080
sql_ad_add_constraint_non_deferrable :  INTEGER  is 0x00000100


feature -- Constants -- SQL_CREATE_SCHEMA bitmasks
sql_cs_create_schema :  INTEGER  is 0x00000001
sql_cs_authorization :  INTEGER  is 0x00000002
sql_cs_default_character_set :  INTEGER  is 0x00000004

feature -- Constants -- SQL_CREATE_TRANSLATION bitmasks
sql_ctr_create_translation :  INTEGER  is 0x00000001

feature -- Constants -- SQL_CREATE_ASSERTION bitmasks
sql_ca_create_assertion :  INTEGER  is 0x00000001
sql_ca_constraint_initially_deferred :  INTEGER  is 0x00000010
sql_ca_constraint_initially_immediate :  INTEGER  is 0x00000020
sql_ca_constraint_deferrable :  INTEGER  is 0x00000040
sql_ca_constraint_non_deferrable :  INTEGER  is 0x00000080

feature -- Constants -- SQL_CREATE_CHARACTER_SET bitmasks
sql_ccs_create_character_set :  INTEGER  is 0x00000001
sql_ccs_collate_clause :  INTEGER  is 0x00000002
sql_ccs_limited_collation :  INTEGER  is 0x00000004

feature -- Constants -- SQL_CREATE_COLLATION bitmasks
sql_ccol_create_collation :  INTEGER  is 0x00000001

feature -- Constants -- SQL_CREATE_DOMAIN bitmasks
sql_cdo_create_domain :  INTEGER  is 0x00000001
sql_cdo_default :  INTEGER  is 0x00000002
sql_cdo_constraint :  INTEGER  is 0x00000004
sql_cdo_collation :  INTEGER  is 0x00000008
sql_cdo_constraint_name_definition :  INTEGER  is 0x00000010
sql_cdo_constraint_initially_deferred :  INTEGER  is 0x00000020
sql_cdo_constraint_initially_immediate :  INTEGER  is 0x00000040
sql_cdo_constraint_deferrable :  INTEGER  is 0x00000080
sql_cdo_constraint_non_deferrable :  INTEGER  is 0x00000100

feature -- Constants -- SQL_CREATE_TABLE bitmasks
sql_ct_create_table :  INTEGER  is 0x00000001
sql_ct_commit_preserve :  INTEGER  is 0x00000002
sql_ct_commit_delete :  INTEGER  is 0x00000004
sql_ct_global_temporary :  INTEGER  is 0x00000008
sql_ct_local_temporary :  INTEGER  is 0x00000010
sql_ct_constraint_initially_deferred :  INTEGER  is 0x00000020
sql_ct_constraint_initially_immediate :  INTEGER  is 0x00000040
sql_ct_constraint_deferrable :  INTEGER  is 0x00000080
sql_ct_constraint_non_deferrable :  INTEGER  is 0x00000100
sql_ct_column_constraint :  INTEGER  is 0x00000200
sql_ct_column_default :  INTEGER  is 0x00000400
sql_ct_column_collation :  INTEGER  is 0x00000800
sql_ct_table_constraint :  INTEGER  is 0x00001000
sql_ct_constraint_name_definition :  INTEGER  is 0x00002000

feature -- Constants -- SQL_DDL_INDEX bitmasks
sql_di_create_index :  INTEGER  is 0x00000001
sql_di_drop_index :  INTEGER  is 0x00000002

feature -- Constants -- SQL_DROP_COLLATION bitmasks
sql_dc_drop_collation :  INTEGER  is 0x00000001

feature -- Constants -- SQL_DROP_DOMAIN bitmasks
sql_dd_drop_domain :  INTEGER  is 0x00000001
sql_dd_restrict :  INTEGER  is 0x00000002
sql_dd_cascade :  INTEGER  is 0x00000004

feature -- Constants -- SQL_DROP_SCHEMA bitmasks
sql_ds_drop_schema :  INTEGER  is 0x00000001
sql_ds_restrict :  INTEGER  is 0x00000002
sql_ds_cascade :  INTEGER  is 0x00000004

feature -- Constants -- SQL_DROP_CHARACTER_SET bitmasks
sql_dcs_drop_character_set :  INTEGER  is 0x00000001

feature -- Constants -- SQL_DROP_ASSERTION bitmasks
sql_da_drop_assertion :  INTEGER  is 0x00000001

feature -- Constants -- SQL_DROP_TABLE bitmasks
sql_dt_drop_table :  INTEGER  is 0x00000001
sql_dt_restrict :  INTEGER  is 0x00000002
sql_dt_cascade :  INTEGER  is 0x00000004

feature -- Constants -- SQL_DROP_TRANSLATION bitmasks
sql_dtr_drop_translation :  INTEGER  is 0x00000001

feature -- Constants -- SQL_DROP_VIEW bitmasks
sql_dv_drop_view :  INTEGER  is 0x00000001
sql_dv_restrict :  INTEGER  is 0x00000002
sql_dv_cascade :  INTEGER  is 0x00000004

feature -- Constants -- SQL_INSERT_STATEMENT bitmasks
sql_is_insert_literals :  INTEGER  is 0x00000001
sql_is_insert_searched :  INTEGER  is 0x00000002
sql_is_select_into :  INTEGER  is 0x00000004

feature -- Constants -- SQL_ODBC_INTERFACE_CONFORMANCE values 
sql_oic_core :  INTEGER  is 1
sql_oic_level1 : integer is 2
sql_oic_level2 : integer is 3

feature -- Constants -- SQL92_FOREIGN_KEY_DELETE_RULE bitmasks
sql_sfkd_cascade :  INTEGER  is 0x00000001
sql_sfkd_no_action :  INTEGER  is 0x00000002
sql_sfkd_set_default :  INTEGER  is 0x00000004
sql_sfkd_set_null :  INTEGER  is 0x00000008

feature -- Constants -- SQL92_FOREIGN_KEY_UPDATE_RULE bitmasks
sql_sfku_cascade :  INTEGER  is 0x00000001
sql_sfku_no_action :  INTEGER  is 0x00000002
sql_sfku_set_default :  INTEGER  is 0x00000004
sql_sfku_set_null :  INTEGER  is 0x00000008

feature -- Constants -- SQL92_GRANT	bitmasks
sql_sg_usage_on_domain :  INTEGER  is 0x00000001
sql_sg_usage_on_character_set :  INTEGER  is 0x00000002
sql_sg_usage_on_collation :  INTEGER  is 0x00000004
sql_sg_usage_on_translation :  INTEGER  is 0x00000008
sql_sg_with_grant_option :  INTEGER  is 0x00000010
sql_sg_delete_table :  INTEGER  is 0x00000020
sql_sg_insert_table :  INTEGER  is 0x00000040
sql_sg_insert_column :  INTEGER  is 0x00000080
sql_sg_references_table :  INTEGER  is 0x00000100
sql_sg_references_column :  INTEGER  is 0x00000200
sql_sg_select_table :  INTEGER  is 0x00000400
sql_sg_update_table :  INTEGER  is 0x00000800
sql_sg_update_column :  INTEGER  is 0x00001000

feature -- Constants -- SQL92_PREDICATES bitmasks
sql_sp_exists :  INTEGER  is 0x00000001
sql_sp_isnotnull :  INTEGER  is 0x00000002
sql_sp_isnull :  INTEGER  is 0x00000004
sql_sp_match_full :  INTEGER  is 0x00000008
sql_sp_match_partial :  INTEGER  is 0x00000010
sql_sp_match_unique_full :  INTEGER  is 0x00000020
sql_sp_match_unique_partial :  INTEGER  is 0x00000040
sql_sp_overlaps :  INTEGER  is 0x00000080
sql_sp_unique :  INTEGER  is 0x00000100
sql_sp_like :  INTEGER  is 0x00000200
sql_sp_in :  INTEGER  is 0x00000400
sql_sp_between :  INTEGER  is 0x00000800
sql_sp_comparison :  INTEGER  is 0x00001000
sql_sp_quantified_comparison :  INTEGER  is 0x00002000

feature -- Constants -- SQL92_RELATIONAL_JOIN_OPERATORS bitmasks
sql_srjo_corresponding_clause :  INTEGER  is 0x00000001
sql_srjo_cross_join :  INTEGER  is 0x00000002
sql_srjo_except_join :  INTEGER  is 0x00000004
sql_srjo_full_outer_join :  INTEGER  is 0x00000008
sql_srjo_inner_join :  INTEGER  is 0x00000010
sql_srjo_intersect_join :  INTEGER  is 0x00000020
sql_srjo_left_outer_join :  INTEGER  is 0x00000040
sql_srjo_natural_join :  INTEGER  is 0x00000080
sql_srjo_right_outer_join :  INTEGER  is 0x00000100
sql_srjo_union_join :  INTEGER  is 0x00000200

feature -- Constants -- SQL92_REVOKE bitmasks
sql_sr_usage_on_domain :  INTEGER  is 0x00000001
sql_sr_usage_on_character_set :  INTEGER  is 0x00000002
sql_sr_usage_on_collation :  INTEGER  is 0x00000004
sql_sr_usage_on_translation :  INTEGER  is 0x00000008
sql_sr_grant_option_for :  INTEGER  is 0x00000010
sql_sr_cascade :  INTEGER  is 0x00000020
sql_sr_restrict :  INTEGER  is 0x00000040
sql_sr_delete_table :  INTEGER  is 0x00000080
sql_sr_insert_table :  INTEGER  is 0x00000100
sql_sr_insert_column :  INTEGER  is 0x00000200
sql_sr_references_table :  INTEGER  is 0x00000400
sql_sr_references_column :  INTEGER  is 0x00000800
sql_sr_select_table :  INTEGER  is 0x00001000
sql_sr_update_table :  INTEGER  is 0x00002000
sql_sr_update_column :  INTEGER  is 0x00004000

feature -- Constants -- SQL92_ROW_VALUE_CONSTRUCTOR bitmasks
sql_srvc_value_expression :  INTEGER  is 0x00000001
sql_srvc_null :  INTEGER  is 0x00000002
sql_srvc_default :  INTEGER  is 0x00000004
sql_srvc_row_subquery :  INTEGER  is 0x00000008

feature -- Constants -- SQL92_VALUE_EXPRESSIONS bitmasks
sql_sve_case :  INTEGER  is 0x00000001
sql_sve_cast :  INTEGER  is 0x00000002
sql_sve_coalesce :  INTEGER  is 0x00000004
sql_sve_nullif :  INTEGER  is 0x00000008

feature -- Constants -- SQL_STANDARD_CLI_CONFORMANCE bitmasks
sql_scc_xopen_cli_version1 : integer is 0x00000001
sql_scc_iso92_cli : integer is 0x00000002

feature -- Constants -- SQL_UNION_STATEMENT bitmasks
sql_us_union : integer is do result := sql_u_union end 
sql_us_union_all : integer is do result := sql_u_union_all end 

--#endif /* ODBCVER >= 0x0300 

feature -- Constants -- DTC transition cost

sql_dtc_enlist_expensive :  INTEGER  is 0x00000001
sql_dtc_unenlist_expensive :  INTEGER  is 0x00000002

end

