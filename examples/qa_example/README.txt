Shows the usage of 'query_assistant'

1. create an ODBC/CLI datasource or use an existing one

2. create the tables using file 'ddl.sql'
	
  By using the 'isql' sample application :
	isql -dsn datasource -user user -pwd password -sql ddl.sql
	
  NOTE: use file ddl.postgres.sql with a PostgreSQL data source

3. populate database using file 'insert.sql'

	isql -dsn datasource -user user -pwd password -sql insert.sql
	
4. use 'query_assistant' to generate class 'participant_by_remaining_cursor', using query 'byremaining.sql'
    query_assistant -sql byremaining.sql -dir ./ -class participant_by_remaining_cursor -dsn <dsn> -user <user> -pwd <pwd>

    query_assistant -eiffel -verbose -dsn <dsn> -user <user> -pwd <paswword> -input access_modules.xml -output .

5. compile project 'qa_example'

6. execute project  
  It is about listing all participants to a conference who have more than ? dollars to pay.

..exercise..
