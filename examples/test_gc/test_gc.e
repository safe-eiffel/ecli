indexing
	description: "Test for objects garbage collection";
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"
	licensing: "See notice at end of class"
class
	TEST_GC

creation

	make

feature -- Initialization

	make is
			-- test_gc			
		do
			-- session opening
			if args.argument_count < 3 then
				io.put_string ("Usage: test_gc <data_source> <user_name> <password>%N")
			else
				create session.make (args.argument (1), "sess0", args.argument (3))
				session.connect
				if session.has_information_message then
					io.put_string (session.cli_state) 
					io.put_string (session.diagnostic_message)
				end
				if session.is_connected then
					io.put_string ("+ Connected %N")
				end
				-- definition of statement on session, which is not disposable
				create statement.make (session)
				test_gc
			end;
		end
	
	test_gc is
		do
			do_case_a
		end
	
	other_test is
		local
			stmt0, stmt11, stmt21, stmt22 : ECLI_STATEMENT
			m : MEMORY
			sess1, sess2 : ECLI_SESSION
		do
			create m 
			--| create 2 new sessions
			create sess1.make (args.argument (1), "sess1", args.argument (3))
			sess1.connect
			create sess2.make (args.argument (1), "sess2", args.argument (3))
			sess2.connect
			--| create statement on 'session' 
			create stmt0.make (session)
			--| create statement on 'sess1' 
			create stmt11.make (sess1)
			--| create statement on 'sess2' 
			create stmt21.make (sess2)
			--| create statement on 'sess2' and let it be "attached"
			create stmt22.make (sess2)			

			--| let stmt 1..3 be "disposable"
			stmt11.release
			stmt21.release
			stmt22.release
			--| detach reference to sess1
			sess1.release
			sess1 := Void -- unattached
			--| unattach references so that GC can work
			stmt0 := Void -- still attached
			stmt11 := Void -- unattached
			stmt21 := Void -- unattached
			stmt22 := Void -- unattached
			--| collect available data
			--| collectable at this point : sess1, stmt11, stmt21, stmt22
			print ("manual collect")
			m.full_collect
			--| collectable after this point : sess2
		end

	-- test cases :
	--	case		SESSION		STATEMENTS	BOOST
	--	A		open		open		N	--> precondition fired 
	--	B		open		open		Y	--> exception raised
	--	C		open		closed		-	--> exception raised
	--	D		closed		open		N	--> precondition fired SESSION.close
	--	E		closed		closed		-	--> nothing
	
	
	a_ok, b_ok, c_ok, d_ok, e_ok : BOOLEAN
	a_tried, b_tried, c_tried, d_tried, e_tried : BOOLEAN
	
	do_case_a is
		do
			if not a_tried then
				a_tried := True
				!!session.make("ecli_db", "u", "p")
				session.connect
				!!statement.make (session)
				-- loose references
				session := Void
				statement := Void
				memory.full_collect
			end
		rescue
			a_tried := True
			retry
		end
	
	do_case_b is
		do
		end
	
	do_case_c is
		do
		end
		
	do_case_d is
		do
		end
		
	do_case_e is
		do
		end

	
	args : ARGUMENTS is once create Result end 

	session : ECLI_SESSION
	statement : ECLI_STATEMENT
	
	memory : MEMORY is once create Result end
	
end -- class TEST_GC
--
-- Copyright: 2000-2002, Paul G. Crismer, <pgcrism@users.sourceforge.net>
-- Released under the Eiffel Forum License <www.eiffel-forum.org>
-- See file <forum.txt>
--
