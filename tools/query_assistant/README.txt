Query Assistant For ECLI

Content
1. Purpose
2. Usage
3. Known problems
4. Changes

1. Purpose

	'Query Assistant' for ECLI allows a developer to generate classes
	that encapsulate SQL queries.
		
	If the query has results (selection) the generated classes are
	descendant of ECLI_CURSOR.
	If the query is a command (insertion, update) the generated classes
	inherit from ECLI_QUERY.
	
	The only visible features are those that allow correct operation of
	those objects.
	
	This way, Query Assistant generates a class that completely hides "statement" details.
	
	Let C be a cursor, 
		with parameters p1, p2
		and  result columns r1, r2, r3
		
	Let p1, p2, and r1, r2, r3 are descendant objects of ECLI_VALUE
	

	p1, p2 are encapsulated in class C_PARAMETERS.
	r1, r2, r3 are encapsulated in class C_RESULTS. 
	
	C shall be used this way :
	
		cursor : C
		parameters : C_PARAMETERS
		row : C_RESULTS
		
		session : ECLI_SESSION
		
		...
		
		create cursor.make (session)

		from
			create parameters.make
			parameters.p1.set_item (...)
			parameters.p2.set_item (...)
			cursor.set_parameters_object (parameters)
			cursor.start
		until
			not cursor.is_ok or else cursor.off
		loop
			row := cursor.item
			
			if row.r1.is_null then ...
			...
			x := row.r2.to_integer + 1
			
			-- advance cursor forward
			cursor.forth
		end
		

2. Usage of query assistant

	query_assistant -sql <queryfile.sql> -class <class_name> -dir <target_dir> -dsn <source> -user <user> -pwd <password>
	
	
3. Known problems

	* some SQL verification is done by query_assistant through letting the database
	  prepare the SQL statements.
	  Unfortunately, the prepare operation does not check all errors.
	  To overcome this problem, just specify a sample attribute for each parameter entity.
	  
	=> if you get bizarre generated classes (i.e. an ECLI_QUERY heir instead of an
	  ECLI_CURSOR one), then check the SQL you provided : there may be some
	  uncaught SQL syntax error.

			
4. Changes

2003-10-01
	Parameter_sets and result_sets can "extend" the same class, i.e. have a same parent class.
	This way it is possible to share the same transfer buffers.
	
	