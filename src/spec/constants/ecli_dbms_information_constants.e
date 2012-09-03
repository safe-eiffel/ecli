note

	description: "Constants related to SQLGetInfo."

	library: "ECLI : Eiffel Call Level Interface (ODBC) Library. Project SAFE."
	Copyright: "Copyright (c) 2001-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class ECLI_DBMS_INFORMATION_CONSTANTS

inherit
	ANY

	XS_UINT32_ROUTINES
		export {NONE} all
		end

feature -- Constants -- Info type

	sql_max_driver_connections :  INTEGER  = 0
	sql_maximum_driver_connections : integer do result := sql_max_driver_connections end
	sql_max_concurrent_activities :  INTEGER  = 1
	sql_maximum_concurrent_activities : integer do result := sql_max_concurrent_activities end
	sql_data_source_name :  INTEGER  = 2
	sql_fetch_direction :  INTEGER  = 8
	sql_server_name :  INTEGER  = 13
	sql_search_pattern_escape :  INTEGER  = 14
	sql_dbms_name :  INTEGER  = 17
	sql_dbms_ver :  INTEGER  = 18
	sql_accessible_tables :  INTEGER  = 19
	sql_accessible_procedures :  INTEGER  = 20
	sql_cursor_commit_behavior :  INTEGER  = 23
	sql_data_source_read_only :  INTEGER  = 25
	sql_default_txn_isolation :  INTEGER  = 26
	sql_identifier_case :  INTEGER  = 28
	sql_identifier_quote_char :  INTEGER  = 29
	sql_max_column_name_len :  INTEGER  = 30
	sql_maximum_column_name_length : integer do result := sql_max_column_name_len end
	sql_max_cursor_name_len :  INTEGER  = 31
	sql_maximum_cursor_name_length : integer do result := sql_max_cursor_name_len end
	sql_max_schema_name_len :  INTEGER  = 32
	sql_maximum_schema_name_length : integer do result := sql_max_schema_name_len end
	sql_max_catalog_name_len :  INTEGER  = 34
	sql_maximum_catalog_name_length : integer do result := sql_max_catalog_name_len end
	sql_max_table_name_len :  INTEGER  = 35
	sql_scroll_concurrency :  INTEGER  = 43
	sql_txn_capable :  INTEGER  = 46
	sql_transaction_capable : integer do result := sql_txn_capable end
	sql_user_name :  INTEGER  = 47
	sql_txn_isolation_option :  INTEGER  = 72
	sql_transaction_isolation_option : integer do result := sql_txn_isolation_option end
	sql_integrity :  INTEGER  = 73
	sql_getdata_extensions :  INTEGER  = 81
	sql_null_collation :  INTEGER  = 85
	sql_alter_table :  INTEGER  = 86
	sql_order_by_columns_in_select :  INTEGER  = 90
	sql_special_characters :  INTEGER  = 94
	sql_max_columns_in_group_by :  INTEGER  = 97
	sql_maximum_columns_in_group_by : integer do result := sql_max_columns_in_group_by end
	sql_max_columns_in_index :  INTEGER  = 98
	sql_maximum_columns_in_index : integer do result := sql_max_columns_in_index end
	sql_max_columns_in_order_by :  INTEGER  = 99
	sql_maximum_columns_in_order_by : integer do result := sql_max_columns_in_order_by end
	sql_max_columns_in_select :  INTEGER  = 100
	sql_maximum_columns_in_select : integer do result := sql_max_columns_in_select end
	sql_max_columns_in_table :  INTEGER  = 101
	sql_max_index_size :  INTEGER  = 102
	sql_maximum_index_size : integer do result := sql_max_index_size end
	sql_max_row_size :  INTEGER  = 104
	sql_maximum_row_size : integer do result := sql_max_row_size end
	sql_max_statement_len :  INTEGER  = 105
	sql_maximum_statement_length : integer do result := sql_max_statement_len end
	sql_max_tables_in_select :  INTEGER  = 106
	sql_maximum_tables_in_select : integer do result := sql_max_tables_in_select end
	sql_max_user_name_len :  INTEGER  = 107
	sql_maximum_user_name_length : integer do result := sql_max_user_name_len end

	sql_oj_capabilities :  INTEGER  = 115
	sql_outer_join_capabilities : integer do result := sql_oj_capabilities end

	sql_xopen_cli_year :  INTEGER  = 10000
	sql_cursor_sensitivity :  INTEGER  = 10001
	sql_describe_parameter :  INTEGER  = 10002
	sql_catalog_name :  INTEGER  = 10003
	sql_collation_seq :  INTEGER  = 10004
	sql_max_identifier_len :  INTEGER  = 10005
	sql_maximum_identifier_length : integer do result := sql_max_identifier_len end

	sql_info_first :  INTEGER  = 0
	sql_active_connections :  INTEGER  = 0
	sql_active_statements :  INTEGER  = 1
	sql_driver_hdbc :  INTEGER  = 3
	sql_driver_henv :  INTEGER  = 4
	sql_driver_hstmt :  INTEGER  = 5
	sql_driver_name :  INTEGER  = 6
	sql_driver_ver :  INTEGER  = 7
	sql_odbc_api_conformance :  INTEGER  = 9
	sql_odbc_ver :  INTEGER  = 10
	sql_row_updates :  INTEGER  = 11
	sql_odbc_sag_cli_conformance :  INTEGER  = 12
	sql_odbc_sql_conformance :  INTEGER  = 15
	sql_procedures :  INTEGER  = 21
	sql_concat_null_behavior :  INTEGER  = 22
	sql_cursor_rollback_behavior :  INTEGER  = 24
	sql_expressions_in_orderby :  INTEGER  = 27
	sql_max_owner_name_len :  INTEGER  = 32
	sql_max_procedure_name_len :  INTEGER  = 33
	sql_max_qualifier_name_len :  INTEGER  = 34
	sql_mult_result_sets : INTEGER = 36
	sql_multiple_active_txn :  INTEGER  = 37
	sql_outer_joins :  INTEGER  = 38
	sql_owner_term :  INTEGER  = 39
	sql_procedure_term :  INTEGER  = 40
	sql_qualifier_name_separator :  INTEGER  = 41
	sql_qualifier_term :  INTEGER  = 42
	sql_scroll_options :  INTEGER  = 44
	sql_table_term :  INTEGER  = 45
	sql_convert_functions :  INTEGER  = 48
	sql_numeric_functions :  INTEGER  = 49
	sql_string_functions :  INTEGER  = 50
	sql_system_functions :  INTEGER  = 51
	sql_timedate_functions :  INTEGER  = 52
	sql_convert_bigint :  INTEGER  = 53
	sql_convert_binary :  INTEGER  = 54
	sql_convert_bit :  INTEGER  = 55
	sql_convert_char :  INTEGER  = 56
	sql_convert_date :  INTEGER  = 57
	sql_convert_decimal :  INTEGER  = 58
	sql_convert_double :  INTEGER  = 59
	sql_convert_float :  INTEGER  = 60
	sql_convert_integer :  INTEGER  = 61
	sql_convert_longvarchar :  INTEGER  = 62
	sql_convert_numeric :  INTEGER  = 63
	sql_convert_real :  INTEGER  = 64
	sql_convert_smallint :  INTEGER  = 65
	sql_convert_time :  INTEGER  = 66
	sql_convert_timestamp :  INTEGER  = 67
	sql_convert_tinyint :  INTEGER  = 68
	sql_convert_varbinary :  INTEGER  = 69
	sql_convert_varchar :  INTEGER  = 70
	sql_convert_longvarbinary :  INTEGER  = 71
	sql_odbc_sql_opt_ief :  INTEGER  = 73
	sql_correlation_name :  INTEGER  = 74
	sql_non_nullable_columns :  INTEGER  = 75
	sql_driver_hlib :  INTEGER  = 76
	sql_driver_odbc_ver :  INTEGER  = 77
	sql_lock_types :  INTEGER  = 78
	sql_pos_operations :  INTEGER  = 79
	sql_positioned_statements :  INTEGER  = 80
	sql_bookmark_persistence :  INTEGER  = 82
	sql_static_sensitivity :  INTEGER  = 83
	sql_file_usage :  INTEGER  = 84
	sql_column_alias :  INTEGER  = 87
	sql_group_by :  INTEGER  = 88
	sql_keywords :  INTEGER  = 89
	sql_owner_usage :  INTEGER  = 91
	sql_qualifier_usage :  INTEGER  = 92
	sql_quoted_identifier_case :  INTEGER  = 93
	sql_subqueries :  INTEGER  = 95
	sql_union :  INTEGER  = 96
	sql_max_row_size_includes_long :  INTEGER  = 103
	sql_max_char_literal_len :  INTEGER  = 108
	sql_timedate_add_intervals :  INTEGER  = 109
	sql_timedate_diff_intervals :  INTEGER  = 110
	sql_need_long_data_len : INTEGER = 111
	sql_max_binary_literal_len :  INTEGER  = 112
	sql_like_escape_clause :  INTEGER  = 113
	sql_qualifier_location :  INTEGER  = 114

feature -- Constants -- SQLGetInfo values not part of X/Open standard

	sql_active_environments :  INTEGER  = 116
	sql_alter_domain :  INTEGER  = 117

	sql_sql_conformance :  INTEGER  = 118
	sql_datetime_literals :  INTEGER  = 119

	sql_async_mode :  INTEGER  = 10021
	sql_batch_row_count :  INTEGER  = 120
	sql_batch_support :  INTEGER  = 121
	sql_catalog_location : integer do result := sql_qualifier_location end
	sql_catalog_name_separator	: INTEGER do Result := sql_qualifier_name_separator end
	sql_catalog_term : INTEGER do Result := sql_qualifier_term end
	sql_catalog_usage : INTEGER do Result := sql_qualifier_usage end
	sql_convert_wchar :  INTEGER  = 122
	sql_convert_interval_day_time :  INTEGER  = 123
	sql_convert_interval_year_month :  INTEGER  = 124
	sql_convert_wlongvarchar :  INTEGER  = 125
	sql_convert_wvarchar :  INTEGER  = 126
	sql_create_assertion :  INTEGER  = 127
	sql_create_character_set :  INTEGER  = 128
	sql_create_collation :  INTEGER  = 129
	sql_create_domain :  INTEGER  = 130
	sql_create_schema :  INTEGER  = 131
	sql_create_table :  INTEGER  = 132
	sql_create_translation :  INTEGER  = 133
	sql_create_view :  INTEGER  = 134
	sql_driver_hdesc :  INTEGER  = 135
	sql_drop_assertion :  INTEGER  = 136
	sql_drop_character_set :  INTEGER  = 137
	sql_drop_collation :  INTEGER  = 138
	sql_drop_domain :  INTEGER  = 139
	sql_drop_schema :  INTEGER  = 140
	sql_drop_table :  INTEGER  = 141
	sql_drop_translation :  INTEGER  = 142
	sql_drop_view :  INTEGER  = 143
	sql_dynamic_cursor_attributes1 : INTEGER =	144
	sql_dynamic_cursor_attributes2 : INTEGER =	145
	sql_forward_only_cursor_attributes1 : INTEGER =	146
	sql_forward_only_cursor_attributes2 : INTEGER =	147
	sql_index_keywords :  INTEGER  = 148
	sql_info_schema_views :  INTEGER  = 149
	sql_keyset_cursor_attributes1 : INTEGER =	150
	sql_keyset_cursor_attributes2 : INTEGER =	151
	sql_max_async_concurrent_statements :  INTEGER  = 10022
	sql_odbc_interface_conformance :  INTEGER  = 152
	sql_param_array_row_counts :  INTEGER  = 153
	sql_param_array_selects :  INTEGER  = 154
	sql_schema_term : INTEGER	do Result := sql_owner_term end
	sql_schema_usage : INTEGER	do Result := sql_owner_usage end
	sql_sql92_datetime_functions : INTEGER =	155
	sql_sql92_foreign_key_delete_rule : INTEGER =	156
	sql_sql92_foreign_key_update_rule : INTEGER =	157
	sql_sql92_grant : INTEGER =	158
	sql_sql92_numeric_value_functions : INTEGER =	159
	sql_sql92_predicates : INTEGER =	160
	sql_sql92_relational_join_operators : INTEGER =	161
	sql_sql92_revoke : INTEGER =	162
	sql_sql92_row_value_constructor : INTEGER =	163
	sql_sql92_string_functions : INTEGER =	164
	sql_sql92_value_expressions : INTEGER =	165
	sql_standard_cli_conformance :  INTEGER  = 166
	sql_static_cursor_attributes1 : INTEGER =	167
	sql_static_cursor_attributes2 : INTEGER =	168

	sql_aggregate_functions :  INTEGER  = 169
	sql_ddl_index :  INTEGER  = 170
	sql_dm_ver :  INTEGER  = 171
	sql_insert_statement :  INTEGER  = 172
	sql_convert_guid :  INTEGER  = 173
	sql_union_statement : integer do result := sql_union end

	sql_dtc_transition_cost :  INTEGER  = 1750

feature -- Constants -- Alter table

	sql_at_add_column :  INTEGER  = 0x00000001
	sql_at_drop_column :  INTEGER  = 0x00000002
	sql_at_add_constraint :  INTEGER  = 0x00000008

	sql_at_add_column_single :  INTEGER  = 0x00000020
	sql_at_add_column_default :  INTEGER  = 0x00000040
	sql_at_add_column_collation :  INTEGER  = 0x00000080
	sql_at_set_column_default :  INTEGER  = 0x00000100
	sql_at_drop_column_default :  INTEGER  = 0x00000200
	sql_at_drop_column_cascade :  INTEGER  = 0x00000400
	sql_at_drop_column_restrict :  INTEGER  = 0x00000800
	sql_at_add_table_constraint :  INTEGER  = 0x00001000
	sql_at_drop_table_constraint_cascade :  INTEGER  = 0x00002000
	sql_at_drop_table_constraint_restrict :  INTEGER  = 0x00004000
	sql_at_constraint_name_definition :  INTEGER  = 0x00008000
	sql_at_constraint_initially_deferred :  INTEGER  = 0x00010000
	sql_at_constraint_initially_immediate :  INTEGER  = 0x00020000
	sql_at_constraint_deferrable :  INTEGER  = 0x00040000
	sql_at_constraint_non_deferrable :  INTEGER  = 0x00080000

feature -- Constants -- Cursor commit behavior

	sql_cb_delete :  INTEGER  = 0
	sql_cb_close :  INTEGER  = 1
	sql_cb_preserve :  INTEGER  = 2

feature -- Constants -- Fetch direction

	sql_fd_fetch_next :  INTEGER  = 0x00000001
	sql_fd_fetch_first :  INTEGER  = 0x00000002
	sql_fd_fetch_last :  INTEGER  = 0x00000004
	sql_fd_fetch_prior :  INTEGER  = 0x00000008
	sql_fd_fetch_absolute :  INTEGER  = 0x00000010
	sql_fd_fetch_relative :  INTEGER  = 0x00000020

feature -- Constants -- GetData extensions

	sql_gd_any_column :  INTEGER  = 0x00000001
	sql_gd_any_order :  INTEGER  = 0x00000002

feature -- Constants -- Identifier case

	sql_ic_upper :  INTEGER  = 1
	sql_ic_lower :  INTEGER  = 2
	sql_ic_sensitive :  INTEGER  = 3
	sql_ic_mixed :  INTEGER  = 4

feature -- Constants -- Null collation

	sql_nc_high :  INTEGER  = 0
	sql_nc_low :  INTEGER  = 1

feature -- Constants -- Outer joins

	sql_oj_left :  INTEGER  = 0x00000001
	sql_oj_right :  INTEGER  = 0x00000002
	sql_oj_full :  INTEGER  = 0x00000004
	sql_oj_nested :  INTEGER  = 0x00000008
	sql_oj_not_ordered :  INTEGER  = 0x00000010
	sql_oj_inner :  INTEGER  = 0x00000020
	sql_oj_all_comparison_ops :  INTEGER  = 0x00000040

feature -- Constants -- Scroll concurrency

	sql_scco_read_only :  INTEGER  = 0x00000001
	sql_scco_lock :  INTEGER  = 0x00000002
	sql_scco_opt_rowver :  INTEGER  = 0x00000004
	sql_scco_opt_values :  INTEGER  = 0x00000008

feature -- Constants -- TXN capability

	sql_tc_none :  INTEGER  = 0
	sql_tc_dml :  INTEGER  = 1
	sql_tc_all :  INTEGER  = 2
	sql_tc_ddl_commit :  INTEGER  = 3
	sql_tc_ddl_ignore :  INTEGER  = 4

feature -- Constants -- Transaction isolation options

	sql_txn_read_uncommitted :  INTEGER  = 0x00000001
	sql_transaction_read_uncommitted : integer do result := sql_txn_read_uncommitted end
	sql_txn_read_committed :  INTEGER  = 0x00000002
	sql_transaction_read_committed : integer do result := sql_txn_read_committed end
	sql_txn_repeatable_read :  INTEGER  = 0x00000004
	sql_transaction_repeatable_read : integer do result := sql_txn_repeatable_read end
	sql_txn_serializable :  INTEGER  = 0x00000008
	sql_transaction_serializable : integer do result := sql_txn_serializable end

feature -- Constants -- conversion

	sql_cvt_char :  INTEGER  = 0x00000001
	sql_cvt_numeric :  INTEGER  = 0x00000002
	sql_cvt_decimal :  INTEGER  = 0x00000004
	sql_cvt_integer :  INTEGER  = 0x00000008
	sql_cvt_smallint :  INTEGER  = 0x00000010
	sql_cvt_float :  INTEGER  = 0x00000020
	sql_cvt_real :  INTEGER  = 0x00000040
	sql_cvt_double :  INTEGER  = 0x00000080
	sql_cvt_varchar :  INTEGER  = 0x00000100
	sql_cvt_longvarchar :  INTEGER  = 0x00000200
	sql_cvt_binary :  INTEGER  = 0x00000400
	sql_cvt_varbinary :  INTEGER  = 0x00000800
	sql_cvt_bit :  INTEGER  = 0x00001000
	sql_cvt_tinyint :  INTEGER  = 0x00002000
	sql_cvt_bigint :  INTEGER  = 0x00004000
	sql_cvt_date :  INTEGER  = 0x00008000
	sql_cvt_time :  INTEGER  = 0x00010000
	sql_cvt_timestamp :  INTEGER  = 0x00020000
	sql_cvt_longvarbinary :  INTEGER  = 0x00040000

	sql_cvt_interval_year_month :  INTEGER  = 0x00080000
	sql_cvt_interval_day_time :  INTEGER  = 0x00100000
	sql_cvt_wchar :  INTEGER  = 0x00200000
	sql_cvt_wlongvarchar :  INTEGER  = 0x00400000
	sql_cvt_wvarchar :  INTEGER  = 0x00800000
	sql_cvt_guid :  INTEGER  = 0x01000000

feature -- Constants -- Convert functions

	sql_fn_cvt_convert :  INTEGER  = 0x00000001
	sql_fn_cvt_cast :  INTEGER  = 0x00000002

feature -- Constants -- String functions

	sql_fn_str_concat :  INTEGER  = 0x00000001
	sql_fn_str_insert :  INTEGER  = 0x00000002
	sql_fn_str_left :  INTEGER  = 0x00000004
	sql_fn_str_ltrim :  INTEGER  = 0x00000008
	sql_fn_str_length :  INTEGER  = 0x00000010
	sql_fn_str_locate :  INTEGER  = 0x00000020
	sql_fn_str_lcase :  INTEGER  = 0x00000040
	sql_fn_str_repeat :  INTEGER  = 0x00000080
	sql_fn_str_replace :  INTEGER  = 0x00000100
	sql_fn_str_right :  INTEGER  = 0x00000200
	sql_fn_str_rtrim :  INTEGER  = 0x00000400
	sql_fn_str_substring :  INTEGER  = 0x00000800
	sql_fn_str_ucase :  INTEGER  = 0x00001000
	sql_fn_str_ascii :  INTEGER  = 0x00002000
	sql_fn_str_char :  INTEGER  = 0x00004000
	sql_fn_str_difference :  INTEGER  = 0x00008000
	sql_fn_str_locate_2 : integer = 0x00010000
	sql_fn_str_soundex :  INTEGER  = 0x00020000
	sql_fn_str_space :  INTEGER  = 0x00040000
	sql_fn_str_bit_length :  INTEGER  = 0x00080000
	sql_fn_str_char_length :  INTEGER  = 0x00100000
	sql_fn_str_character_length :  INTEGER  = 0x00200000
	sql_fn_str_octet_length :  INTEGER  = 0x00400000
	sql_fn_str_position :  INTEGER  = 0x00800000

feature -- Constants -- SQL92 String functions

	sql_ssf_convert :  INTEGER  = 0x00000001
	sql_ssf_lower :  INTEGER  = 0x00000002
	sql_ssf_upper :  INTEGER  = 0x00000004
	sql_ssf_substring :  INTEGER  = 0x00000008
	sql_ssf_translate :  INTEGER  = 0x00000010
	sql_ssf_trim_both :  INTEGER  = 0x00000020
	sql_ssf_trim_leading :  INTEGER  = 0x00000040
	sql_ssf_trim_trailing :  INTEGER  = 0x00000080

feature -- Constants -- SQL Numeric functions

	sql_fn_num_abs :  INTEGER  = 0x00000001
	sql_fn_num_acos :  INTEGER  = 0x00000002
	sql_fn_num_asin :  INTEGER  = 0x00000004
	sql_fn_num_atan :  INTEGER  = 0x00000008
	sql_fn_num_atan2 : integer = 0x00000010
	sql_fn_num_ceiling :  INTEGER  = 0x00000020
	sql_fn_num_cos :  INTEGER  = 0x00000040
	sql_fn_num_cot :  INTEGER  = 0x00000080
	sql_fn_num_exp :  INTEGER  = 0x00000100
	sql_fn_num_floor :  INTEGER  = 0x00000200
	sql_fn_num_log :  INTEGER  = 0x00000400
	sql_fn_num_mod :  INTEGER  = 0x00000800
	sql_fn_num_sign :  INTEGER  = 0x00001000
	sql_fn_num_sin :  INTEGER  = 0x00002000
	sql_fn_num_sqrt :  INTEGER  = 0x00004000
	sql_fn_num_tan :  INTEGER  = 0x00008000
	sql_fn_num_pi :  INTEGER  = 0x00010000
	sql_fn_num_rand :  INTEGER  = 0x00020000
	sql_fn_num_degrees :  INTEGER  = 0x00040000
	sql_fn_num_log10 : integer = 0x00080000
	sql_fn_num_power :  INTEGER  = 0x00100000
	sql_fn_num_radians :  INTEGER  = 0x00200000
	sql_fn_num_round :  INTEGER  = 0x00400000
	sql_fn_num_truncate :  INTEGER  = 0x00800000

feature -- Constants -- SQL92 Numeric value functions

	sql_snvf_bit_length :  INTEGER  = 0x00000001
	sql_snvf_char_length :  INTEGER  = 0x00000002
	sql_snvf_character_length :  INTEGER  = 0x00000004
	sql_snvf_extract :  INTEGER  = 0x00000008
	sql_snvf_octet_length :  INTEGER  = 0x00000010
	sql_snvf_position :  INTEGER  = 0x00000020

feature -- Constants -- TimeDate functions

	sql_fn_td_now :  INTEGER  = 0x00000001
	sql_fn_td_curdate :  INTEGER  = 0x00000002
	sql_fn_td_dayofmonth :  INTEGER  = 0x00000004
	sql_fn_td_dayofweek :  INTEGER  = 0x00000008
	sql_fn_td_dayofyear :  INTEGER  = 0x00000010
	sql_fn_td_month :  INTEGER  = 0x00000020
	sql_fn_td_quarter :  INTEGER  = 0x00000040
	sql_fn_td_week :  INTEGER  = 0x00000080
	sql_fn_td_year :  INTEGER  = 0x00000100
	sql_fn_td_curtime :  INTEGER  = 0x00000200
	sql_fn_td_hour :  INTEGER  = 0x00000400
	sql_fn_td_minute :  INTEGER  = 0x00000800
	sql_fn_td_second :  INTEGER  = 0x00001000
	sql_fn_td_timestampadd :  INTEGER  = 0x00002000
	sql_fn_td_timestampdiff :  INTEGER  = 0x00004000
	sql_fn_td_dayname :  INTEGER  = 0x00008000
	sql_fn_td_monthname :  INTEGER  = 0x00010000
	sql_fn_td_current_date :  INTEGER  = 0x00020000
	sql_fn_td_current_time :  INTEGER  = 0x00040000
	sql_fn_td_current_timestamp :  INTEGER  = 0x00080000
	sql_fn_td_extract :  INTEGER  = 0x00100000

feature -- Constants -- SQL92 DATETIME functions

	sql_sdf_current_date :  INTEGER  = 0x00000001
	sql_sdf_current_time :  INTEGER  = 0x00000002
	sql_sdf_current_timestamp :  INTEGER  = 0x00000004

feature -- Constants -- SQL System functions

	sql_fn_sys_username :  INTEGER  = 0x00000001
	sql_fn_sys_dbname :  INTEGER  = 0x00000002
	sql_fn_sys_ifnull :  INTEGER  = 0x00000004


feature -- Constants -- TIMEDATE Add/Diff functions

	sql_fn_tsi_frac_second :  INTEGER  = 0x00000001
	sql_fn_tsi_second :  INTEGER  = 0x00000002
	sql_fn_tsi_minute :  INTEGER  = 0x00000004
	sql_fn_tsi_hour :  INTEGER  = 0x00000008
	sql_fn_tsi_day :  INTEGER  = 0x00000010
	sql_fn_tsi_week :  INTEGER  = 0x00000020
	sql_fn_tsi_month :  INTEGER  = 0x00000040
	sql_fn_tsi_quarter :  INTEGER  = 0x00000080
	sql_fn_tsi_year :  INTEGER  = 0x00000100

feature -- Constants -- Cursor and keyset attribute values (SQL_DYNAMIC_CURSOR_ATTRIBUTES1, SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1, SQL_KEYSET_CURSOR_ATTRIBUTES1, and SQL_STATIC_CURSOR_ATTRIBUTES1

	sql_ca1_next : integer = 0x00000001
	sql_ca1_absolute : integer = 0x00000002
	sql_ca1_relative : integer = 0x00000004
	sql_ca1_bookmark : integer = 0x00000008

--/* supported SQLSetPos LockType's
	sql_ca1_lock_no_change : integer = 0x00000040
	sql_ca1_lock_exclusive : integer = 0x00000080
	sql_ca1_lock_unlock : integer = 0x00000100

--/* supported SQLSetPos Operations
	sql_ca1_pos_position : integer = 0x00000200
	sql_ca1_pos_update : integer = 0x00000400
	sql_ca1_pos_delete : integer = 0x00000800
	sql_ca1_pos_refresh : integer = 0x00001000

--/* positioned updates and deletes
	sql_ca1_positioned_update : integer = 0x00002000
	sql_ca1_positioned_delete : integer = 0x00004000
	sql_ca1_select_for_update : integer = 0x00008000

--/* supported SQLBulkOperations operations
	sql_ca1_bulk_add : integer = 0x00010000
	sql_ca1_bulk_update_by_bookmark : integer = 0x00020000
	sql_ca1_bulk_delete_by_bookmark : integer = 0x00040000
	sql_ca1_bulk_fetch_by_bookmark : integer = 0x00080000

--/* bitmasks for SQL_DYNAMIC_CURSOR_ATTRIBUTES2,
-- * SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2,
-- * SQL_KEYSET_CURSOR_ATTRIBUTES2, and SQL_STATIC_CURSOR_ATTRIBUTES2
--
--#if (ODBCVER >= 0x0300)
--/* supported values for SQL_ATTR_SCROLL_CONCURRENCY
	sql_ca2_read_only_concurrency : integer = 0x00000001
	sql_ca2_lock_concurrency : integer = 0x00000002
	sql_ca2_opt_rowver_concurrency : integer = 0x00000004
	sql_ca2_opt_values_concurrency : integer = 0x00000008

--/* sensitivity of the cursor to its own inserts, deletes, and updates
	sql_ca2_sensitivity_additions : integer = 0x00000010
	sql_ca2_sensitivity_deletions : integer = 0x00000020
	sql_ca2_sensitivity_updates : integer = 0x00000040

--/* semantics of SQL_ATTR_MAX_ROWS
	sql_ca2_max_rows_select : integer = 0x00000080
	sql_ca2_max_rows_insert : integer = 0x00000100
	sql_ca2_max_rows_delete : integer = 0x00000200
	sql_ca2_max_rows_update : integer = 0x00000400
	sql_ca2_max_rows_catalog : integer = 0x00000800
sql_ca2_max_rows_affects_all : INTEGER do
		Result := c_u_or (sql_ca2_max_rows_select,
				  c_u_or (sql_ca2_max_rows_insert,
				  c_u_or (sql_ca2_max_rows_delete,
				  c_u_or (sql_ca2_max_rows_update, sql_ca2_max_rows_catalog))))
		end

--/* semantics of SQL_DIAG_CURSOR_ROW_COUNT
	sql_ca2_crc_exact : integer = 0x00001000
	sql_ca2_crc_approximate : integer = 0x00002000

--/* the kinds of positioned statements that can be simulated
	sql_ca2_simulate_non_unique : integer = 0x00004000
	sql_ca2_simulate_try_unique : integer = 0x00008000
	sql_ca2_simulate_unique : integer = 0x00010000


feature -- Constants -- ODBC API Conformance values

	sql_oac_none :  INTEGER  = 0x0000
	sql_oac_level1 : integer = 0x0001
	sql_oac_level2 : integer = 0x0002

feature -- Constants -- SQL_ODBC_SAG_CLI_CONFORMANCE values

	sql_oscc_not_compliant :  INTEGER  = 0x0000
	sql_oscc_compliant :  INTEGER  = 0x0001

feature -- Constants -- SQL_ODBC_SQL_CONFORMANCE values

	sql_osc_minimum :  INTEGER  = 0x0000
	sql_osc_core :  INTEGER  = 0x0001
	sql_osc_extended :  INTEGER  = 0x0002


feature -- Constants -- SQL_CONCAT_NULL_BEHAVIOR values

	sql_cb_null :  INTEGER  = 0x0000
	sql_cb_non_null :  INTEGER  = 0x0001

feature -- Constants -- SQL_SCROLL_OPTIONS masks

	sql_so_forward_only :  INTEGER  = 0x00000001
	sql_so_keyset_driven :  INTEGER  = 0x00000002
	sql_so_dynamic :  INTEGER  = 0x00000004
	sql_so_mixed :  INTEGER  = 0x00000008
	sql_so_static :  INTEGER  = 0x00000010

feature -- Constants -- SQL_FETCH_DIRECTION masks

--/* SQL_FETCH_RESUME is no longer supported
sql_fd_fetch_resume :  INTEGER  = 0x00000040
--
sql_fd_fetch_bookmark :  INTEGER  = 0x00000080

feature -- Constants -- SQL_TXN_ISOLATION_OPTION masks
--/* SQL_TXN_VERSIONING is no longer supported
sql_txn_versioning :  INTEGER  = 0x00000010
--

feature -- Constants -- SQL_CORRELATION_NAME values

sql_cn_none :  INTEGER  = 0x0000
sql_cn_different :  INTEGER  = 0x0001
sql_cn_any :  INTEGER  = 0x0002

feature -- Constants -- SQL_NON_NULLABLE_COLUMNS values

sql_nnc_null :  INTEGER  = 0x0000
sql_nnc_non_null :  INTEGER  = 0x0001

feature -- Constants -- SQL_NULL_COLLATION values

sql_nc_start :  INTEGER  = 0x0002
sql_nc_end :  INTEGER  = 0x0004

feature -- Constants -- SQL_FILE_USAGE values

sql_file_not_supported :  INTEGER  = 0x0000
sql_file_table :  INTEGER  = 0x0001
sql_file_qualifier :  INTEGER  = 0x0002
sql_file_catalog : integer do result := sql_file_qualifier end


feature -- Constants -- SQL_GETDATA_EXTENSIONS values

sql_gd_block :  INTEGER  = 0x00000004
sql_gd_bound :  INTEGER  = 0x00000008

feature -- Constants -- SQL_POSITIONED_STATEMENTS masks

sql_ps_positioned_delete :  INTEGER  = 0x00000001
sql_ps_positioned_update :  INTEGER  = 0x00000002
sql_ps_select_for_update :  INTEGER  = 0x00000004

feature -- Constants -- SQL_GROUP_BY values

sql_gb_not_supported :  INTEGER  = 0x0000
sql_gb_group_by_equals_select :  INTEGER  = 0x0001
sql_gb_group_by_contains_select :  INTEGER  = 0x0002
sql_gb_no_relation :  INTEGER  = 0x0003
--#if (ODBCVER >= 0x0300)
sql_gb_collate :  INTEGER  = 0x0004

--#endif /* ODBCVER >= 0x0300

feature -- Constants -- SQL_OWNER_USAGE masks

sql_ou_dml_statements :  INTEGER  = 0x00000001
sql_ou_procedure_invocation :  INTEGER  = 0x00000002
sql_ou_table_definition :  INTEGER  = 0x00000004
sql_ou_index_definition :  INTEGER  = 0x00000008
sql_ou_privilege_definition :  INTEGER  = 0x00000010

feature -- Constants -- SQL_SCHEMA_USAGE masks
--#if (ODBCVER >= 0x0300)
sql_su_dml_statements : integer do result := sql_ou_dml_statements end
sql_su_procedure_invocation : integer do result := sql_ou_procedure_invocation end
sql_su_table_definition : integer do result := sql_ou_table_definition end
sql_su_index_definition : integer do result := sql_ou_index_definition end
sql_su_privilege_definition : integer do result := sql_ou_privilege_definition end
--#endif /* ODBCVER >= 0x0300

feature -- Constants -- SQL_QUALIFIER_USAGE masks

sql_qu_dml_statements :  INTEGER  = 0x00000001
sql_qu_procedure_invocation :  INTEGER  = 0x00000002
sql_qu_table_definition :  INTEGER  = 0x00000004
sql_qu_index_definition :  INTEGER  = 0x00000008
sql_qu_privilege_definition :  INTEGER  = 0x00000010

--#if (ODBCVER >= 0x0300)
feature -- Constants -- SQL_CATALOG_USAGE masks
sql_cu_dml_statements : integer do result := sql_qu_dml_statements end
sql_cu_procedure_invocation : integer do result := sql_qu_procedure_invocation end
sql_cu_table_definition : integer do result := sql_qu_table_definition end
sql_cu_index_definition : integer do result := sql_qu_index_definition end
sql_cu_privilege_definition : integer do result := sql_qu_privilege_definition end
--#endif /* ODBCVER >= 0x0300

feature -- Constants -- SQL_SUBQUERIES masks

sql_sq_comparison :  INTEGER  = 0x00000001
sql_sq_exists :  INTEGER  = 0x00000002
sql_sq_in :  INTEGER  = 0x00000004
sql_sq_quantified :  INTEGER  = 0x00000008
sql_sq_correlated_subqueries :  INTEGER  = 0x00000010

feature -- Constants -- SQL_UNION masks

sql_u_union :  INTEGER  = 0x00000001
sql_u_union_all :  INTEGER  = 0x00000002

feature -- Constants -- SQL_BOOKMARK_PERSISTENCE values

sql_bp_close :  INTEGER  = 0x00000001
sql_bp_delete :  INTEGER  = 0x00000002
sql_bp_drop :  INTEGER  = 0x00000004
sql_bp_transaction :  INTEGER  = 0x00000008
sql_bp_update :  INTEGER  = 0x00000010
sql_bp_other_hstmt :  INTEGER  = 0x00000020
sql_bp_scroll :  INTEGER  = 0x00000040

feature -- Constants -- SQL_STATIC_SENSITIVITY values

sql_ss_additions :  INTEGER  = 0x00000001
sql_ss_deletions :  INTEGER  = 0x00000002
sql_ss_updates :  INTEGER  = 0x00000004

feature -- Constants -- SQL_VIEW values
sql_cv_create_view :  INTEGER  = 0x00000001
sql_cv_check_option :  INTEGER  = 0x00000002
sql_cv_cascaded :  INTEGER  = 0x00000004
sql_cv_local :  INTEGER  = 0x00000008

feature -- Constants -- SQL_LOCK_TYPES masks

sql_lck_no_change :  INTEGER  = 0x00000001
sql_lck_exclusive :  INTEGER  = 0x00000002
sql_lck_unlock :  INTEGER  = 0x00000004

feature -- Constants -- SQL_POS_OPERATIONS masks

sql_pos_position :  INTEGER  = 0x00000001
sql_pos_refresh :  INTEGER  = 0x00000002
sql_pos_update :  INTEGER  = 0x00000004
sql_pos_delete :  INTEGER  = 0x00000008
sql_pos_add :  INTEGER  = 0x00000010

feature -- Constants -- SQL_QUALIFIER_LOCATION values

sql_ql_start :  INTEGER  = 0x0001
sql_ql_end :  INTEGER  = 0x0002

--/* Here start return values for ODBC 3.0 SQLGetInfo

--#if (ODBCVER >= 0x0300)
feature -- Constants -- SQL_AGGREGATE_FUNCTIONS bitmasks
sql_af_avg :  INTEGER  = 0x00000001
sql_af_count :  INTEGER  = 0x00000002
sql_af_max :  INTEGER  = 0x00000004
sql_af_min :  INTEGER  = 0x00000008
sql_af_sum :  INTEGER  = 0x00000010
sql_af_distinct :  INTEGER  = 0x00000020
sql_af_all :  INTEGER  = 0x00000040

feature -- Constants -- SQL_CONFORMANCE bit masks
sql_sc_sql92_entry : integer = 0x00000001
sql_sc_fips127_2_transitional : integer = 0x00000002
sql_sc_sql92_intermediate : integer = 0x00000004
sql_sc_sql92_full : integer = 0x00000008

feature -- Constants -- SQL_DATETIME_LITERALS masks
sql_dl_sql92_date : integer = 0x00000001
sql_dl_sql92_time : integer = 0x00000002
sql_dl_sql92_timestamp : integer = 0x00000004
sql_dl_sql92_interval_year : integer = 0x00000008
sql_dl_sql92_interval_month : integer = 0x00000010
sql_dl_sql92_interval_day : integer = 0x00000020
sql_dl_sql92_interval_hour : integer = 0x00000040
sql_dl_sql92_interval_minute : integer = 0x00000080
sql_dl_sql92_interval_second : integer = 0x00000100
sql_dl_sql92_interval_year_to_month : integer = 0x00000200
sql_dl_sql92_interval_day_to_hour : integer = 0x00000400
sql_dl_sql92_interval_day_to_minute : integer = 0x00000800
sql_dl_sql92_interval_day_to_second : integer = 0x00001000
sql_dl_sql92_interval_hour_to_minute : integer = 0x00002000
sql_dl_sql92_interval_hour_to_second : integer = 0x00004000
sql_dl_sql92_interval_minute_to_second : integer = 0x00008000

feature -- Constants -- SQL_CATALOG_LOCATION values
sql_cl_start : integer do result := sql_ql_start end
sql_cl_end : integer do result := sql_ql_end end

feature -- Constants -- SQL_BATCH_ROW_COUNT
sql_brc_procedures :  INTEGER  = 0x0000001
sql_brc_explicit :  INTEGER  = 0x0000002
sql_brc_rolled_up :  INTEGER  = 0x0000004

feature -- Constants -- SQL_BATCH_SUPPORT
sql_bs_select_explicit :  INTEGER  = 0x00000001
sql_bs_row_count_explicit :  INTEGER  = 0x00000002
sql_bs_select_proc :  INTEGER  = 0x00000004
sql_bs_row_count_proc :  INTEGER  = 0x00000008

feature -- Constants -- SQL_PARAM_ARRAY_ROW_COUNTS getinfo
sql_parc_batch :  INTEGER  = 1
sql_parc_no_batch :  INTEGER  = 2

feature -- Constants -- SQL_PARAM_ARRAY_SELECTS
sql_pas_batch :  INTEGER  = 1
sql_pas_no_batch :  INTEGER  = 2
sql_pas_no_select :  INTEGER  = 3

feature -- Constants -- SQL_INDEX_KEYWORDS
sql_ik_none :  INTEGER  = 0x00000000
sql_ik_asc :  INTEGER  = 0x00000001
sql_ik_desc :  INTEGER  = 0x00000002
--#define SQL_IK_ALL	(SQL_IK_ASC | SQL_IK_DESC)

feature -- Constants -- Bitmasks for SQL_INFO_SCHEMA_VIEWS

sql_isv_assertions :  INTEGER  = 0x00000001
sql_isv_character_sets :  INTEGER  = 0x00000002
sql_isv_check_constraints :  INTEGER  = 0x00000004
sql_isv_collations :  INTEGER  = 0x00000008
sql_isv_column_domain_usage :  INTEGER  = 0x00000010
sql_isv_column_privileges :  INTEGER  = 0x00000020
sql_isv_columns :  INTEGER  = 0x00000040
sql_isv_constraint_column_usage :  INTEGER  = 0x00000080
sql_isv_constraint_table_usage :  INTEGER  = 0x00000100
sql_isv_domain_constraints :  INTEGER  = 0x00000200
sql_isv_domains :  INTEGER  = 0x00000400
sql_isv_key_column_usage :  INTEGER  = 0x00000800
sql_isv_referential_constraints :  INTEGER  = 0x00001000
sql_isv_schemata :  INTEGER  = 0x00002000
sql_isv_sql_languages :  INTEGER  = 0x00004000
sql_isv_table_constraints :  INTEGER  = 0x00008000
sql_isv_table_privileges :  INTEGER  = 0x00010000
sql_isv_tables :  INTEGER  = 0x00020000
sql_isv_translations :  INTEGER  = 0x00040000
sql_isv_usage_privileges :  INTEGER  = 0x00080000
sql_isv_view_column_usage :  INTEGER  = 0x00100000
sql_isv_view_table_usage :  INTEGER  = 0x00200000
sql_isv_views :  INTEGER  = 0x00400000

feature -- Constants -- Bitmasks for SQL_ASYNC_MODE

sql_am_none :  INTEGER  = 0
sql_am_connection :  INTEGER  = 1
sql_am_statement :  INTEGER  = 2

feature -- Constants -- Bitmasks for SQL_ALTER_DOMAIN
sql_ad_constraint_name_definition :  INTEGER  = 0x00000001
sql_ad_add_domain_constraint :  INTEGER  = 0x00000002
sql_ad_drop_domain_constraint :  INTEGER  = 0x00000004
sql_ad_add_domain_default :  INTEGER  = 0x00000008
sql_ad_drop_domain_default :  INTEGER  = 0x00000010
sql_ad_add_constraint_initially_deferred :  INTEGER  = 0x00000020
sql_ad_add_constraint_initially_immediate :  INTEGER  = 0x00000040
sql_ad_add_constraint_deferrable :  INTEGER  = 0x00000080
sql_ad_add_constraint_non_deferrable :  INTEGER  = 0x00000100


feature -- Constants -- SQL_CREATE_SCHEMA bitmasks
sql_cs_create_schema :  INTEGER  = 0x00000001
sql_cs_authorization :  INTEGER  = 0x00000002
sql_cs_default_character_set :  INTEGER  = 0x00000004

feature -- Constants -- SQL_CREATE_TRANSLATION bitmasks
sql_ctr_create_translation :  INTEGER  = 0x00000001

feature -- Constants -- SQL_CREATE_ASSERTION bitmasks
sql_ca_create_assertion :  INTEGER  = 0x00000001
sql_ca_constraint_initially_deferred :  INTEGER  = 0x00000010
sql_ca_constraint_initially_immediate :  INTEGER  = 0x00000020
sql_ca_constraint_deferrable :  INTEGER  = 0x00000040
sql_ca_constraint_non_deferrable :  INTEGER  = 0x00000080

feature -- Constants -- SQL_CREATE_CHARACTER_SET bitmasks
sql_ccs_create_character_set :  INTEGER  = 0x00000001
sql_ccs_collate_clause :  INTEGER  = 0x00000002
sql_ccs_limited_collation :  INTEGER  = 0x00000004

feature -- Constants -- SQL_CREATE_COLLATION bitmasks
sql_ccol_create_collation :  INTEGER  = 0x00000001

feature -- Constants -- SQL_CREATE_DOMAIN bitmasks
sql_cdo_create_domain :  INTEGER  = 0x00000001
sql_cdo_default :  INTEGER  = 0x00000002
sql_cdo_constraint :  INTEGER  = 0x00000004
sql_cdo_collation :  INTEGER  = 0x00000008
sql_cdo_constraint_name_definition :  INTEGER  = 0x00000010
sql_cdo_constraint_initially_deferred :  INTEGER  = 0x00000020
sql_cdo_constraint_initially_immediate :  INTEGER  = 0x00000040
sql_cdo_constraint_deferrable :  INTEGER  = 0x00000080
sql_cdo_constraint_non_deferrable :  INTEGER  = 0x00000100

feature -- Constants -- SQL_CREATE_TABLE bitmasks
sql_ct_create_table :  INTEGER  = 0x00000001
sql_ct_commit_preserve :  INTEGER  = 0x00000002
sql_ct_commit_delete :  INTEGER  = 0x00000004
sql_ct_global_temporary :  INTEGER  = 0x00000008
sql_ct_local_temporary :  INTEGER  = 0x00000010
sql_ct_constraint_initially_deferred :  INTEGER  = 0x00000020
sql_ct_constraint_initially_immediate :  INTEGER  = 0x00000040
sql_ct_constraint_deferrable :  INTEGER  = 0x00000080
sql_ct_constraint_non_deferrable :  INTEGER  = 0x00000100
sql_ct_column_constraint :  INTEGER  = 0x00000200
sql_ct_column_default :  INTEGER  = 0x00000400
sql_ct_column_collation :  INTEGER  = 0x00000800
sql_ct_table_constraint :  INTEGER  = 0x00001000
sql_ct_constraint_name_definition :  INTEGER  = 0x00002000

feature -- Constants -- SQL_DDL_INDEX bitmasks
sql_di_create_index :  INTEGER  = 0x00000001
sql_di_drop_index :  INTEGER  = 0x00000002

feature -- Constants -- SQL_DROP_COLLATION bitmasks
sql_dc_drop_collation :  INTEGER  = 0x00000001

feature -- Constants -- SQL_DROP_DOMAIN bitmasks
sql_dd_drop_domain :  INTEGER  = 0x00000001
sql_dd_restrict :  INTEGER  = 0x00000002
sql_dd_cascade :  INTEGER  = 0x00000004

feature -- Constants -- SQL_DROP_SCHEMA bitmasks
sql_ds_drop_schema :  INTEGER  = 0x00000001
sql_ds_restrict :  INTEGER  = 0x00000002
sql_ds_cascade :  INTEGER  = 0x00000004

feature -- Constants -- SQL_DROP_CHARACTER_SET bitmasks
sql_dcs_drop_character_set :  INTEGER  = 0x00000001

feature -- Constants -- SQL_DROP_ASSERTION bitmasks
sql_da_drop_assertion :  INTEGER  = 0x00000001

feature -- Constants -- SQL_DROP_TABLE bitmasks
sql_dt_drop_table :  INTEGER  = 0x00000001
sql_dt_restrict :  INTEGER  = 0x00000002
sql_dt_cascade :  INTEGER  = 0x00000004

feature -- Constants -- SQL_DROP_TRANSLATION bitmasks
sql_dtr_drop_translation :  INTEGER  = 0x00000001

feature -- Constants -- SQL_DROP_VIEW bitmasks
sql_dv_drop_view :  INTEGER  = 0x00000001
sql_dv_restrict :  INTEGER  = 0x00000002
sql_dv_cascade :  INTEGER  = 0x00000004

feature -- Constants -- SQL_INSERT_STATEMENT bitmasks
sql_is_insert_literals :  INTEGER  = 0x00000001
sql_is_insert_searched :  INTEGER  = 0x00000002
sql_is_select_into :  INTEGER  = 0x00000004

feature -- Constants -- SQL_ODBC_INTERFACE_CONFORMANCE values
sql_oic_core :  INTEGER  = 1
sql_oic_level1 : integer = 2
sql_oic_level2 : integer = 3

feature -- Constants -- SQL92_FOREIGN_KEY_DELETE_RULE bitmasks
sql_sfkd_cascade :  INTEGER  = 0x00000001
sql_sfkd_no_action :  INTEGER  = 0x00000002
sql_sfkd_set_default :  INTEGER  = 0x00000004
sql_sfkd_set_null :  INTEGER  = 0x00000008

feature -- Constants -- SQL92_FOREIGN_KEY_UPDATE_RULE bitmasks
sql_sfku_cascade :  INTEGER  = 0x00000001
sql_sfku_no_action :  INTEGER  = 0x00000002
sql_sfku_set_default :  INTEGER  = 0x00000004
sql_sfku_set_null :  INTEGER  = 0x00000008

feature -- Constants -- SQL92_GRANT	bitmasks
sql_sg_usage_on_domain :  INTEGER  = 0x00000001
sql_sg_usage_on_character_set :  INTEGER  = 0x00000002
sql_sg_usage_on_collation :  INTEGER  = 0x00000004
sql_sg_usage_on_translation :  INTEGER  = 0x00000008
sql_sg_with_grant_option :  INTEGER  = 0x00000010
sql_sg_delete_table :  INTEGER  = 0x00000020
sql_sg_insert_table :  INTEGER  = 0x00000040
sql_sg_insert_column :  INTEGER  = 0x00000080
sql_sg_references_table :  INTEGER  = 0x00000100
sql_sg_references_column :  INTEGER  = 0x00000200
sql_sg_select_table :  INTEGER  = 0x00000400
sql_sg_update_table :  INTEGER  = 0x00000800
sql_sg_update_column :  INTEGER  = 0x00001000

feature -- Constants -- SQL92_PREDICATES bitmasks
sql_sp_exists :  INTEGER  = 0x00000001
sql_sp_isnotnull :  INTEGER  = 0x00000002
sql_sp_isnull :  INTEGER  = 0x00000004
sql_sp_match_full :  INTEGER  = 0x00000008
sql_sp_match_partial :  INTEGER  = 0x00000010
sql_sp_match_unique_full :  INTEGER  = 0x00000020
sql_sp_match_unique_partial :  INTEGER  = 0x00000040
sql_sp_overlaps :  INTEGER  = 0x00000080
sql_sp_unique :  INTEGER  = 0x00000100
sql_sp_like :  INTEGER  = 0x00000200
sql_sp_in :  INTEGER  = 0x00000400
sql_sp_between :  INTEGER  = 0x00000800
sql_sp_comparison :  INTEGER  = 0x00001000
sql_sp_quantified_comparison :  INTEGER  = 0x00002000

feature -- Constants -- SQL92_RELATIONAL_JOIN_OPERATORS bitmasks
sql_srjo_corresponding_clause :  INTEGER  = 0x00000001
sql_srjo_cross_join :  INTEGER  = 0x00000002
sql_srjo_except_join :  INTEGER  = 0x00000004
sql_srjo_full_outer_join :  INTEGER  = 0x00000008
sql_srjo_inner_join :  INTEGER  = 0x00000010
sql_srjo_intersect_join :  INTEGER  = 0x00000020
sql_srjo_left_outer_join :  INTEGER  = 0x00000040
sql_srjo_natural_join :  INTEGER  = 0x00000080
sql_srjo_right_outer_join :  INTEGER  = 0x00000100
sql_srjo_union_join :  INTEGER  = 0x00000200

feature -- Constants -- SQL92_REVOKE bitmasks
sql_sr_usage_on_domain :  INTEGER  = 0x00000001
sql_sr_usage_on_character_set :  INTEGER  = 0x00000002
sql_sr_usage_on_collation :  INTEGER  = 0x00000004
sql_sr_usage_on_translation :  INTEGER  = 0x00000008
sql_sr_grant_option_for :  INTEGER  = 0x00000010
sql_sr_cascade :  INTEGER  = 0x00000020
sql_sr_restrict :  INTEGER  = 0x00000040
sql_sr_delete_table :  INTEGER  = 0x00000080
sql_sr_insert_table :  INTEGER  = 0x00000100
sql_sr_insert_column :  INTEGER  = 0x00000200
sql_sr_references_table :  INTEGER  = 0x00000400
sql_sr_references_column :  INTEGER  = 0x00000800
sql_sr_select_table :  INTEGER  = 0x00001000
sql_sr_update_table :  INTEGER  = 0x00002000
sql_sr_update_column :  INTEGER  = 0x00004000

feature -- Constants -- SQL92_ROW_VALUE_CONSTRUCTOR bitmasks
sql_srvc_value_expression :  INTEGER  = 0x00000001
sql_srvc_null :  INTEGER  = 0x00000002
sql_srvc_default :  INTEGER  = 0x00000004
sql_srvc_row_subquery :  INTEGER  = 0x00000008

feature -- Constants -- SQL92_VALUE_EXPRESSIONS bitmasks
sql_sve_case :  INTEGER  = 0x00000001
sql_sve_cast :  INTEGER  = 0x00000002
sql_sve_coalesce :  INTEGER  = 0x00000004
sql_sve_nullif :  INTEGER  = 0x00000008

feature -- Constants -- SQL_STANDARD_CLI_CONFORMANCE bitmasks
sql_scc_xopen_cli_version1 : integer = 0x00000001
sql_scc_iso92_cli : integer = 0x00000002

feature -- Constants -- SQL_UNION_STATEMENT bitmasks
sql_us_union : integer do result := sql_u_union end
sql_us_union_all : integer do result := sql_u_union_all end

--#endif /* ODBCVER >= 0x0300

feature -- Constants -- DTC transition cost

sql_dtc_enlist_expensive :  INTEGER  = 0x00000001
sql_dtc_unenlist_expensive :  INTEGER  = 0x00000002

end

