note
	description: "Query assistant."
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"

class
	QUERY_ASSISTANT

inherit
	ARGUMENTS

	ECLI_TYPE_CONSTANTS

create
	make

feature -- Initialization

	make
		do
			print_prologue
			parse_arguments
			if parsed_arguments and arguments_ok then
				--read_query
				io.put_string ("QUERY> ")
				io.read_line
				query := clone (io.last_string)
				if query /= Void then
					connect_session
					launch_qacursor
					if qacursor.is_executed then
						generate
					end
					qacursor.close
					session.disconnect
					session.close
				end
			else
				print_usage
			end
		end

	print_prologue
		do
			io.put_string ("** ECLI Query Assistant **%N")
			io.put_string ("*  Generates a class encapsulation of a SQL SELECT statement.%N")
			io.put_string ("*  The statement is first 'tried' on the target database.%N")
			io.put_string ("*  Then the cursor class is generated.%N**%N")
		end
		
	parse_arguments
		local
			arg_index : INTEGER
			key, value : STRING
		do
			-- check that argument number is divisible by 2
			if argument_count \\ 2 /= 0 then
				print_usage
			else
				-- read arguments
				from 
					arg_index := 1
				until 
					arg_index >= argument_count
				loop
					key := argument (arg_index)
					value := clone (argument (arg_index + 1))
					if key.is_equal ("-class") then
						class_name := value
					elseif key.is_equal ("-sql") then
						query_file_name := value
					elseif key.is_equal ("-dsn") then
						data_source_name := value
					elseif key.is_equal ("-user") then
						user_name := value
					elseif key.is_equal ("-pwd") then
						password := value
					elseif key.is_equal ("-dir") then
						target_directory_name := value
					end
					arg_index := arg_index + 2
				end
				parsed_arguments := True 
			end										
		end

	print_usage
		do
			io.put_string ("Usage :%N")
			io.put_string ("%Tquery_assistant  -class <class> -sql <sql> -dsn <dsn> -user <user> -pwd <pwd> -dir <dir>%N")
			io.put_string ("where%N")
			io.put_string (" <class>%T%Tclass name of the generated cursor%N")
			io.put_string (" <sql>%T%Tname of a file that contains the sql query%N")
			io.put_string (" <dsn>%T%Tdata source name%N")
			io.put_string (" <user>%T%Tuser name needed to establish a session%N")
			io.put_string (" <pwd>%T%Tpassword needed to establish a session%N")
			io.put_string (" <dir>%T%Ttarget directory where the generated class is stored (end it with directory separator)%N")
		end

feature -- Access

	class_name : STRING

	target_directory_name : STRING

	target_file : KL_TEXT_OUTPUT_FILE

	data_source_name : STRING

	user_name : STRING

	password : STRING

	query_file_name : STRING

	session : ECLI_SESSION

	qacursor : QA_CURSOR
	
	query : STRING

	gen : QA_CURSOR_GENERATOR

feature -- Measurement

feature -- Status report

	parsed_arguments : BOOLEAN

	arguments_ok : BOOLEAN
		do
			Result := (class_name /= Void and data_source_name /= Void and user_name /= Void
						and password /= Void and query_file_name /= Void and target_directory_name /= Void)
		ensure
			resultok: Result = (class_name /= Void and data_source_name /= Void and user_name /= Void
						and password /= Void and query_file_name /= Void and target_directory_name /= Void)
		end

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	read_query
		local
			s : STRING
			qcount, scount : INTEGER
			ok : BOOLEAN
		do
			create query_file.make (query_file_name)
			if query_file.exists then
				query_file.open_read
				create query.make (1000)
				-- read file
				from
					ok := false
				until
					ok
				loop
					query_file.read_line
					if query_file.end_of_file then
						ok := true
					end
					s := query_file.last_string
					if s.count > 0 then
						-- prevent concatenation of separate words
						qcount := query.count
						scount := s.count
						if qcount > 0 and then query.item (qcount) /= ' ' and then scount > 0 and then s.item (1) /= ' ' then
						   query.append_character (' ')
						end
						query.append (query_file.last_string)
					end
				end
				query_file.close
			else
				io.put_string ("* ERROR - file '")
				io.put_string (query_file_name)
				io.put_string ("' does not exist%N")
				query := Void
			end
		end

	connect_session
		do
			create session.make (data_source_name, user_name, password)
			session.connect
		end
		
	launch_qacursor
		local
			i : INTEGER
		do
			create qacursor.make (session)
			qacursor.define (query)
			io.put_string ("+ Cursor definition :%N%T")
			io.put_string (qacursor.definition)
			io.put_character ('%N')
			qacursor.prepare
			if qacursor.is_ok then
				io.put_string ("+ Prepared%N")
				if qacursor.has_parameters then
					-- create and set 'parameters' array
					create parameters.make (1, qacursor.parameters_count)
					--qacursor.set_parameters (parameters)
					-- try to describe parameters
					if qacursor.is_describe_parameters_capable then
						qacursor.describe_parameters
						create_parameters_automatically
					else
						io.put_string ("Data source cannot describe parameters%N")
						create_parameters_manually
					end
					define_parameters
					qacursor.bind_parameters
				end
				qacursor.execute
				if not qacursor.is_ok then
					print_error ("Execute", qacursor)
				else 
					io.put_string ("+ Executed%N")
					if qacursor.has_information_message then
						io.put_string (qacursor.diagnostic_message)
						io.put_character ('%N')
					end
				end
			else
				print_error ("Prepare", qacursor)
			end				
		end

	print_error (action : STRING; cursor : QA_CURSOR)
		do
			io.put_string ("  * Error : '")
			io.put_string (action)
			io.put_string (" failed%N")
			io.put_string (qacursor.diagnostic_message)
			io.put_string ("%N  * - on query : ")
			io.put_string (qacursor.definition)
			io.put_character ('%N')
		end

	generate
		local
			i : INTEGER
			d : ECLI_COLUMN_DESCRIPTION
			e : QA_VALUE
			file_name : STRING
		do
			-- describe results
			io.put_string ("+ Results metatada :%N")
			if qacursor.has_result_set then
				qacursor.describe_cursor
				qacursor.create_compatible_cursor
				from
					i := 1
				until
					i > qacursor.result_columns_count
				loop
					d := qacursor.cursor_description.item (i)
					e := qacursor.cursor.item (i)
					if  e /= Void then
						io.put_string (d.name)
						io.put_string ("%Tinstance of ")
						io.put_string (e.ecli_type)
						io.put_string ("%T(")
						io.put_integer (e.column_precision)
						io.put_string (", ")
						io.put_integer (e.decimal_digits)
						io.put_string (")%T-- item :")
						io.put_string (e.item.generator)
						io.put_string ("%N")
					else
						io.put_string ("* ERROR -- No value object for result #")
						io.put_integer (i)
						io.put_string (" [")
						io.put_integer (d.sql_type_code)
						io.put_string (", ")
						io.put_integer (d.size)
						io.put_string (", ")
						io.put_integer (d.decimal_digits)
						io.put_string ("]%N")
					end
					i := i + 1
				end
			end
			-- generate class	
			create gen
			file_name := clone (target_directory_name)
			file_name.append (class_name)
			file_name.append (".e")
			create target_file.make (file_name)
			target_file.open_write
			qacursor.set_name (class_name)
			gen.execute (qacursor, target_directory_name) -- target_file)
			target_file.close	
		end
		
	create_parameters_manually
			-- create as many parameters as there are parameter names
		local
			plist : DS_LIST [QA_VALUE]
			pcursor : DS_LIST_CURSOR [STRING]
			ptype, pprecision : INTEGER
		do
			io.put_string ("? Please describe parameters%N")
			io.put_string ("    Allowed types : VARCHAR, CHAR, INTEGER, FLOAT, REAL, DOUBLE, DATE, TIMESTAMP.%N")
			-- iterate on parameter names
			pcursor := qacursor.parameter_names.new_cursor
			from
				pcursor.start
			until
				pcursor.off
			loop
				io.put_string ("? Type of '")
				io.put_string (pcursor.item)
				io.put_string ("'%N")
				ptype := asked_type
				if ptype = sql_char or ptype = sql_varchar then
					pprecision := asked_precision
				end
				qacursor.value_factory.create_instance (ptype, pprecision, 0)
				qacursor.put_parameter (qacursor.value_factory.last_result, pcursor.item)
				pcursor.forth
			end
		end

	create_parameters_automatically
		local
			pdef : ECLI_PARAMETER_DESCRIPTION
			pcursor : DS_LIST_CURSOR [STRING]
		do
			-- iterate on parameter names
			pcursor := qacursor.parameter_names.new_cursor
			from
				pcursor.start
			until
				pcursor.off
			loop
				pdef := qacursor.parameters_description.item (qacursor.parameter_positions (pcursor.item).first)
				qacursor.value_factory.create_instance (pdef.sql_type_code, pdef.size, pdef.decimal_digits)
				qacursor.put_parameter (qacursor.value_factory.last_result, pcursor.item)
				pcursor.forth
			end
		end

	define_parameters
		local
			a_parameter : 	QA_VALUE
			a_char : 		QA_CHAR
			a_varchar : 	QA_VARCHAR
			a_float : 		QA_FLOAT
			a_double : 		QA_DOUBLE
			a_integer : 	QA_INTEGER
			a_real : 		QA_REAL
			a_date : 		QA_DATE
			a_timestamp : 	QA_TIMESTAMP
			pcursor : 		DS_LIST_CURSOR[STRING]
		do
			io.put_string ("? Please give value to parameters so that the query can be executed.%N")
			-- iterate on parameter names
			pcursor := qacursor.parameter_names.new_cursor
			from
				pcursor.start
			until
				pcursor.off
			loop
				io.put_string ("? Value of '")
				io.put_string (pcursor.item)
				io.put_string ("' : ")
				a_parameter := qacursor.parameter (pcursor.item)
				a_char ?= a_parameter
				if a_char /= Void then
					io.read_line
					a_char.set_item (io.last_string)
				else
					a_varchar ?= a_parameter
					if a_varchar /= Void then
						io.read_line
						a_varchar.set_item (io.last_string)
					else
						a_double ?= a_parameter
						if a_double /= Void then
							io.read_double
							a_double.set_item (io.last_double)
						else
							a_real ?= a_parameter
							if a_real /= Void then
								io.read_real
								a_real.set_item (io.last_real)
							else
								a_integer ?= a_parameter
								if a_integer /= Void then
									io.read_integer
									a_integer.set_item (io.last_integer)
								else
									a_date ?= a_parameter
									if a_date /= Void then
										io.put_string ("YYYY-MM-DD >")
										io.read_line
										a_date.set_item (date_from_string (io.last_string))
									else
										a_timestamp ?= a_parameter
										if a_timestamp /= Void then
											io.read_line
											a_timestamp.set_item (timestamp_from_string (io.last_string))
										end
									end
								end
							end
						end
					end
				end
				pcursor.forth
			end
		end

	asked_type : INTEGER
		local
			t : STRING
			ok : BOOLEAN
		do
			from
			until
				ok
			loop
				io.put_string ("?   Data type%T: ")
				io.read_line
				ok := true
				inspect io.last_string.item (1)
				when 'v', 'V' then Result := sql_varchar
				when 'c', 'C' then Result := sql_char
				when 'i', 'I' then Result := sql_integer
				when 'f', 'F' then Result := sql_float
				when 'r', 'R' then Result := sql_real
				when 'd', 'D' then
					if io.last_string.item (2) = 'o' or io.last_string.item (2) = 'O' then
						Result := sql_double
					else
						Result := sql_type_date
					end
				when 't', 'T' then
					Result := sql_type_timestamp
				else
					ok := false
					io.put_string (" ! - Invalid type, try again %N")
				end
			end
		end

	asked_precision : INTEGER
		local
			ok : BOOLEAN
		do
			from
			until
				ok
			loop
				io.put_string ("?   max length%T: ")
				io.read_line
				if io.last_string.is_integer and io.last_string.as_integer > 0 then
					ok := true
				else
					io.put_string (" ! - Invalid precision, try again %N")
				end
			end
			Result := io.last_string.as_integer
		end

	date_from_string (s: STRING) : DT_DATE
			-- read a date in format yyyy-mm-dd
		local
			y, m, d : INTEGER
			sy, sm, sd : STRING
			i, j : INTEGER
			ok : BOOLEAN
		do
			sy := s.substring (1,4)
			sm := s.substring (6,7)
			sd := s.substring (9,10)
			y := sy.as_integer
			m := sm.as_integer
			d := sd.as_integer 
			create Result.make (y, m, d)
		end

	timestamp_from_string (s: STRING) : DT_DATE_TIME
			-- read a timestamp in format yyyy-mm-dd hh:mm:ss
		local
			hh, mm, ss : INTEGER
			date : DT_DATE
		do
			date := date_from_string (s)
			hh := s.substring (12,13).as_integer
			mm := s.substring (15,16).as_integer
			ss := s.substring (18,19).as_integer
			create  Result.make(date.year, date.month, date.day, hh, mm, ss)
		end
						
feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
			
	query_file : KL_TEXT_INPUT_FILE
	
	parameters : ARRAY[QA_VALUE]
		
end -- class QUERY_ASSISTANT
--
-- Copyright (c) 2000-2006, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
