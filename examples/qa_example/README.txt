Shows the usage of 'query_assistant'

1. create an ODBC/CLI datasource or use an existing one

2. create the tables using file 'ddl.sql'
	
  By using the 'isql' sample application :
	isql datasource user password < ddl.sql
	
  NOTE: use file ddl.postgres.sql wit a PostgreSQL data source

3. populate database using file 'insert.sql'

	isql datasource user password < insert.sql
	
4. use 'query_assistant' to generate class 'participant_by_remaining_cursor', using query 'byremaining.sql'
    query_assistant -sql byremaining.sql -dir ./ -class participant_by_remaining_cursor -dsn <dsn> -user <user> -pwd <pwd>

5. compile project 'qa_example'

6. execute project  
  It is about listing all participants to a conference who have more than ? dollars to pay.

..exercise..

7. ... modify project and generate cursor classes for other by*.sql query files
