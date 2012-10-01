note
	description: "Summary description for {ECLI_ENVIRONMENT_ATTRIBUTE_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ECLI_ENVIRONMENT_ATTRIBUTE_CONSTANTS

feature {NONE} -- Attribute value type

	SQL_IS_POINTER	:	INTEGER = -4
	SQL_IS_UINTEGER	:	INTEGER = -5
	SQL_IS_INTEGER	:	INTEGER = -6
	SQL_IS_USMALLINT	:	INTEGER = -7
	SQL_IS_SMALLINT	:	INTEGER = -8

feature {NONE} -- Environment attributes

	Sql_attr_odbc_version	:	INTEGER = 200
	Sql_attr_connection_pooling	:	INTEGER = 201
	Sql_attr_cp_match	:	INTEGER = 202

	Sql_cp_off	:	NATURAL_32 = 0
	Sql_cp_one_per_driver	:	NATURAL_32 = 1
	Sql_cp_one_per_henv	:	NATURAL_32 = 2
	Sql_cp_default	:	NATURAL_32 = 0

	Sql_cp_strict_match	:	NATURAL_32 = 0
	Sql_cp_relaxed_match	:	NATURAL_32 = 1
	Sql_cp_match_default	:	NATURAL_32 = 0

	Sql_ov_odbc2	:	NATURAL_32 = 2
	Sql_ov_odbc3	:	NATURAL_32 = 3

end
