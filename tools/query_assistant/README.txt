Query Assistant For ECLI

1. Purpose

	'Query Assistant' for ECLI allows a developer to generate classes
	that encapsulate a cursor on a SQL 'SELECT' query.
		
	The generated cursor class is a descendant of ECLI_CURSOR 
	(being itself a descendant of ECLI_STATEMENT) that only exports cursor operations
	and status information.
	
	This way, Query Assistant generates a class that completely hides "statement" details.
	
	Let C be a cursor, 
		with parameters p1, p2
		and  result columns r1, r2, r3
		
	Let p1, p2, and r1, r2, r3 are descendant objects of ECLI_VALUE
	
	Let pv1 is like p1.item and pv2 is like p2.item

	C shall be used this way :
	
		cursor : C
		session : ECLI_SESSION
		
		...
		
		create cursor.make (session)

		-- sweep through cursor values
		from
			-- go to first position
			cursor.start (pv1, pv2)
		until
			not cursor.is_ok or else cursor.off
		loop
			-- result attributes reflect values
			if cursor.r1.is_null then ...
			...
			x := cursor.r2.to_integer + 1
			
			-- advance cursor forward
			cursor.forth
		end
		

2. Usage of query assistant

	query_assistant -sql <queryfile.sql> -class <class_name> -dir <target_dir> -dsn <source> -user <user> -pwd <password>
	
	
*. Design notes
	
	SELECT <column list> FROM <table list> WHERE <parameterized boolean expression>
	
	==>
	
	class <selection name>_CURSOR
	
	inherit
	
		ECLI_CURSOR
			
	creation 
		
		make
	
	feature -- Initialization
	
		setup is
			do
				create cursor.make (1, <result_count>)
				-- for each column in <column list>
				create <column>.make <corresponding creation parameters>
				cursor.put (<column>, rank)
				
				-- for each parameter in <parameter list>
				create <parameter>.make <corresponding creation parameters>
				put_parameter (<parameter>, <parameter_name>)
			end
			
	feature -- basic operations
	
		
			start (<parameter list with corresponding Eiffel types>)
				--
				ensure
					is_ok implies statement.is_executed
					-- every parameter value has been set
				

	feature -- 
	
		<column_name> : ECLI_<type>
		
		<parameter_name> : ECLI_<type>

	end -- class ...
	
			
		

		
	