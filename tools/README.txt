ECLI tools applications

Directory	Application name	Description
---------	----------------	-------------------------------------------------------
query_assitant	query_assistant		Wraps SQL statements with parameters in 2 or 3 classes :
					Let "my_query" the name associated with a SQL.  The generated classes will be
					- MY_QUERY : ECLI_STATEMENT descendant
					- MY_QUERY_PARAMETERS : encapsulates the parameter set
					- MY_QUERY_RESULTS : encapsulates a result row.
					

isql		isql			Interactive SQL
					usage: isql [<data_source_name> <user> <password> [sql_file_name [echo]]] 
					isql works in two modes
					* interactive (no sql_file_name parameter)
					* batch : isql reads commands from file whose name is sql_file_name.
					* echo is a flag that directs isql to echo commands when they are executed.
					If no <datasource_name> <user> <password> tuple is defined, a 'connect' 
					  command must be issued before executing any SQL.
					Type type the help;<enter> command to get help.